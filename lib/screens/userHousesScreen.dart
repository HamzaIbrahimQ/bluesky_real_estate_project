import 'package:bluesky_project/screens/houseDetailsScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/utils/custom_functions.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';



class UserHousesScreen extends StatefulWidget {



  @override
  _UserHousesScreenState createState() => _UserHousesScreenState();
}

class _UserHousesScreenState extends State<UserHousesScreen> {


  bool isFavorite = false;
  House _selectedHouse;

  House findById (String id) {
    final houseProvider = Provider.of<Houses>(context, listen: false);
    return _selectedHouse = houseProvider.houses.firstWhere((house) => house.id == id);
  }


    Future<void> deleteHouseImages(String id) async {
      final houseProvider = Provider.of<Houses>(context, listen: false);
      final existingHouseIndex = houseProvider.houses.indexWhere((house) =>
      house.id == id);
      final house = houseProvider.houses[existingHouseIndex];
      for (int i = 0; i < house.images.length; i++) {
        final Reference firebaseStorageRef = FirebaseStorage.instance.refFromURL(house.images[i]);
        await firebaseStorageRef.delete().then((value) => print('imaaaaaagggggggggg deleeeeeeeeeteddddddd'));
      }
    }




  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final ThemeData themeData = Theme.of(context);
    final userHousesProvider = Provider.of<Houses>(context, listen: false);




    return SafeArea(
        child: Center(
          child:
           Container(
              width: isLandscape ? screenSize.width * 0.9 : screenSize.width * 0.9,
              height: screenSize.height * 0.8,
              // padding: EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  addVerticalSpace(padding),
                  Expanded(
                    child: RawScrollbar(
                        thumbColor: Colors.green[700],
                        thickness: 2.0,
                        radius: Radius.circular(15.0),
                        child: userHousesProvider.userHouses.length == 0 ? Center(
                          child: Text(
                            'Your shared houses will shown here',
                            textAlign: TextAlign.center,
                            style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: isLandscape ? screenSize.width * 0.014 : screenSize.height * 0.014),
                          ),
                        ) : ListView.builder(
                            itemCount: userHousesProvider.userHouses.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(userHousesProvider.userHouses[index].id))).then((value) => setState(() {}));
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: isLandscape ? screenSize.height * 0.22 : screenSize.width * 0.22,
                                              height: isLandscape ? screenSize.height * 0.22 : screenSize.width * 0.22,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                                                child: userHousesProvider.userHouses[index].images == null ? Image.asset('images/empty.png', fit: BoxFit.cover,) : FadeInImage(
                                                  placeholder: AssetImage('images/empty.png'),
                                                  image: NetworkImage(userHousesProvider.userHouses[index].images[0],),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            addHorizontalSpace(padding),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${formatCurrency(userHousesProvider.userHouses[index].price)}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TEXT_THEME_DEFAULT.headline5.copyWith(fontSize: isLandscape ? screenSize.width * 0.017 : screenSize.height * 0.017, color: purpleColor,),
                                                ),
                                                addVerticalSpace(padding / 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons.map_marker,
                                                      size: size / 1.5,
                                                      color: purpleColor,
                                                    ),
                                                    addHorizontalSpace(padding / 3),
                                                    Text(
                                                      userHousesProvider.userHouses[index].firstAddress,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TEXT_THEME_DEFAULT.headline6.copyWith(fontSize: isLandscape ? screenSize.width * 0.010 : screenSize.height * 0.010, color: purpleColor),
                                                    ),
                                                  ],
                                                ),
                                                addVerticalSpace(padding / 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons.calendar,
                                                      size: size / 1.5,
                                                      color: purpleColor,
                                                    ),
                                                    addHorizontalSpace(padding / 3),
                                                    Text(
                                                      userHousesProvider.userHouses[index].shareDate,
                                                      style: TEXT_THEME_DEFAULT.headline6.copyWith(fontSize: isLandscape ? screenSize.width * 0.008 : screenSize.height * 0.008, color: purpleColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            iconSize: size * 2,
                                            color: Colors.red,
                                            onPressed: () {
                                              return showDialog(context: context, builder: (context) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: Text('Do you want to delete this property?', style: themeData.textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                                                actions: [
                                                  TextButton(
                                                    child: Text('No', style: TextStyle(color: Colors.green[700])),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Yes', style: TextStyle(color: Colors.red)),
                                                    onPressed: () {
                                                      userHousesProvider.updateVisibility(false);
                                                      findById(userHousesProvider.userHouses[index].id);
                                                      deleteHouseImages(_selectedHouse.id);
                                                      userHousesProvider.deleteHouse(_selectedHouse.id);
                                                      userHousesProvider.removeMarker(_selectedHouse.id);
                                                      userHousesProvider.deleteFromFavorites(_selectedHouse.id);
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              ).then((value) => setState(() {}));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            })
                    ),
                  ),
                  addVerticalSpace(padding),
                ],
              ),
            ),
        ),
    );
  }
}



