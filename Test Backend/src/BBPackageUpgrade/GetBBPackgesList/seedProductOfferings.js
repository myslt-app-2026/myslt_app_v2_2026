require('dotenv').config(); // Load .env if you have MONGO_URI there
const mongoose = require('mongoose');
const ProductOffering = require('./models/productOffering.model');

// Use MONGO_URI from .env if available, otherwise fallback to hardcoded string
const connectionString =
  process.env.MONGO_URI ||
  "mongodb+srv://omnichannelservicehub_db_user:OmniChannel@cluster0.jgutgzr.mongodb.net/OmniChannel?retryWrites=true&w=majority";
// Connect to MongoDB Atlas
mongoose
  .connect(connectionString, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => console.log("Connected to OmniChannel database ✅"))
  .catch(err => {
    console.error("Connection error ❌", err);
    process.exit(1);
  });

// Seed function
async function seed() {
  try {
    // Delete all existing documents (optional, clean start)
    await ProductOffering.deleteMany({});

    // Insert normalized TMF seed data
const seedData = [
  {
    bbType: "SLTFIBER",
    currentProductName: "ANYBLAZE",
    category: "upgrade",
    productOffering: {
      name: "Web Family Xtra",
      productOfferingCode: "Fiber-WFX"
    }
  },
  {
    bbType: "SLTFIBER",
    currentProductName: "ANYBLAZE",
    category: "downgrade",
    productOffering: {
      name: "Web Family Plus",
      productOfferingCode: "Fiber-WFP"
    }
  }
];


    await ProductOffering.insertMany(seedData);

    console.log("Seed completed successfully ✅");
  } catch (err) {
    console.error("Seed failed ❌", err);
  } finally {
    mongoose.connection.close();
    process.exit(0);
  }
}

// Run seed
seed();
