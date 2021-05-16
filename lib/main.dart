import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'Providers/font_size_provider.dart';
import 'Providers/provider_error_model.dart';
import 'Screens/SplashScreen/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
FirebaseMessaging messaging = FirebaseMessaging.instance;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Tell Kelly', // title
    'New Stories are arrived please check it.', // description
    importance: Importance.high,
    playSound: true);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    await Firebase.initializeApp();


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,

    );
    runApp(
        MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_)=>ProviderError()),
              ChangeNotifierProvider(create: (_)=>FontSizeProvider())
            ],
            child:MyApp()
        )
    );
  } catch (e) {}
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}
