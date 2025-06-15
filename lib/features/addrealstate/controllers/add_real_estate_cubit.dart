import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakeny/core/APIs/api_post.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/addrealstate/models/add_estate_params.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';
import 'package:sakeny/generated/l10n.dart';

part 'add_real_estate_state.dart';

class AddRealEstateCubit extends Cubit<AddRealEstateState> {
  AddRealEstateCubit() : super(AddRealEstateInitial());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController areaController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FocusNode areaFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();

  final scaffoldKeyAddRealEstate = GlobalKey<ScaffoldState>();
  final scaffoldKeyAdd = GlobalKey<ScaffoldState>(); //key for the add screen

  UnitType? unitType;
  int? level;
  int? beds;
  int? rooms;
  int? bathrooms;
  LatLng? location;
  String? address;
  RentFrequency? rentalFrequency;
  bool? isFurnished;
  Gender? gender;
  NearbyServicesModel? nearbyServices;
  ServicesModel? services;
  List<XFile> images = [];

  void addPost(BuildContext context) async {
    if (images.isEmpty) return;

    final S lang = S.of(context);
    EasyLoading.show();

    final res = await ApiPost.addPost(
      params: AddEstateParams(
        unitType: unitType!,
        title: titleController.text,
        description: descriptionController.text,
        area: double.parse(areaController.text),
        price: double.parse(priceController.text),
        floor: level!,
        bathrooms: bathrooms!,
        location: location!,
        address: address!,
        isFurnished: isFurnished!,
        images: images,
        gender: gender!,
        nearbyServices: nearbyServices!,
        services: services!,
        rooms: rooms,
        beds: beds,
        rentalFrequency: rentalFrequency,
      ),
    );

    res.fold(
      (error) => ToastificationService.showGlobalErrorToast(error),
      (r) => ToastificationService.showGlobalSuccessToast(lang.unitAddedSuccessfully),
    );

    EasyLoading.dismiss();
  }

  void openDrawerAddRealEstate() {
    //open the drawer for the add real estate screen
    if (scaffoldKeyAddRealEstate.currentState != null) {
      scaffoldKeyAddRealEstate.currentState!.openEndDrawer();
    }
  }

  void closeDrawerAddRealEstate() {
    //close the drawer for the add real estate screen
    if (scaffoldKeyAddRealEstate.currentState != null) {
      scaffoldKeyAddRealEstate.currentState!.closeEndDrawer();
    }
  }

  void openDrawerAddScreen() {
    //open the drawer for the add room screen
    if (scaffoldKeyAdd.currentState != null) {
      scaffoldKeyAdd.currentState!.openEndDrawer();
    }
  }

  void closeDrawerAddScreen() {
    //close the drawer for the add room screen
    if (scaffoldKeyAdd.currentState != null) {
      scaffoldKeyAdd.currentState!.closeEndDrawer();
    }
  }

  @override
  Future<void> close() async {
    areaController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    areaFocusNode.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    priceFocusNode.dispose();
    super.close();
  }
}
