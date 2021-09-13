import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';




class House with ChangeNotifier {

  final String id;
  final String ownerId;
  final int price;
  final LatLng location;
  final String ownerName;
  final String phNumber;
  final String email;
  final List<dynamic> images;
  final String city;
  final String firstAddress;
  final int houseArea;
  final int landArea;
  final String bedRoomsNumber;
  final String bathsNumber;
  final String floorsNumber;
  final int floor;
  final String houseCondition;
  final String houseAge;
  final String houseType;
  final String parkingsNumber;
  final String shareDate;
  final String description;
  final bool isRent;
  final String paymentMethod;
  final bool balcony;
  final bool garden;
  final bool garage;
  final bool elevator;
  final bool nearServices;
  final bool mainStreet;
  final bool maidRoom;
  final bool guardRoom;
  final bool laundryRoom;
  final bool swimmingBool;
  final bool equippedKitchen;
  final bool centralHeating;
  final bool wareHouse;
  final bool doubleGlazing;
  final bool shutters;
  bool isFavorite;

  House({
    this.id,
    this.ownerId,
    this.price,
    this.location,
    this.ownerName,
    this.phNumber,
    this.email,
    this.images,
    this.city,
    this.firstAddress,
    this.houseArea,
    this.landArea,
    this.bedRoomsNumber,
    this.bathsNumber,
    this.floorsNumber,
    this.floor,
    this.houseCondition,
    this.houseAge,
    this.houseType,
    this.parkingsNumber,
    this.shareDate,
    this.description,
    this.isRent,
    this.paymentMethod,
    this.balcony,
    this.garden,
    this.garage,
    this.elevator,
    this.nearServices,
    this.mainStreet,
    this.maidRoom,
    this.guardRoom,
    this.laundryRoom,
    this.swimmingBool,
    this.equippedKitchen,
    this.centralHeating,
    this.wareHouse,
    this.doubleGlazing,
    this.shutters,
    this.isFavorite = false,
  });




  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId, BuildContext context) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://bluesky-project-318113-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode(
            isFavorite,
          )
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    }
    catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }


}

// enum HouseType {
//   building,
//   apartment,
//   house,
// }
//
// enum HouseCondition {
//   notUsed,
//   used,
// }
//
// enum SellOrRent {
//   sell,
//   rent,
// }




