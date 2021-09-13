import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';


class ChooseMapScreen extends StatefulWidget {
  
  final LatLng initialPosition;
  final bool isSelecting;

  ChooseMapScreen({
    this.initialPosition =  const LatLng(31.94207, 35.92578),
    this.isSelecting = false,
  });

  @override
  _ChooseMapScreenState createState() => _ChooseMapScreenState();
}

class _ChooseMapScreenState extends State<ChooseMapScreen> {

  Set<Marker> _markers = Set<Marker>();
  LatLng _pickedLocation;
  // MapType _currentMapType = MapType.normal;
  String _mapTypeAsString;
  bool _selecting = false;

  // _getMapType() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     _mapTypeAsString = pref.getString('mapType');
  //     if(_mapTypeAsString == 'MapType.hybrid') {
  //       _currentMapType = MapType.hybrid;
  //     }
  //     else {
  //       _currentMapType = MapType.normal;
  //     }
  //   });
  //   print('hooooooooooooooooooooooooooooooooooooooooooooo');
  //   print(_mapTypeAsString);
  // }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    if (!_selecting) {
      _selecting = !_selecting;
    }
  }

  LatLng _userLocation;

  Future<void> _getCurrentLocation() async {
    final currentLocation = await Location.instance.getLocation();
    setState(() {
      _userLocation = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    return currentLocation;
  }

  @override
  void initState() {
    // _getMapType();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    // size = 20.55
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    // padding = 16.45



    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Click on the location', style: TextStyle(color: Colors.green[700], fontSize: size * 0.8),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.green[700],
          ),
          centerTitle: true,
          actions: [
            if(_selecting) TextButton.icon(
              label: Text('Done', textAlign: TextAlign.center, style: TextStyle(color: Colors.green[700]),),
              icon: Icon(Icons.check, color: Colors.green[700],),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: _pickedLocation == null ? null : () {
                print('the user picked thissssssssss looooooocaaaaaaaaationnnnnnnnnnn:');
                print(_pickedLocation);
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.3),
        body: Container(
          // width: screenSize.width * 0.9,
          // height: screenSize.height * 0.8,
          child: Stack(
            children: [
              _userLocation == null ? Center(child: CircularProgressIndicator(),) : GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 15.0,
                ),
                mapType: MapType.hybrid,
                onTap: widget.isSelecting ? _selectLocation : null,
                markers: _pickedLocation == null ? _markers : {
                  Marker(
                    markerId: MarkerId('m'),
                    position: _pickedLocation,
                  ),
                },
              ),
              if (_selecting && !isLandscape) Positioned(
                bottom: padding,
                left: isLandscape ? screenSize.width / 2.3 : screenSize.width / 2.7,
                child: ElevatedButton.icon(
                  label: Text('Done', textAlign: TextAlign.center, style: TextStyle(color: Colors.green[700]),),
                  icon: Icon(Icons.check, color: Colors.green[700],),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: _pickedLocation == null ? null : () {
                    print('the user picked thissssssssss looooooocaaaaaaaaationnnnnnnnnnn:');
                    print(_pickedLocation);
                    Navigator.of(context).pop(_pickedLocation);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
