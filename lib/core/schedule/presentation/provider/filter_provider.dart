import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  int _filter = 1;
  void next() {
    if (_filter > 2) {
      _filter = 1;
    } else {
      _filter++;
    }
    notifyListeners();
  }

  int get filter => _filter;  
}
