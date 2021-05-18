import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:provider/provider.dart';
import 'package:tellkelly/Providers/provider_error_model.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class FirebaseAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
// Create an instance of FacebookLogin
  final fb = FacebookLogin();
   UserCredential userCredential;

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = new GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;
      print(user.displayName);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      return "signInWithGoogle $user";
    } catch (e) {
      print("google sing in error => ${e.toString()}");
    }
    return null;
  }

  Future<String> signInWithFacebook() async {
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
  }


     Future<User> signUpWithEmailAndPass(
        String email, String pass, BuildContext context) async {
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: "$email", password: "$pass");
        print(userCredential.user.email);
        if (userCredential != null) {
          return userCredential.user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
         Provider.of<ProviderError>(context,listen: false).setSignUpError("The password provided is too weak.");
          print('The password provided is too weak.');

         final snackBar = SnackBar(content: Text('The password provided is too weak',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 2,),backgroundColor: errorFieldColor,);
         ScaffoldMessenger.of(context).showSnackBar(snackBar);

        } else if (e.code == 'email-already-in-use') {
          Provider.of<ProviderError>(context,listen: false).setSignUpError("The account already exists for that email.");
          print('The account already exists for that email.');

          final snackBar = SnackBar(content: Text('The account already exists for that email.',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 2,),backgroundColor: errorFieldColor,);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
      } catch (e) {
        print(e);
      }
      Provider.of<ProviderError>(context,listen: false).setSignUpError("Something is wrong");

      return null;
    }

     Future<User> signInWithEmailAndPass(
        String email, String pass, BuildContext context) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: "$email", password: "$pass");

        if (userCredential != null) {
          return userCredential.user;
        } else {
          return null;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Provider.of<ProviderError>(context,listen: false).setSignInError("No user found for that email");
          print('No user found for that email');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user');
          Provider.of<ProviderError>(context,listen: false).setSignInError("Wrong password provided for that user");
        }
      }
      return null;
    }

     Future<void> passwordReset(String email, BuildContext context) async {
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() {
        final snackBar = SnackBar(content: Text('Check your email.',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 2,),backgroundColor: secondaryColor,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      });
    }

     Future<void> logOut() async {
      return _auth.signOut();
    }

}
