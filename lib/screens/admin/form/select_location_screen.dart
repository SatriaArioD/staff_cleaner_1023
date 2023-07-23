import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/constant.dart';
import 'package:staff_cleaner/values/output_utils.dart';
import 'package:staff_cleaner/values/widget_utils.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  latlong2.LatLng? latLng;
  Placemark? placemark;

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast("Location services are disabled. Please enable the services");
      logO("permission",
          m: "Location services are disabled. Please enable the services");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast("Location permissions are denied");
        logO("permission", m: "Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showToast(
          "Location permissions are permanently denied, we cannot request permissions.");
      logO("permission",
          m: "Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      latLng = latlong2.LatLng(
        position.latitude,
        position.longitude,
      );
      placemark = placemarks.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    const padding = 50.0;

    return Scaffold(
      body: latLng != null
          ? Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: latLng,
                    zoom: 16,
                    boundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.only(
                        left: padding,
                        top: padding + MediaQuery.of(context).padding.top,
                        right: padding,
                        bottom: padding,
                      ),
                    ),
                    onTap: (tapPosition, latLng) async {
                      // get placemark
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        latLng.latitude,
                        latLng.longitude,
                      );

                      setState(() {
                        this.latLng = latLng;
                        placemark = placemarks.first;
                      });
                    },
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                      urlTemplate:
                          "https://api.tomtom.com/map/1/tile/basic/main/"
                          "{z}/{x}/{y}.png?key=$apiKey",
                      additionalOptions: const {
                        "apiKey": apiKey,
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: latLng!,
                          width: 35,
                          height: 35,
                          builder: (context) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 24,
                          ),
                          anchorPos: AnchorPos.align(AnchorAlign.top),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: latLng != null,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextComponent(
                            placemark!.street!,
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                          TextComponent(
                            '${placemark!.subLocality}, ${placemark!.locality}, ${placemark!.postalCode}, ${placemark!.country}',
                            size: 14,
                            weight: FontWeight.w400,
                          ),
                          V(16),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, latLng);
                              },
                              child: TextComponent(
                                'Pilih',
                                size: 16,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
