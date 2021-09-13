import 'package:bluesky_project/custom/OptionButton.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'package:bluesky_project/screens/addHouseScreen.dart';
import 'package:bluesky_project/screens/favoritesScreen.dart';
import 'package:bluesky_project/screens/profileScreen.dart';
import 'package:bluesky_project/screens/settingsScreen.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/custom_functions.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'houseDetailsScreen.dart';
import 'housesListScreen.dart';
import 'loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mapScreen.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum _SelectedTab { home, favorite, settings, profile }

class _HomeScreenState extends State<HomeScreen> {



  bool isFavorite = false;
  House _selectedHouse;
  List<House> _filteredHouses;

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





  bool isSell = false;
  bool isRent = false;
  bool isCash = false;
  bool isNotCash = false;
  bool isFirstHouseType = false;
  bool isSecondHouseType = false;
  bool isThirdHouseType = false;
  bool filtered = false;


  _showModalBottomSheet(context) {


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
              color: Colors.white,
              height: screenSize.height * 0.5,
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
                                _updateHouses();
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
                            _updateHouses();
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
                            _updateHouses();
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

  _updateHouses() {
    final housesProvider = Provider.of<Houses>(context, listen: false);
    if (!isSell && !isRent) {
      setState(() {
        _filteredHouses = housesProvider.houses.toList();
      });
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    if (isSell) {
      setState(() {
        _filteredHouses = housesProvider.houses.where((house) => !house.isRent &&
            (isCash ? house.paymentMethod == 'Cash' || house.paymentMethod == 'Cash/Installments' : house.paymentMethod == 'Installments' || house.paymentMethod == 'Cash/Installments')
            && (isFirstHouseType ? house.houseType == 'Separate' : isSecondHouseType ? house.houseType == 'Apartment' : house.houseType == 'Building')).toList();
      });
      if (_filteredHouses.isEmpty) {
        print('lololollleeeeesh');
      }
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    if (isRent) {
      setState(() {
        _filteredHouses = housesProvider.houses.where((house) => house.isRent && (isFirstHouseType ? house.houseType == 'Separate' : isSecondHouseType ? house.houseType == 'Apartment' : house.houseType == 'Building')).toList();
      });
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
  }


  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    print('issssss Visitooooorrrr?');
    print(isVisitor);
    final userProvider = Provider.of<Auth>(context);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      if (isVisitor == false) {
        await Provider.of<Houses>(context).fetchAndSetHouses().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      else {
        await Provider.of<Houses>(context).fetchAndSetHousesForVisitor().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    myFuture = userProvider.getProfileImage();
    _isInit = false;
    userProvider.getProfileImage();
    super.didChangeDependencies();
  }


  String profileImageUrl;
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    // final userProvider = Provider.of<Auth>(context, listen: false);
    if ((i == 1 || i == 3) && isVisitor) {
      _showVisitorAlert();
    }
    else {
      setState(() {
        _selectedTab = _SelectedTab.values[i];
      });
    }

    // print('hhhhhhhooooooooohoooooohoooooooo');
    // print(_selectedTab);
  }

  var currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Click again to exit',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 12.0,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }


  Future myFuture;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final housesProvider = Provider.of<Houses>(context);
    final userProvider = Provider.of<Auth>(context, listen: false);
    // print('visitoooor valuuuueeeee:');
    // print(userProvider.isVisitor);



    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(0xfff6f6f6),
          appBar: AppBar(
            centerTitle: true,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(50)),
            // ),
            backgroundColor: Colors.white,
            title: Text(_selectedTab == _SelectedTab.favorite ? 'Favorite' : _selectedTab == _SelectedTab.settings ? 'Settings' : _selectedTab == _SelectedTab.profile ? 'Profile' : 'Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            leading: Padding(
              padding: EdgeInsets.all(padding / 2),
              child: FutureBuilder(
                future: myFuture,
                builder: (context, snapshot) => ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: Container(
                    // width: isLandscape ? 40 : size,
                    // height: isLandscape ? 40 : size,
                    child: isVisitor
                        ?
                    Image.asset('images/user image.png', fit: BoxFit.cover,)
                        :
                    userProvider.profileImageUrl == null
                        ?
                    Image.asset('images/user image.png', fit: BoxFit.cover,)
                        :
                    snapshot.connectionState == ConnectionState.waiting
                        ?
                    Container(child: CircularProgressIndicator(
                      backgroundColor: Colors.green[700],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                        :
                    FadeInImage(
                      placeholder: AssetImage('images/empty.png',),
                      fit: BoxFit.cover,
                      image: NetworkImage(userProvider.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_box_outlined, color: Colors.green,),
                    splashColor: Colors.green.withOpacity(0.0),
                    highlightColor: Colors.green.withOpacity(0.0),
                    padding: EdgeInsets.only(left: padding),
                    // iconSize: size * 1.5,
                    onPressed: () {
                      if (isVisitor) {
                        _showVisitorAlert();
                      }
                      else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddHouseScreen()));
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.format_list_bulleted, color: Colors.green),
                    splashColor: Colors.green.withOpacity(0.0),
                    highlightColor: Colors.green.withOpacity(0.0),
                    // iconSize: size * 1.5,
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                  ),
                ],
              ),
            ],
          ),
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: _SelectedTab.values.indexOf(_selectedTab),
              showElevation: true,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: _handleIndexChanged,
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.house_outlined),
                  title: Text('Home'),
                  activeColor: Colors.green[700],
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.favorite_border),
                  title: Text('Favorite'),
                  activeColor: Colors.green[700],
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings',),
                  activeColor: Colors.green[700],
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  activeColor: Colors.green[700],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            body: _selectedTab == _SelectedTab.favorite ? FavoritesScreen() : _selectedTab == _SelectedTab.settings ? SettingsScreen() : _selectedTab == _SelectedTab.profile ? ProfileScreen() : Container(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(padding),
                      _isLoading
                          ?
                      Center(child: CircularProgressIndicator(
                        backgroundColor: Colors.green[700],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),)
                          :
                      _filteredHouses == null
                          ?
                      Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: housesProvider.houses.length == 0 ? Center(
                            child: Text('No properties advertised!', textAlign: TextAlign.center, style: TEXT_THEME_DEFAULT.headline3.copyWith(
                              color: Colors.green[700],
                              fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018,
                              fontWeight: FontWeight.bold,
                            ),),
                          ) : GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isLandscape ? 2 : 1,
                                crossAxisSpacing: padding,
                                mainAxisSpacing: padding * 1.5,
                                childAspectRatio: 1.4,
                              ),
                              padding: EdgeInsets.only(bottom: padding * 4),
                              physics: BouncingScrollPhysics(),
                              itemCount: housesProvider.houses.length,
                              itemBuilder: (context, index) {
                                return buildHouses(housesProvider.houses[index], context,);
                              }),
                        ),
                      )
                          :
                      Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: _filteredHouses.length == 0 ? Center(
                            child: Text('No matching results!', textAlign: TextAlign.center, style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),),
                          ) : GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isLandscape ? 2 : 1,
                                crossAxisSpacing: padding,
                                mainAxisSpacing: padding * 1.5,
                                childAspectRatio: 1.4,
                              ),
                              padding: EdgeInsets.only(bottom: padding * 4),
                              physics: BouncingScrollPhysics(),
                              itemCount: _filteredHouses.length,
                              itemBuilder: (context, index) {
                                return buildHouses(_filteredHouses[index], context,);
                              }),
                        ),
                      ),
                      // addVerticalSpace(60),
                    ],
                  ),
                  Positioned(
                    bottom: padding,
                    width: screenSize.width,
                    child: Center(
                      child: OptionButton(
                        text: "Map View",
                        icon: Icons.map_outlined,
                        width: padding * 10,
                        size: size,
                        color: Colors.green[700],
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(hasLocation: false,)));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}


Widget buildHouses(House house, BuildContext context,) {

  final mediaQuery = MediaQuery.of(context);
  final isLandscape = (mediaQuery.orientation == Orientation.landscape);
  final Size screenSize = MediaQuery.of(context).size;
  final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
  final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;


  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Details(house.id)));
    },
    child: Card(
      margin: EdgeInsets.only(bottom: size),
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[700].withOpacity(0.5),
          image: DecorationImage(
            image: house.images == null ? AssetImage('images/noImage.jpg') : NetworkImage(house.images[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(padding * 1.2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size * 4.5,
                decoration: BoxDecoration(
                  color: Colors.green[700].withOpacity(0.8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 4,),
                child: Center(
                  child: Text(
                    house.isRent ? "FOR RENT" : "FOR SALE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        house.city,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(house.price),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: padding / 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: size * 0.7,
                          ),
                          SizedBox(
                            width: padding / 4,
                          ),
                          Text(
                            house.firstAddress,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.7,
                            ),
                          ),
                          SizedBox(
                            width: padding / 2,
                          ),
                          Icon(
                            Icons.house_outlined,
                            color: Colors.white,
                            size: size * 0.7,
                          ),
                          SizedBox(
                            width: padding / 4,
                          ),
                          Text(
                            house.houseArea.toString() + " m²",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.7,
                            ),
                          ),
                          SizedBox(
                            width: padding / 2,
                          ),
                          Icon(
                            Icons.house_outlined,
                            color: Colors.white,
                            size: size * 0.7,
                          ),
                          SizedBox(
                            width: padding / 4,
                          ),
                          Text(
                            house.houseType,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.7,
                            ),
                          ),
                          SizedBox(
                            width: padding / 2,
                          ),
                          // if(!housesProvider.houses[index].isRent) Icon(
                          //   Icons.monetization_on_outlined,
                          //   color: Colors.white,
                          //   size: 14,
                          // ),
                          // if(!housesProvider.houses[index].isRent) SizedBox(
                          //   width: 4,
                          // ),
                          // if(!housesProvider.houses[index].isRent) Text(
                          //   housesProvider.houses[index].paymentMethod.length > 12 ? 'Cash or Inst...' : housesProvider.houses[index].paymentMethod,
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.star,
                      //       color: Colors.yellow[700],
                      //       size: 14,
                      //     ),
                      //     SizedBox(
                      //       width: 4,
                      //     ),
                      //     // Text(
                      //     //   property.review + " Reviews",
                      //     //   style: TextStyle(
                      //     //     color: Colors.white,
                      //     //     fontSize: 14,
                      //     //   ),
                      //     // ),
                      //
                      //   ],
                      // ),

                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    ),
  );
}


