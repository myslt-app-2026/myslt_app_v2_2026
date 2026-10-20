import 'models/connection_package.dart';

/// Mock data for now. Replace the bodies with calls through your existing
/// Dio client (same pattern as the other features) once the endpoints are known.
class NewConnectionRepository {
  /// One-time new connection charge. TODO: get from API.
  static const int connectionCharge = 4500;

  Future<List<ConnectionPackage>> fetchPackages() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      ConnectionPackage(
        id: 'fibre_basic',
        name: 'Fibre Starter',
        type: 'Fibre',
        speedLabel: '50 Mbps',
        monthlyRental: 2990,
        features: ['Free Wi-Fi router', 'Night-time unlimited'],
      ),
      ConnectionPackage(
        id: 'fibre_unlimited',
        name: 'Fibre Unlimited',
        type: 'Fibre',
        speedLabel: '100 Mbps',
        monthlyRental: 5490,
        features: ['Free Wi-Fi 6 router', 'No data cap', 'Priority support'],
        recommended: true,
      ),
      ConnectionPackage(
        id: 'fibre_triple',
        name: 'Fibre Triple Play',
        type: 'Fibre Triple Play',
        speedLabel: '100 Mbps',
        monthlyRental: 7490,
        features: ['Internet + voice + PEO TV', 'Free Wi-Fi 6 router'],
      ),
    ];
  }

  Future<List<AddOn>> fetchAddOns() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      AddOn(
        id: 'peo_tv_silver',
        name: 'PEO TV Silver',
        description: 'Live channels and on-demand content',
        monthlyPrice: 1250,
      ),
      AddOn(
        id: 'home_voice',
        name: 'Home voice line',
        description: 'Fixed line with your fibre connection',
        monthlyPrice: 450,
      ),
      AddOn(
        id: 'wifi_mesh',
        name: 'Wi-Fi mesh extender',
        description: 'Better coverage for larger homes',
        monthlyPrice: 300,
      ),
    ];
  }
}
