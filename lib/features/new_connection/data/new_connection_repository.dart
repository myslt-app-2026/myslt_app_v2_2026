import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import 'models/connection_package.dart';

class CoverageResult {
  const CoverageResult({
    required this.available,
    required this.title,
    required this.subtitle,
  });

  final bool available;
  final String title;
  final String subtitle;
}

/// Mock data and API client for the new-connection flow.
class NewConnectionRepository {
  /// One-time new connection charge.
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

  /// Check fibre coverage for the specified address via the Coverage API.
  Future<CoverageResult> checkCoverage({
    required String street,
    String? landmark,
    required String city,
    required String district,
  }) async {
    try {
      final res = await DioClient.instance.dio.post(
        ApiConstants.fiberCoverageCheck,
        data: {
          'place': {
            'street': street,
            'landmark': landmark ?? '',
            'city': city,
            'district': district,
          },
        },
      );

      final data = res.data;
      final bool isAvailable =
          (data is Map && (data['available'] == true || data['covered'] == true));
      final String title = data is Map && data['title'] != null
          ? data['title'].toString()
          : (isAvailable ? 'Fibre available' : 'Fibre coverage not available');
      final String subtitle = data is Map && data['message'] != null
          ? data['message'].toString()
          : (isAvailable
              ? 'Continue to choose an installation time.'
              : 'Fibre broadband is not currently available at this location.');

      return CoverageResult(
        available: isAvailable,
        title: title,
        subtitle: subtitle,
      );
    } on DioException catch (e) {
      debugPrint('[Coverage API] DioException: ${e.message}');
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        final bool isAvailable =
            data['available'] == true || data['covered'] == true;
        return CoverageResult(
          available: isAvailable,
          title: data['title']?.toString() ??
              (isAvailable ? 'Fibre available' : 'Fibre coverage not available'),
          subtitle: data['message']?.toString() ??
              (isAvailable
                  ? 'Continue to choose an installation time.'
                  : 'Fibre broadband is not currently available at this location.'),
        );
      }

      // Fallback for development/testing when backend endpoint is offline:
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return const CoverageResult(
        available: true,
        title: 'Fibre available',
        subtitle: 'Continue to choose an installation time.',
      );
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return const CoverageResult(
        available: true,
        title: 'Fibre available',
        subtitle: 'Continue to choose an installation time.',
      );
    }
  }
}
