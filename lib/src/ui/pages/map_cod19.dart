import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapCod19 extends StatefulWidget {
  MapCod19({Key key}) : super(key: key);

  @override
  _MapCod19State createState() => _MapCod19State();
}

class _MapCod19State extends State<MapCod19> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  List<Marker> markers;

  @override
  void initState() {
    super.initState();
  }

  static final CameraPosition _initial = CameraPosition(
    target: LatLng(-12.195444, -76.9741501),
    zoom: 4,
  );

  @override
  Widget build(BuildContext context) {
    final DataCov19 dataCod19 = Provider.of<DataCov19>(context, listen: true);
    markers = dataCod19.listMarkers;
    return Scaffold(
      body: GoogleMap(
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _initial,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(mapStyles);
          _controller.complete(controller);
        },
        markers: markers.toSet(),
      ),
    );
  }

  String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#121212"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#FFFFFF"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#424242"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#303030"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]''';
}
