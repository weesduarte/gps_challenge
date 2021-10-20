import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_challenge/helpers/local_edit_page.dart';
import 'package:gps_challenge/helpers/local_helper.dart';
import 'package:gps_challenge/interface/after_start.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocalHelper helper = LocalHelper();
  List<Local> locals = List();
  Completer<GoogleMapController> _Mapcontroller = Completer();
  Set<Marker> markers = Set<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    _Mapcontroller.complete(controller);
  }

  static const LatLng _center = const LatLng(-7.1702109, -34.8617614);

  LatLng _lastMapPosition = _center;

  void _onAddMarkerButtonPressed() {
    setState(() {
      markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Title testing',
          snippet: 'engelset location',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _getAllLocals() {
    helper.getAllLocals().then((list) {
      setState(() {
        locals = list;
      });
    });
  }

  void _showLocalPage({Local local}) async {
    final recLocal = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocalPage(
                local: local,
              )),
    );
    if (recLocal != null) {
      if (local != null) {
        await helper.updateLocal(recLocal);
      } else {
        await helper.saveLocal(recLocal);
      }
      _getAllLocals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2286c3),
        title: const Text(
          "Nova Localização",
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 17.0),
            markers: markers,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  _onAddMarkerButtonPressed;
                  _showLocalPage();
                },
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: const Color(0xFF2286c3),
                child: const Icon(Icons.add_location_alt_outlined, size: 40.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
