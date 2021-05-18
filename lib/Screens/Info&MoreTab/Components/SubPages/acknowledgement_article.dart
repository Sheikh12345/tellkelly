import 'package:flutter/material.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class AcknowledgementsPage extends StatefulWidget {
  AcknowledgementsPage({Key key}) : super(key: key);

  @override
  _AcknowledgementsPageState createState() => _AcknowledgementsPageState();
}

class _AcknowledgementsPageState extends State<AcknowledgementsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: black,
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
            "$infoAndMoreAcknowledgementArticle",
            style: headerText15(size: size.width * 0.04),
            textAlign: TextAlign.left,
            overflow: TextOverflow.visible,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.015),
            child: Column(
              children: <Widget>[
                // TODO: IMAGE FIX
                Container(
                  width: double.infinity,
                  height: size.height * 0.13,
                  color: Colors.grey,
                ),
                Text(
                  "$acknowledgementArticle",
                  style: storypageHeaderText(size: size.width * 0.066),
                  textAlign: TextAlign.center,
                ),
                Column(children: [
                  Text("$thanksText",
                    style: storyText(size: size.width * 0.04),
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: size.height * 0.04),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "$googleLLC",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- $authenticationAndDatabase",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "$andreaBizzotto",
                            style: AckText(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "$flutterAndDart",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "$canva",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "$splashImage",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "$carolinaLach",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "$headerTextFont",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(children: [
                        Text(
                          "$marieMonsalveAndAngelinaSanchez",
                          style: AckText(size: size.width * 0.038),
                        ),
                      ]),
                      Row(
                        children: [
                          Text(
                            "$bodyTextFonts",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "$peterBilakAndNikolaDjurek",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "$btnTextFonts",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "$you",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "$readingAndSharing",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(children: [
                        Text(
                          "$continueToGrow",
                          style: storyText(size: size.width * 0.038),
                        )
                      ]),
                      Row(children: [
                        Text(
                          "$updateRegularly",
                          style: storyText(size: size.width * 0.038),
                        )
                      ])
                    ],
                  ),
                ]),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ));
  }
}
