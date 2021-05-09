import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/app_theme.dart';
import 'package:covid_app/get_covid_details.dart';
import 'package:covid_app/login_screen.dart';
import 'package:covid_app/services/getUserId.dart';
import 'package:covid_app/services/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:covid_app/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'fitness_app/fitness_app_home_screen.dart';
import 'get_nearby_centers.dart';
import 'navigation_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadCount();
  // Position pos = await getCurrentLocation();
  // await getNearbyCovidCenters(pos);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    PushNotificationsManager().init();

    return MaterialApp(
      title: 'Flutter UI',
      routes: {
        MyHomePage.routeName: (ctx) => MyHomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
      ),
      home: NavigationHomeScreen()
      // StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (ctx, userSnapshot) {
      //       if (userSnapshot.hasData) {
      //         return StreamBuilder(
      //             stream: FirebaseFirestore.instance
      //                 .collection('Users')
      //                 .doc(getUserId())
      //                 .snapshots(),
      //             builder: (context, AsyncSnapshot snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return Center(
      //                   child: CircularProgressIndicator(
      //                     strokeWidth: 10,
      //                   ),
      //                 );
      //               }
      //               DocumentSnapshot docs = snapshot.data;
      //               var data = docs.data();
      //               if (data['name'].toString().isNotEmpty) {
      //                 return FitnessAppHomeScreen();
      //               } else {
      //                 FirebaseAuth.instance.signOut();
      //                 return LoginScreen();
      //               }
      //             });
      //       }
      //       return LoginScreen();
      //     }
      // )
    );
  }
}

// navigateToHomeScreen(context) {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   _auth.authStateChanges().listen((user) {
//     if (user != null) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessAppHomeScreen()));
//     }
//     else {
//       NavigationHomeScreen();
//     }
//   });
// }

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
