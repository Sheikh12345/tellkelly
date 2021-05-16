import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Screens/ReadStoryPage/read_story.dart';
import 'package:tellkelly/Style/style_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoadingScreen extends StatefulWidget {
  final storyBody;
  final imageAddress;
  final title;
  final favoriteButtonIsVisible;
  final replyBody;
  const LoadingScreen({Key key, this.storyBody, this.imageAddress, this.title, this.favoriteButtonIsVisible, this.replyBody}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin{


  InterstitialAd myInterstitial;

  /// this function is called after the init and before the build function
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadInterstitial();
  }
  bool _state;
  int isSubscribed;

  @override
  void initState() {
    super.initState();
    _state = true;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
    }).whenComplete((){
      print("isSubscribed $isSubscribed");
      setState(() {

      });
    });
  }


  /// Ad Function
  void loadInterstitial () async {
    myInterstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
          onAdLoaded: (Ad ad) {

            print("Ad loaded");
          },
          onAdClosed: (Ad ad) {
            print("Ad Closed");
            myInterstitial.dispose();
            Future.delayed(Duration(seconds: 2),(){
              myInterstitial.load();
            });
          }
      ),
    );
    myInterstitial.load();
  }



  @override
  Widget build(BuildContext context) {
    if(_state){
    _state = false;
    moveToReadStory();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
             SizedBox(
               height: size.height*0.25,
             ),
            Container(
                width: size.width*0.5,

                child: Image.asset("images/icon.png"))
        ],
    ),
      ),
      bottomNavigationBar: Container(
        width: size.width * 0.5,
        height: size.height * 0.07,
        child: SpinKitWave(
          color: primaryColor,
          size: size.width * 0.1,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }

  moveToReadStory(){
    Future.delayed(Duration(milliseconds: 1500),(){
      if(    isSubscribed==0){
        myInterstitial.show();
        Future.delayed(Duration(seconds: 1),(){
          screenPushRep(
              context,
              ReadStory(
                  title:widget.title,
                  imageAddress: widget.imageAddress,
                  storyBody:widget.storyBody,
                replyBody: widget.replyBody,
              ));
        });
      }else{
        screenPushRep(
            context,
            ReadStory(
              replyBody: widget.replyBody,
                favoriteButtonIsVisible: widget.favoriteButtonIsVisible,
                title:widget.title,
                imageAddress: widget.imageAddress,
                storyBody:widget.storyBody,
            ));
      }
    });

  }
}
