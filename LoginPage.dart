import 'dart:developer';
import 'service.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
const String _baseURL = 'https://aliabed.000webhostapp.com';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controlleremail = TextEditingController();
  TextEditingController _controllerpassword = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('login'),
          centerTitle: true,
        ),
        body: Center(child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                  width: 200, child: TextFormField(controller: _controlleremail,
                keyboardType: TextInputType.emailAddress,
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
                  child: TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 10),
              ElevatedButton(

                onPressed: _loading
                    ? null
                    : () {
                    signup(update, _controlleremail.text.toString(),
                        _controllerpassword.text.toString());

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceReservationPage()));
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
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
void signup(Function(String text) update,String email,String password) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/log.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
          'email':'$email','password':'$password', 'key': myKey
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