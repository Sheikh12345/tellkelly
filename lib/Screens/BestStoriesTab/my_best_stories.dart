import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/LocalStorage/sqflite_database.dart';
import 'package:tellkelly/Services/AdMob/loading_screen.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';



class BestStories extends StatefulWidget {
  @override
  _BestStoriesState createState() => _BestStoriesState();
}

class _BestStoriesState extends State<BestStories> {
  List<Map<String, dynamic>> bestStories = [];
  int storiesLength = 0;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
    }).whenComplete(() {
      setState(() {});
    });

    LocalDatabase.instance.readAll().then((value) {
      bestStories = value;
    }).whenComplete(() {
      storiesLength = bestStories.length;
      print(bestStories[0]["${LocalDatabase.storyImageUrl}"]);
      setState(() {});
    });
    super.initState();
  }

  int isSubscribed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            screenPush(context, LoadingScreen());
          },
          child: Text(
            "$myBestStories",
            style: GoogleFonts.courgette(
                color: primaryColor, fontSize: size.width * 0.063),
          ),
        ),
      ),
      body: Container(
          width: size.width,
          child: ListView.builder(
              itemCount: bestStories.length == null ? 0 : bestStories.length,
              itemBuilder: (_, index) {
                return Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.31,
                    ),
                    GestureDetector(
                      onTap: () {
                        moveToReadStory(
                          title: bestStories[index][LocalDatabase.storyName],
                          image: bestStories[index]
                              [LocalDatabase.storyImageUrl],
                          body: bestStories[index][LocalDatabase.storyBody],
                            // replyBody: doc["replyBody"]
                        );
                      },
                      child: Container(
                        width: size.width,
                        height: size.height * 0.22,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: bestStories[index]
                                            [LocalDatabase.storyImageUrl] ==
                                        null
                                    ? AssetImage("images/tellkellylogo.png")
                                    : NetworkImage(
                                        "${bestStories[index][LocalDatabase.storyImageUrl]}"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(
                            bottom: size.height * .12,
                            left: size.width * 0.03,
                            right: size.width * 0.03),
                      ),
                    ),
                    Positioned(
                      bottom: size.height * 0.03,
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "${bestStories[index][LocalDatabase.storyName]}",
                              style: TextStyle(color: primaryColor, height: 2),
                            ),
                            Container(
                              width: size.width,
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Text("$readStory",
                                        style: GoogleFonts.ruda(
                                            color: secondaryColor,
                                            letterSpacing: 0.1,
                                            fontSize: size.width * 0.032)),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: secondaryColor,
                                      size: size.width * 0.025,
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                ),
                                onTap: () {
                                  moveToReadStory(
                                    title: bestStories[index]
                                        [LocalDatabase.storyName],
                                    image: bestStories[index]
                                        [LocalDatabase.storyImageUrl],
                                    body: bestStories[index]
                                        [LocalDatabase.storyBody],
                                  );
                                },
                              ),
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(
                                  top: size.height * 0.02,
                                  right: size.width * 0.01),
                            )
                          ],
                        ),
                        width: size.width,
                        alignment: Alignment.center,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                        right: size.width * 0.05,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: size.width * 0.09,
                          ),
                          onPressed: () async {
                            int status = await LocalDatabase.instance.delete(
                                bestStories[index][LocalDatabase.storyName]);
                            if (status == 1) {
                              print("Deleted $status");
                              final snackBar = SnackBar(content: Text('$removed',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              var value =
                                  await LocalDatabase.instance.readAll();
                              if (value != null) {
                                bestStories = value;
                                setState(() {});
                                return;
                              }
                              bestStories.clear();
                              setState(() {});
                            }
                          },
                        ))
                  ],
                );
              })),
    ));
  }

  moveToReadStory({String title,String body,String image,String replyBody}){
    screenPush(
        context,
        LoadingScreen(
            replyBody: replyBody,
            favoriteButtonIsVisible: true,
            title:title,
            imageAddress: image,
            storyBody:body
        ));
  }
}
