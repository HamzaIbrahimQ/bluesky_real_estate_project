import 'package:bluesky_project/screens/houseDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_project/models/House.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'package:bluesky_project/screens/loginScreen.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/utils/custom_functions.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';


class InfoWindowHouseCard extends StatefulWidget {


  final String houseId;
  final int price;
  final String ownerName;
  final String ownerPhNumber;
  final String ownerEmail;
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
  final double leftMargin;
  final double topMargin;


   InfoWindowHouseCard({
    this.houseId,
    this.price,
    this.ownerName,
    this.ownerPhNumber,
    this.ownerEmail,
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
    this.isFavorite,
    this.leftMargin,
    this.topMargin,
  });

  @override
  _InfoWindowHouseCardState createState() => _InfoWindowHouseCardState();
}

class _InfoWindowHouseCardState extends State<InfoWindowHouseCard> {


  _onHouseCardPressed() {
    return DialogBackground(
      dismissable: true,
      blur: 5.0,
      dialog: Details(widget.houseId),
      // onDismiss: () {},
    ).show(context, transitionType: DialogTransitionType.BottomToTop).then((value) => setState(() {}));
  }


  House _selectedHouse;
  bool isFavorite = false;

  House findById (String id) {
    final houseProvider = Provider.of<Houses>(context);
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



  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    findById(widget.houseId);
    final userProvider = Provider.of<Auth>(context);


    return InkWell(
      onTap: _onHouseCardPressed,
      child: Container(
        width: isLandscape ? screenSize.height * 0.7 : screenSize.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xfff6f6f6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(_selectedHouse.isFavorite ? Icons.favorite : Icons.favorite_border),
                iconSize: size * 2,
                color: Colors.green[700],
                onPressed: () {
                  if (userProvider.isVisitor) {
                    _showVisitorAlert();
                  }
                  else {
                    onFavoriteIconPressed();
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  }
                }
            ),
            addHorizontalSpace(padding),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${formatCurrency(widget.price)}',
                  overflow: TextOverflow.ellipsis,
                  style: TEXT_THEME_DEFAULT.headline5.copyWith(fontSize: size * 0.9, color: Colors.black,),
                ),
                addVerticalSpace(padding),
                Row(
                  children: [
                    Text(
                      widget.firstAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TEXT_THEME_DEFAULT.headline6.copyWith(fontSize: size * 0.4, color: Colors.black),
                    ),
                    addHorizontalSpace(padding / 3),
                    Icon(
                      LineAwesomeIcons.map_marker,
                      size: size * 0.4,
                      color: Colors.black,
                    ),
                  ],
                ),
                addVerticalSpace(padding / 4),
                Row(
                  children: [
                    Text('${widget.shareDate}',
                      style: TEXT_THEME_DEFAULT.headline6.copyWith(fontSize: size * 0.4, color:Colors.black),
                    ),
                    addHorizontalSpace(padding / 3),
                    Icon(
                      LineAwesomeIcons.calendar,
                      size: size * 0.4,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: isLandscape ? screenSize.height * 0.22 : screenSize.width * 0.22,
              height: isLandscape ? screenSize.height * 0.22 : screenSize.width * 0.22,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                child: _selectedHouse.images == null ? Image.asset('images/empty.png', fit: BoxFit.cover,) : FadeInImage(
                  placeholder: AssetImage('images/empty.png'),
                  image: NetworkImage(_selectedHouse.images[0],),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

