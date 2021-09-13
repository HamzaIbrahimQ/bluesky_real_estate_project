import 'package:clippy_flutter/arc.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/providers/location_provider.dart';
import 'package:bluesky_project/screens/settingsScreen.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/custom/infoWindowhouseCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'housesListScreen.dart';






class MapScreen extends StatefulWidget {
  final bool hasLocation;
  final double latitude;
  final double longitude;

  MapScreen({@required this.hasLocation, this.latitude, this.longitude});


  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {




  BitmapDescriptor yellowMarker;
  BitmapDescriptor greenMarker;
  MapType _currentMapType = MapType.normal;
  String _mapTypeAsString;










  _onMapTypeButtonPressed() async {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('mapType', _currentMapType.toString());

  }

  _onSettingsButtonPressed() {
    return showDialog(context: context, builder: (context) => DialogBackground(
      dismissable: true,
      dialog: SettingsScreen(),
    ));
  }


  _getMapType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _mapTypeAsString = pref.getString('mapType');
      if(_mapTypeAsString != null && _mapTypeAsString == 'MapType.hybrid') {
        _currentMapType = MapType.hybrid;
      }
      else {
        _currentMapType = MapType.normal;
      }
    });

  }






  GoogleMapController mapController;




  List<House> _filteredHouses;
  bool isSell = false;
  bool isRent = false;
  bool isCash = false;
  bool isNotCash = false;
  bool isFirstHouseType = false;
  bool isSecondHouseType = false;
  bool isThirdHouseType = false;
  bool filtered = false;
  bool _noFilteredFound = false;
  bool filteredFound = false;


  _showModalBottomSheet(context, double infoWindowWidth, double markerOffset) {


    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = screenSize.width * 0.04;
    final TextTheme textTheme = TEXT_THEME_DEFAULT;


    showModalBottomSheet(context: context, builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 500.0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isSell = false;
                                  isRent = false;
                                  isCash = false;
                                  isNotCash = false;
                                  isFirstHouseType = false;
                                  isSecondHouseType = false;
                                  isThirdHouseType = false;
                                });
                                _updateHouses(infoWindowWidth, markerOffset);
                              },
                              child: Text('Cancel filter', style: TextStyle(color: Colors.red),),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.red,
                              splashColor: Colors.white.withOpacity(0.0),
                              highlightColor: Colors.white.withOpacity(0.0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: isLandscape ? padding : padding * 2),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                              highlightColor: Colors.white.withOpacity(0.0),
                              onTap: () {
                                if (isRent) {
                                  setState(() {
                                    isSell = !isSell;
                                    isRent = false;
                                  });
                                }
                                else {
                                  setState(() {
                                    isSell = !isSell;
                                  });
                                }
                              },
                              child: FilterOption(text: 'For sale', isSelected: isSell, ),
                            ),
                            InkWell(
                              overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                              highlightColor: Colors.white.withOpacity(0.0),
                              onTap: () {
                                if (isNotCash) {
                                  return;
                                }
                                if (isSell) {
                                  setState(() {
                                    isRent = !isRent;
                                    isSell = false;
                                  });
                                }
                                else {
                                  setState(() {
                                    isRent = !isRent;
                                  });
                                }
                              },
                              child: FilterOption(text: 'For rent', isSelected: isRent, ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    addVerticalSpace(padding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                            highlightColor: Colors.white.withOpacity(0.0),
                            onTap: () {
                              if (isNotCash) {
                                setState(() {
                                  isCash = !isCash;
                                  isNotCash = false;
                                });
                              }
                              else {
                                setState(() {
                                  isCash = !isCash;
                                });
                              }
                            },
                            child: FilterOption(text: 'Cash', isSelected: isCash, ),
                          ),
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                            highlightColor: Colors.white.withOpacity(0.0),
                            onTap: () {
                              if (isRent) {
                                return;
                              }
                              if (isCash) {
                                setState(() {
                                  isNotCash = !isNotCash;
                                  isCash = false;
                                });
                              }
                              else {
                                setState(() {
                                  isNotCash = !isNotCash;
                                });
                              }
                            },
                            child: FilterOption(text: 'Installments', isSelected: isNotCash, ),
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                            highlightColor: Colors.white.withOpacity(0.0),
                            onTap: () {
                              setState(() {
                                isFirstHouseType = !isFirstHouseType;
                                isSecondHouseType = false;
                                isThirdHouseType = false;
                              });
                            },
                            child: FilterOption(text: 'Separate', isSelected: isFirstHouseType, ),
                          ),
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                            highlightColor: Colors.white.withOpacity(0.0),
                            onTap: () {
                              setState(() {
                                isFirstHouseType = false;
                                isSecondHouseType = !isSecondHouseType;
                                isThirdHouseType = false;
                              });
                            },
                            child: FilterOption(text: 'Apartment', isSelected: isSecondHouseType, ),
                          ),
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                            highlightColor: Colors.white.withOpacity(0.0),
                            onTap: () {
                              setState(() {
                                isFirstHouseType = false;
                                isSecondHouseType = false;
                                isThirdHouseType = !isThirdHouseType;
                              });
                            },
                            child: FilterOption(text: 'Building', isSelected: isThirdHouseType, ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: isLandscape ? padding * 2 : padding * 6,
                        bottom: isLandscape ? padding : 0.0,
                      ),
                      child: TextButton(
                        child: Text('Done', textAlign: TextAlign.center,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          if (!isSell && !isRent && !isCash && !isNotCash && !isFirstHouseType && !isSecondHouseType && !isThirdHouseType) {
                            _updateHouses(infoWindowWidth, markerOffset);
                          }
                          else if (!isSell && !isRent) {
                            return showDialog(
                              context: context, builder: (context) => AlertDialog(backgroundColor: Colors.white,
                              content: Text('Please select sell or rent!', style: textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                              actions: [
                                TextButton(
                                  child: Text('Ok', style: TextStyle(color: Colors.green[700]),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),);
                          }
                          else if(!isCash && !isNotCash) {
                            return showDialog(
                              context: context, builder: (context) => AlertDialog(backgroundColor: Colors.white,
                              content: Text('Please select payment way!', style: textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                              actions: [
                                TextButton(
                                  child: Text('Ok', style: TextStyle(color: Colors.green[700]),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),);
                          }
                          else if(!isFirstHouseType && !isSecondHouseType && !isThirdHouseType) {
                            return showDialog(
                              context: context, builder: (context) => AlertDialog(backgroundColor: Colors.white,
                              content: Text('Please select house type!', style: textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                              actions: [
                                TextButton(
                                  child: Text('Ok', style: TextStyle(color: Colors.green[700]),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),);
                          }
                          else {
                            _updateHouses(infoWindowWidth, markerOffset);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
    );
  }


  _updateHouses(double infoWindowWidth, double markerOffset) {
    final housesProvider = Provider.of<Houses>(context, listen: false);
    if (!isSell && !isRent) {
      setState(() {
        housesProvider.filteredHousesMarkers = Set<Marker>();
        _filteredHouses = housesProvider.houses.toList();
        _filteredHouses.forEach((house) async {
          if (yellowMarker != null && greenMarker != null) {
            housesProvider.filteredHousesMarkers.add(
              Marker(
                  markerId: MarkerId(house.id),
                  position: house.location,
                  icon: house.isRent ? greenMarker : yellowMarker,
                  onTap: () {
                    housesProvider.updateInfoWindow(context, mapController,
                        house.location, infoWindowWidth, markerOffset
                    );
                    housesProvider.updateVisibleHouse(house);
                    housesProvider.updateVisibility(true);
                    housesProvider.rebuildInfoWindow();
                  }),
            );
          }
        });
      });
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    else if (isSell) {
      setState(() {
        housesProvider.filteredHousesMarkers = Set<Marker>();
        _filteredHouses = housesProvider.houses.where((house) =>
        !house.isRent && (isCash ? house.paymentMethod == 'Cash' || house.paymentMethod == 'Cash/Installments' : house.paymentMethod == 'Installments' || house.paymentMethod == 'Cash/Installments')
            && (isFirstHouseType ? house.houseType == 'Separate' : isSecondHouseType ? house.houseType == 'Apartment' : house.houseType == 'Building')).toList();
        _filteredHouses.forEach((house) async {
          if (yellowMarker != null && greenMarker != null) {
            housesProvider.filteredHousesMarkers.add(
              Marker(
                  markerId: MarkerId(house.id),
                  position: house.location,
                  icon: house.isRent ? greenMarker : yellowMarker,
                  onTap: () {
                    housesProvider.updateInfoWindow(context, mapController,
                        house.location, infoWindowWidth, markerOffset
                    );
                    housesProvider.updateVisibleHouse(house);
                    housesProvider.updateVisibility(true);
                    housesProvider.rebuildInfoWindow();
                  }),
            );
          }
        });
      });

      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    else if (isRent) {
      setState(() {
        housesProvider.filteredHousesMarkers = Set<Marker>();
        _filteredHouses = housesProvider.houses.where((house) => house.isRent && (isFirstHouseType ? house.houseType == 'Separate' : isSecondHouseType ? house.houseType == 'Apartment' :
        house.houseType == 'Building')).toList();
        _filteredHouses.forEach((house) async {
          if (yellowMarker != null && greenMarker != null) {
            housesProvider.filteredHousesMarkers.add(
              Marker(
                  markerId: MarkerId(house.id),
                  position: house.location,
                  icon: house.isRent ? greenMarker : yellowMarker,
                  onTap: () {
                    housesProvider.updateInfoWindow(context, mapController,
                        house.location, infoWindowWidth, markerOffset
                    );
                    housesProvider.updateVisibleHouse(house);
                    housesProvider.updateVisibility(true);
                    housesProvider.rebuildInfoWindow();
                  }),
            );
          }
        });
      });

      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    else {
      // housesProvider.updateVisibility(false);
      setState(() {
        _noFilteredFound = true;
        filteredFound = false;
      });

    }
  }



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getMapType();
      yellowMarker = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(72, 72)), 'images/yellowHouseIcon.png');

      greenMarker = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(72, 72)), 'images/greenHouseIcon.png');

    });
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;








  @override
  Widget build(BuildContext context) {


    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double _infoWindowWidth = isLandscape ? screenSize.height * 0.72 : screenSize.width * 0.72;
    final double _markerOffset = size * 6.81;
    final locationProvider = Provider.of<LocationProvider>(context);
    final houseProvider = Provider.of<Houses>(context);
    final authProvider = Provider.of<Auth>(context);


      houseProvider.houses.forEach((house) async {
        if (yellowMarker != null && greenMarker != null) {
          houseProvider.markers.add(
            Marker(
                markerId: MarkerId(house.id),
                position: house.location,
                icon: house.isRent ? greenMarker : yellowMarker,
                onTap: () {
                  houseProvider.updateInfoWindow(context, mapController,
                      house.location, _infoWindowWidth, _markerOffset
                  );
                  houseProvider.updateVisibleHouse(house);
                  houseProvider.updateVisibility(true);
                  houseProvider.rebuildInfoWindow();
                }),
          );
        }
      });

    // SystemChrome.setEnabledSystemUIOverlays([]);
    return (locationProvider.currentLocation == null)
        ?
     Container(
     color: Colors.white,
     child: Center(
       child: CircularProgressIndicator(
         backgroundColor: greenColor,
         valueColor: AlwaysStoppedAnimation<Color>(purpleColor),
       ),
     ),
     )
        :
        WillPopScope(
          onWillPop: () {
            houseProvider.updateVisibility(false);
            Navigator.of(context).pop();
            return;
          },
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                backgroundColor: greenColor,
                valueColor: AlwaysStoppedAnimation<Color>(purpleColor),
              ),
              ) : Container(
                child: Consumer<Houses>(
                  builder: (context, model, child) {
                    return Stack(
                      children: [
                        child,
                        _noFilteredFound ? Positioned(
                          left: isLandscape ? screenSize.width * 0.3 : screenSize.width * 0.1,
                          top: isLandscape ? screenSize.height * 0.4 : screenSize.height * 0.5,
                          child: Text('لا توجد عقارات متطابقة قم بتغيير شروط الفلترة او الغائها', style: TextStyle(color: _currentMapType == MapType.hybrid ? Colors.white : purpleColor, fontWeight: FontWeight.bold),),
                        ) : SizedBox(),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Visibility(
                            visible: houseProvider.showInfoWindow,
                            child: (houseProvider.house == null ||
                                !houseProvider.showInfoWindow)
                                ? Container()
                                :
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: houseProvider.leftMargin,
                                  top: houseProvider.topMargin,
                                ),
                                child: Column(
                                  children: [
                                    InfoWindowHouseCard(
                                      houseId: houseProvider.house.id,
                                      price: houseProvider.house.price,
                                      ownerName: authProvider.userName,
                                      ownerPhNumber: houseProvider.house.phNumber,
                                      ownerEmail: authProvider.userEmail,
                                      images: houseProvider.house.images == null ? [] : houseProvider.house.images,
                                      city: houseProvider.house.city,
                                      firstAddress: houseProvider.house.firstAddress,
                                      houseArea: houseProvider.house.houseArea,
                                      landArea: houseProvider.house.landArea,
                                      bedRoomsNumber: houseProvider.house.bedRoomsNumber,
                                      bathsNumber: houseProvider.house.bathsNumber,
                                      floorsNumber: houseProvider.house.floorsNumber,
                                      floor: houseProvider.house.floor,
                                      houseCondition: houseProvider.house.houseCondition,
                                      houseAge: houseProvider.house.houseAge,
                                      houseType: houseProvider.house.houseType,
                                      shareDate: houseProvider.house.shareDate,
                                      description: houseProvider.house.description,
                                      isRent: houseProvider.house.isRent,
                                      paymentMethod: houseProvider.house.paymentMethod,
                                      balcony: houseProvider.house.balcony,
                                      garden: houseProvider.house.garden,
                                      garage: houseProvider.house.garage,
                                      elevator: houseProvider.house.elevator,
                                      nearServices: houseProvider.house.nearServices,
                                      mainStreet: houseProvider.house.mainStreet,
                                      maidRoom: houseProvider.house.maidRoom,
                                      guardRoom: houseProvider.house.guardRoom,
                                      laundryRoom: houseProvider.house.laundryRoom,
                                      swimmingBool: houseProvider.house.swimmingBool,
                                      equippedKitchen: houseProvider.house.equippedKitchen,
                                      centralHeating: houseProvider.house.centralHeating,
                                      wareHouse: houseProvider.house.wareHouse,
                                      doubleGlazing: houseProvider.house.doubleGlazing,
                                      shutters: houseProvider.house.shutters,
                                      isFavorite: houseProvider.house.isFavorite,
                                      leftMargin: houseProvider.leftMargin,
                                      topMargin: houseProvider.topMargin,
                                    ),
                                    Triangle.isosceles(
                                      edge: Edge.BOTTOM,
                                      child: Container(
                                        color: purpleColor,
                                        width: 20.0,
                                        height: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // top: isLandscape ? screenSize.width * 0.012 : screenSize.height * 0.012,
                          // left: isLandscape ? screenSize.height * 0.03 : screenSize.width * 0.03,
                          bottom: isLandscape ? screenSize.width * 0.12 : screenSize.height * 0.09,
                          left: isLandscape ? screenSize.height * 0.03 : screenSize.width * 0.03,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.transparent.withOpacity(0.4),
                                    spreadRadius: 0.1,
                                    blurRadius: 15,
                                    offset: Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(1.5)
                            ),
                            width: size + 18.0,
                            height: size + 18.0,
                            child: IconButton(
                              icon: Icon(LineAwesomeIcons.map, color: Colors.black.withOpacity(0.5),),
                              iconSize: size + 2,
                              onPressed: _onMapTypeButtonPressed
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: isLandscape ? screenSize.width * 0.052 : screenSize.height * 0.062,
                        //   left: isLandscape ? screenSize.height * 0.03 : screenSize.width * 0.03,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white.withOpacity(0.7),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.transparent.withOpacity(0.4),
                        //             spreadRadius: 0.1,
                        //             blurRadius: 15,
                        //             offset: Offset(0, 4), // changes position of shadow
                        //           ),
                        //         ],
                        //         borderRadius: BorderRadius.circular(1.5)
                        //     ),
                        //     width: size + 18.0,
                        //     height: size + 18.0,
                        //     child: IconButton(
                        //       icon: Icon(Icons.settings, color: Colors.black.withOpacity(0.5),),
                        //       iconSize: size + 2,
                        //       onPressed: _onSettingsButtonPressed,
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                          // bottom: isLandscape ? screenSize.width * 0.12 : screenSize.height * 0.12,
                          // left: isLandscape ? screenSize.height * 0.03 : screenSize.width * 0.03,
                          bottom: isLandscape ? screenSize.width * 0.040 : screenSize.height * 0.040,
                          left: isLandscape ? screenSize.height * 0.03 : screenSize.width * 0.03,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.transparent.withOpacity(0.4),
                                    spreadRadius: 0.1,
                                    blurRadius: 15,
                                    offset: Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(1.5)
                            ),
                            width: size + 18.0,
                            height: size + 18.0,
                            child: IconButton(
                              icon: Icon(Icons.format_list_bulleted, color: Colors.black.withOpacity(0.5),),
                              iconSize: size + 2,
                              onPressed: () {
                                _showModalBottomSheet(context, _infoWindowWidth, _markerOffset);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Positioned(
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      onTap: (position) {
                        if (houseProvider.showInfoWindow) {
                          houseProvider.updateVisibility(false);
                          houseProvider.rebuildInfoWindow();
                        }
                      },
                      // ignore: unrelated_type_equality_checks
                      mapType: _currentMapType == null ? MapType.hybrid : _currentMapType,
                      markers: _filteredHouses == null ? houseProvider.markers : houseProvider.filteredHousesMarkers,
                      onCameraMove: (position) {
                        if (houseProvider.house != null) {
                          houseProvider.updateInfoWindow(context, mapController, houseProvider.house.location, _infoWindowWidth, _markerOffset);
                          houseProvider.rebuildInfoWindow();
                        }
                      },
                      myLocationEnabled: true,
                      initialCameraPosition: widget.hasLocation ?
                      CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 17.0,
                      )
                          :
                      CameraPosition(
                        target: LatLng(locationProvider.currentLocation.latitude, locationProvider.currentLocation.longitude),
                        zoom: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
