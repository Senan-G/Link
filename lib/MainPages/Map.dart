import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:link/services/userInfo.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import '../SubPages/LinkPage.dart';


class MapPage extends StatefulWidget {

  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late GoogleMapController mapController;
  Location _location = Location();
  Set<Marker> _markers = HashSet<Marker>();
  LatLng _initialPosition = LatLng(0.0,0.0);
  List<String> nearbyUsers = [];

  @override
  void initState(){
    super.initState();
    setState(() {
      getInitialLocation();
      Geofire.stopListener();
      Geofire.initialize("locations");
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    getLocation();
    mapController = controller;
    setMapStyle();
  }

  void setMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString("assets/map_style.txt");
    mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition.latitude == 0.0 ? Center(child: CircularProgressIndicator(color: Colors.blue))
    : MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          compassEnabled: false,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }

  void getLocation() async{
    var location = await _location.getLocation();
    mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0), 15.0,
        ),
    );

    String uid = (Provider.of<UserData>(context, listen: false).uid);
    await Geofire.setLocation(uid, location.latitude ?? 0.0, location.longitude ?? 0.0);
    await getNearbyLinks(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
  }

  void getInitialLocation() async {
    var location = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(location.latitude!, location.longitude!);
    });
  }

  getNearbyLinks(LatLng location) async {
    Fluttertoast.showToast(
        msg: 'Finding Links',
        backgroundColor: Colors.grey,
        gravity: ToastGravity.TOP
    );

    var callBack;

     Geofire.queryAtLocation(location.latitude, location.longitude, 2.0)?.listen((map) {
      nearbyUsers.clear();
      if (map != null) {

        callBack = map['callBack'];
        if (callBack == Geofire.onGeoQueryReady){
            map["result"].forEach((key){
              nearbyUsers.add(key.toString());
            });
            setState(() {
              setMarkers();
            });
            return;
        }

      }
      if (!mounted) return;
    });
  }

  setMarkers() async {
    Set<Marker> newMarkers = HashSet<Marker>();
    String myUid = Provider.of<UserData>(context, listen: false).uid;
    List finalList = [];

    for(String uid in nearbyUsers){
      if(uid != myUid && !(await UserData.getLinkList()).contains(uid) && !(await UserData.getBlockedList()).contains(uid)) {
        finalList.add(uid);
      }
    }

    print("Nearby Users:\n");
    print(finalList);

    if(finalList.length == 0){
      Fluttertoast.showToast(
          msg: 'No Nearby Links Found',
          backgroundColor: Colors.grey,
          gravity: ToastGravity.TOP
      );
    }

    for(String uid in finalList){

        CollectionReference users = FirebaseFirestore.instance.collection('users');
        DocumentSnapshot document = await users.doc(uid).get();
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        final storageRef = FirebaseStorage.instance.ref();
        var imageRef = storageRef.child("$uid/profile.png");
        String imageurl = await imageRef.getDownloadURL();

        Map<String, dynamic> geofiredata = await Geofire.getLocation(uid);
        LatLng location = LatLng(geofiredata["lat"], geofiredata["lng"]);

        Marker marker = Marker(
            markerId: MarkerId(uid),
            position: location,
            consumeTapEvents: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LinkPage(data: data, uid: uid, imageurl: imageurl)));
            }
        );

        newMarkers.add(marker);
      }

    setState(() {
      _markers = newMarkers;
    });
  }
}