import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tellkelly/Screens/BestStoriesTab/my_best_stories.dart';
import 'package:tellkelly/Screens/CurrStoriesTab/current_stories.dart';
import 'package:tellkelly/Screens/HomeTab/home.dart';
import 'package:tellkelly/Screens/Info&MoreTab/info_and_more.dart';
import 'package:tellkelly/Screens/PreStoriesTab/previous_stories.dart';
import 'package:tellkelly/Screens/SendAStoryTab/send_a_story.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  TextEditingController _controllerMessage = TextEditingController();

  var _rating = 0.0;
  String userName;
  String subscriptionPrice;
  int isSubscribed;
  bool ratingIsAvailable;
  int userVisit=0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      isSubscribed = value.get("subscription");
      ratingIsAvailable = value.get("ratingIsAvailable");
      userVisit = value.get("userVisit");
      print(userVisit);
    }).whenComplete((){
      print("isSubscribed $isSubscribed");
      print("userVisit => $userVisit");

      setState(() {

      });
      if(!ratingIsAvailable && userVisit>0){
        Future.delayed(Duration(seconds: 4),(){
          _showDialog(size, buildContext);
        });
      }
    });
  }


  var auth = FirebaseAuth.instance;
  Size size;
  BuildContext buildContext;


  int _selectedIndex;

  List pages = [
    HomeTab(),
    CurrentStories(),
    PreviousStories(),
    SendAStory(),
    BestStories(),
    InfoMore()
  ];

  void _incrementTab(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: size.height * 0.067 + 5,
        color: Colors.black,
        child: BottomNavigationBar(
          selectedItemColor: secondaryColor,
          backgroundColor: Colors.black,
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "Home",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 0 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.play_circle_fill,
                color: _selectedIndex == 1 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "Current Stories",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 1 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.fast_rewind_outlined,
                color: _selectedIndex == 2 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "Previous Stories",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 2 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.send_sharp,
                color: _selectedIndex == 3 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "Send A Story",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 3 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.favorite_sharp,
                color: _selectedIndex == 4 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "My Best Stories",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 4 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.info_outline_rounded,
                color: _selectedIndex == 5 ? secondaryColor : primaryColor,
              ),
              title: Text(
                "Info & More",
                style: GoogleFonts.courgette(
                    color: _selectedIndex == 5 ? secondaryColor : primaryColor,
                    fontSize: size.width * 0.022),
              ),
            ),
          ],
          onTap: (index) {
            _incrementTab(index);
            print(index);
          },
        ),
      ),
    ));
  }


  _showDialog(Size size,BuildContext context){
    showDialog(context: context, builder: (_)=>AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
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
                  width: size.width*0.46,
                  child: Image.asset("images/icon.png")
              ),
              Text("Tell Kelly",style: GoogleFonts.ruda(color: Colors.black,fontSize: size.width*0.07,fontWeight: FontWeight.w600),),
              SizedBox(
                height: size.height*0.01,
              ),
              Text("Use stars to rate the Tell Kelly App.",style: GoogleFonts.ruda(color: Colors.black,fontSize: size.width*0.035,fontWeight: FontWeight.w600))

              ,       SizedBox(
                height: size.height*0.02,
              ),SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (selectedRating) {
                    setState(() {
                      _rating = selectedRating;
                    });
                  },
                  starCount: 5,
                  rating: _rating,
                  size: size.width*0.11,
                  color: Colors.yellow.shade700,
                  borderColor: Colors.grey,
                  spacing:0.0
              ),
              SizedBox(
                height: size.height*0.02,
              ),
              Text("Please share a comment (optional)",style: GoogleFonts.ruda(color: Colors.grey[700],fontSize: size.width*0.041,fontWeight: FontWeight.w600),)
              ,   TextField(
                decoration: InputDecoration(

                ),
              ),
              SizedBox(
                height: size.height*0.01,
              ),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){
                  sendMessageToFirebase(context);
                },color: Colors.blue,
                child: Text("Send Review",style: GoogleFonts.ruda(color: Colors.white),),),


            ],
          ),
        ),
      ),),);
  }

  sendMessageToFirebase(BuildContext context) {
    if(_rating!=0.0) {
      FirebaseFirestore.instance.collection("reviews").add({
        "displayName":userName,
        "message":_controllerMessage.text,
        "rating":_rating
      }).whenComplete(() {
        final snackBar = SnackBar(content: Text('Review Sent',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: secondaryColor,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser.uid).update({
          "ratingIsAvailable":true
        });
      });
    }else{
      final snackBar = SnackBar(content: Text('Rating is empty',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
