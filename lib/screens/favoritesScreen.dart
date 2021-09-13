import 'package:bluesky_project/screens/houseDetailsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/utils/custom_functions.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';


class FavoritesScreen extends StatefulWidget {



  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {


  bool isFavorite = false;
  House _selectedHouse;

  House findById (String id) {
    final houseProvider = Provider.of<Houses>(context, listen: false);
    return _selectedHouse = houseProvider.houses.firstWhere((house) => house.id == id);
  }


  onFavoriteIconPressed() {
    final auth = Provider.of<Auth>(context, listen: false);
    _selectedHouse.toggleFavoriteStatus(auth.token, auth.userId, context);
  }

  @override
  Widget build(BuildContext context) {


    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final favoritesProvider = Provider.of<Houses>(context, listen: false);





    return SafeArea(
      child: Container(
        color: Color(0xfff6f6f6),
        child: Column(
          children: [
            addVerticalSpace(padding),
           Expanded(
             child: RawScrollbar(
               thumbColor: Colors.green[700],
               thickness: 2.0,
               radius: Radius.circular(15.0),
               child: favoritesProvider.favoriteHouses.length == 0 ? Center(
                 child: Text(
                   'Your favorite houses will shown here',
                   textAlign: TextAlign.center,
                   style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: isLandscape ? screenSize.width * 0.017 : screenSize.height * 0.017),
                 ),
               ) : ListView.builder(
                   itemCount: favoritesProvider.favoriteHouses.length,
                   physics: BouncingScrollPhysics(),
                   itemBuilder: (context, index) {
                 return InkWell(
                   onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(favoritesProvider.favoriteHouses[index].id))).then((value) => setState(() {}));
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
                                   child: favoritesProvider.favoriteHouses[index].images == null ? Image.asset('images/empty.png', fit: BoxFit.cover,) : FadeInImage(
                                     placeholder: AssetImage('images/empty.png'),
                                     image: NetworkImage(favoritesProvider.favoriteHouses[index].images[0],),
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
                                     '${formatCurrency(favoritesProvider.favoriteHouses[index].price)}',
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
                                         favoritesProvider.favoriteHouses[index].firstAddress,
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
                                         favoritesProvider.favoriteHouses[index].shareDate,
                                         style: TEXT_THEME_DEFAULT.headline6.copyWith(fontSize: isLandscape ? screenSize.width * 0.008 : screenSize.height * 0.008, color: purpleColor),
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ],
                           ),
                           IconButton(
                             icon: Icon(favoritesProvider.favoriteHouses[index].isFavorite ? Icons.favorite : Icons.favorite_border),
                             iconSize: size * 2,
                             color: Colors.green[700],
                             onPressed: () {
                                 findById(favoritesProvider.favoriteHouses[index].id);
                                 onFavoriteIconPressed();
                                 setState(() {
                                   isFavorite =! isFavorite;
                                 });
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
    );
  }
}



