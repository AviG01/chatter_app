import 'package:chating_app/helper/helper_func.dart';
import 'package:chating_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// login
  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email.toString().trim(), password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// register
  Future registerUserWithEmailandPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email.toString().trim(), password: password))
          .user!;

      if (user != null) {
        // update userbase data
        DatabaseService(uid: user.uid).savingUserData(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// signout

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
