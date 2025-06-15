import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/features/filters/screens/widgets/area_range_fields_row.dart';
import 'package:sakeny/features/filters/screens/widgets/location_selection.dart';
import 'package:sakeny/features/filters/screens/widgets/price_range_fields_row.dart';
import 'package:sakeny/features/filters/screens/widgets/property_button.dart';
import 'package:sakeny/features/filters/screens/widgets/property_selection_row.dart';
import 'package:sakeny/features/filters/screens/widgets/reset_button.dart';
import 'package:sakeny/features/filters/screens/widgets/show_properties_button.dart';
import 'package:sakeny/features/filters/screens/widgets/value_button.dart';
import 'package:sakeny/features/filters/screens/widgets/value_selection_row.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/maps/map_show_units/models/map_show_units_args.dart';
import 'package:sakeny/generated/l10n.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final FiltersCubit filtersCubit = context.read<FiltersCubit>();
    final S lang = S.of(context);

    void showPropertiesOnTap() {
      Navigator.pushReplacementNamed(
        context,
        PageRouteNames.mapShowUnits,
        arguments: MapShowUnitsArgs(filters: filtersCubit.getFiltersParams()),
      );
    }

    void resetButtonOnTap() {
      filtersCubit.resetFilters();
      homeCubit.filtersParams = filtersCubit.getFiltersParams();
      setState(() {});
    }

    void selectLocationOnTap() async {
      final MapSelectLocationArgs? sendArgs = filtersCubit.location == null
          ? null
          : MapSelectLocationArgs(
              location: filtersCubit.location!,
              address: filtersCubit.addressController.text,
            );
      final MapSelectLocationArgs? retArgs = await Navigator.pushNamed(
        context,
        PageRouteNames.mapSelectLocation,
        arguments: sendArgs,
      ) as MapSelectLocationArgs?;

      if (retArgs != null) {
        filtersCubit.updateLocation(retArgs.location, retArgs.address);
      }
      setState(() {});
    }

    return CustomScaffold(
      scaffoldKey: filtersCubit.scaffoldKeyFilters,
      screenTitle: lang.filters,
      openDrawer: filtersCubit.openDrawerFilter,
      onBack: () => Navigator.pop(context),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: ConstConfig.scrollPhysics,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  //property type header
                  lang.propertyType,
                  style: Theme.of(context).brightness == Brightness.light
                      ? CustomTextTheme.lightTextTheme.bodyMedium
                      : CustomTextTheme.darkTextTheme.bodyMedium,
                ),
              ),
              PropertySelectionRow(
                //property selection row with cupertrino segmented selection
                filtersCubit: filtersCubit,
                segmentsMap: {
                  "room": PropertyButton(
                    iconPath: ConstImages.room,
                    title: lang.room,
                  ),
                  "apartment": PropertyButton(
                    iconPath: ConstImages.apartment,
                    title: lang.apartment,
                  ),
                  "studentApartment": PropertyButton(
                    iconPath: ConstImages.apartment,
                    title: lang.studentApartment,
                  ),
                  "house": PropertyButton(
                    iconPath: ConstImages.house,
                    title: lang.house,
                  ),
                },
              ),
              const SizedBox(
                height: 6,
              ),
              const Divider(
                height: 2,
                color: ConstColors.dividerColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                //location header
                lang.location,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              LocationSelection(onTap: selectLocationOnTap),
              const SizedBox(
                height: 12,
              ),
              Text(
                //price range header
                lang.priceRange,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 15,
              ),
              PriceRangeFieldsRow(
                //price fields row
                lang: lang,
                filtersCubit: filtersCubit,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                //area header
                lang.areaRange,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              AreaRangeFieldsRow(
                //area fields row
                lang: lang,
                filtersCubit: filtersCubit,
              ),
              const SizedBox(
                height: 24,
              ),
              const Divider(
                height: 2,
                color: ConstColors.dividerColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // rental frequency header
                lang.rentalFrequency,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //rental row selection
                value: filtersCubit.rentFrequency,
                segmentsMap: {
                  "daily": ValueButton(title: lang.enumDaily),
                  "weekly": ValueButton(title: lang.enumWeekly),
                  "monthly": ValueButton(title: lang.enumMonthly),
                  "yearly": ValueButton(title: lang.enumYearly),
                  "any": ValueButton(title: lang.any),
                },
                onChanged: (value) {
                  filtersCubit.updateRentFrequency(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // furnished header
                lang.furnished,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //furnished row selection
                value: filtersCubit.furnished,
                segmentsMap: {
                  "furnished": ValueButton(title: lang.furnished),
                  "unfurnished": ValueButton(title: lang.unfurnished),
                  "all": ValueButton(title: lang.all),
                },
                onChanged: (value) {
                  filtersCubit.updateFurnishedStatus(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                height: 2,
                color: ConstColors.dividerColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // levels header
                lang.level,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //level row selection
                value: filtersCubit.level,
                segmentsMap: const {
                  1: ValueButton(title: "1"),
                  2: ValueButton(title: "2"),
                  3: ValueButton(title: "3"),
                  4: ValueButton(title: "4"),
                  5: ValueButton(title: "+5"),
                },
                onChanged: (value) {
                  filtersCubit.updateLevel(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // rooms header
                lang.rooms,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //rooms row selection
                value: filtersCubit.rooms,
                segmentsMap: const {
                  1: ValueButton(title: "1"),
                  2: ValueButton(title: "2"),
                  3: ValueButton(title: "3"),
                  4: ValueButton(title: "4"),
                  5: ValueButton(title: "+5"),
                },
                onChanged: (value) {
                  filtersCubit.updateRooms(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // beds header
                lang.beds,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //beds row selection
                value: filtersCubit.beds,
                segmentsMap: const {
                  1: ValueButton(title: "1"),
                  2: ValueButton(title: "2"),
                  3: ValueButton(title: "3"),
                  4: ValueButton(title: "4"),
                  5: ValueButton(title: "+5"),
                },
                onChanged: (value) {
                  filtersCubit.updateBeds(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // bathrooms header
                lang.bathrooms,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //bathrooms row selection
                value: filtersCubit.bathrooms,
                segmentsMap: const {
                  1: ValueButton(title: "1"),
                  2: ValueButton(title: "2"),
                  3: ValueButton(title: "3"),
                  4: ValueButton(title: "4"),
                  5: ValueButton(title: "+5"),
                },
                onChanged: (value) {
                  filtersCubit.updateBathrooms(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // gender header
                lang.gender,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //gender row selection
                value: filtersCubit.gender,
                segmentsMap: {
                  "males": ValueButton(title: lang.enumGenderMale),
                  "females": ValueButton(title: lang.enumGenderFemale),
                  "any": ValueButton(title: lang.enumGenderAny),
                },
                onChanged: (value) {
                  filtersCubit.updateGender(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                height: 2,
                color: ConstColors.dividerColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // purpose header
                lang.purpose,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodyMedium
                    : CustomTextTheme.darkTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ValueSelectionRow(
                //purpose row selection
                value: filtersCubit.purpose,
                segmentsMap: {
                  "buy": ValueButton(title: lang.enumPurposeBuy),
                  "rent": ValueButton(title: lang.enumPurposeRent),
                  "all": ValueButton(title: lang.enumPurposeAll),
                },
                onChanged: (value) {
                  filtersCubit.updatePurpose(value);
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                height: 2,
                color: ConstColors.dividerColor,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ResetButton(
                      //reset button
                      onTap: resetButtonOnTap,
                      title: lang.reset,
                    ),
                  ),
                  Expanded(
                    //show properties button
                    flex: 2,
                    child: ShowPropertiesButton(
                      onTap: () {
                        if (filtersCubit.hasAnyFilterApplied()) {
                          showPropertiesOnTap();
                        } else {
                          // Show error message that at least one filter must be applied
                          ToastificationService.showErrorToast(
                            context,
                            lang.pleaseApplyAtLeastOneFilter,
                          );
                        }
                      },
                      title: lang.showProperties,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
