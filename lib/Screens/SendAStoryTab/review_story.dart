import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tellkelly/Screens/SendAStoryTab/send_a_story.dart';
import 'package:tellkelly/Services/AdMob/ad_state.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class ReviewStory extends StatefulWidget {
  final storyTitle;
  final storyBody;

  const ReviewStory({Key key, this.storyTitle, this.storyBody})
      : super(key: key);
  @override
  _ReviewStoryState createState() => _ReviewStoryState();
}

class _ReviewStoryState extends State<ReviewStory> {
  
  int isSubscribed;
  
  String userName;
  TextEditingController _controller = TextEditingController();
  BannerAd _bannerAd;
  InterstitialAd myInterstitial;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState().bannerAdUnitId,
          listener: AdListener(onAdLoaded: (Ad ad) {
            print("Ad loaded");
          }, onAdClosed: (Ad ad) {
            print("Ad Closed");
            _bannerAd.dispose();
            Future.delayed(Duration(seconds: 2), () {
              _bannerAd.load();
            });
          }),
          request: AdRequest())
        ..load();
    });
  }

  @override
  void initState() {
    _controller.text = widget.storyBody;
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      userName = value.get("userName");
      isSubscribed = value.get("subscription");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: Text(
          "$reviewStory",
          style: GoogleFonts.courgette(
              color: primaryColor, fontSize: size.width * 0.065),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: size.height*0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: size.width * 0.02),
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$title",
                          style: GoogleFonts.zillaSlab(
                              color: secondaryColor, fontSize: size.width * 0.06),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                            "${widget.storyTitle ?? "$kellyTitle"}",
                            style: GoogleFonts.zillaSlab(
                                color: primaryColor, fontSize: size.width * 0.055),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: size.height * 0.027),
                          child: Text(
                            "$story",
                            style: GoogleFonts.zillaSlab(
                                color: secondaryColor,
                                fontSize: size.width * 0.055),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                          width: size.width,
                          margin: EdgeInsets.only(
                              left: size.width * 0.02,
                              right: size.width * 0.02),
                          child: TextField(
                            minLines: 1,
                            maxLines: 17,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.zillaSlab(
                                  color: secondaryColor,
                                  fontSize: size.width * 0.055),
                            ),
                            controller: _controller,
                            style:  GoogleFonts.zillaSlab(
                                color: primaryColor, fontSize: size.width * 0.05),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.02),
                        width: size.width,
                        height: size.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: MaterialButton(
                                color: secondaryColor,
                                onPressed: () {

                                  final snackBar = SnackBar(content: Text('$editorsMode',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 2,),backgroundColor: secondaryColor,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  Navigator.pop(context);
                                },
                                child: Text(' $editStory ',
                                    style: reviewButton(
                                        size: size.width * 0.035,
                                        color: Colors.black)),
                              ),
                              height: size.height * 0.047,
                            ),
                            Container(
                              height: size.height * 0.047,
                              child: MaterialButton(
                                  color: Colors.lightBlue,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "  $send  ",
                                        style: GoogleFonts.zillaSlab(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: size.width * 0.037),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    controllerTitle.clear();
                                    controllerStory.clear();
                                    sendStoryToFirebase(context);
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              isSubscribed==1?Container():Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: _bannerAd == null
                    ? Container(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: Container(
                          child: Text("$purchasedSubscription",
                              style: GoogleFonts.abel(
                                color: Colors.white,
                              )),
                        ),
                      )
                    : Container(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: AdWidget(
                          ad: _bannerAd,
                        ),
                      ),)
            ],
          ),
        ),
      ),
    ));
  }

  sendStoryToFirebase(BuildContext context) {
    FirebaseFirestore.instance.collection("Incoming Stories").add({
      "Date & Time Added": Timestamp.now(),
      "Story Body": widget.storyBody,
      "Title": widget.storyTitle ?? "Not Available",
      "User Email": FirebaseAuth.instance.currentUser.email,
      "username": userName
    }).whenComplete(() {
      final snackBar = SnackBar(content: Text('$thankYouForSharingYourStory',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 2,),backgroundColor: secondaryColor,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
    });
  }
}
