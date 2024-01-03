import 'dart:developer';
import 'service.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
const String _baseURL = 'https://aliabed.000webhostapp.com';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerfname = TextEditingController();
  TextEditingController _controllerlname = TextEditingController();
  TextEditingController _controlleraddress = TextEditingController();
  TextEditingController _controlleremail = TextEditingController();
  TextEditingController _controllerpassword = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {

    _controllerfname.dispose();
    _controllerlname.dispose();
    _controlleraddress.dispose();
    _controlleremail.dispose();
    _controllerpassword.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }
  void checkSavedData() async {
    _encryptedData.getString('myKey').then((String myKey) {
      if (myKey.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => ServiceReservationPage()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    // call the below function to check if key exists
    checkSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          centerTitle: true,
        ),
        body: Center(child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                  width: 200, child: TextFormField(controller: _controllerfname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter First Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              )),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200, child: TextFormField(controller: _controllerlname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Last Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              )),
              const SizedBox(height: 10),
              SizedBox(width: 200,
                  child: TextFormField(controller: _controlleraddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Address',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200, child: TextFormField(controller: _controlleremail,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              )),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200,
                  child: TextField(
                    // replace typed text with * for passwords
                    obscureText: true,
                    enableSuggestions: false,
                    // disable suggestions for password
                    autocorrect: false,
                    // disable auto correct for password
                    controller: _controllerpassword,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter password'),
                  )),
              const SizedBox(height: 10),
              ElevatedButton(
                // we need to prevent the user from sending another request, while current
                // request is being processed
                onPressed: _loading
                    ? null
                    : () { // disable button while loading
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    signup(update, _controllerfname.text.toString(),
                        _controllerlname.text.toString(),
                        _controlleraddress.text.toString(),
                        _controlleremail.text.toString(),
                        _controllerpassword.text.toString());
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              Visibility(
                  visible: _loading, child: const CircularProgressIndicator())
            ],
          ),
        ),)
    );
  }
}
void signup(Function(String text) update, String fname, String lname,String address,String email,String password) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/sing.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
          'fname': '$fname', 'lname': '$lname','address':'$address','email':'$email','password':'$password', 'key': myKey
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