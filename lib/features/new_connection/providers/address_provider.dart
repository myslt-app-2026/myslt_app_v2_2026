import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/new_connection_repository.dart';
import 'new_connection_providers.dart';

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
    this.houseNumberAndStreet = '',
    this.apartmentLandmark = '',
    this.city = '',
    this.district,
    this.isChecking = false,
    this.coverageResult,
  });

  final String houseNumberAndStreet;
  final String apartmentLandmark;
  final String city;
  final String? district;
  final bool isChecking;
  final CoverageResult? coverageResult;

  bool? get isFibreAvailable => coverageResult?.available;

  AddressState copyWith({
    String? houseNumberAndStreet,
    String? apartmentLandmark,
    String? city,
    String? district,
    bool clearDistrict = false,
    bool? isChecking,
    CoverageResult? coverageResult,
    bool clearCoverage = false,
  }) =>
      AddressState(
        houseNumberAndStreet: houseNumberAndStreet ?? this.houseNumberAndStreet,
        apartmentLandmark: apartmentLandmark ?? this.apartmentLandmark,
        city: city ?? this.city,
        district: clearDistrict ? null : (district ?? this.district),
        isChecking: isChecking ?? this.isChecking,
        coverageResult:
            clearCoverage ? null : (coverageResult ?? this.coverageResult),
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
    final addressChanged = (houseNumberAndStreet != null &&
            houseNumberAndStreet != state.houseNumberAndStreet) ||
        (city != null && city != state.city) ||
        (district != null && district != state.district);

    state = state.copyWith(
      houseNumberAndStreet: houseNumberAndStreet,
      apartmentLandmark: apartmentLandmark,
      city: city,
      district: district,
      clearCoverage: addressChanged,
    );
  }

  Future<CoverageResult> checkAvailability({
    required String street,
    String? landmark,
    required String city,
    required String district,
  }) async {
    state = state.copyWith(isChecking: true);
    final repo = ref.read(newConnectionRepositoryProvider);
    final result = await repo.checkCoverage(
      street: street,
      landmark: landmark,
      city: city,
      district: district,
    );
    state = state.copyWith(
      isChecking: false,
      houseNumberAndStreet: street,
      apartmentLandmark: landmark ?? state.apartmentLandmark,
      city: city,
      district: district,
      coverageResult: result,
    );
    return result;
  }

  void reset() => state = const AddressState();
}

final addressProvider =
    NotifierProvider<AddressNotifier, AddressState>(AddressNotifier.new);
