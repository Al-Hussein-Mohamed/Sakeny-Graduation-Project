import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/text_fields/area_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/description_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/price_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/title_text_field.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/add_button.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/add_image_header.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/furnished_radio_buttons.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/gender_radio_buttons.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/modal_bottom_sheets.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/value_selection.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class AddEstateScreen extends StatefulWidget {
  const AddEstateScreen({super.key});

  @override
  State<AddEstateScreen> createState() => _AddEstateScreenState();
}

class _AddEstateScreenState extends State<AddEstateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final UnitType unitType =
          ModalRoute.of(context)!.settings.arguments as UnitType;
      context.read<AddRealEstateCubit>().unitType = unitType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UnitType unitType =
        ModalRoute.of(context)!.settings.arguments as UnitType;

    final AddRealEstateCubit addRealEstateCubit =
        context.read<AddRealEstateCubit>();

    final S lang = S.of(context);
    return CustomScaffold(
      scaffoldKey: addRealEstateCubit.scaffoldKeyAdd,
      screenTitle: unitType.getString(context),
      openDrawer: addRealEstateCubit.openDrawerAddScreen,
      onBack: () => Navigator.pop(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Form(
            key: addRealEstateCubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // add images-------------
                const AddImagesSection(),
                const SizedBox(
                  height: 42,
                ),
                AreaTextField(
                  // area text field -----------
                  label: lang.area,
                  hintText: lang.areaHint,
                  areaController: addRealEstateCubit.areaController,
                  focusNode: addRealEstateCubit.areaFocusNode,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 15,
                ),
                TitleTextField(
                  // text field area -------------
                  label: lang.title,
                  hintText: lang.titleHint,
                  titleController: addRealEstateCubit.titleController,
                  focusNode: addRealEstateCubit.titleFocusNode,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 15,
                ),
                DescriptionTextField(
                  // description field
                  label: lang.description,
                  hintText: lang.descriptionHint,
                  descriptionController:
                      addRealEstateCubit.descriptionController,
                  focusNode: addRealEstateCubit.descriptionFocusNode,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueSelection(
                  //level selection
                  label: lang.level,
                  value: addRealEstateCubit.level,
                  onTap: () async {
                    final selectedValue = await OptionsModalBottomSheets
                        .selectOptionFromBottomSheetLevel(context, lang);
                    if (selectedValue != null) {
                      addRealEstateCubit.level = selectedValue;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                if (unitType != UnitType.roomRental) ...[
                  ValueSelection(
                    //rooms value selection
                    label: lang.rooms,
                    onTap: () async {
                      final selectedValue = await OptionsModalBottomSheets
                          .selectOptionFromBottomSheetGeneral(
                        context,
                        lang.rooms,
                      );
                      if (selectedValue != null) {
                        addRealEstateCubit.rooms = selectedValue;
                      }
                      setState(() {});
                    },
                    value: addRealEstateCubit.rooms,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],

                ValueSelection(
                  //beds selection
                  label: lang.beds,
                  value: addRealEstateCubit.beds,
                  onTap: () async {
                    final selectedValue = await OptionsModalBottomSheets
                        .selectOptionFromBottomSheetGeneral(context, lang.beds);
                    if (selectedValue != null) {
                      addRealEstateCubit.beds = selectedValue;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueSelection(
                  //bathrooms selection
                  label: lang.bathrooms,
                  value: addRealEstateCubit.bathrooms,
                  onTap: () async {
                    final selectedValue = await OptionsModalBottomSheets
                        .selectOptionFromBottomSheetGeneral(
                            context, lang.bathrooms);
                    if (selectedValue != null) {
                      addRealEstateCubit.bathrooms = selectedValue;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueSelection(
                  //location Selection
                  label: lang.location,
                  value: addRealEstateCubit.address,
                  onTap: () => _goToMapSelectLocation(context),
                ),
                const SizedBox(height: 15),
                RadioButtonsFurnished(
                  //furnished radio buttons
                  lang: lang,
                  addRealEstateCubit: addRealEstateCubit,
                ),
                const SizedBox(height: 15),
                if (unitType.isRental()) ...[
                  ValueSelection(
                    //rental frequencey selection
                    label: lang.rentalFrequency,
                    value: addRealEstateCubit.rentalFrequency,
                    onTap: () async {
                      final selectedValue = await OptionsModalBottomSheets
                          .selectOptionFromBottomSheetRentalFrequency(
                        context,
                        lang,
                      );
                      if (selectedValue != null) {
                        addRealEstateCubit.rentalFrequency = selectedValue;
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 15),
                ],
                PriceTextField(
                  //price text field
                  label: lang.price,
                  hintText: lang.priceHint,
                  priceController: addRealEstateCubit.priceController,
                  focusNode: addRealEstateCubit.priceFocusNode,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(height: 15),
                ValueSelection(
                  // feature and amentities selection page
                  label: lang.featureAndAmenities,
                  onTap: () async {
                    addRealEstateCubit.services = await OptionsModalBottomSheets
                        .selectServicesFromBottomSheet(
                      context,
                      lang,
                      ServicesModel.fromMask(0),
                    );
                  },
                  value: addRealEstateCubit.services,
                ),
                const SizedBox(height: 15),
                ValueSelection(
                  // nearby selection page
                  label: lang.nearbyServices,
                  onTap: () async {
                    addRealEstateCubit.nearbyServices =
                        await OptionsModalBottomSheets
                            .selectNearbyServicesFromBottomSheet(
                      context,
                      lang,
                      NearbyServicesModel.fromMask(0),
                    );
                  },
                  value: addRealEstateCubit.nearbyServices,
                ),
                const SizedBox(height: 15),
                RadioButtonsGender(
                  //gender selection
                  lang: lang,
                  addRealEstateCubit: addRealEstateCubit,
                ),
                const SizedBox(height: 15),
                AddButton(
                  // add estate button
                  title: lang.addNow,
                  onTap: () {
                    if (addRealEstateCubit.formKey.currentState!.validate()) {
                      // All form fields with validators are valid
                      // Now check other required fields
                      bool isValid =
                          _validateNonFormFields(addRealEstateCubit, context);

                      if (isValid) {
                        addRealEstateCubit.addPost(context);
                      }
                    }
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _goToMapSelectLocation(BuildContext context) async {
  final AddRealEstateCubit addRealEstateCubit =
      context.read<AddRealEstateCubit>();
  final MapSelectLocationArgs? args = addRealEstateCubit.location == null
      ? null
      : MapSelectLocationArgs(
          location: addRealEstateCubit.location!,
          address: addRealEstateCubit.address!,
        );

  final retArgs = await Navigator.pushNamed(
    context,
    PageRouteNames.mapSelectLocation,
    arguments: args,
  ) as MapSelectLocationArgs?;

  if (retArgs != null) {
    addRealEstateCubit
      ..location = retArgs.location
      ..address = retArgs.address;
  }
}

bool _validateNonFormFields(
  AddRealEstateCubit cubit,
  BuildContext context,
) {
  final S lang = S.of(context);
  String? errorMessage;
  final UnitType unitType =
      ModalRoute.of(context)!.settings.arguments as UnitType;

  // Check each field independently
  if (cubit.level == null) {
    errorMessage = lang.validators_levelRequired;
  }

  // Only after validating level, check other fields if level is valid
  if (errorMessage == null) {
    if (unitType != UnitType.roomRental && cubit.rooms == null) {
      errorMessage = lang.validators_roomsRequired;
    } else if (cubit.beds == null) {
      errorMessage = lang.validators_bedsRequired;
    } else if (cubit.bathrooms == null) {
      errorMessage = lang.validators_bathroomsRequired;
    } else if (cubit.location == null) {
      errorMessage = lang.validators_locationRequired;
    } else if (cubit.isFurnished == null) {
      errorMessage = lang.validators_furnishedRequired;
    } else if (cubit.gender == null) {
      errorMessage = lang.validators_genderRequired;
    } else if (unitType.isRental() && cubit.rentalFrequency == null) {
      errorMessage = lang.validators_rentalFrequencyRequired;
    }
  }

  // Show error message if validation fails
  if (errorMessage != null) {
    ToastificationService.showErrorToast(context, errorMessage);
    return false;
  }

  return true;
}
