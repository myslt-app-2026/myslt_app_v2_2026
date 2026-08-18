require("dotenv").config();
const mongoose = require("mongoose");
const Contact = require("./models/contact.model.js");

async function seed() {
  const MONGO_URI = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/tmfdb";
  await mongoose.connect(MONGO_URI);

  await Contact.deleteMany({});

  await Contact.insertMany([
    {
      id: "1",
      partyId: "P001",
      contactType: "email",
      emailAddress: "alice@example.com",
      preferred: true,
      status: "active",
    },
    {
      id: "2",
      partyId: "P002",
      contactType: "mobile",
      phoneNumber: "0722222222",
      preferred: false,
      status: "active",
    },
    {
      id: "3",
      partyId: "P003",
      contactType: "postal",
      address: {
        street: "789 Kandy Road",
        city: "Kandy",
        country: "Sri Lanka",
      },
      preferred: false,
      status: "inactive",
    },
  ]);

  console.log("✅ Seed data inserted");
  mongoose.connection.close();
}

seed();
