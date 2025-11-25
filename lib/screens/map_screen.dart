import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_2_map_app/screens/map_screen.dart';

import '../models/state_visit.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Rough center of continental US
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(39.8283, -98.5795), // center-ish of US
    zoom: 4.0,
  );

  // Hard-coded list of state “centers” or capitals
  // (add more as needed)
  static const List<_StateLocation> _stateLocations = [
    _StateLocation('AL', 32.806671, -86.791130),
    _StateLocation('AK', 61.370716, -152.404419),
    _StateLocation('AZ', 33.729759, -111.431221),
    _StateLocation('AR', 34.969704, -92.373123),
    _StateLocation('CA', 36.116203, -119.681564),
    _StateLocation('CO', 39.059811, -105.311104),
    _StateLocation('CT', 41.597782, -72.755371),
    _StateLocation('DE', 39.318523, -75.507141),
    _StateLocation('FL', 27.766279, -81.686783),
    _StateLocation('GA', 33.040619, -83.643074),
    _StateLocation('HI', 21.094318, -157.498337),
    _StateLocation('ID', 44.240459, -114.478828),
    _StateLocation('IL', 40.349457, -88.986137),
    _StateLocation('IN', 39.849426, -86.258278),
    _StateLocation('IA', 42.011539, -93.210526),
    _StateLocation('KS', 38.526600, -96.726486),
    _StateLocation('KY', 37.668140, -84.670067),
    _StateLocation('LA', 31.169546, -91.867805),
    _StateLocation('ME', 44.693947, -69.381927),
    _StateLocation('MD', 39.063946, -76.802101),
    _StateLocation('MA', 42.230171, -71.530106),
    _StateLocation('MI', 43.326618, -84.536095),
    _StateLocation('MN', 45.694454, -93.900192),
    _StateLocation('MS', 32.741646, -89.678696),
    _StateLocation('MO', 38.456085, -92.288368),
    _StateLocation('MT', 46.921925, -110.454353),
    _StateLocation('NE', 41.125370, -98.268082),
    _StateLocation('NV', 38.313515, -117.055374),
    _StateLocation('NH', 43.452492, -71.563896),
    _StateLocation('NJ', 40.298904, -74.521011),
    _StateLocation('NM', 34.840515, -106.248482),
    _StateLocation('NY', 42.165726, -74.948051),
    _StateLocation('NC', 35.630066, -79.806419),
    _StateLocation('ND', 47.528912, -99.784012),
    _StateLocation('OH', 40.388783, -82.764915),
    _StateLocation('OK', 35.565342, -96.928917),
    _StateLocation('OR', 44.572021, -122.070938),
    _StateLocation('PA', 40.590752, -77.209755),
    _StateLocation('RI', 41.680893, -71.511780),
    _StateLocation('SC', 33.856892, -80.945007),
    _StateLocation('SD', 44.299782, -99.438828),
    _StateLocation('TN', 35.747845, -86.692345),
    _StateLocation('TX', 31.054487, -97.563461),
    _StateLocation('UT', 40.150032, -111.862434),
    _StateLocation('VT', 44.045876, -72.710686),
    _StateLocation('VA', 37.769337, -78.169968),
    _StateLocation('WA', 47.400902, -121.490494),
    _StateLocation('WV', 38.491226, -80.954453),
    _StateLocation('WI', 44.268543, -89.616508),
    _StateLocation('WY', 42.755966, -107.302490),
  ];

  @override
  Widget build(BuildContext context) {
    final visitBox = Hive.box<StateVisit>('stateVisits');

    // Build markers from state locations + Hive data
    final Set<Marker> markers = _stateLocations.map((loc) {
      final visit = visitBox.get(loc.code);
      final visited = visit?.visited ?? false;
      final favorite = visit?.favoriteThing ?? '';

      return Marker(
        markerId: MarkerId(loc.code),
        position: LatLng(loc.lat, loc.lng),
        infoWindow: InfoWindow(
          title: '${loc.code} ${visited ? "(visited)" : "(not visited)"}',
          snippet: visited && favorite.isNotEmpty
              ? 'Favorite: $favorite'
              : visited
              ? 'No favorite set yet'
              : 'Tap on main page to set visited.',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          visited ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueAzure,
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visited States Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: markers,
        mapType: MapType.normal,
      ),
    );
  }
}

class _StateLocation {
  final String code;
  final double lat;
  final double lng;

  const _StateLocation(this.code, this.lat, this.lng);
}
