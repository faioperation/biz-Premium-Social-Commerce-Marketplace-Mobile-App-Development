class AddressModel {
  final String id;
  final String label;
  final String name;
  final String house;
  final String street;
  final String town;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.house,
    required this.street,
    required this.town,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$house, $street, $town';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      label: json['label'] ?? 'Home',
      name: json['name'] ?? '',
      house: json['house'] ?? '',
      street: json['street'] ?? '',
      town: json['town'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'house': house,
      'street': street,
      'town': town,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}
