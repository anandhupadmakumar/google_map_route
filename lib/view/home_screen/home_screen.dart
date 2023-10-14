import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/controller/home/g_map_route_controller.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  Set<Marker> markersss = {};
  LatLng loc1 = const LatLng(26.679070, 77.349710);
  int numDeltas = 1000;
  int delay = 50;
  var i = 0;
  double? deltaLat;
  double? deltaLang;
  var position;

  @override
  void initState() {
    position = [loc1.latitude, loc1.longitude];

    homeController.setCustomIcon();

    super.initState();
  }

  transition(result) {
    i = 0;
    deltaLat = (result[0] - position[0]) / numDeltas;
    deltaLang = (result[1] - position[1]) / numDeltas;
    moveMarker();
  }

  moveMarker() {
    position[0] += deltaLat;
    position[1] += deltaLang;
    var latLang = LatLng(position[0], position[1]);
    markersss = {
      Marker(
          markerId: const MarkerId("moveMarker"),
          position: latLang,
          icon: homeController.sourceIcon!)
    };

    if (i != numDeltas) {
      i++;
      Future.delayed(const Duration(milliseconds: 20), () {
        moveMarker();
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GMapRouteController>(
          id: "mapId",
          init: GMapRouteController(),
          builder: (gData) {
            if (gData.positionIcon == null) {
              gData.setCustomIcon();
              return const CircularProgressIndicator();
            } else {
              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: LatLng(26.679070, 77.349710), zoom: 7.5),
                mapType: MapType.normal,
                markers: gData.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                polylines: gData.polyline,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    mapController = controller;
                  });
                  // gData.controller.complete(controller);
                },
              );
            }
          }),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 100,
            child: Row(
              children: [
                Container(
                  width: Get.width * 120 / 414,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/map_car-removebg-preview.png'))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Get.width * 180 / 414,
                      child: Text(
                        'Current Latitude : ${LatLng(position[0], position[1]).latitude}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 180 / 414,
                      child: Text(
                        'Current Longitude : ${LatLng(position[0], position[1]).longitude}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const Text(
                      'Car Model : Maruthi suzuki ',
                      style:
                           TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const Text(
                      'Speed : 60 km/hr ',
                      style:
                           TextStyle(color: Colors.black, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  width: Get.width * 25 / 414,
                ),
                IconButton(
                    onPressed: () {
                      var result = [
                        homeController.latLen[0].latitude,
                        homeController.latLen[1].longitude
                      ];

                      transition(result);
                    },
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.cyan,
                      size: 40,
                    ))
              ],
            )),
      ),
    );
  }
}
