import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/home/data/models/account_summary_model.dart';
import '../../features/home/data/models/promotion_model.dart';
import '../../features/home/data/models/notification_model.dart';
import '../../features/bill/data/models/bill_model.dart';
import '../../features/packages/data/models/package_model.dart';
import '../../features/usage/data/models/usage_model.dart';
import '../../features/connections/data/models/connection_model.dart';
import '../../features/peotv/data/models/peotv_package_model.dart';
import '../../features/more/data/models/loyalty_model.dart';
import '../../features/more/data/models/idd_model.dart';
import '../../features/more/data/models/shop_location_model.dart';

/// Centralized mock data for the mySLT demo application.
/// Replace with real API responses in production.
abstract final class MockData {
  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const UserEntity currentUser = UserEntity(
    id: 'usr_001',
    name: 'Kasun Perera',
    nic: '199012345678',
    mobile: '0771234567',
    email: 'kasun.perera@gmail.com',
    accountNumber: 'ACC-0094-7821',
  );

  // ─── Account Summary ──────────────────────────────────────────────────────
  static AccountSummaryModel get accountSummary => AccountSummaryModel(
        accountNumber: 'ACC-0094-7821',
        planName: 'SLT Fiber Max 100',
        totalDataMB: 102400, // 100 GB
        usedDataMB: 63488,   // 62 GB
        bonusDataMB: 5120,   // 5 GB
        nightDataMB: 20480,  // 20 GB
        nightDataUsedMB: 8192,
        freeMinutes: 120,
        usedMinutes: 45,
        expiryDate: DateTime.now().add(const Duration(days: 18)),
        accountType: 'Postpaid Fiber',
        isActive: true,
      );

  // ─── Promotions ───────────────────────────────────────────────────────────
  static List<PromotionModel> get promotions => [
        PromotionModel(
          id: 'promo_001',
          title: 'Double Your Data This Weekend!',
          subtitle: 'Activate any package and get 2x data',
          imageUrl: 'https://picsum.photos/800/400?random=1',
          ctaLabel: 'Get Now',
          ctaUrl: '#',
          badgeLabel: 'Limited',
          badgeColor: 0xFFEF4444,
          expiryDate: DateTime.now().add(const Duration(days: 3)),
        ),
        PromotionModel(
          id: 'promo_002',
          title: 'SLT PeoTV Premium — Free 1 Month',
          subtitle: 'Subscribe to any fiber package and enjoy PeoTV Premium',
          imageUrl: 'https://picsum.photos/800/400?random=2',
          ctaLabel: 'Learn More',
          ctaUrl: '#',
          badgeLabel: 'New',
          badgeColor: 0xFF22C55E,
          expiryDate: DateTime.now().add(const Duration(days: 15)),
        ),
        PromotionModel(
          id: 'promo_003',
          title: 'Loyalty Rewards — Earn More Points',
          subtitle: '5x points on every package purchase this month',
          imageUrl: 'https://picsum.photos/800/400?random=3',
          ctaLabel: 'View Rewards',
          ctaUrl: '#',
          badgeLabel: 'Offer',
          badgeColor: 0xFFF59E0B,
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        ),
      ];

  // ─── Bills ────────────────────────────────────────────────────────────────
  static BillModel get currentBill => BillModel(
        billId: 'BILL-2026-07',
        amount: 4850.00,
        dueDate: DateTime.now().add(const Duration(days: 8)),
        issueDate: DateTime.now().subtract(const Duration(days: 7)),
        period: 'July 2026',
        status: BillStatus.unpaid,
        accountNumber: 'ACC-0094-7821',
      );

  static List<BillModel> get billHistory => [
        BillModel(
          billId: 'BILL-2026-06',
          amount: 4850.00,
          dueDate: DateTime.now().subtract(const Duration(days: 22)),
          issueDate: DateTime.now().subtract(const Duration(days: 37)),
          period: 'June 2026',
          status: BillStatus.paid,
          paidDate: DateTime.now().subtract(const Duration(days: 25)),
          accountNumber: 'ACC-0094-7821',
        ),
        BillModel(
          billId: 'BILL-2026-05',
          amount: 5200.00,
          dueDate: DateTime.now().subtract(const Duration(days: 52)),
          issueDate: DateTime.now().subtract(const Duration(days: 67)),
          period: 'May 2026',
          status: BillStatus.paid,
          paidDate: DateTime.now().subtract(const Duration(days: 55)),
          accountNumber: 'ACC-0094-7821',
        ),
        BillModel(
          billId: 'BILL-2026-04',
          amount: 4200.00,
          dueDate: DateTime.now().subtract(const Duration(days: 82)),
          issueDate: DateTime.now().subtract(const Duration(days: 97)),
          period: 'April 2026',
          status: BillStatus.paid,
          paidDate: DateTime.now().subtract(const Duration(days: 84)),
          accountNumber: 'ACC-0094-7821',
        ),
        BillModel(
          billId: 'BILL-2026-03',
          amount: 4850.00,
          dueDate: DateTime.now().subtract(const Duration(days: 112)),
          issueDate: DateTime.now().subtract(const Duration(days: 127)),
          period: 'March 2026',
          status: BillStatus.paid,
          paidDate: DateTime.now().subtract(const Duration(days: 115)),
          accountNumber: 'ACC-0094-7821',
        ),
      ];

  // ─── Usage ────────────────────────────────────────────────────────────────
  static List<HourlyUsageModel> get todayHourlyUsage => List.generate(24, (hour) {
        final baseUsage = hour >= 8 && hour <= 23
            ? (hour >= 20 ? 800.0 : (hour >= 12 ? 400.0 : 150.0))
            : 20.0;
        return HourlyUsageModel(
          hour: hour,
          usedMB: baseUsage + (hour * 13.7) % 200,
          downloadMB: (baseUsage * 0.7) + (hour * 8.3) % 150,
          uploadMB: (baseUsage * 0.3) + (hour * 5.4) % 50,
        );
      });

  static List<DailyUsageModel> get monthlyUsage => List.generate(30, (i) {
        final day = DateTime.now().subtract(Duration(days: 29 - i));
        final base = 1500.0 + (i * 83.7) % 2000;
        return DailyUsageModel(
          date: day,
          usedMB: base,
          streamingMB: base * 0.45,
          browsingMB: base * 0.25,
          socialMB: base * 0.20,
          gamingMB: base * 0.07,
          otherMB: base * 0.03,
        );
      });

  // ─── Packages ─────────────────────────────────────────────────────────────
  static List<PackageModel> get prepaidDataPackages => [
        PackageModel(
          id: 'pkg_p_d1',
          name: 'Daily Boost 1GB',
          description: '1 GB data valid for 24 hours',
          price: 75.00,
          dataMB: 1024,
          validityDays: 1,
          type: PackageType.prepaidData,
          isActive: false,
          tag: 'Popular',
        ),
        PackageModel(
          id: 'pkg_p_d2',
          name: 'Weekly 5GB',
          description: '5 GB data valid for 7 days',
          price: 299.00,
          dataMB: 5120,
          validityDays: 7,
          type: PackageType.prepaidData,
          isActive: true,
          tag: 'Best Value',
          tagColor: 0xFF22C55E,
        ),
        PackageModel(
          id: 'pkg_p_d3',
          name: 'Monthly 20GB',
          description: '20 GB data valid for 30 days',
          price: 999.00,
          dataMB: 20480,
          validityDays: 30,
          type: PackageType.prepaidData,
          isActive: false,
        ),
        PackageModel(
          id: 'pkg_p_d4',
          name: 'Super 50GB',
          description: '50 GB data + 10 GB night data for 30 days',
          price: 1999.00,
          dataMB: 51200,
          bonusDataMB: 10240,
          validityDays: 30,
          type: PackageType.prepaidData,
          isActive: false,
          tag: 'New',
          tagColor: 0xFF3B82F6,
        ),
      ];

  static List<PackageModel> get prepaidVoicePackages => [
        PackageModel(
          id: 'pkg_p_v1',
          name: 'Talk 30',
          description: '30 minutes to any network',
          price: 45.00,
          freeMinutes: 30,
          validityDays: 1,
          type: PackageType.prepaidVoice,
          isActive: false,
        ),
        PackageModel(
          id: 'pkg_p_v2',
          name: 'Talk 200',
          description: '200 minutes to any network, 7 days',
          price: 199.00,
          freeMinutes: 200,
          validityDays: 7,
          type: PackageType.prepaidVoice,
          isActive: true,
          tag: 'Active',
          tagColor: 0xFF22C55E,
        ),
      ];

  static List<PackageModel> get postpaidPackages => [
        PackageModel(
          id: 'pkg_po_1',
          name: 'Fiber 25',
          description: '25 Mbps unlimited fiber with 100GB FUP',
          price: 2999.00,
          dataMB: 102400,
          type: PackageType.postpaidFiber,
          isActive: false,
          speed: '25 Mbps',
        ),
        PackageModel(
          id: 'pkg_po_2',
          name: 'Fiber Max 100',
          description: '100 Mbps fiber with 200GB FUP + 5GB bonus',
          price: 4850.00,
          dataMB: 204800,
          bonusDataMB: 5120,
          type: PackageType.postpaidFiber,
          isActive: true,
          tag: 'Your Plan',
          tagColor: 0xFF003087,
          speed: '100 Mbps',
        ),
        PackageModel(
          id: 'pkg_po_3',
          name: 'Fiber Pro 200',
          description: '200 Mbps fiber with unlimited data',
          price: 7999.00,
          dataMB: -1, // unlimited
          type: PackageType.postpaidFiber,
          isActive: false,
          tag: 'Unlimited',
          tagColor: 0xFF7C3AED,
          speed: '200 Mbps',
        ),
      ];

  // ─── Connections ──────────────────────────────────────────────────────────
  static List<ConnectionModel> get connections => [
        ConnectionModel(
          id: 'conn_001',
          accountNumber: 'ACC-0094-7821',
          name: 'Home Fiber',
          type: ConnectionType.fiber,
          isActive: true,
          planName: 'Fiber Max 100',
        ),
        ConnectionModel(
          id: 'conn_002',
          accountNumber: 'MOB-077-1234567',
          name: 'Personal Mobile',
          type: ConnectionType.mobile,
          isActive: false,
          planName: 'Mobitel Postpaid 10GB',
        ),
        ConnectionModel(
          id: 'conn_003',
          accountNumber: 'ACC-0094-3312',
          name: 'Office Fiber',
          type: ConnectionType.fiber,
          isActive: false,
          planName: 'Fiber Pro 200',
        ),
      ];

  // ─── PeoTV ────────────────────────────────────────────────────────────────
  static List<PeoTVPackageModel> get peoTVPackages => [
        PeoTVPackageModel(
          id: 'ptv_001',
          name: 'Basic Pack',
          description: 'Essential Sri Lankan channels + DD India',
          price: 350.00,
          channelCount: 52,
          isActive: false,
          imageUrl: 'https://picsum.photos/120/80?random=10',
          channels: ['Sirasa TV', 'Rupavahini', 'ITN', 'Swarnavahini', 'MTV', 'Derana'],
        ),
        PeoTVPackageModel(
          id: 'ptv_002',
          name: 'Entertainment Pack',
          description: 'HD movies, sports, and entertainment channels',
          price: 650.00,
          channelCount: 110,
          isActive: true,
          imageUrl: 'https://picsum.photos/120/80?random=11',
          channels: ['Star Movies', 'HBO', 'Sony LIV', 'Star Sports', 'ESPN', 'Nat Geo'],
          tag: 'Active',
        ),
        PeoTVPackageModel(
          id: 'ptv_003',
          name: 'Premium Pack',
          description: 'Full HD + 4K channels, unlimited streaming',
          price: 1200.00,
          channelCount: 200,
          isActive: false,
          imageUrl: 'https://picsum.photos/120/80?random=12',
          channels: ['Discovery 4K', 'Nat Geo Wild', 'Animal Planet', 'History HD'],
          tag: 'Premium',
          tagColor: 0xFF7C3AED,
        ),
      ];

  // ─── Loyalty Points ────────────────────────────────────────────────────
  static LoyaltyPointsModel get loyaltyPoints => LoyaltyPointsModel(
        totalPoints: 4250,
        redeemablePoints: 3800,
        tier: LoyaltyTier.gold,
        nextTierPoints: 5000,
        history: [
          LoyaltyHistoryEntry(
            id: 'lp_001',
            description: 'Bill Payment — July 2026',
            points: 485,
            date: DateTime.now().subtract(const Duration(days: 2)),
            isEarned: true,
          ),
          LoyaltyHistoryEntry(
            id: 'lp_002',
            description: 'Package Purchase — Weekly 5GB',
            points: 150,
            date: DateTime.now().subtract(const Duration(days: 5)),
            isEarned: true,
          ),
          LoyaltyHistoryEntry(
            id: 'lp_003',
            description: 'Data Redemption — 500MB',
            points: -200,
            date: DateTime.now().subtract(const Duration(days: 8)),
            isEarned: false,
          ),
          LoyaltyHistoryEntry(
            id: 'lp_004',
            description: 'Bill Payment — June 2026',
            points: 485,
            date: DateTime.now().subtract(const Duration(days: 32)),
            isEarned: true,
          ),
          LoyaltyHistoryEntry(
            id: 'lp_005',
            description: 'Referral Bonus',
            points: 500,
            date: DateTime.now().subtract(const Duration(days: 45)),
            isEarned: true,
          ),
          LoyaltyHistoryEntry(
            id: 'lp_006',
            description: 'Gift Data — 1GB to 0771234567',
            points: -400,
            date: DateTime.now().subtract(const Duration(days: 50)),
            isEarned: false,
          ),
        ],
      );

  static List<RedeemablePackage> get redeemablePackages => [
        const RedeemablePackage(
          id: 'rdm_001',
          name: '500 MB',
          description: 'Valid for 3 days',
          pointsCost: 200,
          dataMB: 512,
          validityDays: 3,
        ),
        const RedeemablePackage(
          id: 'rdm_002',
          name: '1 GB',
          description: 'Valid for 7 days',
          pointsCost: 350,
          dataMB: 1024,
          validityDays: 7,
        ),
        const RedeemablePackage(
          id: 'rdm_003',
          name: '3 GB',
          description: 'Valid for 14 days',
          pointsCost: 900,
          dataMB: 3072,
          validityDays: 14,
        ),
        const RedeemablePackage(
          id: 'rdm_004',
          name: '5 GB',
          description: 'Valid for 30 days',
          pointsCost: 1400,
          dataMB: 5120,
          validityDays: 30,
        ),
      ];

  // ─── Notifications ─────────────────────────────────────────────────────
  static List<NotificationModel> get notifications => [
        NotificationModel(
          id: 'notif_001',
          title: 'Bill Payment Due',
          body: 'Your July 2026 bill of Rs. 4,850.00 is due in 8 days. Pay now to avoid late charges.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: NotificationType.bill,
        ),
        NotificationModel(
          id: 'notif_002',
          title: 'Data Usage Alert',
          body: 'You have used 62% of your monthly data allowance. 38 GB remaining.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          type: NotificationType.usage,
          isRead: true,
        ),
        NotificationModel(
          id: 'notif_003',
          title: 'Double Data Weekend!',
          body: 'Activate any data package this weekend and get 2x data. Offer valid till Sunday.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: NotificationType.promo,
        ),
        NotificationModel(
          id: 'notif_004',
          title: 'Happy Day Reward Available',
          body: 'Your weekly reward is ready! Scratch to reveal your prize.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
          type: NotificationType.reward,
        ),
        NotificationModel(
          id: 'notif_005',
          title: 'System Maintenance',
          body: 'Scheduled maintenance on July 25, 2026 from 2:00 AM to 5:00 AM. Services may be briefly interrupted.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: NotificationType.system,
          isRead: true,
        ),
        NotificationModel(
          id: 'notif_006',
          title: 'Loyalty Points Earned',
          body: 'You earned 485 loyalty points for your June bill payment. Total: 4,250 points.',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          type: NotificationType.reward,
          isRead: true,
        ),
        NotificationModel(
          id: 'notif_007',
          title: 'Speed Upgrade Available',
          body: 'Upgrade to Fiber Pro 200 Mbps for just Rs. 3,149/month more. Unlimited data included!',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          type: NotificationType.promo,
          isRead: true,
        ),
      ];

  // ─── IDD Rates ─────────────────────────────────────────────────────────
  static List<IDDRateModel> get iddRates => const [
        IDDRateModel(countryCode: 'IN', countryName: 'India', flag: '🇮🇳', ratePerMin: 5.50, peakRate: 7.00, offPeakRate: 4.00),
        IDDRateModel(countryCode: 'US', countryName: 'United States', flag: '🇺🇸', ratePerMin: 8.00, peakRate: 10.00, offPeakRate: 6.00),
        IDDRateModel(countryCode: 'GB', countryName: 'United Kingdom', flag: '🇬🇧', ratePerMin: 9.50, peakRate: 12.00, offPeakRate: 7.50),
        IDDRateModel(countryCode: 'AU', countryName: 'Australia', flag: '🇦🇺', ratePerMin: 10.00, peakRate: 13.00, offPeakRate: 8.00),
        IDDRateModel(countryCode: 'AE', countryName: 'UAE', flag: '🇦🇪', ratePerMin: 12.00, peakRate: 15.00, offPeakRate: 9.00),
        IDDRateModel(countryCode: 'SG', countryName: 'Singapore', flag: '🇸🇬', ratePerMin: 7.50, peakRate: 9.50, offPeakRate: 5.50),
        IDDRateModel(countryCode: 'JP', countryName: 'Japan', flag: '🇯🇵', ratePerMin: 11.00, peakRate: 14.00, offPeakRate: 8.50),
        IDDRateModel(countryCode: 'KR', countryName: 'South Korea', flag: '🇰🇷', ratePerMin: 10.50, peakRate: 13.50, offPeakRate: 8.00),
        IDDRateModel(countryCode: 'CA', countryName: 'Canada', flag: '🇨🇦', ratePerMin: 8.50, peakRate: 11.00, offPeakRate: 6.50),
        IDDRateModel(countryCode: 'DE', countryName: 'Germany', flag: '🇩🇪', ratePerMin: 9.00, peakRate: 11.50, offPeakRate: 7.00),
        IDDRateModel(countryCode: 'IT', countryName: 'Italy', flag: '🇮🇹', ratePerMin: 9.50, peakRate: 12.00, offPeakRate: 7.50),
        IDDRateModel(countryCode: 'MY', countryName: 'Malaysia', flag: '🇲🇾', ratePerMin: 6.00, peakRate: 8.00, offPeakRate: 4.50),
      ];

  static List<IDDPackageModel> get iddPackages => const [
        IDDPackageModel(
          id: 'idd_pkg_001',
          name: 'IDD India 100',
          description: '100 minutes to India landline & mobile',
          price: 299.00,
          minutes: 100,
          countries: ['India'],
          validityDays: 30,
          isActive: true,
        ),
        IDDPackageModel(
          id: 'idd_pkg_002',
          name: 'IDD Global 50',
          description: '50 minutes to any 12 countries',
          price: 499.00,
          minutes: 50,
          countries: ['US', 'UK', 'Australia', 'Canada'],
          validityDays: 30,
        ),
        IDDPackageModel(
          id: 'idd_pkg_003',
          name: 'IDD Asia 200',
          description: '200 minutes to India, Singapore, Malaysia',
          price: 599.00,
          minutes: 200,
          countries: ['India', 'Singapore', 'Malaysia'],
          validityDays: 30,
        ),
      ];

  // ─── Shop Locations ────────────────────────────────────────────────────
  static List<ShopLocationModel> get shopLocations => const [
        ShopLocationModel(
          id: 'shop_001',
          name: 'SLT Flagship — Lotus Tower',
          address: 'Lotus Road, Colombo 01',
          city: 'Colombo',
          phone: '011 2021000',
          hours: '8:30 AM – 5:00 PM',
          latitude: 6.9271,
          longitude: 79.8612,
          isOpen: true,
          distanceKm: 1.2,
        ),
        ShopLocationModel(
          id: 'shop_002',
          name: 'SLT Regional — Bambalapitiya',
          address: '15, Galle Road, Bambalapitiya',
          city: 'Colombo',
          phone: '011 2582100',
          hours: '8:30 AM – 4:30 PM',
          latitude: 6.8879,
          longitude: 79.8560,
          isOpen: true,
          distanceKm: 3.5,
        ),
        ShopLocationModel(
          id: 'shop_003',
          name: 'SLT Teleshop — Nugegoda',
          address: '23, High Level Road, Nugegoda',
          city: 'Nugegoda',
          phone: '011 2813600',
          hours: '8:30 AM – 4:30 PM',
          latitude: 6.8726,
          longitude: 79.8891,
          isOpen: true,
          distanceKm: 5.8,
        ),
        ShopLocationModel(
          id: 'shop_004',
          name: 'SLT Regional — Kandy',
          address: '36, Dalada Veediya, Kandy',
          city: 'Kandy',
          phone: '081 2222100',
          hours: '8:30 AM – 4:00 PM',
          latitude: 7.2906,
          longitude: 80.6337,
          isOpen: false,
          distanceKm: 115.0,
        ),
        ShopLocationModel(
          id: 'shop_005',
          name: 'SLT Teleshop — Maharagama',
          address: '45, High Level Road, Maharagama',
          city: 'Maharagama',
          phone: '011 2849200',
          hours: '8:30 AM – 4:30 PM',
          latitude: 6.8484,
          longitude: 79.9263,
          isOpen: true,
          distanceKm: 8.2,
        ),
        ShopLocationModel(
          id: 'shop_006',
          name: 'SLT Regional — Galle',
          address: '12, Main Street, Galle Fort',
          city: 'Galle',
          phone: '091 2234100',
          hours: '8:30 AM – 4:00 PM',
          latitude: 6.0320,
          longitude: 80.2167,
          isOpen: true,
          distanceKm: 120.0,
        ),
      ];
}

