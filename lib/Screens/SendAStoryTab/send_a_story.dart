import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Screens/SendAStoryTab/review_story.dart';
import 'package:tellkelly/Services/AdMob/ad_state.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class SendAStory extends StatefulWidget {
  @override
  _SendAStoryState createState() => _SendAStoryState();
}
TextEditingController controllerTitle = TextEditingController();
TextEditingController controllerStory = TextEditingController();

class _SendAStoryState extends State<SendAStory> {
  int isSubscribed;
  BannerAd _bannerAd;
  InterstitialAd myInterstitial;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState().bannerAdUnitId,
          listener:  AdListener(
              onAdLoaded: (Ad ad) {

                print("Ad loaded");
              },
              onAdClosed: (Ad ad) {
                print("Ad Closed");
                _bannerAd.dispose();
                Future.delayed(Duration(seconds: 2),(){
                  _bannerAd.load();
                });
              }
          ),
          request: AdRequest())
        ..load();
    });

  }

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
          child: Container(
            height: size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Column(
                  children: [
                    Text(
                      "$sendAStory",
                      style: GoogleFonts.courgette(
                          color: primaryColor,
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      "$tellKellyYourStory...",
                      style: GoogleFonts.courgette(
                          color: primaryColor,
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.7),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.04),
                      height: size.height * 0.2,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: TextField(
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.emailAddress,
                              style: formFieldLabelText(),
                              cursorColor: secondaryColor,
                              controller: controllerTitle,
                              decoration: InputDecoration(
                                errorBorder: errorFieldBorder,
                                errorStyle: errorText(),
                                focusedErrorBorder: errorFieldBorder,
                                hintStyle: formFieldHintText(),
                                labelText: "$storyTitle",
                                focusedBorder: formFieldBorder,
                                labelStyle: formFieldLabelText(),
                                enabledBorder: formFieldBorder,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.002,
                          ),
                          Text(
                            "$youCanLeaveTitleBlank",
                            style: GoogleFonts.cabin(
                                color: secondaryColor,
                                fontSize: size.width * 0.025,
                                letterSpacing: 0.7,
                                height: -1),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.02,
                          right: size.width * 0.02,
                          top: size.width * 0.02),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 14,
                        minLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        style: formFieldLabelText(),
                        cursorColor: secondaryColor,
                        controller: controllerStory,
                        decoration: InputDecoration(
                          errorBorder: errorFieldBorder,
                          errorStyle: errorText(),
                          focusedErrorBorder: errorFieldBorder,
                          hintStyle: formFieldHintText(),
                          labelText: "$story",
                          focusedBorder: formFieldBorder,
                          labelStyle: formFieldLabelText(),
                          enabledBorder: formFieldBorder,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: size.height * 0.065,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(

                            child: MaterialButton(
                                color: primaryColor,
                                onPressed: () {
                                  sendToReview(context);
                                },
                                child: Text(' $reviewStory ',
                                    style: GoogleFonts.ruda(fontSize: size.width*0.025,color: Colors.black,fontWeight: FontWeight.w600))
                            ),
                            height: size.height * 0.05,
                          ),
                          Container(
                            height: size.height * 0.05,
                            child: MaterialButton(
                                color: negButtonColor,
                                child: Text(
                                    " $deleteTitleAndStory ",
                                    style: GoogleFonts.ruda(fontSize: size.width*0.025,color: Colors.white,fontWeight: FontWeight.w600)
                                ),
                                onPressed: () {
                                  controllerTitle.clear();
                                  controllerStory.clear();
                                  final snackBar = SnackBar(content: Text('$cleared',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: secondaryColor,);

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                )),

                isSubscribed==1?Container():Container(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: _bannerAd==null?Container(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: Container(
                    child: Text("$purchasedSubscription",style:GoogleFonts.abel(
                      color: Colors.white,
                    )),
                  ),
                ):Container(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child:AdWidget(ad: _bannerAd,) ,
                ))

              ],
            ),
          ),
        ),
      ),
    );
  }
  final snackBar = SnackBar(content: Text('$pleaseEnterStoryAndThenTry',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);

  sendToReview(BuildContext context){
    if(controllerStory.text.length<=0){
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      String capitalizedTitle;
      if(controllerTitle.text.length==0){
    capitalizedTitle =null;
    }else{
        capitalizedTitle = StringUtils.capitalize("${controllerTitle.text??""}",allWords: true);
    }
      screenPush(context, ReviewStory(storyBody:"$hiKelly... "+controllerStory.text,storyTitle: capitalizedTitle,));
    }
  }
}
