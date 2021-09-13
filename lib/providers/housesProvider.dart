import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:http/http.dart' as http;


class Houses with ChangeNotifier {


  final String authToken;
  final String userId;
  Houses(this.authToken, this.userId, this._housesList);

  List<House> _housesList = [];
  House _house;
  bool _showInfoWindow = false;
  bool _tempHidden = false;
  double _leftMargin;
  double _topMargin;



  // var _showFavoritesOnly = false;

  List<House> get houses {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._housesList];
  }


  // List<Product> get favoriteItems {
  //   return _housesList.where((prodItem) => prodItem.isFavorite).toList();
  // }

  List<House> get favoriteHouses {
    return _housesList.where((house) => house.isFavorite).toList();
  }

  House findById(String id) {
    return _housesList.firstWhere((house) => house.id == id);
  }

  // List<House> userHouses;
  List<House> get userHouses {
    return _housesList.where((house) => house.ownerId == userId).toList();
  }

  List<House> get forSaleHouses {
    return _housesList.where((house) => !house.isRent).toList();
  }

  Set<Marker> markers = Set<Marker>();
  Set<Marker> filteredHousesMarkers = Set<Marker>();

  removeMarker(String id) {
    markers.removeWhere((house) => house.markerId == MarkerId(id));
    notifyListeners();
  }


  // changeFavorite(String id) {
  //   House tar = _housesList.firstWhere((element) => element.id == id);
  //   tar.isFavorite = !tar.isFavorite;
  //   notifyListeners();
  // }

  // List<String> imagesPaths = ['images/house 4.jpg', 'images/house 2.jpg', 'images/house 3.jpg', 'images/house 1.jpg',];
  String markerId = 'firstHouse';
  String imagesFileName;



  Future<void> fetchAndSetHouses([bool filterByUser = false]) async {
    // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/houses.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      print('respoooooooooooooooonse issssssssss');
      print(favoriteData);
      final List<House> loadedHouses = [];
      extractedData.forEach((houseId, houseData) {
        houseId == null ? markerId = 'firstHouse' : markerId = houseId;
        print('markerrrrrrrrrrrrrrrrrrr id isssssssssss');
        print(houseId);
        loadedHouses.add(House(
          id: houseId,
          ownerId: houseData['ownerId'],
          price: houseData['price'],
          location: LatLng(houseData['latitude'], houseData['longitude']),
          ownerName: houseData['ownerName'],
          phNumber: houseData['phNumber'],
          email: houseData['email'],
          images: houseData['imagesPaths'],
          city: houseData['city'],
          firstAddress: houseData['firstAddress'],
          houseArea: houseData['houseArea'],
          landArea: houseData['landArea'],
          bedRoomsNumber: houseData['bedRoomsNumber'],
          bathsNumber: houseData['bathsNumber'],
          floorsNumber: houseData['floorsNumber'].toString(),
          floor: houseData['floorNumber'],
          houseCondition: houseData['houseCondition'],
          houseAge: houseData['houseAge'],
          houseType: houseData['houseType'],
          parkingsNumber: houseData['parkingsNumber'].toString(),
          shareDate: houseData['shareDate'].toString(),
          description: houseData['description'],
          isRent: houseData['isRent'],
          paymentMethod: houseData['paymentMethod'],
          balcony: houseData['balcony'],
          garden: houseData['garden'],
          garage: houseData['garage'],
          elevator: houseData['elevator'],
          nearServices: houseData['nearServices'],
          mainStreet: houseData['mainStreet'],
          maidRoom: houseData['maidRoom'],
          guardRoom: houseData['guardRoom'],
          laundryRoom: houseData['laundryRoom'],
          swimmingBool: houseData['swimmingBool'],
          equippedKitchen: houseData['equippedKitchen'],
          centralHeating: houseData['centralHeating'],
          wareHouse: houseData['wareHouse'],
          doubleGlazing: houseData['doubleGlazing'],
          shutters: houseData['shutters'],
          isFavorite: favoriteData == null ? false : favoriteData[houseId] ?? false,
          // favoriteData[houseData[id]] == null ? false : true
        ));
      });
      _housesList = loadedHouses;
      print('hooooooooooouuuuuuuuuuse');
      print(_housesList[0]);
      // int listLength = _housesList.length;
      // marker = int.parse(_housesList[listLength - 1].id);
      notifyListeners();
      // print(json.decode(response.body));
    }
    catch (error) {
      print('errooorrr');
      throw(error);
    }
  }


  Future<void> fetchAndSetHousesForVisitor([bool filterByUser = false]) async {
    print('houuuuuusesssssss for visitttttoooooooorrr');
    // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/houses.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/userFavorites/$userId.json';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      print('respoooooooooooooooonse issssssssss');
      print(favoriteData);
      final List<House> loadedHouses = [];
      extractedData.forEach((houseId, houseData) {
        print('prdddddddddddddddddddddddddd id isssssssssss');
        print(houseId);
        loadedHouses.add(House(
          id: houseId,
          ownerId: houseData['ownerId'],
          price: houseData['price'],
          location: LatLng(houseData['latitude'], houseData['longitude']),
          ownerName: houseData['ownerName'],
          phNumber: houseData['phNumber'],
          email: houseData['email'],
          images: houseData['imagesPaths'],
          // images: [houseData['imagesPaths'][0], houseData['imagesPaths'][1], houseData['imagesPaths'][2], houseData['imagesPaths'][3], houseData['imagesPaths'][4] ,houseData['imagesPaths'][5], houseData['imagesPaths'][6],
          //   houseData['imagesPaths'][7], houseData['imagesPaths'][8], houseData['imagesPaths'][9]],
          city: houseData['city'],
          firstAddress: houseData['firstAddress'],
          houseArea: houseData['houseArea'],
          landArea: houseData['landArea'],
          bedRoomsNumber: houseData['bedRoomsNumber'],
          bathsNumber: houseData['bathsNumber'],
          floorsNumber: houseData['floorsNumber'].toString(),
          floor: houseData['floorNumber'],
          houseCondition: houseData['houseCondition'],
          houseAge: houseData['houseAge'],
          houseType: houseData['houseType'],
          parkingsNumber: houseData['parkingsNumber'].toString(),
          shareDate: houseData['shareDate'].toString(),
          description: houseData['description'],
          isRent: houseData['isRent'],
          paymentMethod: houseData['paymentMethod'],
          balcony: houseData['balcony'],
          garden: houseData['garden'],
          garage: houseData['garage'],
          elevator: houseData['elevator'],
          nearServices: houseData['nearServices'],
          mainStreet: houseData['mainStreet'],
          maidRoom: houseData['maidRoom'],
          guardRoom: houseData['guardRoom'],
          laundryRoom: houseData['laundryRoom'],
          swimmingBool: houseData['swimmingBool'],
          equippedKitchen: houseData['equippedKitchen'],
          centralHeating: houseData['centralHeating'],
          wareHouse: houseData['wareHouse'],
          doubleGlazing: houseData['doubleGlazing'],
          shutters: houseData['shutters'],
          isFavorite: false,
          // favoriteData[houseData[id]] == null ? false : true
        ));
      });
      _housesList = loadedHouses;
      print('hooooooooooouuuuuuuuuuse');
      print(_housesList[0]);
      // int listLength = _housesList.length;
      // marker = int.parse(_housesList[listLength - 1].id);
      notifyListeners();
      // print(json.decode(response.body));
    }
    catch (error) {
      print('errooorrr');
      throw(error);
    }
  }




  Future<void> addHouse(int price, LatLng location, String ownerName, String phNumber, String email, List<dynamic> images, String city, String firstAddress, int houseArea, int landArea, String bedRoomsNumber,
      String bathsNumber, String floorsNumber, int floor,
      String houseCondition, String houseAge, String houseType, String parkingsNumber, String shareDate,  String description, bool isRent, String paymentMethod, bool balcony, bool garden, bool garage, bool elevator, bool nearServices,
      bool mainStreet, bool maidRoom, bool guardRoom, bool laundryRoom, bool swimmingBool, bool equippedKitchen, bool centralHeating, bool wareHouse, bool doubleGlazing, bool shutters) async {
    final url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/houses.json?auth=$authToken';
      // markerId++;
    markerId = markerId + '1';
    try {
      final response =  await http.post(Uri.parse(url),
        body: json.encode({
          // 'id': markerId,
          'ownerId': userId,
          'price': price,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'ownerName': ownerName,
          'phNumber': phNumber,
          'email': email,
          'imagesPaths': images,
          // 'imagesPaths': ['images/house 4.jpg', 'images/house 2.jpg', 'images/house 3.jpg', 'images/house 1.jpg',],
          'city': city,
          'firstAddress': firstAddress,
          'houseArea': houseArea,
          'landArea': landArea,
          'bedRoomsNumber': bedRoomsNumber,
          'bathsNumber': bathsNumber,
          'floorsNumber': floorsNumber,
          'floorNumber': floor,
          'houseCondition': houseCondition,
          'houseAge': houseAge,
          'houseType': houseType,
          'parkingsNumber': parkingsNumber,
          'shareDate': shareDate,
          'description': description,
          'isRent': isRent,
          'paymentMethod': paymentMethod,
          'balcony': balcony,
          'garden': garden,
          'garage': garage, 'elevator': elevator, 'nearServices': nearServices, 'mainStreet': mainStreet,
          'maidRoom': maidRoom, 'guardRoom': guardRoom, 'laundryRoom': laundryRoom, 'swimmingBool': swimmingBool,
          'equippedKitchen': equippedKitchen, 'centralHeating': centralHeating, 'wareHouse': wareHouse, 'doubleGlazing': doubleGlazing, 'shutters': shutters,
        }),);
      final newHouse = House(
        id: json.decode(response.body)['name'],
        ownerId: userId,
        price: price,
        location: location,
        ownerName: ownerName,
        phNumber: phNumber,
        email: email,
        images: images,
        city: city,
        firstAddress: firstAddress,
        houseArea: houseArea,
        landArea: landArea, bedRoomsNumber: bedRoomsNumber, bathsNumber: bathsNumber, floorsNumber: floorsNumber, floor: floor, houseCondition: houseCondition, houseAge: houseAge, houseType: houseType,
        parkingsNumber: parkingsNumber,
        shareDate: shareDate,
        description: description, isRent: isRent, paymentMethod: paymentMethod, balcony: balcony, garden: garden, garage: garage, elevator: elevator, nearServices: nearServices,
        mainStreet: mainStreet, maidRoom: maidRoom, guardRoom: guardRoom, laundryRoom: laundryRoom, swimmingBool: swimmingBool, equippedKitchen: equippedKitchen, centralHeating: centralHeating,
        wareHouse: wareHouse, doubleGlazing: doubleGlazing, shutters: shutters,
      );
      _housesList.add(newHouse);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    }
    catch (error) {
      print(error);
      throw error;
    }
  }


  // Future<void> updateHouse(String id, House updatedHouse) async {
  //   final houseIndex = _housesList.indexWhere((house) => house.id == id);
  //   if (houseIndex >= 0){
  //     final url = 'https://shop-app-cd24c-default-rtdb.firebaseio.com/houses/$id.json?auth=$authToken';
  //     await http.patch(Uri.parse(url), body: json.encode({
  //       // 'title': updatedHouse.title,
  //       // 'description': updatedHouse.description,
  //       // 'price': updatedHouse.price,
  //       // 'imageUrl': updatedHouse.imageUrl,
  //     }));
  //     _housesList[houseIndex] = updatedHouse;
  //     notifyListeners();
  //   }
  //   else {
  //     print('errorrrrrrrrrr');
  //   }
  // }

  Future<void> deleteHouse(String id) async {
    final url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/houses/$id.json?auth=$authToken';
    final existingHouseIndex = _housesList.indexWhere((house) =>
    house.id == id);
    var existingHouse = _housesList[existingHouseIndex];
    _housesList.removeAt(existingHouseIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _housesList.insert(existingHouseIndex, existingHouse);
      notifyListeners();
      throw HttpException('لم يتم حذف البيت');
    }
    existingHouse = null;
  }

  Future<void> deleteFromFavorites(String id) async {
    // final dbRef = FirebaseDatabase.instance.reference();
    // dbRef.child('userFavorites').update({id: null});
    final url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final response = await http.delete(Uri.parse(url)).whenComplete(() => print('deleeeeeeeeeeted from faaaaaavooooorites'));
    if (response.statusCode >= 400) {
      // _housesList.insert(existingHouseIndex, existingHouse);
      // notifyListeners();
      throw HttpException('لم يتم حذف البيت من المفضلة');
    }
    notifyListeners();
    // existingHouse = null;
  }


  void rebuildInfoWindow() {
    notifyListeners();
  }

  void updateVisibleHouse(House house) {
    _house = house;
  }

  void updateVisibility(bool visibility) {
    _showInfoWindow = visibility;

  }

  void updateInfoWindow(BuildContext context, GoogleMapController controller, LatLng location, double infoWindowWidth, double markerOffset) async {
    ScreenCoordinate screenCoordinate = await controller.getScreenCoordinate(location);

    double devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;

    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) - (infoWindowWidth / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) - markerOffset;


    if (left < 0.0 || top < 0.0) {
      _tempHidden = true;
    }
    else {
      _tempHidden = false;
      _leftMargin = left;
      _topMargin = top;
    }
  }


  bool get showInfoWindow => (_showInfoWindow == true && _tempHidden == false) ? true : false;

  double get leftMargin => _leftMargin;

  double get topMargin => _topMargin;

  House get house => _house;

// void addHouse(House house) {
//   housesList.add(house);
//   notifyListeners();
// }





}

