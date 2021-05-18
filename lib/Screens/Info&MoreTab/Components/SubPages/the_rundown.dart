import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class TheRundown extends StatefulWidget {
  @override
  _TheRundownState createState() => _TheRundownState();
}

class _TheRundownState extends State<TheRundown> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child:Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: secondaryColor,onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "$infoAndMoreRunDown",
          style: GoogleFonts.courgette(
              color: primaryColor, fontSize: size.width * 0.043),
        ),
      ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width*0.02),
            child: Column(
              children: <Widget>[
                // TODO: IMAGE FIX
                Container(
                  margin: EdgeInsets.only(bottom: size.height*0.01),
                  width: double.infinity,
                  height: size.height*0.15,
                  color: Colors.grey,
                ),
                // Image.asset(widget.storyData.image),
                Text(
                  "$theRundown",
                  style: storypageHeaderText(
                    size: size.width*0.065
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                    child: Text("$runDownTxt",
                                 style: storyText(size: size.width*0.04),
                      softWrap: true,
                      textAlign: TextAlign.justify,
                    )),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        )),
    );
  }
}
