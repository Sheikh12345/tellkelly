import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          "Info & More - The Rundown",
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
                  "The Rundown",
                  style: storypageHeaderText(
                    size: size.width*0.065
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                    child: Text(
                      """Tell Kelly is a place where Kelly offers her advice on readers who find themselves in difficult situations they may find themselves in within their everyday lives.Feel alone? You're not the only one and sometimes it helps just to tell someone about these situations who is unbiased she is here to do just that! Send a Story.
Whilst a humble little app we want to be the go to app to not only have Kelly share her advice, but to also help other 'Tell Kelly' readers who may find themselves in a similar situation .Head to the Send A Story, compose and review and send your story. Sometimes it helps to just tell someone and have their advice on the issue.

We here at 'Tell Kelly' hope you are happy and successful in your everyday lives, so 'Tell Kelly' is always here as an advice column that you can sit and read without using her advice for yourself. We aim to release stories on weekdays every week, so everyday you can just sign in (or just stay signed in) and read the day's current stories. Stories have a finite shelf life. They would stay in 'Current Stories' for a week and then head to 'Previous Stories' for another week, after which they are no longer viewable. If you like a story and would like to read it later..save the story in 'My Best Stories' where it stay as long as you like..""",
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
