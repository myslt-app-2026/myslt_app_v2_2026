const mongoose = require("mongoose");
const eBillUser = require("./models/eBillUsers"); // ✅ fixed path
require("dotenv").config({ path: "../../../.env" }); // adjust path to .env

mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    await eBillUser.create({
      accountNo: "0036213541",
      tpNo: "0112051934",
      econtact: "eathameera@gmail.com",
      econtactType: "EMAIL",
    });
    console.log("✅ Sample eBillUser inserted successfully!");
    process.exit();
  })
  .catch((err) => {
    console.error("❌ MongoDB connection failed:", err);
    process.exit(1);
  });
