import 'package:firebase_auth/firebase_auth.dart';

getUserId() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  final uid = user.uid;
  return uid;
}