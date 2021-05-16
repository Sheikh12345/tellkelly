import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier{
  double _fontSize =0.0;
  double getFontSize() => _fontSize;

  setFontSize(double size ){
    _fontSize = size;
    notifyListeners();
  }

}