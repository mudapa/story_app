import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../data/cubit/theme/theme_cubit.dart';
import '../../shared/helper.dart';
import '../../shared/style.dart';
import 'custom_button.dart';

class SetLocationStory extends StatefulWidget {
  const SetLocationStory({
    super.key,
  });

  @override
  State<SetLocationStory> createState() => _SetLocationStoryState();
}

class _SetLocationStoryState extends State<SetLocationStory> {
  LatLng defaultLoc = const LatLng(-6.902525, 107.618796);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  MapType selectedMapType = MapType.normal;

  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: defaultLoc,
              ),
              markers: markers,
              mapType: selectedMapType,
              onMapCreated: (controller) async {
                mapController = controller;
                await updateCurrentLocation();
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onTap: (LatLng latLng) => onTapGoogleMap(latLng),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16.h,
                right: 16.w,
                left: 16.w,
                child: PlacemarkWidget(
                  placemark: placemark!,
                  latLng: defaultLoc,
                ),
              ),
            Positioned(
              top: 16.h,
              right: 16.w,
              child: FloatingActionButton.small(
                onPressed: null,
                child: PopupMenuButton<MapType>(
                  onSelected: (MapType item) {
                    setState(() {
                      selectedMapType = item;
                    });
                  },
                  offset: const Offset(0, 54),
                  icon: const Icon(Icons.layers_outlined),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MapType>>[
                    const PopupMenuItem<MapType>(
                      value: MapType.normal,
                      child: Text('Normal'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.satellite,
                      child: Text('Satellite'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.terrain,
                      child: Text('Terrain'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.hybrid,
                      child: Text('Hybrid'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateCurrentLocation() async {
    LocationData? currentLocation = await getLocation();
    if (currentLocation != null) {
      final latLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      final info = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      final place = info[0];
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      setState(() {
        placemark = place;
        defaultLoc = latLng;
      });

      defineMarker(latLng, street, address);
    }
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  void onTapGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      defaultLoc = latLng; // Update defaultLoc with the current location
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
      defaultLoc =
          latLng; // Update defaultLoc with the selected marker location
    });

    // Call the function to update the map with the new location
    updateMapWithNewLocation(latLng);
  }

  void updateMapWithNewLocation(LatLng latLng) {
    // Move the camera to the new location
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  final geo.Placemark placemark;
  final LatLng latLng;

  const PlacemarkWidget({
    super.key,
    required this.placemark,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: context.select(
                (ThemeCubit cubit) => cubit.state.brightness == Brightness.dark)
            ? blackColor
            : whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                CustomButton(
                  onTap: () {
                    GoRouter.of(context).pop(latLng);
                  },
                  text: text(context).btnSetLocation,
                  color: greenColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
