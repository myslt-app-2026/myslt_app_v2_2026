const mongoose = require("mongoose");
const PopupMessage = require("./models/popupMessage.model");

// Replace this with your MongoDB connection string
const connectionString = "mongodb+srv://omnichannelservicehub_db_user:OmniChannel@cluster0.jgutgzr.mongodb.net/OmniChannel?retryWrites=true&w=majority";

mongoose.connect(connectionString, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log("Connected to OmniChannel database"))
.catch(err => console.error("Connection error:", err));

async function createTest() {
  try {
    const doc = new PopupMessage({
      id: "test002",
      title: "Test Popup",
      message: "This is second test message",
      created_USER: "admin",
      created_DATE: new Date()
    });

    await doc.save();
    console.log("Document inserted!");
  } catch (err) {
    console.error("Error inserting document:", err.message);
  } finally {
    mongoose.connection.close(); // close the connection
  }
}

createTest();
