import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/features/addrealstate/screens/widgets/real_estate_type_selector.dart';
import 'package:sakeny/generated/l10n.dart';

class AddRealEstateScreen extends StatelessWidget {
  const AddRealEstateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddRealEstateCubit addRealEstateCubit = context.read<AddRealEstateCubit>();
    final S lang = S.of(context);

    return CustomScaffold(
      scaffoldKey: addRealEstateCubit.scaffoldKeyAddRealEstate,
      screenTitle: lang.addRealEstate,
      openDrawer: addRealEstateCubit.openDrawerAddRealEstate,
      onBack: () => Navigator.pop(context),
      body: Column(
        children: [
          RealEstateTypeSelector(
            // room button
            title: lang.roomForRent,
            iconPath: ConstImages.room,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.roomRental,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
          RealEstateTypeSelector(
            // Student's Apartment button
            title: lang.studentsApartmentForRent,
            iconPath: ConstImages.apartment,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.studentHousing,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
          RealEstateTypeSelector(
            // Apartment for sale button
            title: lang.apartmentForSale,
            iconPath: ConstImages.apartment,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.apartmentSale,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
          RealEstateTypeSelector(
            // Apartment for rent button
            title: lang.apartmentForRent,
            iconPath: ConstImages.apartment,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.apartmentRent,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
          RealEstateTypeSelector(
            //House for sale button
            title: lang.houseForSale,
            iconPath: ConstImages.house,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.houseSale,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
          RealEstateTypeSelector(
            //House for rent button
            title: lang.houseForRent,
            iconPath: ConstImages.house,
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRouteNames.addEstateScreen,
                arguments: UnitType.houseRental,
              );
            },
          ),
          const Divider(
            // Divider ---------------------
            height: 0,
            thickness: 2,
            color: ConstColors.dividerColor,
          ),
        ],
      ),
    );
  }
}
