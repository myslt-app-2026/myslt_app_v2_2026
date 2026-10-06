import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/repositories/fault_repository.dart';

class TrackTicketPage extends StatefulWidget {
  const TrackTicketPage({super.key, this.initialTicketId});

  final String? initialTicketId;

  @override
  State<TrackTicketPage> createState() => _TrackTicketPageState();
}

class _TrackTicketPageState extends State<TrackTicketPage> {
  final _faultRepository = FaultRepository();
  late final TextEditingController _ticketIdCtrl;

  Map<String, dynamic>? _ticketData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ticketIdCtrl = TextEditingController(text: widget.initialTicketId ?? 'TT10294');
    _fetchTicketDetails();
  }

  @override
  void dispose() {
    _ticketIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchTicketDetails() async {
    final ticketId = _ticketIdCtrl.text.trim();
    if (ticketId.isEmpty) return;

    setState(() => _isLoading = true);
    final data = await _faultRepository.getTroubleTicketStatus(ticketId: ticketId);

    if (!mounted) return;
    setState(() {
      _ticketData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Track Trouble Ticket', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Box
            Text('Search Trouble Ticket', style: AppTextStyles.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ticketIdCtrl,
                    decoration: InputDecoration(
                      hintText: 'Enter Ticket Reference (e.g. TT10294)',
                      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                      prefixIcon: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    ),
                  ),
                  onPressed: _fetchTicketDetails,
                  child: const Text('Track'),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.xl),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl2),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_ticketData != null) ...[
              // Ticket Header Details Card
              _buildTicketHeaderCard(_ticketData!).animate().fadeIn(duration: 300.ms, delay: 50.ms),
              const SizedBox(height: AppSpacing.xl),

              // Progress Timeline Section
              Text('Resolution Timeline', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.md),
              _buildTimelineSection(_ticketData!).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              const SizedBox(height: AppSpacing.xl2),

              // Action Buttons
              AppButton(
                label: 'Call Technical Support (1212)',
                icon: Icons.phone_forwarded_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dialing SLT Support Hotline 1212...'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeaderCard(Map<String, dynamic> data) {
    final ticketId = data['ticketId'] ?? 'TT10294';
    final status = data['status'] ?? 'In Progress';
    final category = data['category'] ?? 'Broadband';
    final description = data['description'] ?? '';
    final reportedDate = data['reportedDate'] ?? '';
    final expectedResolution = data['expectedResolution'] ?? '';
    final technicianName = data['technicianName'] ?? 'Assigned Team';

    Color statusColor = AppColors.warning;
    Color statusBg = AppColors.warningLight;
    if (status == 'Resolved') {
      statusColor = AppColors.success;
      statusBg = AppColors.successLight;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TICKET REFERENCE', style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(
                    ticketId,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync_rounded, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow('Issue Category:', category),
          const SizedBox(height: 6),
          _buildInfoRow('Description:', description),
          const SizedBox(height: 6),
          _buildInfoRow('Reported Date:', reportedDate),
          const SizedBox(height: 6),
          _buildInfoRow('Est. Resolution:', expectedResolution, isHighlight: true),
          const SizedBox(height: 6),
          _buildInfoRow('Technician:', technicianName),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isHighlight ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection(Map<String, dynamic> data) {
    final List steps = data['steps'] is List ? data['steps'] as List : [];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = Map<String, dynamic>.from(steps[index] as Map);
          final title = step['title']?.toString() ?? 'Step ${index + 1}';
          final date = step['date']?.toString() ?? '';
          final isDone = step['isDone'] == true;
          final isLast = index == steps.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.success : AppColors.dividerLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone ? Icons.check : Icons.more_horiz,
                        size: 14,
                        color: isDone ? Colors.white : AppColors.textTertiary,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isDone ? AppColors.success : AppColors.dividerLight,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                            color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(date, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
