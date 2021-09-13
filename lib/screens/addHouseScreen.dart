import 'package:custom_dialog/custom_dialog.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:bluesky_project/screens/chooseLocation.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';



class AddHouseScreen extends StatefulWidget {
  _AddHouseScreenState createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  int _currentStep = 0;



  String houseType;
  List houseTypeList = [
    'Separate',
    'Apartment',
    'Building'
  ];

  String sellOrRent;
  List sellOrRentList = [
    'For sale',
    'For rent'
  ];

  String roomsNumber;
  List roomsNumberList = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'More than five'
  ];


  String bathsNumber;
  List bathsNumberList = [
    'One',
    'Two',
    'Three',
    'Four',
    'More than four',
  ];


  String city;
  List citiesList = [
    'Amman',
    'Irbid',
    'Al Zarqa',
    'AL Salt',
    'Al Karak',
    'Al Mafraq',
    'Ajlun',
    'Ma\'an',
    'Al Tafilah',
    'Madaba',
    'Jarash',
    'Aqaba',
  ];

  String houseCondition;
  List houseConditionList = [
    'New',
    'Used',

  ];

  String parkingNumber;
  List parkingNumberList = [
    'No parking',
    'one Parking',
    'Two Parkings',
    'Three Parkings',
    'Four Parkings',
    'More than four'
  ];


  String floorsNumber;
  List floorsNumberList = [
    'One',
    'Two',
    'Three',
    'Four',
    'More than four',
  ];

  String floorNumber;
  List floorNumberList = [
    '-1',
    'Ground Floor',
    'First Floor',
    'Second Floor',
    'Third Floor',
  ];

  String paymentMethod;
  List paymentMethodList = [
    'Cash',
    'Installments',
    'Cash/Installments'
  ];

  String houseAge;
  List houseAgeList = [
    'Under construction',
    'Form 1 to 5',
    'From 5 to 10',
    'From 10 to 15',
    'From 15 to 20',
    'More than 20',
  ];

  TextEditingController _firstAddressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _landAreaController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _phNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _balcony = false;
  bool _garden = false;
  bool _garage = false;
  bool _elevator = false;
  // مصعد
  bool _nearServices = false;
  // قرب الخدمات
  bool _mainStreet = false;
  // شارع رئيسي
  bool _maidRoom = false;
  // غرفة خادمة
  bool _guardRoom = false;
  // غرفة حارس
  bool _laundryRoom = false;
  // غرفة غسيل
  bool _swimmingBool = false;
  // بركة سباحة
  bool _equippedKitchen = false;
  // مطبخ جاهز
  bool _centralHeating = false;
  // تدفئة مركزية
  bool _wareHouse = false;
  // مخزن
  bool _doubleGlazing = false;
  // زجاج مزدوج
  bool _shutters = false;
  // اباجور


  LatLng _houseLocation;



  bool locationPickedByCurrent= false;
  bool locationPickedByMap = false;



  List<File> _image = [];
  final picker = ImagePicker();

  printImagesPaths() {
    print('hhhhhhhhhhhhhhhoooooooooooohhhhhhhhhhhhoooooooooooo');
    print(_image);
  }



  chooseImage(int index, ImageSource source) async {
    final pickedFile = await picker.getImage(
        source: source, maxWidth: 400.0, maxHeight: 400.0);
    setState(() {
      // _image.add(File(pickedFile?.path));
      // _image.removeAt(index);
      _image.insert(index, File(pickedFile?.path));
      printImagesPaths();
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  chooseImageFromCamera(int index) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxWidth: 600.0, maxHeight: 600.0);
    setState(() {
      // _image.add(File(pickedFile?.path));
      // _image.removeAt(index);
      _image.insert(index, File(pickedFile?.path));
      printImagesPaths();
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  List<dynamic> downloadPaths = [];


  Future<void> _getCurrentLocation() async {
    final currentLocation = await Location.instance.getLocation();
    setState(() {
      _houseLocation = LatLng(currentLocation.latitude, currentLocation.longitude);
      locationPickedByCurrent = true;
      locationPickedByMap = false;
      _locationInfoDone = true;
    });
    // print('sssssssssssssssoooooooooooooooooooosssssssss');
    // print(currentLocation);
    print('the house Loooooooooooooooooooooooocation is:');
    print(_houseLocation);
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
          content: Text(
              'Current Location Selected Successfully',
              style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
              MediaQuery.of(context).size.width * 0.05 / 1.5)
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Ok',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(
                  context)
                  .hideCurrentSnackBar();
            },
          ),
        ),
    );
  }


  Future<void> _selectLocation() async {
    ScaffoldMessenger.of(
        context)
        .hideCurrentSnackBar();
    final selectedLocation = await Navigator.of(context).push<LatLng>(MaterialPageRoute(
        builder: (context) => ChooseMapScreen(isSelecting: true,)
    ));
    if (selectedLocation == null) {
      print('the house Loooooooooooooooooooooooocation is:');
      print(_houseLocation);
      return;
    }
    setState(() {
      _houseLocation = selectedLocation;
      locationPickedByCurrent = false;
      locationPickedByMap = true;
      _locationInfoDone = true;
    });
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
            'Location Picked Successfully',
            style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
            MediaQuery.of(context).size.width * 0.05 / 1.5)
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(
                context)
                .hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  bool _showDialogAgain = true;
  bool _keyboardVisible = false;

  House _newHouse = House(
    id: null,
    price: 0,
    location: LatLng(32.131602, 36.130584),
    ownerName: ' ',
    phNumber: ' ',
    images: [],
    city: ' ',
    firstAddress: ' ',
    houseArea: 0,
    landArea: 0,
    bedRoomsNumber: ' ',
    bathsNumber: ' ',
    floorsNumber: ' ',
    floor: 0,
    houseCondition: ' ',
    houseAge: ' ',
    houseType: ' ',
    parkingsNumber: ' ',
    isRent: false,
    description: ' ',
    shareDate: ' ',
    paymentMethod: ' ',
  );



  _checkBeforShare() {
    if (houseType == null) {
      return showDialog(
        context: context,
        builder: (context) => CustomDialog(
          content: 'Main Informations are not complete!',
          title: 'Error',
          firstColor: Colors.green[700],
          secondColor: Colors.white,
          headerIcon: Icons.cancel_outlined,
          iconColor: Colors.red,
        ),
      );
    }
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return showDialog(
          context: context,
          builder: (context) => CustomDialog(
            content: 'Main Informations are not complete!',
            title: 'Error',
            firstColor: Colors.green[700],
            secondColor: Colors.white,
            headerIcon: Icons.cancel_outlined,
            iconColor: Colors.red,
          )
      );
    }
    else {
      _formKey.currentState.save();
    }
    if (houseType == houseTypeList[0]) {
      // بيت مستقل
      if (sellOrRent == sellOrRentList[0]) {
        // بيع
        if (houseType == null || sellOrRent == null || city == null || paymentMethod == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorsNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
      else {
        // اجار
        if (houseType == null || sellOrRent == null || city == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorsNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
    }
    if (houseType == houseTypeList[1]) {
      // شقة
      if (sellOrRent == sellOrRentList[0]) {
        // بيع
        if (houseType == null || sellOrRent == null || city == null || paymentMethod == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
      else {
        // اجار
        if (houseType == null || sellOrRent == null || city == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
    }
    if (houseType == houseTypeList[2]) {
      // بناية
      if (sellOrRent == sellOrRentList[0]) {
        // بيع
        if (houseType == null || sellOrRent == null || city == null || paymentMethod == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorsNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
      else {
        // اجار
        if (houseType == null || sellOrRent == null || city == null || houseCondition == null || roomsNumber == null || bathsNumber == null || floorsNumber == null || houseAge == null ) {
          return showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: 'Main Informations are not complete!',
              title: 'Error',
              firstColor: Colors.green[700],
              secondColor: Colors.white,
              headerIcon: Icons.cancel_outlined,
              iconColor: Colors.red,
            ),
          );
        }
      }
    }

    // _formKey.currentState.save();
    if (_houseLocation == null) {
      return showDialog(
        context: context,
        builder: (context) => CustomDialog(
          content: 'You didn\'t add the location!',
          title: 'Error',
          firstColor: Colors.green[700],
          secondColor: Colors.white,
          headerIcon: Icons.cancel_outlined,
          iconColor: Colors.red,
        ),
      );
    }
    if (_image.isEmpty && _showDialogAgain) {
      _showDialogAgain = !_showDialogAgain;
      return showDialog(
        context: context,
        builder: (context) => CustomDialog(
          content: 'You didn\'t add pictures!',
          title: 'Alert!',
          firstColor: Colors.green[700],
          secondColor: Colors.white,
          headerIcon: Icons.warning_amber_outlined,
          iconColor: Colors.yellow,
        ),
      );
    }
    else {
      _formKey.currentState.save();
      uploadImageToFirebase(context);
    }
  }




  bool uploading = false;
  Future<void> uploadImageToFirebase(BuildContext context) async {
    setState(() {
      uploading = true;
    });
    buildShowDialog(context);
    // uploading ?? buildShowDialog(context);
    final houseProvider = Provider.of<Houses>(context, listen: false);
    for (int i = 0; i < _image.length; i++) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('houses/${houseProvider.markerId}/$i');
      UploadTask uploadTask =  ref.putFile(_image[i]);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => ref.getDownloadURL().then((value) => downloadPaths.add(value)));
      houseProvider.imagesFileName = houseProvider.markerId;
    }
    setState(() {
      uploading = false;
    });
    Navigator.of(context).pop();
    Provider.of<Houses>(context, listen: false).addHouse(_newHouse.price, _houseLocation, _newHouse.ownerName, _newHouse.phNumber, _newHouse.email, downloadPaths, city, _newHouse.firstAddress, _newHouse.houseArea, _newHouse.landArea,
        _newHouse.bedRoomsNumber, _newHouse.bathsNumber,
        _newHouse.floorsNumber, _newHouse.floor, houseCondition, _newHouse.houseAge, houseType, _newHouse.parkingsNumber, _newHouse.shareDate,
        _newHouse.description, sellOrRent == sellOrRentList[0] ? false : true, paymentMethod ?? _newHouse.paymentMethod, _balcony, _garden, _garage, _elevator, _nearServices, _mainStreet, _maidRoom,
        _guardRoom, _laundryRoom, _swimmingBool, _equippedKitchen, _centralHeating, _wareHouse, _doubleGlazing, _shutters);
   setState(() {
     _image = [];
     downloadPaths = [];
     houseType = null;
     sellOrRent = null;
     city = null;
     paymentMethod = null;
     houseCondition = null;
     roomsNumber = null;
     bathsNumber = null;
     floorsNumber = null;
     floorNumber = null;
     houseAge = null;
     _balcony = false;
     _garden = false;
     _garage = false;
     _elevator = false;
     _nearServices = false;
     _mainStreet = false;
     _maidRoom = false;
     _guardRoom = false;
     _laundryRoom = false;
     _swimmingBool = false;
     _equippedKitchen = false;
     _centralHeating = false;
     _wareHouse = false;
     _doubleGlazing = false;
     _shutters = false;
     _houseLocation = null;
     locationPickedByCurrent = false;
     locationPickedByMap = false;
     _phNumberController.clear();
     _firstAddressController.clear();
     _priceController.clear();
     _areaController.clear();
     _landAreaController.clear();
     _descriptionController.clear();
   });

    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        content: 'Your property published successfully',
        title: 'Congratulations!',
        firstColor: Colors.green[700],
        secondColor: Colors.white,
        headerIcon: Icons.check,
        iconColor: Colors.white,
      ),
    );
  }




  bool _mainInfoDone = false;
  bool _locationInfoDone = false;



  final _priceFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _areaFocusNode = FocusNode();
  final _landAreaFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();




  _checkBedRoomsNumber(String value) {
    if (value == roomsNumberList[0]) {
      return '1';
    }
    if (value == roomsNumberList[1]) {
      return '2';
    }
    if (value == roomsNumberList[2]) {
      return'3';
    }
    if (value == roomsNumberList[3]) {
      return '4';
    }
    if (value == roomsNumberList[4]) {
      return '5';
    }
    else {
      return '+5';
    }
  }


  _checkBathsNumber(String value) {
    if (value == bathsNumberList[0]) {
      return '1';
    }
    if (value == bathsNumberList[1]) {
      return '2';
    }
    if (value == bathsNumberList[2]) {
    return '3';
    }
    if (value == bathsNumberList[3]) {
    return '4';
    }
    else {
      return '+4';
    }
  }


  _checkFloorsNumber(String value) {
    if (value == floorsNumberList[0]) {
      return '1';
    }
    if (value == floorsNumberList[1]) {
      return '2';
    }
    if (value == floorsNumberList[2]) {
      return '3';
    }
    if (value == floorsNumberList[3]) {
      return '4';
    }
    else {
      return '+4';
    }
  }


  _checkFloorNumber(String value) {
    if (value == floorNumberList[0]) {
      return -1;
    }
    if (value == floorNumberList[1]) {
      return 0;
    }
    if (value == floorNumberList[2]) {
      return 1;
    }
    if (value == floorNumberList[3]) {
      return 2;
    }
    else {
      return 3;
    }
  }


  _checkParkingsNumber(String value) {
    if (value == parkingNumberList[0]) {
      return '0';
    }
    if (value == parkingNumberList[1]) {
      return '1';
    }
    if (value == parkingNumberList[2]) {
      return '2';
    }
    if (value == parkingNumberList[3]) {
      return '3';
    }
    if (value == parkingNumberList[4]) {
      return '4';
    }
    else {
      return '+4';
    }
  }


  _checkHouseAge(String value) {
    if (value == houseAgeList[0]) {
      return 'Under construction';
    }
    if (value == houseAgeList[1]) {
      return '1-5';
    }
    if (value == houseAgeList[2]) {
      return '5-10';
    }
    if (value == houseAgeList[3]) {
      return '10-15';
    }
    if (value == houseAgeList[3]) {
      return '15-20';
    }
    else {
      return '+20';
    }
  }


  bool isNumberOnly(String value){
    var data = int.tryParse(value);
    if (data!=null) return true;
    else return false ;
  }


  bool isCharOnly(String value){
    for(int i = 0 ; i <= 9 ; i ++) {
      if(value.contains(i.toString())) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _phNumberController.dispose();
    _priceController.dispose();
    _firstAddressController.dispose();
    _areaController.dispose();
    _landAreaController.dispose();
    _descriptionController.dispose();
    _priceFocusNode.dispose();
    _addressFocusNode.dispose();
    _areaFocusNode.dispose();
    _landAreaFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    // size = 20.55
    final double padding = screenSize.width * 0.04;
    // padding = 16.45
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final TextTheme textTheme = TEXT_THEME_DEFAULT;
    final authProvider = Provider.of<Auth>(context, listen: false);
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;




    List<Step> _stepper() {
      List<Step> _steps = [
        Step(
          isActive: _currentStep >= 0,
          state: StepState.indexed,
          title: Text('Main Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('House Type', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: houseType,
                        onChanged: (value) {
                          setState(() {
                            houseType = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: authProvider.userName,
                              phNumber: _newHouse.phNumber,
                              email: authProvider.userEmail,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: value == houseTypeList[0] ? 'Separate' : value == houseTypeList[1] ? 'Apartment' : 'Building',
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: '${DateTime.now().year}\/${DateTime.now().month}\/${DateTime.now().day}',
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: houseTypeList.map((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Center(
                                child: Text(value,
                                  style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                                ),
                              ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Sell or Rent', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: sellOrRent,
                        onChanged: (value) {
                          setState(() {
                            sellOrRent = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: value == sellOrRentList[0] ? false : true,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: sellOrRentList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('City', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: city,
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: value,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: citiesList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    sellOrRent == sellOrRentList[1] ? SizedBox() : addHorizontalSpace(padding),
                    sellOrRent == sellOrRentList[1] ? SizedBox() : Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Payment way',style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value;
                          });
                          _newHouse = House(
                            id: _newHouse.id,
                            price: _newHouse.price,
                            location: _newHouse.location,
                            ownerName: _newHouse.ownerName,
                            phNumber: _newHouse.phNumber,
                            email: _newHouse.email,
                            images: _newHouse.images,
                            city: _newHouse.city,
                            firstAddress: _newHouse.firstAddress,
                            houseArea: _newHouse.houseArea,
                            landArea: _newHouse.landArea,
                            bedRoomsNumber: _newHouse.bedRoomsNumber,
                            bathsNumber: _newHouse.bathsNumber,
                            floorsNumber: _newHouse.floorsNumber,
                            floor: _newHouse.floor,
                            houseCondition: _newHouse.houseCondition,
                            houseAge: _newHouse.houseAge,
                            houseType: _newHouse.houseType,
                            parkingsNumber: _newHouse.parkingsNumber,
                            isRent: _newHouse.isRent,
                            description: _newHouse.description,
                            shareDate: _newHouse.shareDate,
                            paymentMethod: value == paymentMethodList[0] ? 'Cash' : value == paymentMethodList[1] ? 'Installments' : 'Cash/Installments',
                          );
                        },
                        items: paymentMethodList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                                // textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('House Condition', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: houseCondition,
                        onChanged: (value) {
                          setState(() {
                            houseCondition = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: value == houseConditionList[0] ? 'New' : 'Used',
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: houseConditionList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Bedrooms', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: roomsNumber,
                        onChanged: (value) {
                          setState(() {
                           roomsNumber = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _checkBedRoomsNumber(value),
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: roomsNumberList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Bathrooms',style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.7),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: bathsNumber,
                        onChanged: (value) {
                          setState(() {
                            bathsNumber = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _checkBathsNumber(value),
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: bathsNumberList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Parkings', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.7),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: parkingNumber,
                        onChanged: (value) {
                          setState(() {
                            parkingNumber = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _checkParkingsNumber(value),
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: parkingNumberList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    addHorizontalSpace(padding),
                    houseType == houseTypeList[1] ? SizedBox() : Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Floors', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: floorsNumber,
                        onChanged: (value) {
                          setState(() {
                            floorsNumber = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _checkFloorsNumber(value),
                              floor: null,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: floorsNumberList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    houseType == houseTypeList[1] ? SizedBox() : addHorizontalSpace(padding),
                    houseType == houseTypeList[0] || houseType == houseTypeList[2] ? SizedBox() : Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('Floor Number', style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: floorNumber,
                        onChanged: (value) {
                          setState(() {
                            floorNumber = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: null,
                              floor: _checkFloorNumber(value),
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: floorNumberList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (houseType == null || houseType == houseTypeList[1])  addHorizontalSpace(padding),
                    Container(
                      width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                      height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.05,
                      padding: sidePadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[700],
                      ),
                      child: DropdownButton(
                        hint: Text('House Age',style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.6),),
                        dropdownColor: Colors.green[700],
                        icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFFFFFFFF),),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: houseAge,
                        onChanged: (value) {
                          setState(() {
                            houseAge = value;
                          });
                          _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _checkHouseAge(value),
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: _newHouse.description,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod
                          );
                        },
                        items: houseAgeList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Center(
                              child: Text(value,
                                style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.white, fontSize: size / 1.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(padding * 2),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          // addHorizontalSpace(padding),
                          Container(
                            width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                            height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.1,
                            // padding: sidePadding,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextFormField(
                              controller: _phNumberController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6),
                              cursorColor: Color(0xFF000000),
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                                errorStyle: TextStyle(
                                  fontSize: size / 2.3,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_addressFocusNode);
                              },
                              onSaved: (value) {
                                _newHouse = House(
                                  id: _newHouse.id,
                                  price: _newHouse.price,
                                  location: _newHouse.location,
                                  ownerName: _newHouse.ownerName,
                                  phNumber: value,
                                  email: _newHouse.email,
                                  images: _newHouse.images,
                                  city: _newHouse.city,
                                  firstAddress: _newHouse.firstAddress,
                                  houseArea: _newHouse.houseArea,
                                  landArea: _newHouse.landArea,
                                  bedRoomsNumber: _newHouse.bedRoomsNumber,
                                  bathsNumber: _newHouse.bathsNumber,
                                  floorsNumber: _newHouse.floorsNumber,
                                  floor: _newHouse.floor,
                                  houseCondition: _newHouse.houseCondition,
                                  houseAge: _newHouse.houseAge,
                                  houseType: _newHouse.houseType,
                                  parkingsNumber: _newHouse.parkingsNumber,
                                  isRent: _newHouse.isRent,
                                  description: _newHouse.description,
                                  shareDate: _newHouse.shareDate,
                                  paymentMethod: _newHouse.paymentMethod,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the phone number';
                                }
                                if (int.parse(value) < 0) {
                                  return 'Phone number can\'t be less than zero!';
                                }
                                if (value.contains(' ')) {
                                  return 'can\t contain space';
                                }
                                if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                    || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')) {
                                  return 'Please use the english numbers';
                                }
                                if (!isNumberOnly(value)) {
                                  return 'Numbers only!';
                                }
                                if (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                    || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                    || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                    || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                    || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ')) {
                                  return 'Numbers only!';
                                }
                                if (!value.startsWith('0')) {
                                  return 'Phone number must start with 0';
                                }
                                if (value.contains('.') || value.contains(',') || value.contains('-') || value.contains('*') || value.contains('/')) {
                                  return 'Please enter the value without commas';
                                }
                                if (value.length < 10) {
                                  return 'Phone number can\t be less than 10 numbers!';
                                }
                                if (value.length > 10) {
                                  return 'Phone number can\t be more than 10 numbers!';
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          addHorizontalSpace(padding),
                          Container(
                            width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                            height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.1,
                            child: TextFormField(
                              controller: _firstAddressController,
                              focusNode: _addressFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6,),
                              cursorColor: Color(0xFF000000),
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                hintText: 'Neighborhood',
                                hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                                errorStyle: TextStyle(
                                  fontSize: size / 2.3,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_priceFocusNode);
                              },
                              onSaved: (value) {
                                setState(() {
                                  _newHouse = House(
                                    id: _newHouse.id,
                                    price: _newHouse.price,
                                    location: _newHouse.location,
                                    ownerName: _newHouse.ownerName,
                                    phNumber: _newHouse.phNumber,
                                    email: _newHouse.email,
                                    images: _newHouse.images,
                                    city: _newHouse.city,
                                    firstAddress: value,
                                    houseArea: _newHouse.houseArea,
                                    landArea: _newHouse.landArea,
                                    bedRoomsNumber: _newHouse.bedRoomsNumber,
                                    bathsNumber: _newHouse.bathsNumber,
                                    floorsNumber: _newHouse.floorsNumber,
                                    floor: _newHouse.floor,
                                    houseCondition: _newHouse.houseCondition,
                                    houseAge: _newHouse.houseAge,
                                    houseType: _newHouse.houseType,
                                    parkingsNumber: _newHouse.parkingsNumber,
                                    isRent: _newHouse.isRent,
                                    description: _newHouse.description,
                                    shareDate: _newHouse.shareDate,
                                    paymentMethod: _newHouse.paymentMethod,
                                  );
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the neighborhood';
                                }
                                if (value.startsWith(' ')) {
                                  return 'can\t start with space';
                                }
                                if (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                    || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                    || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                    || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                    || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ')) {
                                  return 'Please use english letters';
                                }
                                if (value.length > 20) {
                                  return 'can\t use more than 20 letters';
                                }
                                if (isNumberOnly(value)) {
                                  return 'Letters only!';
                                }
                                if (value.startsWith('٠') || value.startsWith('١') || value.startsWith('٢') || value.startsWith('٣') || value.startsWith('٤') || value.startsWith('٥') ||
                                    value.startsWith('٦') || value.startsWith('٧') || value.startsWith('٨') || value.startsWith('٩')) {
                                  return 'Letters only!';
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          addHorizontalSpace(padding),
                          Container(
                            width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                            height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.1,
                            child: TextFormField(
                              controller: _priceController,
                              focusNode: _priceFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6),
                              cursorColor: Color(0xFF000000),
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                hintText: sellOrRent == sellOrRentList[1] ? 'Monthly Rent' : 'Price',
                                hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                                errorStyle: TextStyle(
                                  fontSize: size / 2.3,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_areaFocusNode);
                              },
                              onSaved: (value) {
                                _newHouse = House(
                                  id: _newHouse.id,
                                  price: int.parse(value),
                                  location: _newHouse.location,
                                  ownerName: _newHouse.ownerName,
                                  phNumber: _newHouse.phNumber,
                                  email: _newHouse.email,
                                  images: _newHouse.images,
                                  city: _newHouse.city,
                                  firstAddress: _newHouse.firstAddress,
                                  houseArea: _newHouse.houseArea,
                                  landArea: _newHouse.landArea,
                                  bedRoomsNumber: _newHouse.bedRoomsNumber,
                                  bathsNumber: _newHouse.bathsNumber,
                                  floorsNumber: _newHouse.floorsNumber,
                                  floor: _newHouse.floor,
                                  houseCondition: _newHouse.houseCondition,
                                  houseAge: _newHouse.houseAge,
                                  houseType: _newHouse.houseType,
                                  parkingsNumber: _newHouse.parkingsNumber,
                                  isRent: _newHouse.isRent,
                                  description: _newHouse.description,
                                  shareDate: _newHouse.shareDate,
                                  paymentMethod: _newHouse.paymentMethod,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the price';
                                }
                                if (value.contains(' ')) {
                                  return 'Can\'t contain a space';
                                }
                                if (int.parse(value) < 0) {
                                  return 'Price can\'t be less than zero!';
                                }
                                if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                    || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')) {
                                  return 'Please use english numbers';
                                }
                                if (value.contains('.') || value.contains(',')) {
                                  return 'Please enter the value without commas';
                                }
                                if (!isNumberOnly(value)) {
                                  return 'Numbers only!';
                                }
                                if (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                    || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                    || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                    || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                    || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ')) {
                                  return 'Numbers only!';
                                }
                                if (sellOrRent == sellOrRentList[1]) {
                                  if (int.parse(value) >= 5001) {
                                    return 'Please enter a valid value';
                                  }
                                }
                                if (int.parse(value) >= 500000001) {
                                  return 'Please enter a valid value';
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          addHorizontalSpace(padding),
                          Container(
                            width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                            height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.1,
                            // padding: sidePadding,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextFormField(
                              controller: _areaController,
                              focusNode: _areaFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6),
                              cursorColor: Color(0xFF000000),
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                hintText: 'House Area (m²)',
                                hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                                errorStyle: TextStyle(
                                  fontSize: size / 2.3,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_landAreaFocusNode);
                              },
                              onSaved: (value) {
                                _newHouse = House(
                                  id: _newHouse.id,
                                  price: _newHouse.price,
                                  location: _newHouse.location,
                                  ownerName: _newHouse.ownerName,
                                  phNumber: _newHouse.phNumber,
                                  email: _newHouse.email,
                                  images: _newHouse.images,
                                  city: _newHouse.city,
                                  firstAddress: _newHouse.firstAddress,
                                  houseArea: int.parse(value),
                                  landArea: _newHouse.landArea,
                                  bedRoomsNumber: _newHouse.bedRoomsNumber,
                                  bathsNumber: _newHouse.bathsNumber,
                                  floorsNumber: _newHouse.floorsNumber,
                                  floor: _newHouse.floor,
                                  houseCondition: _newHouse.houseCondition,
                                  houseAge: _newHouse.houseAge,
                                  houseType: _newHouse.houseType,
                                  parkingsNumber: _newHouse.parkingsNumber,
                                  isRent: _newHouse.isRent,
                                  description: _newHouse.description,
                                  shareDate: _newHouse.shareDate,
                                  paymentMethod: _newHouse.paymentMethod,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the house area';
                                }
                                if (value.contains(' ')) {
                                  return 'Can\'t contain a space';
                                }
                                if (int.parse(value) < 0) {
                                  return 'House area can\'t be less than zero!';
                                }
                                if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                    || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')) {
                                  return 'Please use english numbers';
                                }
                                if (value.contains('.') || value.contains(',')) {
                                  return 'Please enter the value without commas';
                                }
                                if (!isNumberOnly(value)) {
                                  return 'Numbers only!';
                                }
                                if (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                    || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                    || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                    || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                    || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ')) {
                                  return 'Numbers only!';
                                }
                                if (int.parse(value) >= 1001) {
                                  return 'Please enter a valid value';
                                }
                                else {
                                  return null;
                                }
                              },

                            ),
                          ),
                          houseType == houseTypeList[1] ? SizedBox() : addHorizontalSpace(padding),
                          houseType == houseTypeList[1] ? SizedBox() : Container(
                            width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.4,
                            height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.1,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            child: TextFormField(
                              controller: _landAreaController,
                              focusNode: _landAreaFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6),
                              cursorColor: Color(0xFF000000),
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                hintText: 'Land Area (m²)',
                                hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                                errorStyle: TextStyle(
                                  fontSize: size / 2.3,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_descriptionFocusNode);
                              },
                              onSaved: (value) {
                                _newHouse = House(
                                  id: _newHouse.id,
                                  price: _newHouse.price,
                                  location: _newHouse.location,
                                  ownerName: _newHouse.ownerName,
                                  phNumber: _newHouse.phNumber,
                                  email: _newHouse.email,
                                  images: _newHouse.images,
                                  city: _newHouse.city,
                                  firstAddress: _newHouse.firstAddress,
                                  houseArea: _newHouse.houseArea,
                                  landArea: int.parse(value),
                                  bedRoomsNumber: _newHouse.bedRoomsNumber,
                                  bathsNumber: _newHouse.bathsNumber,
                                  floorsNumber: _newHouse.floorsNumber,
                                  floor: _newHouse.floor,
                                  houseCondition: _newHouse.houseCondition,
                                  houseAge: _newHouse.houseAge,
                                  houseType: _newHouse.houseType,
                                  parkingsNumber: _newHouse.parkingsNumber,
                                  isRent: _newHouse.isRent,
                                  description: _newHouse.description,
                                  shareDate: _newHouse.shareDate,
                                  paymentMethod: _newHouse.paymentMethod,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the land area';
                                }
                                if (int.parse(value) < 0) {
                                  return 'Land area can\'t be less than zero!';
                                }
                                if (value.contains(' ')) {
                                  return 'Can\'t contain a space';
                                }
                                if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                    || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')) {
                                  return 'Please use the english numbers';
                                }
                                if (value.contains('.') || value.contains(',')) {
                                  return 'Please enter the value without commas';
                                }
                                if (!isNumberOnly(value)) {
                                  return 'Numbers only!';
                                }
                                if (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                    || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                    || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                    || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                    || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ')) {
                                  return 'Numbers only!';
                                }
                                if (int.parse(value) >= 10001){
                                  return 'Please enter a valid value';
                                }
                                else {
                                  return null;
                                }
                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    DotsIndicator(
                      dotsCount: 3,
                      decorator: DotsDecorator(
                        color: Colors.green[700].withOpacity(0.5), // Inactive color
                        activeColor: Colors.green[700].withOpacity(0.5),
                      ),
                    ),
                    addVerticalSpace(padding * 2),
                    Container(
                      // width: screenSize.width,
                      height: isLandscape ? screenSize.width * 0.3 : screenSize.height * 0.3,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.green[700],
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          maxLines: (isLandscape ? screenSize.width * 0.3 : screenSize.height * 0.3).toInt(),
                          maxLength: 250,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          textInputAction: TextInputAction.done,
                          style: TEXT_THEME_DEFAULT.headline4.copyWith(fontSize: size / 1.6),
                          cursorColor: Color(0xFF000000),
                          scrollPhysics: BouncingScrollPhysics(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: size / 1.8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.green[700],
                              ),
                            ),
                            hintText: 'ex: separate house in Amman, with an area of 250 square meters, in a quiet neighborhood...(optional)',
                            hintStyle: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.grey.withOpacity(0.7), fontSize: size / 1.8),
                            errorStyle: TextStyle(
                              fontSize: size / 2.3,
                            ),
                          ),
                          onSaved: (value) {
                            _newHouse = House(
                              id: _newHouse.id,
                              price: _newHouse.price,
                              location: _newHouse.location,
                              ownerName: _newHouse.ownerName,
                              phNumber: _newHouse.phNumber,
                              email: _newHouse.email,
                              images: _newHouse.images,
                              city: _newHouse.city,
                              firstAddress: _newHouse.firstAddress,
                              houseArea: _newHouse.houseArea,
                              landArea: _newHouse.landArea,
                              bedRoomsNumber: _newHouse.bedRoomsNumber,
                              bathsNumber: _newHouse.bathsNumber,
                              floorsNumber: _newHouse.floorsNumber,
                              floor: _newHouse.floor,
                              houseCondition: _newHouse.houseCondition,
                              houseAge: _newHouse.houseAge,
                              houseType: _newHouse.houseType,
                              parkingsNumber: _newHouse.parkingsNumber,
                              isRent: _newHouse.isRent,
                              description: value,
                              shareDate: _newHouse.shareDate,
                              paymentMethod: _newHouse.paymentMethod,
                            );
                          },
                          validator: (value) {
                            if (value.startsWith(' ')) {
                              return 'Description can\t start with space';
                            }
                            if (value.length > 250) {
                              return 'Description can\t be more than 250 letters';
                            }
                            else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 1,
          state: _mainInfoDone ? StepState.indexed : StepState.disabled,
            title: Text('Additional Features'),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _garden,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _garden = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Garden',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _balcony,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _balcony = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Balcony',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _elevator,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _elevator = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Elevator',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _nearServices,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _nearServices = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Near Services',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _mainStreet,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _mainStreet = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Main Street',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _equippedKitchen,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _equippedKitchen = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Equipped Kitchen',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _shutters,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _shutters = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Shutters',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _centralHeating,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _centralHeating = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Central Heating',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _doubleGlazing,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _doubleGlazing = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Double Glazing',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _wareHouse,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _wareHouse = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Warehouse',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _maidRoom,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _maidRoom = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Maid Room',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  houseType == houseTypeList[2] ? Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _guardRoom,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _guardRoom = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Guard Room',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _laundryRoom,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _laundryRoom = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Laundry Room',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _swimmingBool,
                            splashRadius: 0.0,
                            // to remove the color when the use pressed on the checkbox
                            onChanged: (value) {
                              setState(() {
                                _swimmingBool = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                          addVerticalSpace(padding / 2),
                          Text(
                            'Swimming Bool',
                            style: textTheme.headline5.copyWith(fontSize: size * 0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
        Step(
          isActive: _currentStep >= 2,
          state: _mainInfoDone ? StepState.indexed : StepState.disabled,
            title: Text('Location'),
            content: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.5,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: size,
                      ),
                      label: Text(
                        'Use My Current Location',
                          style: textTheme.headline5.copyWith(color: Colors.white, fontSize: size * 0.5),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green[700],
                        ),
                      ),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                  // addHorizontalSpace(padding),
                  !locationPickedByCurrent
                      ? SizedBox()
                      : Icon(
                          Icons.check_circle,
                          size: size,
                          color: Colors.green[700],
                        ),
                ],
              ),
              addVerticalSpace(padding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: isLandscape ? screenSize.height * 0.5 : screenSize.width * 0.5,
                    child: TextButton.icon(
                      icon: Icon(
                        LineAwesomeIcons.search_location,
                        color: Colors.white,
                          size: size,
                      ),
                      label: Text(
                        'Pick Location on the Map',
                        style: textTheme.headline5.copyWith(color: Colors.white, fontSize: size * 0.5),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green[700],
                        ),
                      ),
                      onPressed: _selectLocation,
                    ),
                  ),
                  // addHorizontalSpace(padding),
                  !locationPickedByMap
                      ?
                  SizedBox()
                      :
                  Icon(
                    Icons.check_circle,
                    size: size,
                    color: Colors.green[700],
                  ),
                ],
              ),
            ]),
        ),
        Step(
            title: Text('Pictures'),
            content: Container(
              width: isLandscape ? screenSize.width : screenSize.width,
              height: isLandscape ? screenSize.width * 0.3 : screenSize.height * 0.4,
              // on landscape (height: screenSize.width * 0.3,)
              child: buildGridView(size, screenSize, isLandscape),
            ),
            isActive: _currentStep >= 3,
            state: _locationInfoDone ? StepState.indexed : StepState.disabled,
        ),
      ];
      return _steps;
    }




    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Theme(
                    data: ThemeData(
                      primaryColor: Colors.green[700],
                      colorScheme: ColorScheme.light(
                        primary: Colors.green[700],
                      ),
                    ),
                    child: Stepper(
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                            VoidCallback onStepCancel}) {
                        return Padding(
                          padding: EdgeInsets.only(top: padding),
                          child: Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  if (_currentStep == 0) {
                                    final isValid = _formKey.currentState.validate();
                                    if (!isValid) {
                                      return;
                                    }
                                    else {
                                      _formKey.currentState.save();
                                      setState(() {
                                        _mainInfoDone = true;
                                      });
                                      // onStepContinue();
                                    }
                                  }
                                  if (_currentStep == 2) {
                                    if (!_locationInfoDone) {
                                      return;
                                    }
                                    else {
                                      onStepContinue();
                                    }
                                  }
                                  else {
                                    // _mainInfoDone = !_mainInfoDone;
                                    onStepContinue();
                                  }
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                    Colors.green[700],
                                  ),
                                ),
                              ),
                              addHorizontalSpace(padding),
                              TextButton(
                                onPressed: () {
                                  if (_currentStep == 2) {
                                    if (!_mainInfoDone) {
                                      return;
                                    }
                                    else {
                                      onStepCancel();
                                    }
                                  }
                                  else {
                                    onStepCancel();
                                  }
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      steps: _stepper(),
                      physics: ClampingScrollPhysics(),
                      currentStep: _currentStep,
                      // type: _stepperType
                      onStepTapped: (step) {
                        setState(() {
                          _currentStep = step;
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (_currentStep < _stepper().length - 1) {
                            _currentStep = _currentStep + 1;
                          } else {
                            return;
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if (_currentStep > 0) {
                            _currentStep = _currentStep - 1;
                          } else {
                            _currentStep = 0;
                          }
                        });
                      },
                    ),
                  ),
                  addVerticalSpace(padding * 7),
                ],
              ),
            ),
          ),
          // uploading ? SizedBox() : AlertDialog(
          //   title: Text('الرجاء الانتظار'),
          //   content: Text('جار نشر العقار'),
          // ),
          _keyboardVisible ? SizedBox() : Positioned(
            bottom: size,
            left: uploading ? screenSize.width / 2.2 : screenSize.width / 2.7,
            child: uploading ? CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]),
            ) : ElevatedButton(
              child: Text('Publish',
                style: textTheme.headline2.copyWith(color: Colors.white, fontSize: size / 1.5),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: screenSize.width * 0.1)),
              ),
              onPressed: _checkBeforShare,
            ),
          ),
        ],),
      ),
    );
  }


  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
            color: Colors.white.withOpacity(0.2),
            child: WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: Container(
                  height: 200.0,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]),
                        ),
                        SizedBox(height: 7.0,),
                        Text('We are Sharing your property, please wait..', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }





  Widget buildGridView(double size, Size screenSize, bool isLandscape) {
    return Stack(
      children: [
        Container(
          // margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(size / 3),
          child: RawScrollbar(
            thumbColor: Colors.green[700],
            thickness: 5.0,
            radius: Radius.circular(15.0),
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 4 : 3
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Column(
                        children: [
                          IconButton(
                              icon: Icon(Icons.add_photo_alternate_outlined),
                              iconSize: size * 2,
                              color: Colors.green[700],
                              onPressed: () {
                                if (_image.length <= 14) {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.green[700],
                                      // title: Text('حدد المصدر', textAlign: TextAlign.center,),
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.camera_alt_outlined),
                                                iconSize: size * 2,
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (_image.length <= 14) {
                                                    chooseImageFromCamera(index);
                                                  }
                                                  else {
                                                    ScaffoldMessenger.of(context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Sorry you can\'t add more then 15 pictures',
                                                            style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
                                                            MediaQuery.of(context).size.width * 0.05 / 1.5)
                                                        ),
                                                        backgroundColor: Colors.green[700],
                                                        behavior: SnackBarBehavior.floating,
                                                        duration: Duration(seconds: 3),
                                                        action: SnackBarAction(
                                                          label: 'Ok',
                                                          textColor: Colors.white,
                                                          onPressed: () {
                                                            ScaffoldMessenger.of(
                                                                context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              Text('Camera' ,
                                                  style: TEXT_THEME_DEFAULT.headline5.copyWith(color: Colors.white, fontSize: size * 0.5)
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(LineAwesomeIcons.image),
                                                iconSize: size * 2,
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (_image.length <= 14) {
                                                    chooseImage(index, ImageSource.gallery);
                                                  }
                                                  else {
                                                    ScaffoldMessenger.of(context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Sorry you can\'t add more then 15 pictures',
                                                            style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
                                                            MediaQuery.of(context).size.width * 0.05 / 1.5)
                                                        ),
                                                        backgroundColor: Colors.green[700],
                                                        behavior: SnackBarBehavior.floating,
                                                        duration: Duration(seconds: 3),
                                                        action: SnackBarAction(
                                                          label: 'Ok',
                                                          textColor: Colors.white,
                                                          onPressed: () {
                                                            ScaffoldMessenger.of(
                                                                context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              Text('Gallery',
                                                  style: TEXT_THEME_DEFAULT.headline5.copyWith(color: Colors.white, fontSize: size * 0.5)
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Sorry you can\'t add more then 15 pictures',
                                          style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
                                          MediaQuery.of(context).size.width * 0.05 / 1.5)
                                      ),
                                      backgroundColor: Colors.green[700],
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                              context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    ),
                                  );
                                }
                                if (_image.length <= 14) {
                                  chooseImage(
                                      index, ImageSource.camera
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Sorry you can\'t add more then 15 pictures',
                                          style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
                                          MediaQuery.of(context).size.width * 0.05 / 1.5)
                                      ),
                                      backgroundColor: Colors.green[700],
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                              context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    ),
                                  );
                                }
                              }),
                          Text('Add Pictures', style: TEXT_THEME_DEFAULT.headline5.copyWith(fontSize: size * 0.5)),
                        ],
                      )
                      : Stack(
                    children: [
                      Container(
                        width: isLandscape ? screenSize.height * 0.3 : screenSize.width * 0.3,
                        height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.2,
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_image[index - 1]), fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                          child: Icon(
                            Icons.remove_circle,
                            size: 15.0,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              // _image.replaceRange(index, index + 1, ['Add Image']);
                              if (_image.length == 0) {
                                _image.clear();
                                printImagesPaths();
                              } else {
                                _image.removeAt(index - 1);
                                // _image.insert(index, 'img');
                                printImagesPaths();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}





// class SmallImage extends StatelessWidget {
//   final Image image;
//
//   SmallImage({this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     final double padding = 15.0;
//     return Row(
//       children: [
//         addHorizontalSpace(padding),
//         Container(
//             width: 50.0,
//             height: 50.0,
//             child: image == null ? SizedBox() : image,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.green[700],
//             )),
//       ],
//     );
//   }
// }


