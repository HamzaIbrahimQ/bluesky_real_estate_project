import 'dart:io';
import 'package:bluesky_project/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluesky_project/models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Auth with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String userName;
  String userEmail;
  String profileImageUrl;
  bool isVisitor = false;



  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }


  Future<bool> setFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('fRun', false);
    notifyListeners();
  }





  visitor(bool value) async {
    isVisitor = value;
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // isVisitor = prefs.getBool('visitor');
    prefs.setBool('visitor', isVisitor);
    print('visiiiiitoooooorrrrrrrrr');
    print(isVisitor);

   }





  Future<void> _authenticate(String email, String password, String name, String urlSegment, BuildContext context) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAC-h9eUtV_xMKMSF08z1neviEOJfGopGI';
    try {
      final response = await http.post(Uri.parse(url), body:
      json.encode({
        'email': email,
        'password': password,
        'displayName': userName,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),),);
      userName = responseData['displayName'];
      userEmail = responseData['email'];
      // _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
            'email': userEmail,
            'name': userName
          });

      prefs.setString('userData', userData);
      notifyListeners();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    catch (error) {
      throw (error);
    }

  }

  Future<void> signup (String email, String password, String name, String imageUrl, BuildContext context) async {
    userName = name;
    return _authenticate(email, password, name, 'signUp', context);
  }

  Future<void> login (String email, String password, String name, String imageUrl, BuildContext context) async {
    name = userName;
    return _authenticate(email, password, name, 'signInWithPassword', context);
  }


  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: 86400), logout);
  //   profileImageUrl = null;
  // }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    userEmail = extractedUserData['email'];
    userName = extractedUserData['name'];
    _expiryDate = expiryDate;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //to clear 'userData
    // print('tooooooookennnnnnnnnnnnnnnnnnn isssssssss');
    // print(token);
    profileImageUrl = null;
  }

  Future<void> getProfileImage() async {
    await FirebaseStorage.instance
        .ref('users/$userEmail')
        .getDownloadURL().then((value){
          if (value != null) {
            profileImageUrl = value;
            print('gettttttttttttt urlllllllllllll:' + profileImageUrl);
          }
          else {
            profileImageUrl = '';
          }
        }).onError((error, stackTrace) => profileImageUrl = null);
    // notifyListeners();
  }

  Future<void> deleteProfileImage() async {
    await FirebaseStorage.instance
        .ref()
        .child("users/$userEmail").delete().whenComplete(() => profileImageUrl = null);
    notifyListeners();
  }



  final user = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async{
    String emailAddress = email;
    await user.sendPasswordResetEmail(email: emailAddress);
  }



}