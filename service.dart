import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
const String _baseURL = 'https://aliabed.000webhostapp.com';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
class ServiceReservationPage extends StatefulWidget {
  @override
  _ServiceReservationPageState createState() => _ServiceReservationPageState();
}

class _ServiceReservationPageState extends State<ServiceReservationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerticketnumber = TextEditingController();
  TextEditingController _controllertypeofservice = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  bool _loading = false;
  @override
  void dispose() {

    _controllerticketnumber.dispose();
    _controllertypeofservice.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime ? picked = await showDatePicker(context: context,
      initialDate: date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }
  void _selectTime(BuildContext context) async {
    final TimeOfDay ? picked = await showTimePicker(context: context,
      initialTime: time,
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
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
        actions: [
          IconButton(onPressed: () {
            _encryptedData.remove('myKey').then((success) =>
                Navigator.of(context).pop());
          }, icon: const Icon(Icons.logout))
        ],
        title: Text('Service Reservation'),
        centerTitle: true,
      ),

      body: Center(child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              width: 200,child: TextFormField(controller: _controllerticketnumber,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "enter ticket number"
            ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ticket number';
                }
                return null;
              },
            )),
            const SizedBox(height: 10),
            SizedBox(width: 200, child: TextFormField(controller: _controllertypeofservice,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter service',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter service';
                }
                return null;
              },
            )),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 8.0),
            SizedBox(width: 200,child: Text('selectdate:${date}'),

            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Time: ${time.format(context)}',
            ),

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
                  service(update, int.parse(_controllerticketnumber.text.toString()),
                      _controllertypeofservice.text.toString(),
                      date,
                      time);
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
void service(Function(String text) update, int ticketnumber, String typeofservice,DateTime date,TimeOfDay time) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/serv.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
          'ticketnumber': '$ticketnumber', 'typeofservice': '$typeofservice','date':'$date','time':'$time', 'key': myKey
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
