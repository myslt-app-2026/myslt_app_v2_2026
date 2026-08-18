const mongoose = require('mongoose');
const dotenv = require('dotenv');
const BillDownloadRequest = require('./models/BillDownloadRequest');
const connectDB = require('../../config/db');

dotenv.config();

const seedData = [
  {
    eContact: "customer1@example.com",
    accountNo: "002969090X",
    ebillMonth: "2023/05",
    tpNo: "0112488102",
    fileUrl: "https://cdn.example.com/bills/002969090X-2023-05.pdf",
    description: "Customer 1 bill for May 2023",
    name: "BillOnCustomerDemand",
    billingAccount: {
      id: "A0815",
      "@type": "BillingAccountRef",
      "@referredType": "BillingAccount"
    },
    relatedParty: {
      role: "requester",
      "@type": "RelatedPartyRefOrRelatedPartyRoleRef",
      partyOrPartyRole: {
        id: "RP0815",
        "@referredType": "Individual",
        "@type": "PartyRef"
      }
    }
  },
  {
    eContact: "customer2@example.com",
    accountNo: "004567890Z",
    ebillMonth: "2023/06",
    tpNo: "0771234567",
    fileUrl: "https://cdn.example.com/bills/004567890Z-2023-06.pdf",
    description: "Customer 2 bill for June 2023",
    name: "BillOnCustomerDemand"
  }
];

const seedDatabase = async () => {
  try {
    await connectDB();

    console.log("🚀 Clearing old BillDownloadRequest documents...");
    await BillDownloadRequest.deleteMany({});

    console.log("🌱 Inserting seed data...");
    const created = await BillDownloadRequest.insertMany(seedData);

    console.log(`✅ Inserted ${created.length} documents`);
    process.exit(0);
  } catch (err) {
    console.error("❌ Error seeding data:", err);
    process.exit(1);
  }
};

seedDatabase();
