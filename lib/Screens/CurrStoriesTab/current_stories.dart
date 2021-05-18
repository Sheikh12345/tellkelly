import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Services/AdMob/loading_screen.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class CurrentStories extends StatefulWidget {
  @override
  _CurrentStoriesState createState() => _CurrentStoriesState();
}

class _CurrentStoriesState extends State<CurrentStories>
    with TickerProviderStateMixin {


  int isSubscribed;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
    }).whenComplete((){
      setState(() {

      });
    });
  }






  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.08,
              color: Colors.black,
              child: Text(
                " $currentStories",
                style: GoogleFonts.zillaSlab(
                    color: secondaryColor, fontSize: size.width * 0.07),
                textAlign: TextAlign.center,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Live Stories")
                    .where("Category", isEqualTo: "Current")
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: size.width,
                      height: size.height * 0.84,
                      child: ListView.builder(

                          /// NeverScrollableScrollPhysics() this function helpful to make listView not scrollable
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (_, index) {
                            var doc = snapshot
                                .data.docs[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.31,
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      moveToReadStory(
                                        title:  doc
                                        ["Title"],
                                        image: doc["Image"],
                                        body: doc["storyBody"],
                                          replyBody: doc["replyBody"]
                                      );
                                    },
                                    child: doc["Image"]
                                .toString()
                                .length<2?Container(
                                      alignment: Alignment.center,
                                      width: size.width,
                                      height: size.height * 0.22,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                      color: Colors.blue
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: size.height * .12,
                                          left: size.width * 0.03,
                                          right: size.width * 0.03),
                                      child: Text(
                                        "${doc["Title"]}",
                                        style:
                                        GoogleFonts.courgette(color: Colors.white,height: 2,fontSize: size.width*0.06,fontWeight: FontWeight.w600),
                                      ),
                                    ):        Container(
                                      margin: EdgeInsets.only(
                                          bottom: size.height * .12,
                                          left: size.width * 0.03,
                                          right: size.width * 0.03),
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: size.width,
                                      height: size.height * 0.22,
                                      child: CachedNetworkImage(
                                        imageUrl: "${doc["Image"]}",
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(child: FancyShimmerImage(
                                          shimmerBackColor: secondaryColor,
                                          shimmerBaseColor: primaryColor,
                                          shimmerHighlightColor: Colors.grey,
                                          width: size.width*0.9,
                                          height: size.height * 0.22,
                                        ),),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),

                                  ),
                                  Positioned(
                                    bottom: size.height * 0.03,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${doc["Title"]}",
                                            style:
                                                TextStyle(color: primaryColor,height: 2),
                                          ),
                                          Container(
                                            width: size.width,
                                            child: GestureDetector(
                                              child: Row(

                                                children: [
                                                  Text(
                                                      "$readStory",
                                                      style: GoogleFonts.ruda(
                                                          color:
                                                          secondaryColor,
                                                          letterSpacing:
                                                          0.1,
                                                          fontSize:
                                                          size.width *
                                                              0.032)),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: secondaryColor,
                                                    size:
                                                    size.width * 0.025,
                                                  )
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.end,
                                              ),
                                              onTap: () {
                                                moveToReadStory(
                                                  title:  doc["Title"],
                                                  image: doc["Image"],
                                                  body:doc["storyBody"],
                                                    replyBody: doc["replyBody"]
                                                );
                                              },
                                            ),
                                            alignment: Alignment.topRight,
                                            margin: EdgeInsets.only(
                                                top: size.height * 0.02,right: size.width*0.01),
                                          )
                                        ],
                                      ),
                                      width: size.width,
                                      alignment: Alignment.center,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Text("$networkError");
                  } else {
                    return Container(
                      width: size.width * 0.5,
                      height: size.height * 0.07,
                      child: SpinKitThreeBounce(
                        color: primaryColor,
                        size: size.width * 0.07,
                        controller: AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 1200)),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
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
