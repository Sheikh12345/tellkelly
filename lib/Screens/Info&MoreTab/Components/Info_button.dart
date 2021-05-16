import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class InfoButton extends StatelessWidget {
  final text;
  final onPressed;
  final value;

  const InfoButton({Key key, this.text, this.onPressed, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.9,
      margin: EdgeInsets.only(top: size.height*0.013,
        left: size.width*0.03,
        right: size.width*0.03,
      ),
      child: MaterialButton(
        onPressed:onPressed,
        color: primaryColor,
        child: Text(
          "$text",
          style: GoogleFonts.ruda(
            color: Colors.black,
            fontSize: size.width * 0.034,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


}