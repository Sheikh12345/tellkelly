import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

screenPush(BuildContext context,Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
}

screenPushRep(BuildContext context,Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));
}

