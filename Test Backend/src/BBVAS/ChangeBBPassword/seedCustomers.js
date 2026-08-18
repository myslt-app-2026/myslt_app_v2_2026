const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const Customer = require("./models/Customer"); 
require("dotenv").config({ path: "./.env" });


const customers = [
  {
    subscriberID: "94112270001",
    username: "Chamidu",
    email: "chamidu@example.com",
    password: "pass123",
  },
  {
    subscriberID: "94112270002",
    username: "Malsha",
    email: "malsha@example.com",
    password: "abc123",
  },
  {
    subscriberID: "94112270003",
    username: "Yohani",
    email: "yohani@example.com",
    password: "hello123",
  },
  {
    subscriberID: "94112270004",
    username: "Didula",
    email: "didula@example.com",
    password: "secure456",
  },
  {
    subscriberID: "94112270005",
    username: "Geeth",
    email: "geeth@example.com",
    password: "mypassword",
  },
  {
    subscriberID: "94112270006",
    username: "Pasindu",
    email: "pasindu@example.com",
    password: "welcome789",
  }
];

// Seed function
const seedDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log("MongoDB Connected ✅");

    // Clear existing customers
    await Customer.deleteMany();

    // Hash passwords
    const customerData = await Promise.all(
      customers.map(async (cust) => {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(cust.password, salt);
        return { ...cust, password: hashedPassword };
      })
    );

    // Insert
    await Customer.insertMany(customerData);

    console.log("✅ Customers seeded successfully!");
    process.exit();
  } catch (err) {
    console.error("❌ Error seeding data:", err.message);
    process.exit(1);
  }
};

seedDB();
