// seed.j
const mongoose = require("mongoose");
require("dotenv").config({ path: require("path").resolve(__dirname, "../../../.env") });

console.log("MONGO_URI:", process.env.MONGO_URI); // Debug statement to verify MONGO_URI

// Import models
const Customer = require("./../../models/TMF629_Customer");
const BillingAccount = require("./../../models/TMF666_BillingAccount");

const seed = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log("✅ Connected to MongoDB");

    // Clear existing data
    console.log("🧹 Clearing old data...");
    await Customer.deleteMany({});
    await BillingAccount.deleteMany({});
    console.log("✅ Old data cleared");

    // Insert Customer
    const customer = await Customer.create({
      "id": "CUST1001",
      "href": "http://localhost:3000/tmf-api/customer/CUST1001",

      "status": "active",

      "engagedParty": {
        "id": "IND1001",
        "href": "http://localhost:3000/tmf-api/individual/IND1001",
        "name": "John Doe",
        "@referredType": "Individual",
        "@type": "IndividualRef"
      },

      "contactMedium": [
        {
          "mediumType": "mobile",
          "preferred": true,
          "characteristic": {
            "phoneNumber": "94771234567"
          }
        },
        {
          "mediumType": "email",
          "characteristic": {
            "emailAddress": "john.doe@example.com"
          }
        }
      ],

      "@type": "Customer",
      "@baseType": "PartyRole"
    });

    // Insert BillingAccount
    const billingAccount = await BillingAccount.create({
    "id": "BA12345",
    "href": "http://localhost:3000/tmf-api/accountManagement/v4/billingAccount/BA12345",
    "name": "Electricity Billing Account",
    "state": "active",
    "accountType": "billing",
    "relatedParty": [
      {
        "role": "Customer",
        "@type": "RelatedPartyRefOrPartyRoleRef",
        "partyOrPartyRole": {
          "id": "CUST1001",
          "href": "http://localhost:3000/tmf-api/customer/CUST1001",
          "name": "John Doe",
          "@referredType": "Individual",
          "@type": "PartyRefOrPartyRoleRef"
        }
      }
    ],
    "characteristic": [
      {
        "name": "billHandlingCode",
        "value": "2"
      }
    ],
    "@type": "BillingAccount"
  });

    console.log("✅ Seed data created:", { customer, billingAccount });
    process.exit();
  } catch (err) {
    console.error("❌ Seed error:", err);
    process.exit(1);
  }
};

seed();
