require('dotenv').config();
const mongoose = require('mongoose');
const UsageSummary = require('./models/Dashboard');

const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/OmniChannel';

// TMF 635 UsageSummary sample data
const sampleUsageSummaries = [
  {
    id: "1",
    href: "http://localhost:3000/api/Dashboard/GetExtraGBDashboard/1",
    "@type": "UsageSummary",
    name: "Extra GB Usage Summary",
    description: "Overall extra GB data usage summary",
    bucket: [
      {
        bucketType: "data",
        totalValue: {
          amount: 5000,
          units: "GB"
        },
        usedValue: {
          amount: 3200,
          units: "GB"
        },
        remainingValue: {
          amount: 1800,
          units: "GB"
        },
        validFor: {
          startDateTime: new Date("2026-01-01"),
          endDateTime: new Date("2026-01-31")
        }
      }
    ],
    status: "active",
    usageCharacteristic: [
      {
        name: "activePackages",
        value: 150
      },
      {
        name: "totalUsers",
        value: 1250
      }
    ]
  },
  {
    id: "2",
    href: "http://localhost:3000/api/Dashboard/GetExtraGBDashboard/2",
    "@type": "UsageSummary",
    name: "Monthly Extra GB Allocation",
    description: "Total monthly extra GB allocation and usage",
    bucket: [
      {
        bucketType: "data",
        totalValue: {
          amount: 10000,
          units: "GB"
        },
        usedValue: {
          amount: 6500,
          units: "GB"
        },
        remainingValue: {
          amount: 3500,
          units: "GB"
        },
        validFor: {
          startDateTime: new Date("2026-01-01"),
          endDateTime: new Date("2026-01-31")
        }
      }
    ],
    status: "active",
    usageCharacteristic: [
      {
        name: "activePackages",
        value: 280
      },
      {
        name: "totalUsers",
        value: 2100
      }
    ]
  }
];

async function seedUsageSummaries() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('✅ MongoDB connected');

    await UsageSummary.deleteMany({});
    console.log('🗑️  Cleared existing usage summaries');

    await UsageSummary.insertMany(sampleUsageSummaries);
    console.log(`✅ Inserted ${sampleUsageSummaries.length} TMF 635 usage summaries`);

    console.log('\n📋 Sample usage summaries:');
    sampleUsageSummaries.forEach(summary => {
      console.log(`  - ID: ${summary.id}, Name: ${summary.name}`);
    });

    console.log('\n✅ Dashboard seeding completed!');
    console.log('\n🔗 Test the endpoint:');
    console.log('GET http://localhost:3000/api/Dashboard/GetExtraGBDashboard');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding usage summaries:', error);
    process.exit(1);
  }
}

seedUsageSummaries();
