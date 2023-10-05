import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool refresh = false;
  String _menuName = '';
  String _imageUrl = '';
  String _menuID = '';
  String _type = '';
  String _pdfData = '';
  int _menuCount = 0;
  int _smartMenuSelected = 0;

  String get menuName => _menuName;
  String get imageUrl => _imageUrl;
  String get menuID => _menuID;
  String get type => _type;
  String get pdfData => _pdfData;
  int get menuCount => _menuCount;
  int get smartMenuSelected => _smartMenuSelected;

  void selectedMenu(String id, name, image, type, pdfData) {
    _menuID = id;
    _menuName = name;
    _imageUrl = image;
    _type = type;
    _pdfData = pdfData;
    notifyListeners();
  }

  void updateSmartMenuIndex(int menuNum) {
    _smartMenuSelected = menuNum;
    notifyListeners();
  }

  void updateMenuCount(int count) {
    _menuCount = count;
    notifyListeners();
  }

  bool get isRefresh => refresh;

  void menuRefresh() {
    refresh = !refresh;
    notifyListeners();
  }
}
