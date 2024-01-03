import 'package:flutter/material.dart';
import 'package:project2/addservice.dart';
import 'package:project2/service.dart';
import 'package:project2/veiw%20reservation.dart';
import 'SignupPage.dart';
import 'LoginPage.dart';
import 'veiw reservation.dart';
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login & Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.blue,
            ),
            Text(
              'Waiting time',
              style: TextStyle(color:Colors.red,fontSize: 32, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),
            Text(
              'Reservation queue for service\nPress start to see the type of service',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addservice()),
                );
              },
              child: Text(' addservice'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ServiceReservationPage()),
                 );
              },
              child: Text(' reservation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text(' veiw service'),
            ),

          ],
        ),
      ),
    );
  }
}