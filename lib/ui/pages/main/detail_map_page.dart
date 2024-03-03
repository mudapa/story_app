import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../data/cubit/story/detail/detail_cubit.dart';
import '../../widgets/item_content_map.dart';

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({super.key});

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
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
        child: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            final story = (state as DetailStorySuccess).detailStory.story!;
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    zoom: 18,
                    target: LatLng(
                      story.lat!,
                      story.lon!,
                    ),
                  ),
                  markers: markers,
                  mapType: selectedMapType,
                  onMapCreated: (controller) async {
                    final info = await geo.placemarkFromCoordinates(
                      story.lat!,
                      story.lon!,
                    );

                    final place = info[0];
                    final street = place.street!;
                    final address =
                        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                    setState(() {
                      placemark = place;
                    });

                    defineMarker(
                        LatLng(
                          story.lat!,
                          story.lon!,
                        ),
                        street,
                        address);

                    setState(() {
                      mapController = controller;
                    });
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                if (placemark == null)
                  const SizedBox()
                else
                  Positioned(
                    bottom: 16.h,
                    right: 16.w,
                    left: 16.w,
                    child: ItemContentMap(
                      placemark: placemark!,
                      story: story,
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
            );
          },
        ),
      ),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

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
    });
  }
}
