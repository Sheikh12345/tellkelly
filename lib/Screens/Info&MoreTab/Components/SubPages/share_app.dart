import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/style_sheet.dart';

import '../Info_button.dart';
import 'bottom_sheet.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({Key key}) : super(key: key);

  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {

  Future<void> share(String text) async {
    await FlutterShare.share(
        title: 'Share App',
        text: '$text',
        linkUrl: 'app web link will come here',
        chooserTitle: 'Tell Kelly',
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back_ios_rounded,color:primaryColor,),
        onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Share App",
          style: GoogleFonts.courgette(
              color: primaryColor, fontSize: size.width * 0.063),
        ),
      ),
 body: Container(
        width: size.width,
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      InfoButton(text: "I like this app",onPressed: () {
        share('I like this app');
   }
      ),
       InfoButton(text: "This app is really cool ",onPressed: () {
         share('This app is really cool');
       }
       ),
       InfoButton(text: "Your Opinion ?",onPressed: () {
         showAnimatedDialog(
           context: context,
           barrierDismissible: true,
           builder: (BuildContext context) {
             return CustomBottomSheet();
           },
           animationType: DialogTransitionType.size,
           curve: Curves.fastOutSlowIn,
           duration: Duration(seconds: 1),
         );
       }
       )
     ],
   ),
 ),
    ));
  }
}
