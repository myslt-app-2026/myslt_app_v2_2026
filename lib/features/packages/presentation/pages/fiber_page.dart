import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';

class FiberPage extends StatefulWidget {
  const FiberPage({super.key});

  @override
  State<FiberPage> createState() => _FiberPageState();
}

class _FiberPageState extends State<FiberPage> {
  final _dio = DioClient.instance.dio;
  late Future<List<Map<String, dynamic>>?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>?> _load() async {
  try {
    // Endpoint 39
    final cov = await _dio.post(
      ApiConstants.fiberCoverageCheck,
      data: {'place': {}},
    );
    debugPrint('[Fiber] 39 OK: ${cov.data}');
    final covered = cov.data is Map && cov.data['available'] == true;
    if (!covered) return null;

    // Endpoint 38
    final res = await _dio.get(ApiConstants.fiberPackageOfferings);
    debugPrint('[Fiber] 38 OK: ${res.data}');
    final data = res.data;
    final raw = data is Map ? data['productOffering'] : data;
    return (raw as List).whereType<Map<String, dynamic>>().toList();
  } on DioException catch (e) {
    debugPrint('[Fiber] FAILED: ${e.requestOptions.method} ${e.requestOptions.uri}');
    rethrow;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Fiber Broadband'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          if (snap.data == null) {
            return const Center(child: Text('Me location ekata Fiber coverage na'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: snap.data!
                .map((p) => Card(
                      child: ListTile(
                        title: Text(p['name']?.toString() ?? ''),
                        subtitle: Text(p['description']?.toString() ?? ''),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}