import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tellkelly/Style/app_text.dart';
import 'package:tellkelly/Style/style_sheet.dart';

class NewsAndUpdates extends StatefulWidget {
  @override
  _NewsAndUpdatesState createState() => _NewsAndUpdatesState();
}

class _NewsAndUpdatesState extends State<NewsAndUpdates> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: secondaryColor,onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "$infoAndMoreNewUpdate",
          style: GoogleFonts.courgette(
              color: primaryColor, fontSize: size.width * 0.043),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
          width:size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("NewsAndUpdates").doc("t7CINuGtJRUTdCp1Mmoz").snapshots(),
           builder: (_,snapshot){
              if(snapshot.hasData){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Container(
                        width: size.width,
                        child:CachedNetworkImage(
                          imageUrl: "${snapshot.data["image"]}",
                          placeholder: (context, url) => Container(
                            height: size.height*0.1,
                            child: SpinKitThreeBounce(
                              color: primaryColor,
                              size: size.width * 0.07,
                              controller: AnimationController(
                                  vsync: this, duration: const Duration(milliseconds: 1200)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),),
                    Text("$newsAndUpdate",style: GoogleFonts.zillaSlab(color: secondaryColor,
                        fontWeight: FontWeight.w400,fontSize: size.width*0.06),),
                    Container(
                      margin: EdgeInsets.only(top: size.height*0.01),
                      width: size.width,
                      alignment: Alignment.center,

                      child: Text("${snapshot.data["news_data"]}",
                        style: GoogleFonts.zillaSlab(color: primaryColor,fontSize: size.width*0.039),
                        textAlign: TextAlign.left,),
                    )
                  ],
                );
           }else{
                return Center(child: CircularProgressIndicator());
              }
           },
          )
        ),
      ),
    ));
  }
}

// t7CINuGtJRUTdCp1Mmoz