import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/style_sheet.dart';


class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key key}) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}
bool btnIsVisible;

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  Future<void> share(String text) async {
    await FlutterShare.share(
      title: 'Share App',
      text: '$text',
      linkUrl: 'app web link will come here',
      chooserTitle: 'Tell Kelly',
    );
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.7,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child:   Image.asset("images/icon.png"),
              height: size.height*0.2,
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height*0.02),
              width: size.width,
              alignment: Alignment.center,
              child: Text.rich(TextSpan(text: "Tell ",style: GoogleFonts.ruda(fontSize: size.width*0.074,color: primaryColor,fontWeight: FontWeight.w600,decoration: TextDecoration.none),children: [
                TextSpan(text: "Kelly",style: GoogleFonts.ruda(fontSize: size.width*0.074,color: secondaryColor,fontWeight: FontWeight.w600,decoration: TextDecoration.none),)
              ]),
                textAlign: TextAlign.center,),
            ),
            Padding(
              padding:  EdgeInsets.all(size.width*0.02),
              child: Material(
                child: Container(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.emailAddress,
                    style: formFieldLabelText(),
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      errorBorder: errorFieldBorder,
                      errorStyle: errorText(),
                      focusedErrorBorder: errorFieldBorder,
                      hintStyle: formFieldHintText(),
                      labelText: "Comment",
                      focusedBorder: formFieldBorder,
                      labelStyle: formFieldLabelText(),
                      enabledBorder: formFieldBorder,
                    ),
                  ),
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height*0.03),
              width: size.width*0.95,
              child: MaterialButton(
                  color: primaryColor,
                  onPressed: () {
                    if(_controller.text.length>4){
                    share(_controller.text);
                    }else{
                      final snackBar = SnackBar(content: Text('Text length is short',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Share App',
                      style: GoogleFonts.ruda(fontSize: size.width*0.04,color: Colors.black,fontWeight: FontWeight.w600))
              ),
              height: size.height * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}











