const mongoose = require('mongoose');
const dotenv = require('dotenv');
const ServiceRequest = require('./models/ServiceRequest'); // ✅ fixed path

dotenv.config();

mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(async () => {
  console.log("✅ MongoDB connected for seeding");

  // Sample data
  const sampleRequests = [
    {
      description: "Internet not working",
      SRType: "Fault",
      INSArea: "Network",
      INSSubArea: "Fiber",
      ServiceId: "SR001",
      TTSource: "Customer",
      note: "Customer called helpline",
      notetype: "Issue"
    },
    {
      description: "Slow broadband speed",
      SRType: "Fault",
      INSArea: "Network",
      INSSubArea: "DSL",
      ServiceId: "SR002",
      TTSource: "App",
      note: "Logged via mobile app",
      notetype: "Performance"
    }
  ];

  await ServiceRequest.deleteMany(); // clear old data
  await ServiceRequest.insertMany(sampleRequests);

  console.log("🌱 Database seeded with sample ServiceRequests");
  process.exit();
})
.catch(err => {
  console.error("❌ Seeding error:", err);
  process.exit(1);
});
