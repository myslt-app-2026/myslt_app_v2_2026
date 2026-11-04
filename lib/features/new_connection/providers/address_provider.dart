import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> sriLankaDistricts = [
  'Ampara',
  'Anuradhapura',
  'Badulla',
  'Batticaloa',
  'Colombo',
  'Galle',
  'Gampaha',
  'Hambantota',
  'Jaffna',
  'Kalutara',
  'Kandy',
  'Kegalle',
  'Kilinochchi',
  'Kurunegala',
  'Mannar',
  'Matale',
  'Matara',
  'Monaragala',
  'Mullaitivu',
  'Nuwara Eliya',
  'Polonnaruwa',
  'Puttalam',
  'Ratnapura',
  'Trincomalee',
  'Vavuniya',
];

class AddressState {
  const AddressState({
    this.houseNumberAndStreet = 'No. 55, Main Street',
    this.apartmentLandmark = '',
    this.city = 'Negombo',
    this.district = 'Gampaha',
    this.isChecking = false,
    this.isFibreAvailable = true,
  });

  final String houseNumberAndStreet;
  final String apartmentLandmark;
  final String city;
  final String district;
  final bool isChecking;
  final bool? isFibreAvailable;

  AddressState copyWith({
    String? houseNumberAndStreet,
    String? apartmentLandmark,
    String? city,
    String? district,
    bool? isChecking,
    bool? isFibreAvailable,
  }) =>
      AddressState(
        houseNumberAndStreet: houseNumberAndStreet ?? this.houseNumberAndStreet,
        apartmentLandmark: apartmentLandmark ?? this.apartmentLandmark,
        city: city ?? this.city,
        district: district ?? this.district,
        isChecking: isChecking ?? this.isChecking,
        isFibreAvailable: isFibreAvailable ?? this.isFibreAvailable,
      );
}

class AddressNotifier extends Notifier<AddressState> {
  @override
  AddressState build() => const AddressState();

  void update({
    String? houseNumberAndStreet,
    String? apartmentLandmark,
    String? city,
    String? district,
  }) {
    state = state.copyWith(
      houseNumberAndStreet: houseNumberAndStreet,
      apartmentLandmark: apartmentLandmark,
      city: city,
      district: district,
    );
  }

  Future<void> checkAvailability() async {
    state = state.copyWith(isChecking: true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      isChecking: false,
      isFibreAvailable: true,
    );
  }

  void reset() => state = const AddressState();
}

final addressProvider =
    NotifierProvider<AddressNotifier, AddressState>(AddressNotifier.new);

