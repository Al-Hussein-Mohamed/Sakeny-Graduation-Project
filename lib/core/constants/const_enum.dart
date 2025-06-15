import 'package:flutter/cupertino.dart';
import 'package:sakeny/generated/l10n.dart';

class KRentFrequencyKeys {
  static const String daily = "Daily";
  static const String weekly = "Weekly";
  static const String monthly = "Monthly";
  static const String yearly = "Yearly";
}

enum RentFrequency {
  daily,
  weekly,
  monthly,
  yearly;

  static RentFrequency? get(String? value) {
    switch (value) {
      case KRentFrequencyKeys.daily:
        return RentFrequency.daily;
      case KRentFrequencyKeys.weekly:
        return RentFrequency.weekly;
      case KRentFrequencyKeys.monthly:
        return RentFrequency.monthly;
      case KRentFrequencyKeys.yearly:
        return RentFrequency.yearly;
      default:
        return null;
    }
  }

  String toJson() {
    switch (this) {
      case RentFrequency.daily:
        return KRentFrequencyKeys.daily;
      case RentFrequency.weekly:
        return KRentFrequencyKeys.weekly;
      case RentFrequency.monthly:
        return KRentFrequencyKeys.monthly;
      case RentFrequency.yearly:
        return KRentFrequencyKeys.yearly;
    }
  }

  String getString(BuildContext context) {
    final S lang = S.of(context);
    switch (this) {
      case RentFrequency.daily:
        return lang.enumDaily;
      case RentFrequency.weekly:
        return lang.enumWeekly;
      case RentFrequency.monthly:
        return lang.enumMonthly;
      case RentFrequency.yearly:
        return lang.enumYearly;
    }
  }
}

class KUnitTypeKeys {
  static const String roomRental = "RoomRental";
  static const String studentHousing = "StudentsRental";
  static const String apartmentRent = "ApartmentRental";
  static const String apartmentSale = "ApartmentSale";
  static const String houseRental = "HouseRental";
  static const String houseSale = "HouseSale";
}

enum UnitType {
  roomRental,
  studentHousing,
  apartmentRent,
  apartmentSale,
  houseRental,
  houseSale;

  static UnitType get(String value) {
    switch (value) {
      case KUnitTypeKeys.roomRental:
        return UnitType.roomRental;

      case KUnitTypeKeys.studentHousing:
        return UnitType.studentHousing;

      case KUnitTypeKeys.apartmentRent:
        return UnitType.apartmentRent;

      case KUnitTypeKeys.apartmentSale:
        return UnitType.apartmentSale;

      case KUnitTypeKeys.houseRental:
        return UnitType.houseRental;

      case KUnitTypeKeys.houseSale:
        return UnitType.houseSale;

      default:
        return UnitType.apartmentRent;
    }
  }

  String toJson() {
    switch (this) {
      case UnitType.roomRental:
        return KUnitTypeKeys.roomRental;
      case UnitType.studentHousing:
        return KUnitTypeKeys.studentHousing;
      case UnitType.apartmentRent:
        return KUnitTypeKeys.apartmentRent;
      case UnitType.apartmentSale:
        return KUnitTypeKeys.apartmentSale;
      case UnitType.houseRental:
        return KUnitTypeKeys.houseRental;
      case UnitType.houseSale:
        return KUnitTypeKeys.houseSale;
    }
  }

  String getString(BuildContext context) {
    final S lang = S.of(context);
    switch (this) {
      case UnitType.roomRental:
        return lang.enumRoomForRent;
      case UnitType.studentHousing:
        return lang.enumStudentHousing;
      case UnitType.apartmentRent:
        return lang.enumApartmentForRent;
      case UnitType.apartmentSale:
        return lang.enumApartmentForSale;
      case UnitType.houseRental:
        return lang.enumHouseForRent;
      case UnitType.houseSale:
        return lang.enumHouseForSale;
    }
  }

  bool isRental() {
    switch (this) {
      case UnitType.roomRental:
      case UnitType.studentHousing:
      case UnitType.apartmentRent:
      case UnitType.houseRental:
        return true;
      case UnitType.apartmentSale:
      case UnitType.houseSale:
        return false;
    }
  }
}

class KGenderKeys {
  static const String male = "Male";
  static const String female = "Female";
  static const String any = "Any";
}

enum Gender {
  male,
  female,
  any;

  static Gender get(String value) {
    switch (value) {
      case KGenderKeys.male:
        return Gender.male;
      case KGenderKeys.female:
        return Gender.female;
      case KGenderKeys.any:
        return Gender.any;
      default:
        return Gender.any;
    }
  }

  String toJson() {
    switch (this) {
      case Gender.male:
        return KGenderKeys.male;

      case Gender.female:
        return KGenderKeys.female;

      case Gender.any:
        return KGenderKeys.any;
    }
  }

  String getString(BuildContext context) {
    final S lang = S.of(context);

    switch (this) {
      case Gender.male:
        return lang.enumGenderMale;

      case Gender.female:
        return lang.enumGenderFemale;

      case Gender.any:
        return lang.enumGenderAny;
    }
  }

  @override
  String toString() {
    switch (this) {
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
      case Gender.any:
        return "any";
    }
  }
}

enum Purpose {
  buy,
  rent,
  all;

  static Purpose? get(String? value) {
    switch (value) {
      case "Buy":
        return Purpose.buy;
      case "Rent":
        return Purpose.rent;
      case "All":
        return Purpose.all;
      default:
        return null;
    }
  }

  String getString(BuildContext context) {
    final S lang = S.of(context);
    switch (this) {
      case Purpose.buy:
        return lang.enumPurposeBuy;
      case Purpose.rent:
        return lang.enumPurposeRent;
      case Purpose.all:
        return lang.enumPurposeAll;
    }
  }
}
