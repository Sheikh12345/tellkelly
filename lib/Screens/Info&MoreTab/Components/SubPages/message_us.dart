import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class MessageUs extends StatefulWidget {
  @override
  _MessageUsState createState() => _MessageUsState();
}

class _MessageUsState extends State<MessageUs> {
  TextEditingController _controllerMessage = TextEditingController();

  String userName;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      userName = value.get("userName");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "$infoAndMoreTxt",
            style: headerText15(size: size.width * 0.04),
            textAlign: TextAlign.left,
            overflow: TextOverflow.visible,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.016),
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.13,
                  color: Colors.grey,
                ),
                Text(
                  "$messageUs",
                  style: GoogleFonts.zillaSlab(
                      color: secondaryColor, fontSize: size.width * 0.07),
                ),
                Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text(
                    "$messageTxt",
                    style: GoogleFonts.zillaSlab(
                        color: primaryColor, fontSize: size.width * 0.041),
                  ),
                ),
                SizedBox(
                  height: size.height * .042,
                ),
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.3,
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      right: BorderSide(
                          color: secondaryColor, width: size.width * 0.002),
                      left: BorderSide(
                          color: secondaryColor, width: size.width * 0.002),
                      top: BorderSide(
                          color: secondaryColor, width: size.width * 0.002),
                      bottom: BorderSide(
                          color: secondaryColor, width: size.width * 0.002),
                    ),
                  ),
                  margin: EdgeInsets.all(size.width * 0.02),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: formFieldLabelText(),
                    maxLines: 10,
                    minLines: 1,
                    textAlign: TextAlign.start,
                    cursorColor: secondaryColor,
                    controller: _controllerMessage,
                    decoration: InputDecoration(
                      errorText: null,
                      border: InputBorder.none,
                      errorStyle: errorText(),
                      hintStyle: formFieldHintText(),
                      hintText: "$message ",
                      labelStyle: formFieldLabelText(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 0.65, right: size.width * 0.03),
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      sendMessageToFirebase(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: size.width * 0.01),
                        Text('  $send'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendMessageToFirebase(BuildContext context) {
    if (_controllerMessage.text.length == 0) {
      final snackBar = SnackBar(content: Text('$pleaseEnterMessage',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } else if (_controllerMessage.text.length < 5) {
      final snackBar = SnackBar(content: Text('$messageLengthIsShort',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } else {
      FirebaseFirestore.instance.collection("NewMessage").add({
        "name": userName,
        "timestamp": Timestamp.now(),
        "userId": FirebaseAuth.instance.currentUser.uid,
        "text": _controllerMessage.text
      }).whenComplete(() {
        final snackBar = SnackBar(content: Text('$messageSuccesfullySent',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: secondaryColor,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      });
    }
  }
}
