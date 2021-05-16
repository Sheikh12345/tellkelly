import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class LogoDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height*0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/icon.png")
                )
            ),
            margin: EdgeInsets.only(bottom: size.height*0.04),
          ),
          Positioned(
            bottom: size.height*0.01,
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: Text.rich(TextSpan(text: "Tell ",style: GoogleFonts.ruda(fontSize: size.width*0.074,color: primaryColor,fontWeight: FontWeight.w600),children: [
                TextSpan(text: "Kelly",style: GoogleFonts.ruda(fontSize: size.width*0.074,color: secondaryColor,fontWeight: FontWeight.w600),)
              ]),
                textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }
}
