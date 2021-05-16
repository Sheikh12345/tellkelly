import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleButton extends StatelessWidget {
  final String text;
  final onPressed;
  final logo;

  const GoogleButton({Key key, this.text, this.onPressed, this.logo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child:   Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.2),
        child: MaterialButton(onPressed:onPressed,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ) ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: size.width*0.08,
                  margin: EdgeInsets.only(right: size.width*0.02),
                  child: Image.asset("images/google_logo.png",)),
              Text("Sign in with Google",style: TextStyle(fontWeight: FontWeight.w800,letterSpacing: 0.7,fontSize: size.width*0.035),),
              SizedBox(width: size.width*0.06,)
            ],
          ),
          color: Colors.white,

        ),
      ),
    );
  }
}
