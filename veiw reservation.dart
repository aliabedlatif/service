import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String _baseURL='aliabed.000webhostapp.com';
class Service{

  String _typeofservice;
  Service(this._typeofservice);
  @override
  String toString() {
    return 'typeofservice: $_typeofservice';
  }
}
List<Service> _services=[];
void updateservices(Function(bool success)update)async{
  try {
    final url = Uri.https(_baseURL, 'res.php');
    final response = await http.get(url).timeout(const Duration(seconds: 20));
    _services.clear();
    if (response.statusCode == 200) {
      final jsonResponse= convert.jsonDecode(response.body);
      for(var row in jsonResponse){
        Service p =Service(
            row ['typeofservice'],);
        _services.add(p);
      }
      update(true);
    }
  }
  catch(e){
    update(false);
  }
}
class Showservices extends StatefulWidget {
  const Showservices({super.key});

  @override
  State<Showservices> createState() => _ShowservicesState();
}

class _ShowservicesState extends State<Showservices> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: _services.length,
        itemBuilder:(context,index){
          return Column(children: [
            const SizedBox(height: 5),
            Row(children: [
              SizedBox(width: width*0.3),
              SizedBox(width: width*0.5,child:
              Flexible(child: Text(_services[index].toString(),
                  style: const TextStyle(fontSize: 18)))),
            ]),
            const SizedBox(height: 5)
          ],);
        });
  }
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override

  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false;
  void upadte(bool success){
    setState(() {
      _load=true;
      if(!success){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('failed')));
      }
    });
  }
  @override
  void initState() {

    updateservices(upadte);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('avarilable service'),
        centerTitle: true,
      ),
      body: _load ? const Showservices(): const Center(
          child: SizedBox(width: 100,height: 100,child: CircularProgressIndicator())
      ),
    );
  }
}