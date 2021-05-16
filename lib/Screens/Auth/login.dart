import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Providers/provider_error_model.dart';
import 'package:tellkelly/Screens/Auth/singup.dart';
import 'package:tellkelly/Screens/Home/homes_screen.dart';
import 'package:tellkelly/Services/firebase_authentication.dart';
import 'package:tellkelly/Style/style_sheet.dart';

import 'components/google_button.dart';
import 'components/logo_design.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  String error = '';
  bool errorsFound = false;
  String _emailErr ;
  String _passErr;
  FocusNode focusNode = new FocusNode();


  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height*0.04,
                ),
                Text("Sign in",style: GoogleFonts.courgette(color: primaryColor, fontSize: size.width*0.05),),
                SizedBox(
                  height: size.height*0.01,
                ),
                LogoDesign(),
                SizedBox(
                  height: size.height*0.03,
                ),
                Padding(
                  padding:  EdgeInsets.all(size.width*0.02),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: formFieldLabelText(),
                    cursorColor: secondaryColor,
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                      errorText: _emailErr,
                      errorBorder: errorFieldBorder,
                      errorStyle: errorText(),
                      focusedErrorBorder: errorFieldBorder,
                      hintStyle: formFieldHintText(),
                      labelText: "Email",
                      focusedBorder: formFieldBorder,
                      labelStyle: formFieldLabelText(),
                      enabledBorder: formFieldBorder,
                    ),
                    onChanged: (value){
                      checkError(value,1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.width*0.02),
                  child: TextField(
                    obscureText: true,
                    style: formFieldLabelText(),
                    cursorColor: secondaryColor,
                    controller: _controllerPassword,
                    focusNode: focusNode,
                    decoration: InputDecoration(

                      errorBorder: errorFieldBorder,
                      errorText: _passErr,
                      errorStyle: errorText(),
                      focusedErrorBorder: errorFieldBorder,
                      hintStyle: formFieldHintText(),
                      labelText: "Password",
                      focusedBorder: formFieldBorder,
                      labelStyle: formFieldLabelText(),
                      enabledBorder: formFieldBorder,
                    ),
                    onChanged: (value) {
                     checkError(value, 2);
                    },
                  ),
                ),
                MaterialButton(
                    color: secondaryColor,
                    child: Text(
                      'Sign in',
                      style: reviewButton(),
                    ),
                    onPressed: () async {
                      focusNode.unfocus();
                     signIn(context);
                    }),
                SizedBox(height: 10.0),

                SizedBox(
                  height: size.height*0.01,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding:  EdgeInsets.only(left: size.width*0.06, right: size.width*0.01),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        )),
                    loading? SpinKitFadingCircle(
                      color: primaryColor,
                      size: size.width*0.1,
                      controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                    ):Container(
                      height: size.height*0.05,
                      child: Text(
                      'Or',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),),

                    Expanded(
                        child: Padding(
                          padding:  EdgeInsets.only(left: size.width*0.01, right: size.width*0.06),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                GoogleButton(
                  onPressed:()async{
                    setState(() {
                      loading = true;
                    });

                    String value = await FirebaseAuthentication().signInWithGoogle();
                    if(value==null){
                      setState(() {
                        loading = false;
                      });
                    }else{
                      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser.uid).set({
                        "userName":FirebaseAuth.instance.currentUser.displayName,
                        "subscription":0,
                        "ratingIsAvailable":false
                      });
                      screenPushRep(context, HomeScreen());
                    }
                  },
                ),

                SignInButton(
                  width: size.width*0.53,
                  padding: size.width*0.01,
                    buttonType: ButtonType.facebook,
                    onPressed: () {
                      //_signInWithFacebook();
                    }),

                SizedBox(
                  height: size.height*0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: (){
                          screenPush(context,SignUp());
                        },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                         ),
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
         _emailErr = null;
       }else{
         _emailErr =  "Email is not valid";
       }
     });
    }else if(code ==2){
   setState(() {
     if(text.length>5){
       _passErr =  null;
     }else{
       _passErr = "Password is short";
     }
   });
    }
  }

  void signIn(BuildContext cntxt) {
    if (_emailErr == null &&
        _passErr == null &&
        _controllerEmail.text.length > 5 &&
    _controllerPassword.text.length > 5) {
      FirebaseAuthentication().signInWithEmailAndPass(
          _controllerEmail.text.replaceAll(" ", ""),
          _controllerPassword.text.replaceAll(" ", ""),
          cntxt)
          .then((value) {
        if (value != null){
        setState(() {
          loading = true;
        });
          screenPushRep(cntxt, HomeScreen());
        }else{
          final snackBar = SnackBar(content: Text('${Provider.of<ProviderError>(cntxt,listen: false).signInError}',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }else{
      final snackBar = SnackBar(content: Text('Login Details Required.',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
