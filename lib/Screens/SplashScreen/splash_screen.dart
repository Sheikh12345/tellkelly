import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellkelly/Common/functions.dart';
import 'package:tellkelly/Providers/font_size_provider.dart';
import 'package:tellkelly/Screens/Auth/login.dart';
import 'package:tellkelly/Screens/Home/homes_screen.dart';
import 'package:tellkelly/Style/style_sheet.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
       AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });

    notificationPermission();

    Future.delayed(Duration(seconds: 4), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          screenPushRep(context, LoginPage());
        } else {
          screenPushRep(context, HomeScreen());
        }
      });
    });
  }


  notificationPermission() async {
    
    await FirebaseMessaging.instance.subscribeToTopic('newStories').whenComplete((){
      print("Topic set");
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setFontSize(size: size, contextt: context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.24,
          ),
          Container(
            width: size.width,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/icon.png"))),
            margin: EdgeInsets.only(bottom: size.height * 0.04),
          ),
          SizedBox(
            height: size.height * 0.35,
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                  text: "Tell ",
                  style: GoogleFonts.ruda(
                      fontSize: size.width * 0.074,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: "Kelly",
                      style: GoogleFonts.ruda(
                          fontSize: size.width * 0.074,
                          color: secondaryColor,
                          fontWeight: FontWeight.w600),
                    )
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: size.width * 0.5,
            height: size.height * 0.07,
            child: SpinKitThreeBounce(
              color: primaryColor,
              size: size.width * 0.07,
              controller: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 1200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setFontSize({Size size, BuildContext contextt}) {
    SharedPreferences.getInstance().then((pref) {
      Provider.of<FontSizeProvider>(contextt, listen: false)
          .setFontSize(pref.getDouble("fontSize") ?? size.width * 0.035);
    });
  }
}
