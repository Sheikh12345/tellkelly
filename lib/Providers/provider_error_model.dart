import 'package:flutter/material.dart';

class ProviderError extends ChangeNotifier{
  String signInError ="";
  String signUpError ="";

  String getSignInError() => signInError;
  String getSignUpError() => signUpError;

  setSignInError(String error){
    signInError = error;
    notifyListeners();
  }

  setSignUpError(String error){
    signUpError = error;
    notifyListeners();
  }
}
