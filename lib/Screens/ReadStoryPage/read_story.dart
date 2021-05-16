import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellkelly/LocalStorage/sqflite_database.dart';
import 'package:tellkelly/Providers/font_size_provider.dart';
import 'package:tellkelly/Services/AdMob/ad_state.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class ReadStory extends StatefulWidget {
  final storyBody;
  final imageAddress;
  final title;
  final favoriteButtonIsVisible;
  final replyBody;
  const ReadStory(
      {Key key,
      this.storyBody,
      this.imageAddress,
      this.title,
      this.favoriteButtonIsVisible, this.replyBody})
      : super(key: key);
  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
  bool _isLike = false;
  int isSubscribed;
  BannerAd _bannerAd;
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState().bannerAdUnitId,
          listener: AdListener(
              onAdLoaded: (Ad ad) {},
              onAdClosed: (Ad ad) {
                _bannerAd.dispose();
                Future.delayed(Duration(seconds: 2), () {
                  _bannerAd.load();
                });
              }),
          request: AdRequest())
        ..load();
    });
  }

  double _fontSize;
  SharedPreferences prefs;
  @override
  void initState() {
    LocalDatabase.instance.readOne(widget.title).then((value) {
      if (value != null) {
        print(value[0]["storyImageUrl"]);
        _isLike = value[0]["storyName"] == widget.title;
        print("_isLike $_isLike");
        setState(() {});
      }
    });
    super.initState();
    getInstance();
    _fontSize = 0.0;
  }

  getInstance() async {
    prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
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
                "Story",
                style: headerText15(size: size.width * 0.05),
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible,
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.format_size_sharp,
                      color: secondaryColor,
                    ),
                    tooltip: "Font Size",
                    onPressed: () {
                      _showDialog(size, context);
                    })
              ],
            ),
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (widget.imageAddress.length<2||widget.imageAddress==null)?Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                      color: Colors.blue
                      ),
                      child: Text(
                        "${widget.title}",
                        style: GoogleFonts.courgette(
                            color: Colors.yellow, fontSize: size.width * 0.06,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      width: size.width,
                      height: size.height * 0.22,
                    )
                        :
                    Container(
                      margin: EdgeInsets.all(size.width * 0.02),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          ),
                      width: size.width,
                      height: size.height * 0.22,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageAddress,
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
                          shimmerHighlightColor: Colors.blue,
                          width: size.width*0.9,
                          height: size.height * 0.22,
                        ),),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      child: (widget.imageAddress.length<2||widget.imageAddress==null)?Text(""):Text(
                        "${widget.title}",
                        style: GoogleFonts.zillaSlab(
                            color: primaryColor, fontSize: size.width * 0.05),
                        textAlign: TextAlign.center,
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.012,
                          vertical: size.height * 0.018),
                    ),
                    Container(
                      width: size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Text(
                        "${widget.storyBody}",
                        style: GoogleFonts.zillaSlab(
                          fontSize: Provider.of<FontSizeProvider>(context)
                              .getFontSize(),
                          color: primaryColor,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: size.height*0.02),
                      width: size.width,
                      margin:
                      EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Text(
                        "${"Kelly says:\n ${widget.replyBody}"}",
                        style: GoogleFonts.zillaSlab(
                          fontSize: Provider.of<FontSizeProvider>(context)
                              .getFontSize(),
                          color: secondaryColor,
                        ),
                      ),
                    ),


                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Visibility(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                var data =
                                    await LocalDatabase.instance.readAll();
                                print(data);
                              },
                              child: Text(
                                "Like Me? Add to 'My Best Stories'  ",
                                style: GoogleFonts.zillaSlab(
                                  color: primaryColor,
                                  fontSize: size.width * 0.04,
                                ),
                              )),
                          Container(
                              width: size.width * 0.14,
                              height: size.width * 0.14,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: primaryColor),
                              child: IconButton(
                                icon: DecoratedIcon(
                                  Icons.favorite,
                                  color:_isLike? Colors.red:Colors.black,
                                  size: size.width*0.06,
                                  shadows: [
                                    BoxShadow(
                                      blurRadius: 42.0,
                                      color: _isLike? Colors.red:Colors.black,
                                    ),
                                    BoxShadow(
                                      blurRadius: 12.0,
                                      color: _isLike? Colors.red:Colors.black,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLike = !_isLike;
                                    print(_isLike);
                                    addOrRemoveBestStories(
                                        title: widget.title,
                                        body: widget.storyBody,
                                        imageUrl: widget.imageAddress);
                                  });
                                },
                              ))
                        ],
                      ),
                    )
                  ],
                ),
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
                              child:
                                  Text("Purchased Subscription to remove Ads",
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
                          ))));
  }

  addOrRemoveBestStories({String title, String body, String imageUrl}) async {
    print(imageUrl);
    if (_isLike) {
      int status = await LocalDatabase.instance.insert({
        LocalDatabase.storyName: title,
        LocalDatabase.storyImageUrl: imageUrl,
        LocalDatabase.storyBody: body
      });

      print("status $status");
    } else {
      int status = await LocalDatabase.instance.delete(title);
      print("Deleted $status");
    }
  }

  _showDialog(Size size, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        scrollable: true,
        backgroundColor: Colors.black,
        content: Container(
            width: size.width,
            child: Column(
              children: [
                Consumer<FontSizeProvider>(
                  builder: (context, fontSize, child) => Container(
                    width: size.width * 0.7,
                    alignment: Alignment.bottomCenter,
                    child: SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 5)),
                      child: Slider(
                        activeColor: errorFieldColor,
                        min: size.width * 0.035,
                        max: size.width * 0.1,
                        value: Provider.of<FontSizeProvider>(context,
                                listen: false)
                            .getFontSize(),
                        divisions: 7,
                        inactiveColor: Colors.grey,
                        onChanged: (val) {
                          setState(() {
                            Provider.of<FontSizeProvider>(context,
                                    listen: false)
                                .setFontSize(val);
                            prefs.setDouble(
                                "fontSize",
                                Provider.of<FontSizeProvider>(context,
                                        listen: false)
                                    .getFontSize());
                          });
                        },
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: primaryColor,
                  child: Text(
                    "Okay",
                    style: GoogleFonts.ruda(
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
