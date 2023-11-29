import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;


class MapView extends StatefulWidget {
  var patientLocation;

  MapView( {Key? key, required this.patientLocation}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Uint8List? markerImage;

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );

    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  late GoogleMapController _controller;
  Set<Marker> _markers = Set();
  List<String> image = [
    "assets/images/food-delivery.png",
    "assets/images/food-delivery.png",
    "assets/images/food-delivery.png",
    "assets/images/food-delivery.png",
    "assets/images/food-delivery.png",
    "assets/images/food-delivery.png",
  ];
  List latLen = [
    LatLng(30.6611, 76.8822),
    LatLng(30.6544, 76.8791),
    LatLng(30.6747, 76.8634),
    LatLng(30.6899, 76.8484),
    LatLng(30.6927,  76.8796),
    LatLng(30.6927, 76.8796),
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    findRider();
  }

   findRider() {
    Future.delayed(Duration.zero, () {

      showModalBottomSheet<void>(
        isDismissible: false,
        context: context,
        builder: (BuildContext context){
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment. end,
                children: <Widget>[
                  Column(
                    children:[
                      Row(
                        children:[
                          Image.asset("assets/images/patient.png",width: 50,height: 50,),
                          Text(widget.patientLocation.toString()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                        child: LinearProgressIndicator(),
                      ),

                      Text("Searching for rider..."),
                      SizedBox(height: 30,),
                      Icon(Icons.cancel,size: 40,),
                      SizedBox(height: 10,)
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
    );
  }

  loadData() async {
    for (int i = 0; i < latLen.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(image[i], 100);
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          draggable: true,
          onDragEnd: (value) {},
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(30.6544, 76.8791),
          zoom: 14.0,
        ),
        markers: _markers,
      ),
    );
  }
}




