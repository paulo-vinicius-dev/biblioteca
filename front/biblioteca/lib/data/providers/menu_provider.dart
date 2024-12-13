import 'package:flutter/material.dart';

class MenuState extends ChangeNotifier {
  int _expandedIndex = -1;

  int get expandedIndex => _expandedIndex;

  set expandedIndex(int index) {
    _expandedIndex = index;
    notifyListeners();
  }

  void reset() {
    _expandedIndex = -1;
    notifyListeners();
  }
}
