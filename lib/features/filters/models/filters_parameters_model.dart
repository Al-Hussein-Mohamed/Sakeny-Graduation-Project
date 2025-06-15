class FiltersParametersModel {
  FiltersParametersModel({
    this.unitType,
    this.latitude,
    this.longitude,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.rentFrequency,
    this.isFurnished,
    this.level,
    this.beds,
    this.bathrooms,
    this.rooms,
    this.gender,
    this.purpose,
  });

  String? unitType;
  double? latitude;
  double? longitude;
  double? minPrice;
  double? maxPrice;
  double? minArea;
  double? maxArea;
  String? rentFrequency;
  bool? isFurnished;
  int? level;
  int? beds;
  int? bathrooms;
  int? rooms;
  String? gender;
  String? purpose;

  Map<String, dynamic> toMap({required int pageIndex, required int pageCount}) {
    return {
      'pageIndex': pageIndex,
      'pageSize': pageCount,
      'unitType': unitType,
      'latitude': latitude,
      'longitude': longitude,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'minArea': minArea,
      'maxArea': maxArea,
      'rentFrequency': rentFrequency,
      'furnished': isFurnished,
      'floor': level,
      'beds': beds,
      'baths': bathrooms,
      'rooms': rooms,
      'gender': gender,
      'purpose': purpose,
    };
  }
}
