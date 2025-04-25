class AddressCreationMapInformation {
  double? latitude;
  double? longitude;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? postcode;
  String? country;

  AddressCreationMapInformation({
    required this.latitude,
    required this.longitude,
    this.addressLine1,
    this.addressLine2,
    this.postcode,
    required this.city,
    required this.state,
    required this.country,
  });
}
