require("dotenv").config();
const dns = require("dns");
const mongoose = require("mongoose");
const app = require("./src/app");

// Fix Windows Node.js SRV & Shard DNS lookup issues for MongoDB Atlas
try {
  dns.setDefaultResultOrder("ipv4first");
  dns.setServers(["8.8.8.8", "1.1.1.1"]);
} catch (_) {}

const MONGO_URI = process.env.MONGO_URI;
let PORT = process.env.PORT ? parseInt(process.env.PORT) : 3000;

// Custom DNS resolver that queries public DNS (8.8.8.8 / 1.1.1.1) to resolve Atlas shard domains
const customLookup = (hostname, options, callback) => {
  if (typeof options === "function") {
    callback = options;
    options = {};
  }
  dns.resolve4(hostname, (err, addresses) => {
    if (err || !addresses || addresses.length === 0) {
      return dns.lookup(hostname, options, callback);
    }
    callback(null, addresses[0], 4);
  });
};

// Start Express server immediately so APIs remain accessible
startServer(PORT);

// Connect to MongoDB in background without blocking server startup
if (MONGO_URI) {
  mongoose
    .connect(MONGO_URI, {
      serverSelectionTimeoutMS: 5000,
      lookup: customLookup,
    })
    .then(() => {
      console.log("✅ MongoDB connected successfully");
    })
    .catch((err) => {
      console.warn("⚠️ MongoDB connection error:", err.message);
      console.warn("💡 If your IP changed, whitelist it in MongoDB Atlas (Network Access -> Allow Access From Anywhere: 0.0.0.0/0)");
    });
}

function startServer(port) {
  const server = app.listen(port);

  app.use('/tmf-api/customerBill/v4', require('./src/EBill/PostRegisterSmartEBill/routes/registerSmartEBillRoutes'));
  app.use('/tmf-api/purchasedProduct/v1', require('./src/PEOVAS/POSTSubscribeChannel/routes/subscribeChannelRoutes'));

  server.on("listening", () => {
    const address = server.address();
    if (address && typeof address === "object") {
      console.log(`Server has started.`);
      console.log(`visit - http://localhost:${address.port}`);
    }
  });

  server.on("error", (err) => {
    if (err.code === "EADDRINUSE") {
      console.log(`⚠️ Port ${port} is busy. Trying ${port + 1}...`);
      startServer(port + 1);
    } else {
      console.error("❌ Server error:", err);
    }
  });

  
}
