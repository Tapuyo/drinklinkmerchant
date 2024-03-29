import 'package:drinklinkmerchant/%20model/smart_menu_model.dart';
import 'package:drinklinkmerchant/%20model/smart_menu_section_model.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  //Sub menu
  bool _isMenuOpen = true;
  int _indexMenu = 100;

  bool refresh = false;
  bool _isImageLoaded = false;
  String _menuName = '';
  String _imageUrl = '';
  String _menuID = '';
  String _type = '';
  String _pdfData = '';
  int _menuCount = 0;
  String _choosenOutletMenId = '';
  String _importFileName = '';
  String _importImage = '';
  String _importType = '';
  String _importMenuName = '';
  int _chooseOutletIndex = -1;
  int _chooseOutletIndexSelected = -1;
  String _searchMenuName = '';
  int _smartMenuSelected = 0;
  List<String> _workStation = [];
  final List<MenuModel> _smartMenu = [];
  final List<MenuSectionModel> _smartMenuSection = [];

  List<MenuSectionModel> get smartMenuSection => _smartMenuSection;
  List<MenuModel> get smartMenu => _smartMenu;
  List<String> get workStation => _workStation;
  bool get isImageLoaded => _isImageLoaded;
  String get menuName => _menuName;
  String get imageUrl => _imageUrl;
  String get menuID => _menuID;
  String get type => _type;
  String get pdfData => _pdfData;
  int get menuCount => _menuCount;
  String get ChoosenOutletMenId => _choosenOutletMenId;
  String get importFileName => _importFileName;
  String get importImage => _importImage;
  String get importType => _importType;
  String get importMenuName => _importMenuName;
  int get chooseOutletIndex => _chooseOutletIndex;
  int get chooseOutletIndexSelected => _chooseOutletIndexSelected;
  String get searchMenuName => _searchMenuName;
  bool get isMenuOpen => _isMenuOpen;
  int get indexMenu => _indexMenu;
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

  void setImageLoaded(bool isloaded) {
    _isImageLoaded = isloaded;
    notifyListeners();
  }

  void setChoosenOutletMenId(String Id) {
    _choosenOutletMenId = Id;
    notifyListeners();
  }

  void setImportImage(String str1, str2, str3, str4) {
    _importFileName = str1;
    _importImage = str2;
    _importType = str2;
    _importMenuName = str4;
    notifyListeners();
  }

  void setChooseOutletIndex(int ind) {
    _chooseOutletIndex = ind;
    notifyListeners();
  }

  void setChooseOutletIndexSelected(int ind) {
    _chooseOutletIndexSelected = ind;
    notifyListeners();
  }

  void setSearchMenuName(String name) {
    _searchMenuName = name;
    notifyListeners();
  }

  void setIsMenuOpen(bool open) {
    _isMenuOpen = open;
    notifyListeners();
  }

  void setIndexMenu(int menu) {
    _indexMenu = menu;

    notifyListeners();
  }

  void setWorkStation(List<String> value) {
    _workStation = value;

    notifyListeners();
  }

  void addSmartMainMenu(MenuModel value) {
    _smartMenu.add(value);

    notifyListeners();
  }

  void addSmartMainMenuSection(MenuSectionModel value) {
    _smartMenuSection.add(value);

    notifyListeners();
  }
}
