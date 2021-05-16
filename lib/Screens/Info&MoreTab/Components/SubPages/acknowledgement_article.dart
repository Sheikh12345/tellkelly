import 'package:flutter/material.dart';
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
            "Info & More - Acknowledgements Article",
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
                  "Acknowledgements Article",
                  style: storypageHeaderText(size: size.width * 0.066),
                  textAlign: TextAlign.center,
                ),
                Column(children: [
                  Text(
                    """
This page is a special thanks to some of the people and companies that have helped get the 'Tell Kelly- She Gives Advice App' what is is today""",
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
                            "Google LLC",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- Authentication / Database",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Andrea Bizzotto",
                            style: AckText(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "- Flutter & Dart Programming Expert",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Canva.com",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- Splash Images",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "Carolina Lach",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- Header Text Fonts",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(children: [
                        Text(
                          "Marie Monsalve & Angelina Sanchez",
                          style: AckText(size: size.width * 0.038),
                        ),
                      ]),
                      Row(
                        children: [
                          Text(
                            "- Body Text Fonts",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "Peter Bil'ak & Nikola Djurek",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- Button Text Font",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "You",
                            style: AckText(size: size.width * 0.038),
                          ),
                          Text(
                            "- Reading & Sharing",
                            style: AckTextRole(size: size.width * 0.038),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(children: [
                        Text(
                          "And we're sure this list will continue to grow...",
                          style: storyText(size: size.width * 0.038),
                        )
                      ]),
                      Row(children: [
                        Text(
                          "So keep an eye out for list updates regularly!",
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
