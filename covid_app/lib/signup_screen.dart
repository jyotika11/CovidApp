

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/fitness_app/fitness_app_home_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password, _location, _date_of_birth;
  double _height, _weight;


  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) async {
  //     if (user != null) {
  //       navigateToHomePage();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        await FirebaseFirestore.instance.collection("Users").doc(user.user.uid).set(
          {
            'name': _name,
            'email': _email,
            'height': _height,
            'weight': _weight,
            'dob': _date_of_birth,
            'location': _location,
          }
        );

        if (user != null) {
          await _auth.currentUser.updateProfile(displayName: _name);
          print(user);
          navigateToHomePage() ;
        }
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToHomePage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessAppHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  child: Image(
                    image: AssetImage("assets/images/login.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Name';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              onSaved: (input) => _name = input),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              onSaved: (input) => _email = input),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Date Of Birth';
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date of Birth (DD/MM/YYYY)',
                                  prefixIcon: Icon(Icons.calendar_today_outlined)),
                              onSaved: (input) => _date_of_birth = input),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Height';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Height (cm)',
                                prefixIcon: Icon(Icons.height),
                              ),
                              onSaved: (input) => _height = double.parse(input)),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Weight';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Weight (Kg)',
                                prefixIcon: Icon(Icons.add_circle_outline),
                              ),
                              onSaved: (input) => _weight = double.parse(input)),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Location';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Location',
                                prefixIcon: Icon(Icons.map_outlined),
                              ),
                              onSaved: (input) => _location = input),
                        ),

                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              onSaved: (input) => _password = input),
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed: signUp,
                          child: Text('SignUp',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}