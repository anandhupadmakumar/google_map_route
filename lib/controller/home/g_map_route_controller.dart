import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final GMapRouteController homeController = Get.put(GMapRouteController());

class GMapRouteController extends GetxController {
  final Set<Polyline> polyline = {};
  Completer<GoogleMapController> controller = Completer();
  double positionLati = 13.679080;
  double positionLongi = 77.346610;
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? positionIcon;
  BitmapDescriptor destination = BitmapDescriptor.defaultMarker;
  LatLng loc1 = const LatLng(26.679070, 77.349710);
  List<LatLng> latLen = [
    // LatLng(19.0759837, 72.8776559),
    const LatLng(28.679070, 77.069710),

    // LatLng(20.679080, 75.949997),
    // LatLng(24.879999, 74.629997),
    //LatLng(16.166700, 74.833298),
    const LatLng(24.971599, 77.594563),
  ];
  @override
  void onInit() {
    setCustomIcon();

    // Future.delayed(
    //     const Duration(
    //       milliseconds: 600,
    //     ), () {
    //   polylineDraw();
    // });

    super.onInit();
  }

  addMarkers() async {
    homeController.markers.add(Marker(
        markerId: MarkerId(loc1.toString()),
        position: loc1,
        icon: homeController.sourceIcon!));
  }

  final CameraPosition kGoogle = const CameraPosition(
    target: LatLng(28.679079, 77.949995),
    zoom: 4,
  );

  Set<Marker> markers = {};

  setCustomIcon() async {
    positionIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/destination.png');
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/images/map_car-removebg-preview.png');
    //     .then((icon) {
    //   positionIcon = icon;
    // });

    homeController.polylineDraw();
    addMarkers();

    update(["mapId"]);
  }

  void polylineDraw() {
    for (int i = 0; i < latLen.length; i++) {
      markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: const InfoWindow(
          title: 'Map',
          snippet: 'my map',
        ),
        icon: positionIcon!,
      ));

      polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: latLen,
        color: const Color.fromARGB(255, 5, 211, 252),
      ));
    }
    // setCustomIcon();

    update(["mapId"]);
  }
}
