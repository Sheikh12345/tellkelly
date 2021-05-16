import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Screens/Auth/login.dart';
import 'package:tellkelly/Screens/CurrStoriesTab/current_stories.dart';
import 'package:tellkelly/Screens/PreStoriesTab/previous_stories.dart';
import 'package:tellkelly/Screens/ReadStoryPage/read_story.dart';
import 'package:tellkelly/Services/AdMob/loading_screen.dart';
import 'package:tellkelly/Style/style_sheet.dart';

import '../../main.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  int isSubscribed;
  bool ratingIsAvailable;
  String name;
  int userVisit;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
      ratingIsAvailable = value.get("ratingIsAvailable");
      name = value.get("userName");
      userVisit = value.get("userVisit");
    }).whenComplete(() {
      if (userVisit == 0) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({"userVisit": 1});
      }

      setState(() {});
    });
  }

  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.notifications,color: Colors.white,),
            onPressed: (){
              flutterLocalNotificationsPlugin.show(
                  0,
                  "New Stories",
                  "Tell Kelly take to new stories for you.",
                  NotificationDetails(
                      android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                          importance: Importance.high,
                          color: Colors.blue,
                          playSound: true,
                          channelAction: AndroidNotificationChannelAction.update,
                          icon: '@mipmap/icon',
                       enableVibration: true
                      )));
            },
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Tell Kelly",
            style: GoogleFonts.courgette(
                color: primaryColor, fontSize: size.width * 0.07),
          ),

        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome ${auth.currentUser.displayName != null ? auth.currentUser.displayName.toString() : name ?? '$name'}",
                      style: GoogleFonts.zillaSlab(
                          color: secondaryColor,
                          fontSize: size.width * 0.04,
                          letterSpacing: 0.7),
                    ),
                    MaterialButton(
                        color: negButtonColor,
                        onPressed: () {
                          auth.signOut().whenComplete(() {
                            screenPushRep(context, LoginPage());
                            final snackBar = SnackBar(
                              content: Text(
                                'Successful Logout',
                                style: GoogleFonts.zillaSlab(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.8),
                              ),
                              duration: Duration(
                                seconds: 1,
                              ),
                              backgroundColor: errorFieldColor,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        },
                        child: Text("Logout", style: logoutButton())),
                  ],
                ),
                Container(
                  width: size.width,
                  height: 1,
                  color: errorFieldColor.withOpacity(0.4),
                  margin: EdgeInsets.only(bottom: size.height * 0.02),
                ),

                /// Section 1
                Container(
                  margin: EdgeInsets.only(
                      bottom: size.height * 0.01, top: size.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Stories",
                        style: GoogleFonts.zillaSlab(
                            color: primaryColor, fontSize: size.width * 0.05),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenPush(context, CurrentStories());
                        },
                        child: Row(
                          children: [
                            Text("view all current stories ",
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
                        ),
                      ),
                    ],
                  ),
                ),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Live Stories")
                        // .orderBy("Date Added")
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(top: size.height * 0.01),
                          width: size.width,
                          height: size.height * 0.32,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length > 8
                                  ? 8
                                  : snapshot.data.docs.length,
                              itemBuilder: (_, index) {
                                final doc = snapshot.data.docs[index];
                                if (snapshot.data.docs[index]["Category"] ==
                                    "Current") {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: size.width,
                                        height: size.height * 0.32,
                                        margin: EdgeInsets.only(
                                            bottom: size.height * 0.01),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          moveToReadStory(
                                              title: snapshot.data.docs[index]
                                                  ["Title"],
                                              image: snapshot.data.docs[index]
                                                  ["Image"],
                                              body: snapshot.data.docs[index]
                                                  ["storyBody"],
                                              replyBody: doc["replyBody"]
                                          );
                                        },
                                        child: doc["Image"].toString().length <
                                                2
                                            ? Container(
                                                alignment: Alignment.center,
                                                width: size.width,
                                                height: size.height * 0.22,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.blue),
                                                margin: EdgeInsets.only(
                                                    bottom: size.height * .12,
                                                    left: size.width * 0.03,
                                                    right: size.width * 0.03),
                                                child: Text(
                                                  "${doc["Title"]}",
                                                  style: GoogleFonts.courgette(
                                                      color: Colors.white,
                                                      height: 2,
                                                      fontSize:
                                                          size.width * 0.06,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    bottom: size.height * .12,
                                                    left: size.width * 0.03,
                                                    right: size.width * 0.03),
                                                padding: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: size.width * 0.95,
                                                height: size.height * 0.23,
                                                child: CachedNetworkImage(
                                                  imageUrl: "${doc["Image"]}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: FancyShimmerImage(
                                                      shimmerBackColor:
                                                          secondaryColor,
                                                      shimmerBaseColor:
                                                          primaryColor,
                                                      shimmerHighlightColor:
                                                          Colors.grey,
                                                      width: size.width * 0.9,
                                                      height:
                                                          size.height * 0.22,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                      ),
                                      Positioned(
                                        bottom: size.height * 0.02,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: size.width,
                                                child: Text(
                                                  "${snapshot.data.docs[index]["Title"]}",
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      height: 2),
                                                ),
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                  right: size.width * 0.03,
                                                ),
                                              ),
                                              Container(
                                                width: size.width,
                                                child: GestureDetector(
                                                  child: Row(
                                                    children: [
                                                      Text("  Read Story",
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
                                                  ),
                                                  onTap: () {
                                                    screenPush(
                                                        context,
                                                        ReadStory(
                                                          title: snapshot.data
                                                                  .docs[index]
                                                              ["Title"],
                                                          imageAddress: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ["Image"],
                                                          storyBody: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ["storyBody"],
                                                          replyBody: snapshot
                                                              .data
                                                              .docs[index]
                                                          ["replyBody"],
                                                        ));
                                                  },
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: size.height * 0.02,
                                                    left: size.width * 0.74,
                                                    bottom: size.height * 0.01),
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
                                } else {
                                  return Container();
                                }
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Network Error");
                      } else {
                        return Center(
                            child: Container(
                                width: size.width * 0.5,
                                height: size.height * 0.07,
                                child: FancyShimmerImage(
                                  shimmerBackColor: secondaryColor,
                                  shimmerBaseColor: primaryColor,
                                  shimmerHighlightColor: Colors.grey,
                                  width: size.width * 0.9,
                                  height: size.height * 0.22,
                                )));
                      }
                    }),

                ///Section 2
                Container(
                  margin: EdgeInsets.only(
                      right: size.width * 0.01, bottom: size.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Previous Stories",
                        style: GoogleFonts.zillaSlab(
                            color: primaryColor, fontSize: size.width * 0.05),
                      ),
                      GestureDetector(
                        onTap: () {
                          screenPush(context, PreviousStories());
                        },
                        child: Row(
                          children: [
                            Text("view all previous stories ",
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
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Live Stories")
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: size.width,
                          height: size.height * 0.32,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length > 8
                                  ? 8
                                  : snapshot.data.docs.length,
                              itemBuilder: (_, index) {
                                final doc = snapshot.data.docs[index];

                                if (snapshot.data.docs[index]["Category"] ==
                                    "Previous") {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: size.width,
                                        height: size.height * 0.32,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          moveToReadStory(
                                              title: snapshot.data.docs[index]
                                                  ["Title"],
                                              image: snapshot.data.docs[index]
                                                  ["Image"],
                                              body: snapshot.data.docs[index]
                                                  ["storyBody"],
                                              replyBody: doc["replyBody"]);
                                        },
                                        child: doc["Image"].toString().length <
                                                2
                                            ? Container(
                                                alignment: Alignment.center,
                                                width: size.width,
                                                height: size.height * 0.22,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.blue),
                                                margin: EdgeInsets.only(
                                                    bottom: size.height * .12,
                                                    left: size.width * 0.03,
                                                    right: size.width * 0.03),
                                                child: Text(
                                                  "${doc["Title"]}",
                                                  style: GoogleFonts.courgette(
                                                      color: Colors.white,
                                                      height: 2,
                                                      fontSize:
                                                          size.width * 0.06,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    bottom: size.height * .12,
                                                    left: size.width * 0.03,
                                                    right: size.width * 0.03),
                                                padding: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: size.width * 0.95,
                                                height: size.height * 0.23,
                                                child: CachedNetworkImage(
                                                  imageUrl: "${doc["Image"]}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: FancyShimmerImage(
                                                      shimmerBackColor:
                                                          secondaryColor,
                                                      shimmerBaseColor:
                                                          primaryColor,
                                                      shimmerHighlightColor:
                                                          Colors.grey,
                                                      width: size.width * 0.9,
                                                      height:
                                                          size.height * 0.22,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                      ),
                                      Positioned(
                                        bottom: size.height * 0.03,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: size.width,
                                                child: Text(
                                                  "${snapshot.data.docs[index]["Title"]}",
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      height: 2),
                                                ),
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    right: size.width * 0.03),
                                              ),
                                              Container(
                                                width: size.width,
                                                child: GestureDetector(
                                                  child: Row(
                                                    children: [
                                                      Text("Read Story",
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
                                                  ),
                                                  onTap: () {
                                                    moveToReadStory(
                                                        title: snapshot.data
                                                                .docs[index]
                                                            ["Title"],
                                                        image: snapshot.data
                                                                .docs[index]
                                                            ["Image"],
                                                        body: snapshot.data
                                                                .docs[index]
                                                            ["storyBody"],
                                                        replyBody:
                                                            doc["replyBody"]);
                                                  },
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: size.height * 0.02,
                                                    left: size.width * 0.74),
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
                                } else {
                                  return Container();
                                }
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Network Error");
                      } else {
                        return Center(
                            child: Container(
                                width: size.width * 0.5,
                                height: size.height * 0.07,
                                child: Center(
                                    child: FancyShimmerImage(
                                  shimmerBackColor: secondaryColor,
                                  shimmerBaseColor: primaryColor,
                                  shimmerHighlightColor: Colors.grey,
                                  width: size.width * 0.9,
                                  height: size.height * 0.22,
                                ))));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  moveToReadStory({String title, String body, String image, String replyBody}) {
    screenPush(
      context,
      LoadingScreen(
          replyBody: replyBody,
          favoriteButtonIsVisible: true,
          title: title,
          imageAddress: image,
          storyBody: body),
    );
  }
}
