import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// domain of your server
const String _baseURL = 'https://aliabed.000webhostapp.com';
// used to retrieve the key later
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class Addservice extends StatefulWidget {
  const Addservice({super.key});

  @override
  State<Addservice> createState() => _AddserviceState();
}

class _AddserviceState extends State<Addservice> {
  // creates a unique key to be used by the form
  // this key is necessary for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllertypeofservice = TextEditingController();
  // the below variable is used to display the progress bar when retrieving data
  bool _loading = false;


  @override
  void dispose() {
    _controllertypeofservice.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: () {
            _encryptedData.remove('myKey').then((success) =>
                Navigator.of(context).pop());
          }, icon: const Icon(Icons.logout))
        ],
          title: const Text('Add service'),
          centerTitle: true,
          // the below line disables the back button on the AppBar
          automaticallyImplyLeading: false,
        ),
        body: Center(child: Form(
          key: _formKey, // key to uniquely identify the form when performing validation
          child: Column(
            children: <Widget>[

              const SizedBox(height: 10),
              SizedBox(width: 200, child: TextFormField(controller: _controllertypeofservice,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter service',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service';
                  }
                  return null;
                },
              )),
              const SizedBox(height: 10),
              ElevatedButton(
                // we need to prevent the user from sending another request, while current
                // request is being processed
                onPressed: _loading ? null : () { // disable button while loading
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    service(update , _controllertypeofservice.text.toString());
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              Visibility(visible: _loading, child: const CircularProgressIndicator())
            ],
          ),
        )));
  }
}

// below function sends the cid, name and key using http post to the REST service
void service(Function(String text) update, String typeofservice) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/addservice.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
           'typeofservice': typeofservice, 'key': myKey
        })).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      // if successful, call the update function
      update(response.body);
    }
  }
  catch(e) {
    update("connection error");
  }
}