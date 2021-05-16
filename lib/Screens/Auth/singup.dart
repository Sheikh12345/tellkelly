import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Providers/provider_error_model.dart';
import 'package:tellkelly/Screens/Home/homes_screen.dart';
import 'package:tellkelly/Services/firebase_authentication.dart';
import 'package:tellkelly/Style/style_sheet.dart';
import 'components/logo_design.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  String nameErr;
  String passErr;
  String emailErr;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Sign Up",
                style: GoogleFonts.courgette(
                    color: primaryColor, fontSize: size.width * 0.045),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              LogoDesign(),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: formFieldLabelText(),
                  cursorColor: secondaryColor,
                  controller: _controllerName,
                  decoration: InputDecoration(
                    errorBorder: errorFieldBorder,
                    errorStyle: errorText(),
                    focusedErrorBorder: errorFieldBorder,
                    hintStyle: formFieldHintText(),
                    errorText: nameErr,
                    labelText: "Name",
                    focusedBorder: formFieldBorder,
                    labelStyle: formFieldLabelText(),
                    enabledBorder: formFieldBorder,
                  ),
                  onChanged: (value) {
                    checkError(value,3);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: formFieldLabelText(),
                  cursorColor: secondaryColor,
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    errorBorder: errorFieldBorder,
                    errorStyle: errorText(),
                    focusedErrorBorder: errorFieldBorder,
                    hintStyle: formFieldHintText(),
                    errorText: emailErr,
                    labelText: "Email",
                    focusedBorder: formFieldBorder,
                    labelStyle: formFieldLabelText(),
                    enabledBorder: formFieldBorder,
                  ),
                  onChanged: (value) {
                    checkError(value,1);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  style: formFieldLabelText(),
                  cursorColor: secondaryColor,
                  controller: _controllerPassword,
                  decoration: InputDecoration(
                    errorBorder: errorFieldBorder,
                    errorText: passErr,
                    errorStyle: errorText(),
                    focusedErrorBorder: errorFieldBorder,
                    hintStyle: formFieldHintText(),
                    labelText: "Password",
                    focusedBorder: formFieldBorder,
                    labelStyle: formFieldLabelText(),
                    enabledBorder: formFieldBorder,
                  ),
                  onChanged: (value) {
                    checkError(value,2);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: MaterialButton(
                  color: secondaryColor,
                  child: Text('Sign up', style: reviewButton()),
                  onPressed: () async {
                    signUp(context);
                  },
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                height: size.height*0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(size.width*0.02),
                    child: GestureDetector(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          {
                            Navigator.pop(context);
                          }
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  checkError(String text,int code){
    if(code==1){
      setState(() {
        if(EmailValidator.validate(text)){
          emailErr =  null;
        }else{
          emailErr = "Email is not valid";
        }
      });
    }else if(code ==2){
      setState(() {
        if(text.length>5){
          passErr = null;
        }else{
          passErr = "Password is short";
        }
      });
    }else if(code ==3){
      setState(() {
        if(text.length>2){
          nameErr = null;
        }else{
          nameErr = "Name is short";
        }
      });
    }
  }


  void signUp(BuildContext cntxt) async {
    if (nameErr == null && emailErr == null && passErr == null) {

      FirebaseAuthentication()
          .signUpWithEmailAndPass(
              _controllerEmail.text, _controllerPassword.text, cntxt).then((value){
                if(value!=null){
                  FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser.uid).set({
                    "userName":_controllerName.text,
                    "subscription":0,
                    "ratingIsAvailable":false,
                    "userVisit":0
                  });
                  screenPushRep(context, HomeScreen());
                }else{
                  print("error");
                  final snackBar = SnackBar(content: Text('${Provider.of<ProviderError>(cntxt,listen: false).signUpError}',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
      });
    }
  }
  }

