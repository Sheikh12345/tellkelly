import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Screens/Info&MoreTab/Components/SubPages/acknowledgement_article.dart';
import 'package:tellkelly/Screens/Info&MoreTab/Components/SubPages/remove_ads.dart';
import 'package:tellkelly/Services/AdMob/ad_state.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';
import 'Components/Info_button.dart';
import 'Components/SubPages/message_us.dart';
import 'Components/SubPages/news_and_updates.dart';
import 'Components/SubPages/share_app.dart';
import 'Components/SubPages/the_rundown.dart';
import 'package:http/http.dart' as http;

class InfoMore extends StatefulWidget {
  @override
  _InfoMoreState createState() => _InfoMoreState();
}

class _InfoMoreState extends State<InfoMore> {
  final cloudFunctionUrl =
      'https://us-central1-kellysadvicecolumn.cloudfunctions.net/helloWorld';

  var _rating = 0.0;
  String userName;
  String subscriptionPrice;
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
          listener: AdListener(onAdClosed: (Ad ad) {
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
    super.initState();
    setState(() {
      _rating = 0.0;
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
    }).whenComplete(() {
      setState(() {});
    });
    FirebaseFirestore.instance
        .collection("admin")
        .doc("subscriptionPrice")
        .get()
        .then((value) {
      subscriptionPrice = value.get("price");
    }).whenComplete(() {
      print(subscriptionPrice);
      setState(() {});
    });
  }

  TextEditingController _controllerMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$infoAndMoreText",
          style: GoogleFonts.courgette(
              fontSize: size.width * 0.06, color: primaryColor),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$selectCategory",
              style: GoogleFonts.ruda(
                  color: secondaryColor, fontSize: size.width * 0.04),
              textAlign: TextAlign.center,
            ),
            InfoButton(
              text: "$theRundown",
              onPressed: () {
                screenPush(context, TheRundown());
              },
              value: 0.35,
            ),
            InfoButton(
              text: "$newsPlusUpdate",
              onPressed: () {
                screenPush(context, NewsAndUpdates());
              },
              value: 0.33,
            ),
            InfoButton(
              text: "$ackArticle",
              onPressed: () {
                screenPush(context, AcknowledgementsPage());
              },
              value: 0.252,
            ),
            InfoButton(
              text: "$messageUs",
              onPressed: () {
                screenPush(context, MessageUs());
              },
              value: 0.365,
            ),
            InfoButton(
              text: "$rateTheApp",
              onPressed: () {
                _showDialog(size, context);
              },
              value: 0.355,
            ),
            InfoButton(
              text: "$shareApp",
              onPressed: () {
                screenPush(context, ShareApp());
              },
              value: 0.355,
            ),
            InfoButton(
              text: "$removeAds ( \$$subscriptionPrice )",
              onPressed: () {
                choosePaymentMethodDialog(size, context);
                // screenPush(context, RemoveAds());
              },
              value: 0.355,
            ),
          ],
        ),
      ),
      bottomNavigationBar: isSubscribed == 1
          ? Container()
          : Container(
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
                    )),
    );
  }

  _showDialog(Size size, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        scrollable: true,
        backgroundColor: Colors.white,
        content: Container(
          width: size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: size.width * 0.46,
                    child: Image.asset("images/icon.png")),
                Text(
                  "$appName",
                  style: GoogleFonts.ruda(
                      color: Colors.black,
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text("$useStarsToRateTheTellKellyApp",
                    style: GoogleFonts.ruda(
                        color: Colors.black,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (selectedRating) {
                      setState(() {
                        _rating = selectedRating;
                      });
                    },
                    starCount: 5,
                    rating: _rating,
                    size: size.width * 0.11,
                    color: Colors.yellow.shade700,
                    borderColor: Colors.grey,
                    spacing: 0.0),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  "$pleaseShareAComment",
                  style: GoogleFonts.ruda(
                      color: Colors.grey[700],
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w600),
                ),
                TextField(
                  decoration: InputDecoration(),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    sendMessageToFirebase(context);
                  },
                  color: Colors.blue,
                  child: Text(
                    "$sendReview",
                    style: GoogleFonts.ruda(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendMessageToFirebase(BuildContext context) {
    if (_rating != 0.0) {
      FirebaseFirestore.instance.collection("reviews").add({
        "displayName": userName,
        "message": _controllerMessage.text,
        "rating": _rating
      }).whenComplete(() {
        final snackBar = SnackBar(
          content: Text(
            '$reviewSent',
            style: GoogleFonts.zillaSlab(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
          ),
          duration: Duration(
            seconds: 1,
          ),
          backgroundColor: secondaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          '$ratingIsEmpty',
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  choosePaymentMethodDialog(Size size, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        scrollable: true,
        backgroundColor: Colors.white,
        content: Container(
          width: size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$paymentOption",
                  style: GoogleFonts.ruda(
                      color: Colors.black,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        paymentByPayPal(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.06,
                            bottom: size.height * 0.04),
                        width: size.width * 0.4,
                        child: Image.asset("images/paypal.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        screenPush(
                            context,
                            RemoveAds(
                              amount: subscriptionPrice,
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: size.height * 0.04,
                            top: size.height * 0.06,
                            left: size.width * 0.05),
                        width: size.width * 0.2,
                        child: Image.asset("images/stripe.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  paymentByPayPal(BuildContext context) async {
    var request = BraintreeDropInRequest(
        tokenizationKey: 'sandbox_jy969tfn_rprz9k6dvjxdbs47',
        collectDeviceData: true,
        cardEnabled: true,
        paypalRequest: BraintreePayPalRequest(
            amount: subscriptionPrice,
            displayName: "Tell Kelly",
            currencyCode: "USD"));

    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      print(result.paymentMethodNonce.description);
      print(result.paymentMethodNonce.nonce);
      final http.Response response = await http.post(Uri.tryParse(
          '$cloudFunctionUrl?=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));
      final payResult = jsonDecode(response.body);
      if (payResult['result'] == 'success') {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({"subscription": 1});

        final snackBar = SnackBar(
          content: Text(
            '$successfullyPurchased',
            style: GoogleFonts.zillaSlab(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
          ),
          duration: Duration(
            seconds: 1,
          ),
          backgroundColor: secondaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("error => " + payResult['result']);
      }
    }
  }
}

/// Info Button design
