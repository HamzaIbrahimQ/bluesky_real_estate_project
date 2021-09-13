import 'package:bluesky_project/screens/houseDetailsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/custom_functions.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import '../main.dart';
import 'loginScreen.dart';


class HousesListScreen extends StatefulWidget {

  @override
  _HousesListScreenState createState() => _HousesListScreenState();
}

class _HousesListScreenState extends State<HousesListScreen> {

  _onHouseCardPressed(String houseId, String email) async {
    // await Provider.of<Auth>(context, listen: false).getOwnerImage(email);
    return DialogBackground(
      dismissable: true,
      blur: 5.0,
      dialog: Details(houseId),
      // dialog: HouseScreen(HouseData[1],),
      onDismiss: () {},
      // zoomScale: 5,
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

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
                        child: Text('عذرا يجب تسجيل الدخول اولا', style: TextStyle(color: Colors.white, fontSize: 16),)
                    ),
                    ElevatedButton(
                      child: Text('تسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(purpleColor),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5)),
                      ),
                      onPressed: () {
                        userProvider.visitor(false);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }



  bool isFavorite = false;
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
                            },
                              child: Text('الغاء الفلترة', style: TextStyle(color: Colors.red),),
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
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: EdgeInsets.only(top: isLandscape ? padding : padding * 2),
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
                            child: FilterOption(text: 'بيع', isSelected: isSell, ),
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
                            child: FilterOption(text: 'اجار', isSelected: isRent, ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(padding),
                  Directionality(
                    textDirection: TextDirection.rtl,
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
                          child: FilterOption(text: 'كاش', isSelected: isCash, ),
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
                          child: FilterOption(text: 'اقساط', isSelected: isNotCash, ),
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(padding),
                  Directionality(
                    textDirection: TextDirection.rtl,
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
                          child: FilterOption(text: 'بيت مستقل', isSelected: isFirstHouseType, ),
                        ),
                        InkWell(
                          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                          highlightColor: Colors.white.withOpacity(0.0),
                          onTap: () {
                            setState(() {
                              isSecondHouseType = !isSecondHouseType;
                              isFirstHouseType = false;
                              isThirdHouseType = false;
                            });
                          },
                          child: FilterOption(text: 'شقة', isSelected: isSecondHouseType, ),
                        ),
                        InkWell(
                          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                          highlightColor: Colors.white.withOpacity(0.0),
                          onTap: () {
                            setState(() {
                              isThirdHouseType = !isThirdHouseType;
                              isFirstHouseType = false;
                              isSecondHouseType = false;
                            });
                          },
                          child: FilterOption(text: 'بناية', isSelected: isThirdHouseType, ),
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
                      child: Text('تم', textAlign: TextAlign.center,),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(purpleColor),
                        foregroundColor: MaterialStateProperty.all(greenColor),
                      ),
                      onPressed: () {
                        if (!isSell && !isRent && !isCash && !isNotCash && !isFirstHouseType && !isSecondHouseType && !isThirdHouseType) {
                          _updateHouses();
                        }
                        else if (!isSell && !isRent) {
                          return showDialog(
                            context: context, builder: (context) => AlertDialog(backgroundColor: purpleColor,
                            content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text('الرجاء اختيار كافة المعلومات للفتلرة', style: textTheme.headline6.copyWith(color: Colors.white, fontSize: size / 1.6),)
                            ),
                            actions: [
                              TextButton(
                                child: Text('حسنا', style: TextStyle(color: greenColor),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),);
                        }
                        else if(!isCash && !isNotCash) {
                          return showDialog(
                            context: context, builder: (context) => AlertDialog(backgroundColor: purpleColor,
                            content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text('الرجاء اختيار كافة المعلومات للفتلرة', style: textTheme.headline6.copyWith(color: Colors.white, fontSize: size / 1.6),)
                            ),
                            actions: [
                              TextButton(
                                child: Text('حسنا', style: TextStyle(color: greenColor),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),);
                        }
                        else if(!isFirstHouseType && !isSecondHouseType && !isThirdHouseType) {
                          return showDialog(
                            context: context, builder: (context) => AlertDialog(backgroundColor: purpleColor,
                            content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text('الرجاء اختيار كافة المعلومات للفتلرة', style: textTheme.headline6.copyWith(color: Colors.white, fontSize: size / 1.6),)
                            ),
                            actions: [
                              TextButton(
                                child: Text('حسنا', style: TextStyle(color: greenColor),),
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
        _filteredHouses = housesProvider.houses.where((house) => !house.isRent && (isCash ? house.paymentMethod == 'كاش' : house.paymentMethod == 'اقساط' || house.paymentMethod == 'كاش/اقساط')
        && (isFirstHouseType ? house.houseType == 'بيت مستقل' : isSecondHouseType ? house.houseType == 'شقة' : house.houseType == 'بناية')).toList();
      });
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
    if (isRent) {
      setState(() {
        _filteredHouses = housesProvider.houses.where((house) => house.isRent && (isFirstHouseType ? house.houseType == 'بيت مستقل' : isSecondHouseType ? house.houseType == 'شقة' : house.houseType == 'بناية')).toList();
      });
      Navigator.of(context).pop();
      print('filllllllllterrrrrd housessssss');
      print(_filteredHouses);
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = screenSize.width * 0.04;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final TextTheme textTheme = TEXT_THEME_DEFAULT;
    final housesProvider = Provider.of<Houses>(context);
    final userProvider = Provider.of<Auth>(context, listen: false);


    return SafeArea(
      child: Scaffold(
          body: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(padding),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              Text(
                                'قائمة البيوت :',
                                style: textTheme.headline4.copyWith(color: Colors.black, fontSize: size),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Divider(
                            height: padding,
                            color: COLOR_GREY,
                          )),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding / 2),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextButton.icon(
                              icon: Icon(Icons.sort),
                              label: Text('فلترة'),
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(purpleColor),
                                overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
                              ),
                              onPressed: () {
                                _showModalBottomSheet(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(isLandscape ? padding / 3 : padding * 1.5),
                      _filteredHouses == null ? Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: housesProvider.houses.length == 0 ? Center(
                            child: Text('لا يوجد اي عقارات معلنة', textAlign: TextAlign.center, style: TEXT_THEME_DEFAULT.headline3.copyWith(color: purpleColor, fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),),
                          ) : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isLandscape ? 2 : 1,
                              crossAxisSpacing: padding,
                              mainAxisSpacing: isLandscape ? padding : padding * 1.5,),
                              physics: BouncingScrollPhysics(),
                              itemCount: housesProvider.houses.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _onHouseCardPressed(housesProvider.houses[index].id, housesProvider.houses[index].email);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(25.0),
                                              child: Container(
                                                width: screenSize.width,
                                                height: isLandscape ? screenSize.width / 3 : screenSize.height / 3,
                                                child: housesProvider.houses[index].images == null ? Image.asset('images/empty.png') : FadeInImage(
                                                  placeholder: AssetImage('images/empty.png'),
                                                  image: NetworkImage(housesProvider.houses[index].images[0],),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),),
                                          Positioned(
                                              top: 15,
                                              left: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                      housesProvider.houses[index].isFavorite ? Icons.favorite : Icons.favorite_border
                                                ),
                                                  iconSize: size * 1.5,
                                                  color: purpleColor,
                                                  onPressed: () {
                                                    if (isVisitor) {
                                                      _showVisitorAlert();
                                                    }
                                                    else {
                                                      findById(housesProvider.houses[index].id);
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
                                      addVerticalSpace(15),
                                      Directionality(
                                      textDirection: TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${formatCurrency(housesProvider.houses[index].price)}",
                                              style: textTheme.headline4.copyWith(color: Colors.black, fontSize: size * 1.3),
                                            ),
                                            addHorizontalSpace(padding),
                                            Text(
                                              "${housesProvider.houses[index].city} / ${housesProvider.houses[index].firstAddress} / ${housesProvider.houses[index].houseType} / "
                                                  "${housesProvider.houses[index].isRent ? 'للاجار' : 'للبيع'}",
                                              style: textTheme.headline4.copyWith(color: Colors.grey, fontSize: size * 0.5),
                                            )
                                          ],
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${housesProvider.houses[index].bedRoomsNumber} غرف نوم / ${housesProvider.houses[index].bathsNumber} حمامات / ${housesProvider.houses[index].houseArea} م²",
                                              style: textTheme.headline4.copyWith(color: Colors.black, fontSize: size * 0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )
                          :
                      Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: _filteredHouses.length == 0 ? Center(
                            child: Text('لا توجد عقارات مطابقة', textAlign: TextAlign.center, style: TEXT_THEME_DEFAULT.headline3.copyWith(color: purpleColor, fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),),
                          ) : GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isLandscape ? 2 : 1,
                                crossAxisSpacing: padding,
                                mainAxisSpacing: isLandscape ? padding : padding * 1.5,),
                              physics: BouncingScrollPhysics(),
                              itemCount: _filteredHouses.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _onHouseCardPressed(_filteredHouses[index].id, _filteredHouses[index].email);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(25.0),
                                            child: Container(
                                              width: screenSize.width,
                                              height: isLandscape ? screenSize.width / 3 : screenSize.height / 3,
                                              child: _filteredHouses[index].images == null ? Image.asset('images/empty.png') : FadeInImage(
                                                placeholder: AssetImage('images/empty.png'),
                                                image: NetworkImage(_filteredHouses[index].images[0],),
                                                fit: BoxFit.cover,
                                              ),
                                            ),),
                                          Positioned(
                                            top: 15,
                                            left: 15,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                    _filteredHouses[index].isFavorite ? Icons.favorite : Icons.favorite_border
                                                ),
                                                iconSize: size * 1.5,
                                                color: purpleColor,
                                                onPressed: () {
                                                  if (isVisitor) {
                                                    _showVisitorAlert();
                                                  }
                                                  else {
                                                    findById(_filteredHouses[index].id);
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
                                      addVerticalSpace(15),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${formatCurrency(_filteredHouses[index].price)}",
                                              style: textTheme.headline4.copyWith(color: Colors.black, fontSize: size * 1.3),
                                            ),
                                            addHorizontalSpace(padding),
                                            Text(
                                              "${_filteredHouses[index].city} / ${_filteredHouses[index].firstAddress} / ${_filteredHouses[index].houseType} / "
                                                  "${_filteredHouses[index].isRent ? 'للاجار' : 'للبيع'}",
                                              style: textTheme.headline4.copyWith(color: Colors.grey, fontSize: size * 0.5),
                                            )
                                          ],
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${_filteredHouses[index].bedRoomsNumber} غرف نوم / ${_filteredHouses[index].bathsNumber} حمامات / ${_filteredHouses[index].houseArea} م²",
                                              style: textTheme.headline4.copyWith(color: Colors.black, fontSize: size * 0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}



class FilterOption extends StatelessWidget {

  final String text;
  final bool isSelected;

  FilterOption({Key key, this.text, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[700] : COLOR_GREY.withAlpha(25),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          // margin: const EdgeInsets.only(left: 20),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: themeData.textTheme.headline5.copyWith(color: isSelected ? Colors.white : Colors.black, fontSize: 15),
          ),
        ),
      ],
    );
  }
}












