import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'package:bluesky_project/screens/mapScreen.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'imageScreen.dart';
import 'loginScreen.dart';


class Details extends StatefulWidget {

  final String houseId;
  Details(this.houseId,);




  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  House _selectedHouse;
  bool isFavorite = false;

  House findById (String id) {
    final houseProvider = Provider.of<Houses>(context, listen: false);
    return _selectedHouse = houseProvider.houses.firstWhere((house) => house.id == id);
  }

  onFavoriteIconPressed() {
    final auth = Provider.of<Auth>(context, listen: false);
    _selectedHouse.toggleFavoriteStatus(auth.token, auth.userId, context);
  }

  _showVisitorAlert() {
    final userProvider = Provider.of<Auth>(context, listen: false);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: DialogBackground(
              color: Colors.white,
              barrierColor: Colors.white,
              dismissable: true,
              blur: 0.2,
              onDismiss: () {},
              dialog: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                        type: MaterialType.transparency,
                        child: Text('Sorry, you need to login first!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                    ),
                    addVerticalSpace(16),
                    ElevatedButton(
                      child: Text('Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5)),
                      ),
                      onPressed: () {
                        userProvider.visitor(false);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }


  Future myFuture;
  String ownerImageUrl;

  // List<Widget> noimages = [
  //
  // ];

  List<Widget> fixDesign(double height) {
    return [
      Container(
        width: 20,
        height: height,
      ),
    ];
  }


  @override
  void initState() {
    findById(widget.houseId);
    myFuture = FirebaseStorage.instance
        .ref('users/${_selectedHouse.email}')
        .getDownloadURL().then((value) {
      if (value != null) {
        ownerImageUrl = value;
        print('ffffffffffffffffffff');
      }
      else {
        setState(() {
          ownerImageUrl = '';
        });
        print('kkkkkkkkkkkkkk');
      }
    });
    super.initState();
  }


  _makeCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final userProvider = Provider.of<Auth>(context);

    return Scaffold(
      body: !isLandscape ? Stack(
        children: [
          InkWell(
            onTap: () {
              if (_selectedHouse.images == null) {
                return;
              }
              else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageScreen(_selectedHouse.images[0])));
              }
            },
            child: Hero(
              tag: _selectedHouse.images == null ? 'img' : _selectedHouse.images[0],
              child: Container(
                height: isLandscape ? screenSize.width * 0.5 : screenSize.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _selectedHouse.images == null ? AssetImage('images/noImage.jpg') : NetworkImage(_selectedHouse.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: screenSize.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.5, vertical: padding * 2.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        iconSize: size * 1.3,
                        padding: EdgeInsets.only(right: padding / 2),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(MdiIcons.homeMapMarker),
                        color: Colors.white,
                        iconSize: size * 1.5,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(hasLocation: true, latitude: _selectedHouse.location.latitude, longitude: _selectedHouse.location.longitude,))).then((value) => setState(() {}));
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.5, vertical: padding / 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    width: size * 4.5,
                    padding: EdgeInsets.symmetric(vertical: 4,),
                    child: Center(
                      child: Text(
                        _selectedHouse.isRent ? 'FOR RENT' : 'FOR SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 0.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedHouse.city,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: size * 2.5,
                        height: size * 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(_selectedHouse.isFavorite
                                ?
                            Icons.favorite
                                :
                            Icons.favorite_border
                            ),
                            color: Colors.green[700],
                            iconSize: size,
                            onPressed: () {
                              if (isVisitor) {
                                _showVisitorAlert();
                              }
                              else {
                                onFavoriteIconPressed();
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: padding * 1.5, right: padding * 1.5, top: padding / 2, bottom: padding,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: size * 0.6,
                          ),
                          SizedBox(
                            width: padding / 4,
                          ),
                          Text(
                            _selectedHouse.firstAddress,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.6,
                            ),
                          ),
                          SizedBox(
                            width: padding / 2,
                          ),
                          Icon(
                            Icons.house_outlined,
                            color: Colors.white,
                            size: size * 0.6,
                          ),
                          SizedBox(
                            width: padding / 4,
                          ),
                          Text(
                            _selectedHouse.houseArea.toString() + "m²",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.6,
                            ),
                          ),
                          if(_selectedHouse.houseType != 'Apartment') SizedBox(
                            width: padding / 2,
                          ),
                          if(_selectedHouse.houseType != 'Apartment') Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                            size: size * 0.6,
                          ),
                          if(_selectedHouse.houseType != 'Apartment') SizedBox(
                            width: padding / 4,
                          ),
                          if(_selectedHouse.houseType != 'Apartment') Text(
                            _selectedHouse.landArea.toString() + "m²",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.6,
                            ),
                          ),
                          if(!_selectedHouse.isRent) SizedBox(
                            width: padding / 2,
                          ),
                          if(!_selectedHouse.isRent) Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.white,
                            size: size * 0.6,
                          ),
                          if(!_selectedHouse.isRent) SizedBox(
                            width: padding / 4,
                          ),
                          if(!_selectedHouse.isRent) Text(
                            _selectedHouse.houseType != 'Apartment' && _selectedHouse.paymentMethod.length > 12 ? 'Cash or Inst...' : _selectedHouse.paymentMethod,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.6,
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    height: _selectedHouse.images == null ? screenSize.height * 0.7 : screenSize.height * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: size * 3,
                                    height: size * 3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: FutureBuilder(
                                        future: myFuture,
                                        builder:(context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                            ? Container()
                                            : FadeInImage(
                                          placeholder: AssetImage('images/empty.png'),
                                          fit: BoxFit.cover,
                                          image: NetworkImage(ownerImageUrl),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size * 0.5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedHouse.ownerName,
                                        style: TextStyle(
                                          fontSize: size * 0.7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Property Owner",
                                        style: TextStyle(
                                          fontSize: size * 0.5,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        height: padding / 2,
                                      ),
                                      Text(
                                        _selectedHouse.shareDate,
                                        style: TextStyle(
                                          fontSize: size * 0.5,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: size * 2.5,
                                    height: size * 2.5,
                                    decoration: BoxDecoration(
                                      color: Colors.green[700].withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(Icons.phone),
                                        color: Colors.green[700],
                                        iconSize: size,
                                        onPressed: () {
                                          showDialog(context: context, builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Text('Do you want to call property owner (${_selectedHouse.phNumber})?', style: TextStyle(color: Colors.green[700], fontSize: size * 0.7),),
                                            actions: [
                                              TextButton(
                                                child: Text('No', style: TextStyle(color: Colors.red, fontSize: size * 0.7),),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                // style: ButtonStyle(
                                                //   backgroundColor: MaterialStateProperty.all(Colors.white),
                                                // ),
                                              ),
                                              TextButton(
                                                child: Text('Yes', style: TextStyle(color: Colors.green[700], fontSize: size * 0.7),),
                                                onPressed: () {
                                                  _makeCall(_selectedHouse.phNumber);
                                                  Navigator.of(context).pop();
                                                },
                                                // style: ButtonStyle(
                                                //   backgroundColor: MaterialStateProperty.all(Colors.white),
                                                // ),
                                              ),
                                            ],
                                          ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: padding,
                                  // ),
                                  // Container(
                                  //   width: size * 2.5,
                                  //   height: size * 2.5,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.green[700].withOpacity(0.1),
                                  //     shape: BoxShape.circle,
                                  //   ),
                                  //   child: Center(
                                  //     child: IconButton(
                                  //       icon: Icon(Icons.message),
                                  //       color: Colors.green[700],
                                  //       iconSize: size,
                                  //       onPressed: () {},
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: padding, top: padding),
                          child: Container(
                            height: size * 4,
                            child: ListView(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children: [
                                buildFeature(Icons.house_outlined, _selectedHouse.houseType, size, padding),
                                if(_selectedHouse.houseType == 'Apartment')
                                if(_selectedHouse.houseType == 'Apartment')
                                  buildFeature(
                                      _selectedHouse.floor == -1 ? MdiIcons.homeFloorNegative1 :
                                      _selectedHouse.floor == 0 ? MdiIcons.homeFloor0 :
                                      _selectedHouse.floor == 1 ? MdiIcons.homeFloor1 :
                                      _selectedHouse.floor == 2 ? MdiIcons.homeFloor2 :
                                      _selectedHouse.floor == 3 ? MdiIcons.homeFloor3 :
                                      MdiIcons.numeric4, 'Floor', size, padding
                                  ),
                                if(_selectedHouse.houseType == 'Building')
                                if(_selectedHouse.houseType == 'Building')
                                  buildFeature(
                                      MdiIcons.officeBuildingOutline, _selectedHouse.floorsNumber + ' Floors', size, padding
                                  ),
                                buildFeature(Icons.hotel, _selectedHouse.bedRoomsNumber + " Bedroom", size, padding),
                                buildFeature(Icons.wc, _selectedHouse.bathsNumber + " Bathroom", size, padding),
                                buildFeature(Icons.local_parking, _selectedHouse.parkingsNumber +  " Parking", size, padding),
                                buildFeature(Icons.house, _selectedHouse.houseCondition, size, padding),
                                buildFeature(
                                    Icons.query_builder_outlined,
                                    _selectedHouse.houseAge.length < 13
                                        ?
                                    _selectedHouse.houseAge +  ' Years'
                                        :
                                    _selectedHouse.houseAge + '',
                                    size, padding
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: padding * 1.5,),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                buildSubFeature('Balcony', _selectedHouse.balcony, size, padding),
                                buildSubFeature('Garden', _selectedHouse.garden, size, padding),
                                buildSubFeature('Parking',_selectedHouse.garage, size, padding),
                                buildSubFeature('Elevator',_selectedHouse.elevator, size, padding),
                                buildSubFeature('Near services', _selectedHouse.nearServices, size, padding),
                                buildSubFeature('Main street', _selectedHouse.mainStreet, size, padding),
                                buildSubFeature('Maid room', _selectedHouse.maidRoom, size, padding),
                                buildSubFeature('Guard room', _selectedHouse.guardRoom, size, padding),
                                buildSubFeature('Laundry room', _selectedHouse.laundryRoom, size, padding),
                                buildSubFeature('Equipped kitchen',_selectedHouse.equippedKitchen, size, padding),
                                buildSubFeature('Central heating',_selectedHouse.centralHeating, size, padding),
                                buildSubFeature('Warehouse', _selectedHouse.wareHouse, size, padding),
                                buildSubFeature('Double glazing', _selectedHouse.doubleGlazing, size, padding),
                                buildSubFeature('Shutters', _selectedHouse.shutters, size, padding),
                                buildSubFeature('Swimming bool', _selectedHouse.swimmingBool, size, padding),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding, top: padding * 1.5),
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: _selectedHouse.description.length < 1
                              ?
                          EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding * 4, top: padding * 2)
                              :
                          EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding),
                          child: Text(
                            _selectedHouse.description.length < 1 ? 'No description for this house!' : _selectedHouse.description,
                            style: TextStyle(
                              fontSize: size * 0.8,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        if (_selectedHouse.images != null) Padding(
                          padding: EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding,),
                          child: Text(
                            "Photos",
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: padding * 1.5,),
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              // shrinkWrap: true,
                              children: _selectedHouse.images == null ? fixDesign(screenSize.height * 0.1) : buildPhotos(_selectedHouse.images.cast<String>(), size),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: padding,
          //   width: screenSize.width,
          //   child: Center(
          //     child: OptionButton(
          //       text: "Map View",
          //       icon: Icons.map_rounded,
          //       width: padding * 10,
          //       size: size,
          //       color: Colors.green[700].withOpacity(0.8),
          //       onPressed: () {
          //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(hasLocation: true, latitude: _selectedHouse.location.latitude, longitude: _selectedHouse.location.longitude,)));
          //       },
          //     ),
          //   ),
          // ),
        ],
      )
          :
      Stack(
        children: [
          Container(
            color: Colors.green[700],
            child: Padding(
              padding: EdgeInsets.only(top: padding * 2, bottom: padding, left: padding * 1.5, right: padding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    iconSize: size * 1.3,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    _selectedHouse.city,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: padding / 2),
                    child: Container(
                      width: size * 4.5,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),

                      child: Center(
                        child: Text(
                          _selectedHouse.isRent ? 'FOR RENT' : 'FOR SALE',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: size * 0.6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: padding / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: size * 0.6,
                            ),
                            SizedBox(
                              width: padding / 4,
                            ),
                            Text(
                              _selectedHouse.firstAddress,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size * 0.6,
                              ),
                            ),
                            SizedBox(
                              width: padding / 2,
                            ),
                            Icon(
                              Icons.house_outlined,
                              color: Colors.white,
                              size: size * 0.6,
                            ),
                            SizedBox(
                              width: padding / 4,
                            ),
                            Text(
                              _selectedHouse.houseArea.toString() + "m²",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size * 0.6,
                              ),
                            ),

                            if(_selectedHouse.houseType != 'Apartment') SizedBox(
                              width: padding / 2,
                            ),

                            if(_selectedHouse.houseType != 'Apartment') Icon(
                              Icons.zoom_out_map,
                              color: Colors.white,
                              size: size * 0.6,
                            ),

                            if(_selectedHouse.houseType != 'Apartment') SizedBox(
                              width: padding / 4,
                            ),

                            if(_selectedHouse.houseType != 'Apartment') Text(
                              _selectedHouse.landArea.toString() + "m²",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size * 0.6,
                              ),
                            ),

                            if(!_selectedHouse.isRent) SizedBox(
                              width: padding / 2,
                            ),

                            if(!_selectedHouse.isRent) Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.white,
                              size: size * 0.6,
                            ),

                            if(!_selectedHouse.isRent) SizedBox(
                              width: padding / 4,
                            ),

                            if(!_selectedHouse.isRent) Text(
                              _selectedHouse.houseType != 'Apartment' && _selectedHouse.paymentMethod.length > 12 ? 'Cash or Inst...' : _selectedHouse.paymentMethod,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size * 0.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: padding * 5.8),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: screenSize.width * 0.65,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(30),
                //     topRight: Radius.circular(30),
                //   ),
                // ),
                child: Center(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      height: _selectedHouse.images == null ? screenSize.width * 0.7 : screenSize.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding * 1.5, vertical: padding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: size * 3,
                                      height: size * 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FutureBuilder(
                                          future: myFuture,
                                          builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                                              ? CircleAvatar(child: CircularProgressIndicator(
                                            backgroundColor: Colors.green[700],
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                            backgroundColor: Colors.white, foregroundColor: Colors.white,
                                          )
                                              : FadeInImage(
                                            placeholder: AssetImage('images/empty.png'),
                                            fit: BoxFit.cover,
                                            image: NetworkImage(ownerImageUrl),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size * 0.5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedHouse.ownerName,
                                          style: TextStyle(
                                            fontSize: size * 0.7,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Property Owner",
                                          style: TextStyle(
                                            fontSize: size * 0.5,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        SizedBox(
                                          height: padding / 2,
                                        ),
                                        Text(
                                          _selectedHouse.shareDate,
                                          style: TextStyle(
                                            fontSize: size * 0.5,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: size * 2.5,
                                      height: size * 2.5,
                                      decoration: BoxDecoration(
                                        color: Colors.green[700].withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(MdiIcons.homeMapMarker),
                                          color: Colors.green[700],
                                          iconSize: size,
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(
                                              hasLocation: true,
                                              latitude: _selectedHouse.location.latitude,
                                              longitude: _selectedHouse.location.longitude,))
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    addHorizontalSpace(padding),
                                    Container(
                                      width: size * 2.5,
                                      height: size * 2.5,
                                      decoration: BoxDecoration(
                                        color: Colors.green[700].withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon( _selectedHouse.isFavorite
                                              ?
                                          Icons.favorite
                                              :
                                          Icons.favorite_border
                                          ),
                                          color: Colors.green[700],
                                          iconSize: size,
                                          onPressed: () {
                                            if (isVisitor) {
                                              _showVisitorAlert();
                                            }
                                            else {
                                              onFavoriteIconPressed();
                                              setState(() {
                                                isFavorite = !isFavorite;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    addHorizontalSpace(padding),
                                    Container(
                                      width: size * 2.5,
                                      height: size * 2.5,
                                      decoration: BoxDecoration(
                                        color: Colors.green[700].withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(Icons.phone),
                                          color: Colors.green[700],
                                          iconSize: size,
                                          onPressed: () {
                                            showDialog(context: context, builder: (context) => AlertDialog(
                                              backgroundColor: Colors.white,
                                              content: Text('Do you want to call property owner (${_selectedHouse.phNumber})?', style: TextStyle(color: Colors.green[700], fontSize: size * 0.7),),
                                              actions: [
                                                TextButton(
                                                  child: Text('No', style: TextStyle(color: Colors.red, fontSize: size * 0.7),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  // style: ButtonStyle(
                                                  //   backgroundColor: MaterialStateProperty.all(Colors.white),
                                                  // ),
                                                ),
                                                TextButton(
                                                  child: Text('Yes', style: TextStyle(color: Colors.green[700], fontSize: size * 0.7),),
                                                  onPressed: () {
                                                    _makeCall(_selectedHouse.phNumber);
                                                    Navigator.of(context).pop();
                                                  },
                                                  // style: ButtonStyle(
                                                  //   backgroundColor: MaterialStateProperty.all(Colors.white),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // addHorizontalSpace(padding),
                                    // Container(
                                    //   width: size * 2.5,
                                    //   height: size * 2.5,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.green[700].withOpacity(0.1),
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: Center(
                                    //     child: Icon(
                                    //       Icons.message,
                                    //       color: Colors.green[700],
                                    //       size: size,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: padding, top: padding),
                            child: Container(
                              height: size * 4,
                              child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  buildFeature(Icons.house_outlined, _selectedHouse.houseType, size, padding),
                                  if(_selectedHouse.houseType == 'Apartment') addHorizontalSpace(padding * 3),
                                  if(_selectedHouse.houseType == 'Apartment')
                                    buildFeature(
                                        _selectedHouse.floor == -1 ? MdiIcons.homeFloorNegative1 :
                                        _selectedHouse.floor == 0 ? MdiIcons.homeFloor0 :
                                        _selectedHouse.floor == 1 ? MdiIcons.homeFloor1 :
                                        _selectedHouse.floor == 2 ? MdiIcons.homeFloor2 :
                                        _selectedHouse.floor == 3 ? MdiIcons.homeFloor3 :
                                        MdiIcons.numeric4, 'Floor', size, padding
                                    ),
                                  if(_selectedHouse.houseType == 'Building') addHorizontalSpace(padding * 3),
                                  if(_selectedHouse.houseType == 'Building')
                                    buildFeature(
                                        MdiIcons.officeBuildingOutline, _selectedHouse.floorsNumber + ' Floors', size, padding
                                    ),
                                  addHorizontalSpace(padding * 3),
                                  buildFeature(Icons.hotel, _selectedHouse.bedRoomsNumber + " Bedroom", size, padding),
                                  addHorizontalSpace(padding * 3),
                                  buildFeature(Icons.wc, _selectedHouse.bathsNumber + " Bathroom", size, padding),
                                  addHorizontalSpace(padding * 3),
                                  buildFeature(Icons.local_parking, _selectedHouse.parkingsNumber +  " Parking", size, padding),
                                  addHorizontalSpace(padding * 3),
                                  buildFeature(Icons.house, _selectedHouse.houseCondition, size, padding),
                                  addHorizontalSpace(padding * 3),
                                  buildFeature(
                                      Icons.query_builder_outlined,
                                      _selectedHouse.houseAge.length < 13
                                          ?
                                      _selectedHouse.houseAge +  ' Years'
                                          :
                                      _selectedHouse.houseAge + '',
                                      size, padding
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: padding * 1.5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  buildSubFeature('Balcony', _selectedHouse.balcony, size, padding),
                                  buildSubFeature('Garden', _selectedHouse.garden, size, padding),
                                  buildSubFeature('Parking',_selectedHouse.garage, size, padding),
                                  buildSubFeature('Elevator',_selectedHouse.elevator, size, padding),
                                  buildSubFeature('Near services', _selectedHouse.nearServices, size, padding),
                                  buildSubFeature('Main street', _selectedHouse.mainStreet, size, padding),
                                  buildSubFeature('Maid room', _selectedHouse.maidRoom, size, padding),
                                  buildSubFeature('Guard room', _selectedHouse.guardRoom, size, padding),
                                  buildSubFeature('Laundry room', _selectedHouse.laundryRoom, size, padding),
                                  buildSubFeature('Equipped kitchen',_selectedHouse.equippedKitchen, size, padding),
                                  buildSubFeature('Central heating',_selectedHouse.centralHeating, size, padding),
                                  buildSubFeature('Warehouse', _selectedHouse.wareHouse, size, padding),
                                  buildSubFeature('Double glazing', _selectedHouse.doubleGlazing, size, padding),
                                  buildSubFeature('Shutters', _selectedHouse.shutters, size, padding),
                                  buildSubFeature('Swimming bool', _selectedHouse.swimmingBool, size, padding),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, top: padding * 2.5, bottom: padding,),
                            child: Text(
                              "Description",
                              style: TextStyle(
                                fontSize: size,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: _selectedHouse.description.length < 1
                                ?
                            EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding * 4, top: padding * 2)
                                :
                            EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, bottom: padding * 1.5),
                            child: Text(
                              _selectedHouse.description.length < 1 ? 'No description for this house!' : _selectedHouse.description,
                              style: TextStyle(
                                fontSize: size * 0.8,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),

                          if (_selectedHouse.images != null) Padding(
                            padding: EdgeInsets.only(right: padding * 1.5, left: padding * 1.5, top: padding * 2.5, bottom: padding * 1.5,),
                            child: Text(
                              "Photos",
                              style: TextStyle(
                                fontSize: size,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: padding),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                // shrinkWrap: true,
                                children: _selectedHouse.images == null ? fixDesign(screenSize.width * 0.5) : buildPhotos(_selectedHouse.images.cast<String>(), size),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeature(IconData iconData, String text, double size, double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
      child: Column(
        children: [

          Icon(
            iconData,
            color: Colors.green[700],
            size: size * 1.4,
          ),
          SizedBox(
            height: size / 2,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: size * 0.7,
            ),
          ),

        ],
      ),
    );
  }

  Widget buildSubFeature(String feature, bool checkBoxValue, double size, double padding) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              visualDensity: VisualDensity.compact,
              value: checkBoxValue,
              splashRadius: 0.0,
              onChanged: (value) {},
              activeColor: Colors.green.withOpacity(0.2),
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.green[700]),
            ),
            addVerticalSpace(size / 2),
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: size * 0.7,
              ),
            )
          ],
        ),
      ),
    );
  }


  List<Widget> buildPhotos(List<String> images, double padding){
    List<Widget> list = [];

    list.add(SizedBox(width: padding * 1.2,));
    for (var i = 0; i < images.length; i++) {
      list.add(buildPhoto(images[i], padding));
    }
    return list;
  }

  Widget buildPhoto(String url, double padding){
    return AspectRatio(
      aspectRatio: 1.3,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageScreen(url)));
        },
        child: Container(
          margin: EdgeInsets.only(right: padding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(fit: BoxFit.cover,
              placeholder: AssetImage('images/empty.png'),
              image: NetworkImage(url),
            ),
          ),
        ),
      ),
    );
  }
}

