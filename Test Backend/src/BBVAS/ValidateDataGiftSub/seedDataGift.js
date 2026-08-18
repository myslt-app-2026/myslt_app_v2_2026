require("dotenv").config();
const mongoose = require("mongoose");
const connectDB = require("../../config/db");
const Customer = require("../../models/TMF629_Customer");
const Service = require("../../models/TMF638_ServiceModel");
const PartyRole = require("./models/PartyRole");

async function seed() {
  try
   {
    await connectDB();

    // Clear existing data
    await Customer.deleteMany({});
    await Service.deleteMany({});
    await PartyRole.deleteMany({});

    // Insert sample customer
    const customer = await Customer.create({
      id:     "CUST1001",
      status: "Approved",
      engagedParty: {
        id:              "P001",
        name:            "Chamidu Perera",
        "@referredType": "Individual",
        "@type":         "Individual"
      },
      contactMedium: [
        {
          mediumType: "phone",
          preferred:  true,
          characteristic: {
            phoneNumber: "0771234567"
          }
        }
      ],
      "@type": "Customer"
    });

    // Insert sample party role
    const sponsorRole = await PartyRole.create({
      id:   "PR2001",
      name: "Geeth Irosha",
      role: "Sponsor",
      engagedParty: {
        id:   "P002",
        name: "Geeth",
        "@type": "Individual"
      }
    });

    // Insert sample service
    const service = await Service.create({
      id:    "DG5001",
      state: "active",
      serviceSpecification: {
        id:    "SPEC001",
        name:  "DataGift",
        "@type": "MobileData"
      },
      serviceCharacteristic: [
        { name: "dataVolume", value: "5GB" },
        { name: "validity",   value: "7 Days" }
      ],
      "@type": "Service"
    });

    console.log("✅ Seeded Customer:", customer);
    console.log("✅ Seeded PartyRole:", sponsorRole);
    console.log("✅ Seeded Service:", service);

    mongoose.connection.close();

  } catch (err) {
    console.error("❌ Seeding error:", err.message);
    mongoose.connection.close();
  }
}

seed();