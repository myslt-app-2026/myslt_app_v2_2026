require("dotenv").config();
const mongoose = require("mongoose");
const ISPContact = require("../models/customer.model");
const connectDB = require("../../../config/db");

const customerData = [
  {
    id: "cus12345",
    href: "/tmf-api/customerManagement/v5/customer/cus12345",
    name: "John Doe",
    relatedParty: [
      {
        id: "rp_001",
        href: "/tmf-api/partyRoleManagement/v5/partyRole/rp_001",
        name: "SLT-Mobitel",
        role: "Internet Service Provider",
      },
    ],
    contactMedium: [
      {
        id: "cm_001",
        mediumType: "Email",
        isDefault: true,
        characteristic: {
          emailAddress: "john.doe@example.com",
        },
      },
      {
        id: "cm_002",
        mediumType: "Mobile",
        isDefault: false,
        characteristic: {
          phoneNumber: "+94711234567",
        },
      },
    ],
    status: "Active",
  },
  {
    id: "cus12346",
    href: "/tmf-api/customerManagement/v5/customer/cus12346",
    name: "Jane Smith",
    relatedParty: [
      {
        id: "rp_002",
        href: "/tmf-api/partyRoleManagement/v5/partyRole/rp_002",
        name: "SLT-Mobitel",
        role: "Internet Service Provider",
      },
    ],
    contactMedium: [
      {
        id: "cm_003",
        mediumType: "Email",
        isDefault: true,
        characteristic: {
          emailAddress: "jane.smith@example.com",
        },
      },
    ],
    status: "Active",
  },
];

const seedCustomers = async () => {
  try {
    await connectDB();
    await ISPContact.deleteMany({});
    console.log("✅ Existing customer data cleared successfully.");
    await ISPContact.insertMany(customerData);
    console.log("✅ Seed data inserted successfully.");
  } catch (error) {
    console.error("❌ Error seeding data:", error.message);
    process.exit(1);
  } finally {
    mongoose.connection.close();
  }
};

seedCustomers();