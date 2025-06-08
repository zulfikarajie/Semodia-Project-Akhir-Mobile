import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/google_place_api.dart';
import '../models/google_place.dart';
import '../utils/session_manager.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _loading = false;
  List<GooglePlace> _places = [];
  TextEditingController _searchController = TextEditingController();

  double? _userLat;
  double? _userLng;
  String? _userAddress;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final uname = await SessionManager.getLoggedUser();
    setState(() {
      _username = uname;
    });
  }

  Future<void> _trackUser() async {
    setState(() {
      _loading = true;
      _places = [];
      _markers = {};
      _userLat = null;
      _userLng = null;
      _userAddress = null;
    });
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLat = pos.latitude;
        _userLng = pos.longitude;
        _markers = {
          Marker(
            markerId: MarkerId('me'),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: InfoWindow(title: "Lokasi Saya"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        };
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mendapatkan lokasi: $e")));
    }
    setState(() => _loading = false);
  }

  Future<void> _searchByText() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _userLat == null || _userLng == null) return;
    setState(() {
      _loading = true;
      _places = [];
      _markers = {
        Marker(
          markerId: MarkerId('me'),
          position: LatLng(_userLat!, _userLng!),
          infoWindow: InfoWindow(title: "Lokasi Saya"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
    try {
      final places = await GooglePlacesApi.searchByText(
        textQuery: query,
        locationBias: {'latitude': _userLat!, 'longitude': _userLng!},
      );
      setState(() {
        _places = places;
        _markers = {
          Marker(
            markerId: MarkerId('me'),
            position: LatLng(_userLat!, _userLng!),
            infoWindow: InfoWindow(title: "Lokasi Saya"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
          ...places.where((p) => p.lat != null && p.lng != null).map((p) => Marker(
                markerId: MarkerId(p.name),
                position: LatLng(p.lat!, p.lng!),
                infoWindow: InfoWindow(title: p.name, snippet: p.address),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              )),
        };
        if (_places.isNotEmpty && _places.first.lat != null && _places.first.lng != null) {
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(_places.first.lat!, _places.first.lng!), 14));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mencari tempat: $e")));
    }
    setState(() => _loading = false);
  }

  Future<void> _searchNearby() async {
    if (_userLat == null || _userLng == null) return;
    setState(() {
      _loading = true;
      _places = [];
      _markers = {
        Marker(
          markerId: MarkerId('me'),
          position: LatLng(_userLat!, _userLng!),
          infoWindow: InfoWindow(title: "Lokasi Saya"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
    try {
      final places = await GooglePlacesApi.searchNearby(
        lat: _userLat!,
        lng: _userLng!,
        radius: 3000,
        maxResults: 10,
      );
      setState(() {
        _places = places;
        _markers = {
          Marker(
            markerId: MarkerId('me'),
            position: LatLng(_userLat!, _userLng!),
            infoWindow: InfoWindow(title: "Lokasi Saya"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
          ...places.where((p) => p.lat != null && p.lng != null).map((p) => Marker(
                markerId: MarkerId(p.name),
                position: LatLng(p.lat!, p.lng!),
                infoWindow: InfoWindow(title: p.name, snippet: p.address),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              )),
        };
        if (_places.isNotEmpty && _places.first.lat != null && _places.first.lng != null) {
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(_places.first.lat!, _places.first.lng!), 14));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mencari sekitar: $e")));
    }
    setState(() => _loading = false);
  }

  Widget _buildPlaceCard(GooglePlace p) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.place, color: Colors.orange, size: 36),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    p.address ?? '-',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  if (p.lat != null && p.lng != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Lat: ${p.lat!.toStringAsFixed(5)}, Lon: ${p.lng!.toStringAsFixed(5)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAPS FOR PLACES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sapaan username di atas maps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Text(
              'Hi ${_username ?? ""}! this maps shows you places address!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: orange,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.my_location),
                label: Text("Track Me"),
                onPressed: _loading ? null : _trackUser,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    enabled: _userLat != null && _userLng != null,
                    decoration: InputDecoration(
                      hintText: "Cari dealer/bengkel/motor...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.search),
                    label: Text("Cari di Sekitar"),
                    onPressed: (_loading || _userLat == null || _userLng == null)
                        ? null
                        : _searchByText,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLat != null && _userLng != null
                    ? LatLng(_userLat!, _userLng!)
                    : LatLng(-6.2, 106.8),
                zoom: _userLat != null ? 14 : 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
          if (_places.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListView.builder(
                  itemCount: _places.length,
                  itemBuilder: (context, i) => _buildPlaceCard(_places[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}