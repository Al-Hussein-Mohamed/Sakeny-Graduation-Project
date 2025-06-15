class PlaceSearchResult {

  PlaceSearchResult({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.description,
  });

  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};

    return PlaceSearchResult(
      placeId: json['place_id'] ?? '',
      mainText: structuredFormatting['main_text'] ?? json['description']?.split(',').first ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
      description: json['description'] ?? '',
    );
  }
  final String placeId;
  final String mainText;
  final String secondaryText;
  final String description;
}