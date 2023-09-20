import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../provider/businessOutletProvider.dart';
import '../../provider/menu_provider.dart';
import '../components/showDialog.dart';
import '../controller/outletController.dart';
import '../data_class/businesses_class.dart';
import '../data_class/outlet_class.dart';
import '../data_class/region_class.dart';

class OutletsPage extends StatefulWidget {
  const OutletsPage({super.key});

  @override
  State<OutletsPage> createState() => _OutletsPageState();
}

class _OutletsPageState extends State<OutletsPage> {
  CollectionReference regionCollection =
      FirebaseFirestore.instance.collection('region');
  CollectionReference cusineCollection =
      FirebaseFirestore.instance.collection('cuisine');
  CollectionReference cusineStyleCollection =
      FirebaseFirestore.instance.collection('cuisineStyle');

  List<DocumentSnapshot> documentsx = [];
  List<BusinessesClass> businessesClass = [];
  List<OutletClass> outletClass = [];
  List<RegionClass> regionClass = [];

  String outletId = '';
  String outletIdProvider = '';
  String currentItem = 'Select Outlet';
  String currentOutletName = '';
  String currentRegion = '';
  String currentRegionId = '';
  String currentCusine = '';
  String currentCusineId = '';
  String currentCusineStyle = '';
  String currentCusineStylId = '';

  OutletClass? dropDownValue;
  String businessName = '';
  String businessId = '';
  bool isSelectedOutlet = false;
  int indexYesNo = 0;
  int indexYesNoCategory = 0;
  int indexYesNoCategoryCount = 0;
  List<int> indexSchedule = [];
  List<int> indexScheduleAdded = [];
  bool isSetDefaultWall = false;
  bool isAbsorb = true;
  String saveEditButton = 'EDIT';
  int addHeight = 100;
  bool isPostbackLoad = false;

  TextEditingController txtSearchRegion = TextEditingController();
  String strSearchRegion = '';

  TextEditingController txtSearchCusine = TextEditingController();
  String strSearchCusine = '';

  TextEditingController txtSearchCusineStyle = TextEditingController();
  String strSearchCusineStyle = '';

  TextEditingController txtLocation = TextEditingController();
  String strLocation = '';
  // String strLocation = 'Queen Elizabeth Ave. 12, 20-233 Angel Town';

  TextEditingController txtNumber = TextEditingController();
  String strNumber = '';
  // String strNumber = '+343 59 456 3452';

  TextEditingController txtEmail = TextEditingController();
  String strEmail = '';
  // String strEmail = 'xxxww@coffeebean.com';

  TextEditingController txtDescription = TextEditingController();
  String strDescription = '';
  // String strDescription = 'Cafetteria, Bar';

  TextEditingController txtCurrency = TextEditingController();
  String strCurrency = '';
  // String strCurrency = 'USD';

  TextEditingController txtMondayStart = TextEditingController();
  String strMondayStart = '';

  TextEditingController txtMondayEnd = TextEditingController();
  String strMondayEnd = '';

  TextEditingController txtTuesdayStart = TextEditingController();
  String strTuesdayStart = '';

  TextEditingController txtTuesdayEnd = TextEditingController();
  String strTuesdayEnd = '';

  TextEditingController txtWednesdayStart = TextEditingController();
  String strWednesdayStart = '';

  TextEditingController txtWednesdayEnd = TextEditingController();
  String strWednesdayEnd = '';

  TextEditingController txtThursdaytart = TextEditingController();
  String stThursdayStart = '';

  TextEditingController txtThursdayEnd = TextEditingController();
  String strThursdayEnd = '';

  TextEditingController txtFridayStart = TextEditingController();
  String strFridayStart = '';

  TextEditingController txtFridayEnd = TextEditingController();
  String strFridayEnd = '';

  TextEditingController txtSaturdayStart = TextEditingController();
  String strSaturdayStart = '';

  TextEditingController txtSaturdayEnd = TextEditingController();
  String strSaturdayEnd = '';

  TextEditingController txtSundayStart = TextEditingController();
  String strSundayStart = '';

  TextEditingController txtSundayEnd = TextEditingController();
  String strSundayEnd = '';

  int intStar = 0;

  List<String> categoryList = <String>[
    'Cafetteria',
    'Bar',
    'Restaurant',
    'Bar2',
    'Cafetteria3',
    'Bar3',
    'Cafetteria4',
    'Bar4',
    'Cafetteria5',
    'Bar5',
    'Cafetteria6',
    'Bar6',
    'Cafetteria7',
    'Bar7'
  ];

  List<String> scheduleList = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  List<String> categoryListAdded = [];
  List<String> scheduleListAdded = [];

  List<DropdownMenuItem<OutletClass>> _createList() {
    return outletClass
        .map<DropdownMenuItem<OutletClass>>(
          (e) => DropdownMenuItem(
            value: e,
            child: Center(
              child: Text(
                e.name,
                style: const TextStyle(
                  color: Color(0xffbef7700),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuEntry<RegionClass>> _createListREgion() {
    return regionClass
        .map<DropdownMenuEntry<RegionClass>>(
          (e) => DropdownMenuEntry(value: e, label: e.name),
        )
        .toList();
  }

  List<DropdownMenuEntry<OutletClass>> _createListOutlet() {
    return outletClass.map<DropdownMenuEntry<OutletClass>>((e) {
      return DropdownMenuEntry(value: e, label: e.name);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final businessProviderRead = context.read<BusinessOutletProvider>();

    final docId = context.select((BusinessOutletProvider p) => p.docId);

    final businessNamex =
        context.select((BusinessOutletProvider p) => p.businessName);
    final defaultOutletIdProvider =
        context.select((BusinessOutletProvider p) => p.defaultOutletId);

    final outletClassx =
        context.select((BusinessOutletProvider p) => p.outletClass);
    final regionClassx =
        context.select((BusinessOutletProvider p) => p.regionClass);
    final isSelected =
        context.select((BusinessOutletProvider p) => p.isBusinessSelected);

    final businessesData = Provider.of<List<BusinessesClass>>(context);
    businessesClass = businessesData
        .where((item) =>
            item.defaultOutletId.toLowerCase() == outletId.toLowerCase())
        .toList();

    outletClass = outletClassx;
    businessName = businessNamex;
    businessId = docId;
    outletIdProvider = defaultOutletIdProvider;

    // regionClass = regionClassx;
    print(regionClass.length);
    print('${outletId}outlet id here');
    regionClass =
        regionClass.where((item) => item.outletId == outletId).toList();
    print(regionClass.length);
    if (isSelected == true) {
      currentItem = 'Select Outlet';

      currentOutletName = '';
      businessProviderRead.setIsBusinessSelected(false);
    }
    if (currentItem == 'Select Outlet') {
      isSelectedOutlet = false;
    }

    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValuex = list.first;

    const List<String> listRegion = <String>[
      'Central African cuisine',
      'East African cuisine',
      'North African cuisine',
      'Southern African cuisine'
    ];
    String dropdownValueRegion = listRegion.first;

    const List<String> listCuisine = <String>[
      'Angolan cuisine',
      'Cameroonian cuisine',
      'Chadian cuisine',
      'Gabonese cuisine'
    ];
    String dropdownValueCuisine = listCuisine.first;

    // final dropdown = DropdownButton<OutletClass>(
    //   items: _createList(),
    //   underline: const SizedBox(),
    //   iconSize: 0,
    //   isExpanded: false,
    //   borderRadius: BorderRadius.circular(20),
    //   hint: Container(
    //     width: 200,
    //     height: 50,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10.0),
    //       color: isSelectedOutlet == true
    //           ? const Color(0xffef7700)
    //           : Colors.grey.shade200,
    //     ),
    //     alignment: Alignment.center,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.business,
    //           color: isSelectedOutlet == true
    //               ? Colors.white
    //               : const Color.fromARGB(255, 66, 64, 64),
    //         ),
    //         const SizedBox(
    //           width: 5,
    //         ),
    //         Text(
    //           currentItem,
    //           style: TextStyle(
    //             fontFamily: 'SFPro',
    //             fontSize: 18,
    //             color: isSelectedOutlet == true
    //                 ? Colors.white
    //                 : const Color.fromARGB(255, 66, 64, 64),
    //             fontWeight: FontWeight.w500,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //   ),
    //   onChanged: (OutletClass? value) {
    //     setState(() {
    //       currentItem = value!.name;
    //       currentOutletName = value.name;
    //       strLocation = value.location;
    //       indexYesNo = value.isLocatedAt == true ? 0 : 1;
    //       strNumber = value.contactNumber;
    //       strEmail = value.email;
    //       strDescription = value.description;
    //       strCurrency = value.currency;
    //       intStar = value.star;
    //       outletId = value.id;
    //       txtLocation.text = strLocation;
    //       txtNumber.text = strNumber;
    //       txtEmail.text = strEmail;
    //       txtDescription.text = strDescription;
    //       txtCurrency.text = strCurrency;

    //       dropDownValue = value;
    //       isSelectedOutlet = true;
    //       print('$defaultOutletIdProvider + $outletId');
    //       // defaultOutletIdProvider.toLowerCase() == outletId.toLowerCase()
    //       //     ? isSetDefaultWall = true
    //       //     : isSetDefaultWall = false;
    //       currentRegionId = value.regionId;
    //       currentRegion = value.regionName;
    //       currentCusineId = value.cuisineId;
    //       currentCusine = value.cuisineName;
    //       currentCusineStylId = value.cuisineStyleId;
    //       currentCusineStyle = value.cuisineStyleName;

    //       businessesClass[0].defaultOutletId.toLowerCase() ==
    //               outletId.toLowerCase()
    //           ? isSetDefaultWall = true
    //           : isSetDefaultWall = false;
    //     });
    //   },
    // );

    void save() async {
      // List<String> category = [];

      print('saveOutlet');
      saveEditButton = 'EDIT';
      isAbsorb = true;
      strLocation = txtLocation.text;
      strNumber = txtNumber.text;
      strEmail = txtEmail.text;
      strDescription = txtDescription.text;
      strCurrency = txtCurrency.text;
      addHeight = 100;
      if (isSetDefaultWall == true) {
        context.read<BusinessOutletProvider>().setDefaultOutletId(outletId);
      }

      await saveBusinessOutlet(
          isSetDefaultWall,
          businessId,
          outletId,
          txtEmail.text,
          txtNumber.text,
          txtLocation.text,
          indexYesNo,
          txtCurrency.text,
          currentRegionId,
          currentRegion,
          currentCusineId,
          currentCusine,
          currentCusineStylId,
          currentCusineStyle,
          '',
          categoryListAdded);
      // businessProviderRead.setDocId(docId);
    }

    void update() async {
      saveEditButton = 'SAVE';
      isAbsorb = false;
      txtLocation.text = strLocation;
      txtNumber.text = strNumber;
      txtEmail.text = strEmail;
      txtDescription.text = strDescription;
      txtCurrency.text = strCurrency;
      addHeight = 0;
    }

    isSelectedOutlet == false
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(getDefaultOutlet))
        : null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0.0, 40.0, 0.0),
        child: Column(
          children: [
            // DropdownMenu<String>(
            //   initialSelection: list.first,
            //   onSelected: (String? value) {
            //     // This is called when the user selects an item.
            //     setState(() {
            //       dropdownValuex = value!;
            //     });
            //   },
            //   dropdownMenuEntries:
            //       list.map<DropdownMenuEntry<String>>((String value) {
            //     return DropdownMenuEntry<String>(value: value, label: value);
            //   }).toList(),
            // )
            // FloatingActionButton(
            //   child: const Text('Refresh'),
            //   onPressed: () {
            //     setState(() {
            //       // _getOutlet('tZajIXre4OqWnhWg5RsV');
            //     });
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Main Wall',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffef7700)),
                  ),
                  SizedBox(
                    width: 230,
                    child: outletClass.isEmpty
                        ? Container()
                        : Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: DropdownMenu<OutletClass>(
                              enableSearch: true,
                              enableFilter: true,

                              inputDecorationTheme: const InputDecorationTheme(
                                  border: InputBorder.none,
                                  fillColor: Color(0xffef7700),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xffef7700))
                                  // border: UnderlineInputBorder(

                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.all(
                                  //     Radius.circular(20.0),
                                  //   ),
                                  // ),
                                  ),

                              // menuStyle: const MenuStyle(
                              //   surfaceTintColor: MaterialStatePropertyAll<Color>( Color(0xffef7700))
                              // ),
                              // initialSelection: list.first,
                              trailingIcon: const Icon(
                                Icons.search,
                                color: Color(0xffef7700),
                              ),
                              // selectedTrailingIcon: null,
                              width: 200,
                              hintText: currentItem,
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xffef7700)),

                              onSelected: (OutletClass? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  currentItem = value!.name;
                                  currentOutletName = value.name;
                                  strLocation = value.location;
                                  indexYesNo =
                                      value.isLocatedAt == true ? 0 : 1;
                                  strNumber = value.contactNumber;
                                  strEmail = value.email;
                                  strDescription = value.description;
                                  strCurrency = value.currency;
                                  intStar = value.star;
                                  outletId = value.id;
                                  txtLocation.text = strLocation;
                                  txtNumber.text = strNumber;
                                  txtEmail.text = strEmail;
                                  txtDescription.text = strDescription;
                                  txtCurrency.text = strCurrency;

                                  dropDownValue = value;
                                  isSelectedOutlet = true;
                                  print('$defaultOutletIdProvider + $outletId');
                                  // defaultOutletIdProvider.toLowerCase() ==
                                  //         outletId.toLowerCase()
                                  //     ? isSetDefaultWall = true
                                  //     : isSetDefaultWall = false;
                                  currentRegionId = value.regionId;
                                  currentRegion = value.regionName;
                                  currentCusineId = value.cuisineId;
                                  currentCusine = value.cuisineName;
                                  currentCusineStylId = value.cuisineStyleId;
                                  currentCusineStyle = value.cuisineStyleName;
                                  print(businessesClass.length);
                                  for (var item in businessesClass) {
                                    item.defaultOutletId.toLowerCase() ==
                                            outletId.toLowerCase()
                                        ? isSetDefaultWall = true
                                        : isSetDefaultWall = false;
                                  }
                                  categoryListAdded.clear();
                                  for (var data in value.category) {
                                    print(data);
                                    categoryListAdded.add(data);
                                  }

                                  context
                                      .read<MenuProvider>()
                                      .selectedMenu('', '', '', '', '');
                                  context
                                      .read<BusinessOutletProvider>()
                                      .setSelectedOutletId(outletId);
                                  context
                                      .read<BusinessOutletProvider>()
                                      .setCountry(
                                          value.country, value.location);

                                  // businessesClass[0]
                                  //             .defaultOutletId
                                  //             .toLowerCase() ==
                                  //         outletId.toLowerCase()
                                  //     ? isSetDefaultWall = true
                                  //     : isSetDefaultWall = false;
                                });
                              },
                              dropdownMenuEntries: _createListOutlet(),
                              // menuStyle: MenuStyle(

                              // ),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height - addHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    // color: const Color(0xffe9f9fc),
                    color: Colors.grey.shade100,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 10.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                      child: Text(
                                    '$businessName $currentOutletName',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ))
                                ],
                              ),
                              const Spacer(),
                              Visibility(
                                visible: currentOutletName != '',
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RatingBarIndicator(
                                          rating: 1,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 1,
                                          itemSize: 50.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Container(
                                          child: Text(
                                            '$intStar Star-Points',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black54,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: currentOutletName != '',
                          child: AbsorbPointer(
                            absorbing: isAbsorb,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'location',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        Container(
                                            child: saveEditButton == 'SAVE'
                                                ? SizedBox(
                                                    width: 600,
                                                    child: TextField(
                                                      controller: txtLocation,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  )
                                                : Text(
                                                    strLocation,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  )),
                                        Row(
                                          children: [
                                            const Text(
                                              'Is your store inside any Airport/Mall/Hotel/Theme Park',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Tooltip(
                                                message: strLocation,
                                                child: const Icon(
                                                    Icons.location_pin))
                                          ],
                                        ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              shape: const CircleBorder(
                                                  eccentricity: 1.0),
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              value: indexYesNo == 0
                                                  ? true
                                                  : false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  indexYesNo = 0;
                                                });
                                              },
                                            ),
                                            const Text('Yes'),
                                            Checkbox(
                                              shape: const CircleBorder(
                                                  eccentricity: 1.0),
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              value: indexYesNo == 1
                                                  ? true
                                                  : false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  indexYesNo = 1;
                                                });
                                              },
                                            ),
                                            const Text('No'),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          'Contacts',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          child: saveEditButton == 'SAVE'
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 600,
                                                      child: TextField(
                                                        controller: txtNumber,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 600,
                                                      child: TextField(
                                                        controller: txtEmail,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      strNumber,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text(
                                                      strEmail,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),

                                        const Text(
                                          'Schedule',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: scheduleList.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                // color: const Color(
                                                //     0xffef7700),
                                                color: Colors.redAccent,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 12,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              scheduleList[
                                                                      index]
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ],
                                                      ),
                                                      const Text('7:00 - 15:00',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                              // return indexSchedule
                                              //         .contains(index)
                                              //     ? Card(
                                              //         // color: const Color(
                                              //         //     0xffef7700),
                                              //         color: Colors.redAccent,
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets
                                              //                   .all(5.0),
                                              //           child: Column(
                                              //             children: [
                                              //               Row(
                                              //                 children: [
                                              //                   const Icon(
                                              //                     Icons
                                              //                         .calendar_today,
                                              //                     size: 12,
                                              //                     color: Colors
                                              //                         .white,
                                              //                   ),
                                              //                   const SizedBox(
                                              //                       width: 5),
                                              //                   Text(
                                              //                       scheduleList[
                                              //                               index]
                                              //                           .toString(),
                                              //                       style:
                                              //                           const TextStyle(
                                              //                         color: Colors
                                              //                             .white,
                                              //                       )),
                                              //                 ],
                                              //               ),
                                              //               const Text(
                                              //                   '7:00 - 15:00',
                                              //                   style:
                                              //                       TextStyle(
                                              //                     color: Colors
                                              //                         .white,
                                              //                   ))
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       )
                                              //     : Container();
                                            },
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 220,
                                        //   width: 300,
                                        //   child: ListView.builder(
                                        //     scrollDirection: Axis.vertical,
                                        //     itemCount: scheduleList.length,
                                        //     itemBuilder: (context, index) {
                                        //       return Padding(
                                        //         padding:
                                        //             const EdgeInsets.symmetric(
                                        //                 vertical: 5.0),
                                        //         child: Row(
                                        //           children: [
                                        //             Container(
                                        //               alignment:
                                        //                   Alignment.center,
                                        //               width: 50,
                                        //               // height: 50,
                                        //               decoration: BoxDecoration(
                                        //                   boxShadow: const [
                                        //                     BoxShadow(
                                        //                       color:
                                        //                           Colors.white,
                                        //                       offset: Offset(
                                        //                         0.0,
                                        //                         2.0,
                                        //                       ),
                                        //                       blurRadius: 5.0,
                                        //                       spreadRadius: 2.0,
                                        //                     ), //BoxShadow
                                        //                   ],
                                        //                   color: const Color(
                                        //                       0xffef7700),
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(
                                        //                               20.0)),
                                        //               child: Text(
                                        //                   scheduleList[index]
                                        //                       .toString(),
                                        //                   style:
                                        //                       const TextStyle(
                                        //                     color: Colors.white,
                                        //                   )),
                                        //             ),
                                        //             // const SizedBox(
                                        //             //   width: 5,
                                        //             // ),
                                        //             const Text(' - '),
                                        //             Container(
                                        //               alignment:
                                        //                   Alignment.center,
                                        //               width: 150,
                                        //               // height: 50,
                                        //               decoration: BoxDecoration(
                                        //                   boxShadow: const [
                                        //                     BoxShadow(
                                        //                       color:
                                        //                           Colors.white,
                                        //                       offset: Offset(
                                        //                         0.0,
                                        //                         2.0,
                                        //                       ),
                                        //                       blurRadius: 5.0,
                                        //                       spreadRadius: 2.0,
                                        //                     ), //BoxShadow
                                        //                   ],
                                        //                   color: const Color(
                                        //                       0xffef7700),
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(
                                        //                               20.0)),
                                        //               child: const Padding(
                                        //                 padding:
                                        //                     EdgeInsets.all(1.0),
                                        //                 child: Text(
                                        //                     '07:00 to 15:00',
                                        //                     style: TextStyle(
                                        //                       color:
                                        //                           Colors.white,
                                        //                     )),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       );
                                        //     },
                                        //   ),
                                        // ),
                                        // const Text(
                                        //   'Mon-Fri',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.black54,
                                        //   ),
                                        // ),
                                        // const Text(
                                        //   '09:00-21:30',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.black54,
                                        //   ),
                                        // ),
                                        // const Text(
                                        //   'Sat-Sun',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.black54,
                                        //   ),
                                        // ),
                                        // const Text(
                                        //   '07:30-22:30',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.black54,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: saveEditButton == 'SAVE',
                                          child: TextButton(
                                              onHover: (value) {},
                                              onPressed: () =>
                                                  showScheduleDialog(),
                                              child: const Text(
                                                'Edit schedule',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.red),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Category',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: SizedBox(
                                          // color: Colors.amberAccent,
                                          width: 300,
                                          height: 100,

                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: saveEditButton == 'SAVE'
                                                ? categoryList.length
                                                : categoryListAdded.length,
                                            itemBuilder: (context, index) {
                                              return SingleChildScrollView(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Flexible(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      saveEditButton == 'SAVE'
                                                          ? Checkbox(
                                                              shape: const CircleBorder(
                                                                  eccentricity:
                                                                      1.0),
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColor),
                                                              value: categoryListAdded
                                                                      .contains(
                                                                          categoryList[
                                                                              index])
                                                                  ? true
                                                                  : false,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  if (value ==
                                                                      true) {
                                                                    categoryListAdded.add(
                                                                        categoryList[
                                                                            index]);
                                                                  } else {
                                                                    categoryListAdded.removeWhere((item) =>
                                                                        item ==
                                                                        categoryList[
                                                                            index]);
                                                                  }
                                                                });
                                                              },
                                                            )
                                                          : const Icon(Icons
                                                              .arrow_right),
                                                      Text(saveEditButton ==
                                                              'SAVE'
                                                          ? categoryList[index]
                                                          : categoryListAdded[
                                                              index]),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                            },
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   child: saveEditButton == 'SAVE'
                                      //       ? SizedBox(
                                      //           width: 300,
                                      //           child: TextField(
                                      //             controller: txtDescription,
                                      //             textAlign: TextAlign.start,
                                      //           ),
                                      //         )
                                      //       : Padding(
                                      //           padding: const EdgeInsets.only(
                                      //               left: 10.0),
                                      //           child: Text(
                                      //             strDescription,
                                      //             style: const TextStyle(
                                      //               fontSize: 16,
                                      //               fontWeight: FontWeight.bold,
                                      //               color: Colors.black54,
                                      //             ),
                                      //           ),
                                      //         ),
                                      // ),
                                      // const Text(
                                      //   'Bar',
                                      //   style: TextStyle(
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.black54,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'CUISINE',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_right),
                                            Text(
                                              currentRegion == ''
                                                  ? 'Choose Region'
                                                  : currentRegion,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Visibility(
                                                visible:
                                                    saveEditButton == 'SAVE',
                                                child: TextButton(
                                                    onHover: (value) {},
                                                    onPressed: () =>
                                                        showRegionDialog(),
                                                    child: const Text(
                                                      'change',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // DropdownMenu<String>(
                                      //   // initialSelection: list.first,
                                      //   trailingIcon: saveEditButton == 'SAVE'
                                      //       ? InkWell(
                                      //           child: const Icon(Icons.add),
                                      //           onTap: () {
                                      //             setState(() {
                                      //               print('add region');
                                      //             });
                                      //           },
                                      //         )
                                      //       : null,
                                      //   width: 200,
                                      //   hintText: 'CHOOSE REGION',
                                      //   textStyle: const TextStyle(
                                      //     fontSize: 12,
                                      //     color: Colors.black,
                                      //   ),
                                      //   onSelected: (String? value) {
                                      //     // This is called when the user selects an item.
                                      //     setState(() {
                                      //       dropdownValueRegion = value!;
                                      //     });
                                      //   },
                                      //   dropdownMenuEntries: listRegion
                                      //       .map<DropdownMenuEntry<String>>(
                                      //           (String value) {
                                      //     return DropdownMenuEntry<String>(
                                      //         value: value, label: value);
                                      //   }).toList(),
                                      // ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_right),
                                            Text(
                                              currentCusine == ''
                                                  ? 'Choose Cuisine'
                                                  : currentCusine,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Visibility(
                                                visible:
                                                    saveEditButton == 'SAVE',
                                                child: TextButton(
                                                    onHover: (value) {},
                                                    onPressed: () =>
                                                        showCuisineDialog(),
                                                    child: const Text(
                                                      'change',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )))
                                          ],
                                        ),
                                      ),
                                      // DropdownMenu<String>(
                                      //   // initialSelection: list.first,
                                      //   trailingIcon: saveEditButton == 'SAVE'
                                      //       ? InkWell(
                                      //           child: const Icon(Icons.add),
                                      //           onTap: () {
                                      //             setState(() {
                                      //               print('add cuisine');
                                      //             });
                                      //           },
                                      //         )
                                      //       : null,
                                      //   width: 200,
                                      //   hintText: 'CHOOSE CUISINE',
                                      //   textStyle: const TextStyle(
                                      //     fontSize: 12,
                                      //     color: Colors.black,
                                      //   ),
                                      //   onSelected: (String? value) {
                                      //     // This is called when the user selects an item.
                                      //     setState(() {
                                      //       dropdownValueCuisine = value!;
                                      //     });
                                      //   },
                                      //   dropdownMenuEntries: listCuisine
                                      //       .map<DropdownMenuEntry<String>>(
                                      //           (String value) {
                                      //     return DropdownMenuEntry<String>(
                                      //         value: value, label: value);
                                      //   }).toList(),
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'CUISINE STYLE',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_right),
                                            Text(
                                              currentCusineStyle == ''
                                                  ? 'Choose Cuisine Style'
                                                  : currentCusineStyle,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Visibility(
                                                visible:
                                                    saveEditButton == 'SAVE',
                                                child: TextButton(
                                                    onHover: (value) {},
                                                    onPressed: () =>
                                                        showCuisineStyleDialog(),
                                                    child: const Text(
                                                      'change',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )))
                                          ],
                                        ),
                                      ),
                                      // DropdownMenu<String>(
                                      //   // initialSelection: list.first,
                                      //   trailingIcon: saveEditButton == 'SAVE'
                                      //       ? InkWell(
                                      //           child: const Icon(Icons.add),
                                      //           onTap: () {
                                      //             setState(() {
                                      //               print(
                                      //                   'add cuisine style');
                                      //             });
                                      //           },
                                      //         )
                                      //       : null,
                                      //   width: 200,
                                      //   hintText: 'NIL',
                                      //   textStyle: const TextStyle(
                                      //     fontSize: 12,
                                      //     color: Colors.black54,
                                      //   ),
                                      //   onSelected: (String? value) {
                                      //     // This is called when the user selects an item.
                                      //     setState(() {
                                      //       dropdownValuex = value!;
                                      //     });
                                      //   },
                                      //   dropdownMenuEntries: list
                                      //       .map<DropdownMenuEntry<String>>(
                                      //           (String value) {
                                      //     return DropdownMenuEntry<String>(
                                      //         value: value, label: value);
                                      //   }).toList(),
                                      // ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Text(
                                        'Currency',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Container(
                                        child: saveEditButton == 'SAVE'
                                            ? SizedBox(
                                                width: 300,
                                                child: TextField(
                                                  controller: txtCurrency,
                                                  textAlign: TextAlign.start,
                                                ),
                                              )
                                            : Text(
                                                strCurrency,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: currentOutletName != '',
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                children: [
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SEASONAL BREAK',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'CLOSE LOCATION',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Text('Set default?'),
                                  AbsorbPointer(
                                    absorbing: isAbsorb,
                                    child: Checkbox(
                                      shape:
                                          const CircleBorder(eccentricity: 1.0),
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      value: isSetDefaultWall,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (isSetDefaultWall == true) {
                                            isSetDefaultWall = false;
                                          } else {
                                            isSetDefaultWall = true;
                                          }
                                          print(value);
                                          print(isSetDefaultWall);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: const Color(0xffef7700),
                                        ),
                                        child: Container(
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (isAbsorb == false) {
                                                  save();
                                                } else {
                                                  update();

                                                  // txtLocation.text =
                                                  //     'Queen Elizabeth Ave. 12, 20-233 Angel Town';
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 5, 0),
                                                  child: Icon(
                                                    isAbsorb == true
                                                        ? Icons.edit
                                                        : Icons.save,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                Text(
                                                  saveEditButton,
                                                  style: const TextStyle(
                                                    fontFamily: 'SFPro',
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // const SizedBox(
                                  //   width: 20,
                                  // ),
                                  // Visibility(
                                  //   visible: saveEditButton == 'SAVE',
                                  //   child: Column(
                                  //     children: [
                                  //       Container(
                                  //         width: 260,
                                  //         height: 40,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(10.0),
                                  //           color: const Color(0xffef7700),
                                  //         ),
                                  //         child: Container(
                                  //           child: TextButton(
                                  //             onPressed: () {},
                                  //             child: const Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.center,
                                  //               children: [
                                  //                 Padding(
                                  //                   padding:
                                  //                       EdgeInsets.fromLTRB(
                                  //                           5, 0, 5, 0),
                                  //                   child: Icon(
                                  //                     Icons.save,
                                  //                     color: Colors.white,
                                  //                   ),
                                  //                 ),
                                  //                 Text(
                                  //                   'SAVE & SET DEFAULT',
                                  //                   style: TextStyle(
                                  //                     fontFamily: 'SFPro',
                                  //                     fontSize: 18,
                                  //                     color: Colors.white,
                                  //                     fontWeight:
                                  //                         FontWeight.w500,
                                  //                   ),
                                  //                   textAlign:
                                  //                       TextAlign.center,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDefaultOutlet() {
    categoryListAdded.clear();
    for (var data in outletClass) {
      if (data.id.toLowerCase() == outletIdProvider.toLowerCase()) {
        currentItem = data.name;
        currentOutletName = data.name;
        strLocation = data.location;
        indexYesNo = data.isLocatedAt == true ? 0 : 1;
        strNumber = data.contactNumber;
        strEmail = data.email;
        strDescription = data.description;
        strCurrency = data.currency;
        intStar = data.star;
        txtLocation.text = strLocation;
        txtNumber.text = strNumber;
        txtEmail.text = strEmail;
        txtDescription.text = strDescription;
        txtCurrency.text = strCurrency;
        outletId = outletIdProvider;

        currentRegionId = data.regionId;
        currentRegion = data.regionName;
        currentCusineId = data.cuisineId;
        currentCusine = data.cuisineName;
        currentCusineStylId = data.cuisineStyleId;
        currentCusineStyle = data.cuisineStyleName;
        for (var data in data.category) {
          print(data);
          categoryListAdded.add(data);
        }
        context.read<BusinessOutletProvider>().setSelectedOutletId(outletId);
        context
            .read<BusinessOutletProvider>()
            .setCountry(data.country, data.location);
        // dropDownValue = outletClass;
        isSelectedOutlet = true;
        isSetDefaultWall = true;
        isPostbackLoad = true;
      }
    }
  }

  showRegionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MouseRegion(
          onHover: (event) {
            setState(() {});
          },
          onExit: (event) {
            setState(() {});
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              TextEditingController txtaddRegion = TextEditingController();

              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: const Text(
                  'Region',
                  textAlign: TextAlign.center,
                ),
                children: [
                  // SizedBox(
                  //   height: 100,
                  //   width: 300,
                  //   child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(Icons.exit_to_app)),
                  // ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            strSearchRegion = value;
                          });
                        },
                        controller: txtSearchRegion,
                        decoration: const InputDecoration(hintText: 'Search'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 400,
                    width: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: regionCollection
                          // .where('outletId', isEqualTo: outletId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          documentsx = snapshot.data!.docs;
                          print(strSearchRegion);
                          if (strSearchRegion.isNotEmpty) {
                            documentsx = documentsx.where((element) {
                              return element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(strSearchRegion.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            itemCount: documentsx.length,
                            itemBuilder: (context, index) {
                              print(strSearchRegion);
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentsx[index]['name'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      currentRegionId = documentsx[index]['id'];
                                      currentRegion = documentsx[index]['name'];
                                      currentCusine = '';
                                      currentCusineId = '';
                                      print(currentRegion);
                                      // isEditRegion = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("No data"));
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: TextField(
                          controller: txtaddRegion,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter region here...',
                              suffixIcon: Tooltip(
                                message: 'save',
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (txtaddRegion.text.isEmpty) return;
                                      saveRegion('dlr005', outletId,
                                          txtaddRegion.text);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.save,
                                    color: Color(0xffbef7700),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                // BoxShadow(
                                //   color: Colors.white,
                                //   offset: Offset(0.0, 0.0),
                                //   blurRadius: 0.0,
                                //   spreadRadius: 0.0,
                                // ), //BoxShadow
                              ],
                              color: const Color(0xffbef7700),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )

                  // Row(
                  //   children: [
                  //     SizedBox(width: 100, child: const TextField()),
                  //     Container(
                  //       decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         color: Color(0xffbef7700),
                  //       ),
                  //       child: const TextButton(
                  //           onPressed: null,
                  //           child: Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Icon(
                  //                   Icons.save,
                  //                   color: Colors.white,
                  //                 ),
                  //                 SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 Text(
                  //                   'ADD',
                  //                   style: TextStyle(color: Colors.white),
                  //                 ),
                  //               ],
                  //             ),
                  //           )),
                  //     ),
                  //   ],
                  // )
                ],
              );
            },
          ),
        );
      },
    );
  }

  showCuisineDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MouseRegion(
          onHover: (event) {
            setState(() {});
          },
          onExit: (event) {
            setState(() {});
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              TextEditingController txtAddCuisine = TextEditingController();

              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: const Text(
                  'Cuisine',
                  textAlign: TextAlign.center,
                ),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            strSearchCusine = value;
                          });
                        },
                        controller: txtSearchCusine,
                        decoration: const InputDecoration(hintText: 'Search'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 400,
                    width: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: cusineCollection
                          .where('regionId', isEqualTo: currentRegionId)
                          // .where('outletId',
                          //     arrayContains: txtSearchRegion.text != ''
                          //         ? outletId
                          //         : txtSearchRegion.text)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          documentsx = snapshot.data!.docs;
                          print(strSearchCusine);
                          if (strSearchCusine.isNotEmpty) {
                            documentsx = documentsx.where((element) {
                              return element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(strSearchCusine.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            itemCount: documentsx.length,
                            itemBuilder: (context, index) {
                              // var doc = snapshot.data!.docs;
                              print(strSearchCusine);
                              // doc.contains(strSearchRegion);
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListTile(
                                  // leading: Image.asset(
                                  //   'assets/chat.png',
                                  //   color: Colors.redAccent[700],
                                  //   height: 24,
                                  // ),
                                  // trailing: Tooltip(
                                  //   message: 'delete',
                                  //   child: IconButton(
                                  //       onPressed: () {
                                  //         setState(() {
                                  //           print(documentsx[index]['id']);
                                  //           deleCuisine(documentsx[index]['id']);
                                  //         });
                                  //       },
                                  //       icon: const Icon(Icons.delete)),
                                  // ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentsx[index]['name'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      currentCusineId = documentsx[index]['id'];
                                      currentCusine = documentsx[index]['name'];

                                      // isEditRegion = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("No data"));
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                // BoxShadow(
                                //   color: Colors.white,
                                //   offset: Offset(0.0, 0.0),
                                //   blurRadius: 0.0,
                                //   spreadRadius: 0.0,
                                // ), //BoxShadow
                              ],
                              color: const Color(0xffbef7700),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: TextField(
                          controller: txtAddCuisine,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter cuisine here...',
                              suffixIcon: Tooltip(
                                message: 'save',
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (txtAddCuisine.text.isEmpty) return;
                                      saveCuisine('dlc006', currentRegionId,
                                          txtAddCuisine.text);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.save,
                                    color: Color(0xffbef7700),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  showCuisineStyleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MouseRegion(
          onHover: (event) {
            setState(() {});
          },
          onExit: (event) {
            setState(() {});
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              TextEditingController txtAddCuisineStyle =
                  TextEditingController();

              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: const Text(
                  'Cuisine Style',
                  textAlign: TextAlign.center,
                ),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            strSearchCusineStyle = value;
                          });
                        },
                        controller: txtSearchCusineStyle,
                        decoration: const InputDecoration(hintText: 'Search'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 400,
                    width: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: cusineStyleCollection
                          // .where('outletId', isEqualTo: outletId)
                          // .where('outletId',
                          //     arrayContains: txtSearchRegion.text != ''
                          //         ? outletId
                          //         : txtSearchRegion.text)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          documentsx = snapshot.data!.docs;
                          print(strSearchCusineStyle);
                          if (strSearchCusineStyle.isNotEmpty) {
                            documentsx = documentsx.where((element) {
                              return element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(strSearchCusineStyle.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            itemCount: documentsx.length,
                            itemBuilder: (context, index) {
                              // var doc = snapshot.data!.docs;
                              print(strSearchCusineStyle);
                              // doc.contains(strSearchRegion);
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListTile(
                                  // leading: Image.asset(
                                  //   'assets/chat.png',
                                  //   color: Colors.redAccent[700],
                                  //   height: 24,
                                  // ),
                                  // trailing: Tooltip(
                                  //   message: 'delete',
                                  //   child: IconButton(
                                  //       onPressed: () {
                                  //         setState(() {
                                  //           print(documentsx[index]['id']);
                                  //           deleCuisineStyle(
                                  //               documentsx[index]['id']);
                                  //         });
                                  //       },
                                  //       icon: const Icon(Icons.delete)),
                                  // ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentsx[index]['name'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      currentCusineStylId =
                                          documentsx[index]['id'];
                                      currentCusineStyle =
                                          documentsx[index]['name'];

                                      // isEditRegion = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("No data"));
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                // BoxShadow(
                                //   color: Colors.white,
                                //   offset: Offset(0.0, 0.0),
                                //   blurRadius: 0.0,
                                //   spreadRadius: 0.0,
                                // ), //BoxShadow
                              ],
                              color: const Color(0xffbef7700),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: TextField(
                          controller: txtAddCuisineStyle,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter cuisine here...',
                              suffixIcon: Tooltip(
                                message: 'save',
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (txtAddCuisineStyle.text.isEmpty) {
                                        return;
                                      }
                                      saveCuisineStyle('dlcs006', outletId,
                                          txtAddCuisineStyle.text);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.save,
                                    color: Color(0xffbef7700),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MouseRegion(
          onHover: (event) {
            setState(() {});
          },
          onExit: (event) {
            setState(() {});
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 400.0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        child: Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.exit_to_app)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                        child: Center(
                          child:
                              Text('Schedule', style: TextStyle(fontSize: 26)),
                        ),
                      ),
                      SizedBox(
                        height: 530,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            // scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Monday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtMondayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              if (txtMondayStart.text != '') {
                                                indexScheduleAdded.add(0);
                                              }

                                              txtMondayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtMondayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(0);
                                              txtMondayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Tuesday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtTuesdayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(1);
                                              txtTuesdayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtTuesdayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(1);
                                              txtTuesdayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Wednesday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtWednesdayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(2);
                                              txtWednesdayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtWednesdayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(2);
                                              txtWednesdayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Thursday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtThursdaytart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(3);
                                              txtThursdaytart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtThursdayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(3);
                                              txtThursdayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Friday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtFridayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(4);
                                              txtFridayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtFridayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(4);
                                              txtFridayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Saturday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtSaturdayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(5);
                                              txtSaturdayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtSaturdayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(5);
                                              txtSaturdayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text(
                                      'Sunday',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'Start',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtSundayStart,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(6);
                                              txtSundayStart.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('To'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              hintText: 'End',
                                              hintTextDirection:
                                                  TextDirection.ltr),
                                          controller: txtSundayEnd,
                                          onTap: () async {
                                            final TimeOfDay? newTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: const TimeOfDay(
                                                  hour: 7, minute: 15),
                                            );
                                            var hour = newTime!.hour;
                                            var minute = newTime.minute;

                                            setState(() {
                                              indexScheduleAdded.add(6);
                                              txtSundayEnd.text =
                                                  '$hour:$minute';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(
                                        0.0,
                                        5.0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    // BoxShadow(
                                    //   color: Colors.white,
                                    //   offset: Offset(0.0, 0.0),
                                    //   blurRadius: 0.0,
                                    //   spreadRadius: 0.0,
                                    // ), //BoxShadow
                                  ],
                                  color: const Color(0xffbef7700),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                for (var data in indexScheduleAdded) {
                                  indexSchedule.add(data);
                                }
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // showScheduleDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return MouseRegion(
  //         // onHover: (event) {
  //         //   setState(() {});
  //         // },
  //         // onExit: (event) {
  //         //   setState(() {});
  //         // },
  //         child: StatefulBuilder(
  //           builder: (context, StateSetter setState) {
  //             return SimpleDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.0)),
  //               title: const Text(
  //                 'Schedule',
  //                 textAlign: TextAlign.center,
  //               ),
  //               contentPadding: const EdgeInsets.all(20.0),
  //               alignment: Alignment.center,
  //               children: [
  //                 SingleChildScrollView(
  //                   // scrollDirection: Axis.vertical,
  //                   child: Column(children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Monday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             decoration: const InputDecoration(
  //                                 hintText: 'Start',
  //                                 hintTextDirection: TextDirection.ltr),
  //                             controller: txtMondayStart,
  //                             onTap: () async {
  //                               final TimeOfDay? newTime = await showTimePicker(
  //                                 context: context,
  //                                 initialTime:
  //                                     const TimeOfDay(hour: 7, minute: 15),
  //                               );
  //                               var hour = newTime!.hour;
  //                               var minute = newTime.minute;

  //                               setState(() {
  //                                 txtMondayStart.text = '$hour:$minute';
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                         const SizedBox(width: 5),
  //                         const Text('To'),
  //                         const SizedBox(width: 5),
  //                         Expanded(
  //                           child: TextField(
  //                             textAlign: TextAlign.center,
  //                             decoration: const InputDecoration(
  //                                 hintText: 'End',
  //                                 hintTextDirection: TextDirection.ltr),
  //                             controller: txtMondayEnd,
  //                             onTap: () async {
  //                               final TimeOfDay? newTime = await showTimePicker(
  //                                 context: context,
  //                                 initialTime:
  //                                     const TimeOfDay(hour: 7, minute: 15),
  //                               );
  //                               var hour = newTime!.hour;
  //                               var minute = newTime.minute;

  //                               setState(() {
  //                                 txtMondayEnd.text = '$hour:$minute';
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Tuesday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Wednesday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Thursday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Friday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Saturday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Text(
  //                             'Sunday',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     const Divider(),
  //                     const SizedBox(height: 10),
  //                   ]),
  //                 ),
  //                 Container(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       InkWell(
  //                         child: Container(
  //                           alignment: Alignment.center,
  //                           width: 150,
  //                           height: 30,
  //                           decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   offset: const Offset(
  //                                     0.0,
  //                                     5.0,
  //                                   ),
  //                                   blurRadius: 10.0,
  //                                   spreadRadius: 2.0,
  //                                 ), //BoxShadow
  //                                 // BoxShadow(
  //                                 //   color: Colors.white,
  //                                 //   offset: Offset(0.0, 0.0),
  //                                 //   blurRadius: 0.0,
  //                                 //   spreadRadius: 0.0,
  //                                 // ), //BoxShadow
  //                               ],
  //                               color: const Color(0xffbef7700),
  //                               borderRadius: BorderRadius.circular(20.0)),
  //                           child: const Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Icon(
  //                                 Icons.exit_to_app,
  //                                 color: Colors.white,
  //                               ),
  //                               SizedBox(
  //                                 width: 5,
  //                               ),
  //                               Text(
  //                                 'Close',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
