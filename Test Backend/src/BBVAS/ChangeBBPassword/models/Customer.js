// const mongoose = require("mongoose");
// const bcrypt = require("bcryptjs");

// const CustomerSchema = new mongoose.Schema({
//   subscriberID: { type: String, required: true, unique: true },
//   username: { type: String, required: true },
//   password: { type: String, required: true }, // hashed password
//   email: { type: String },
//   createdAt: { type: Date, default: Date.now }
// });

// // Hash password before saving
// CustomerSchema.pre("save", async function (next) {
//   if (!this.isModified("password")) return next();
//   const salt = await bcrypt.genSalt(10);
//   this.password = await bcrypt.hash(this.password, salt);
//   next();
// });

// // Compare password method
// CustomerSchema.methods.matchPassword = async function (enteredPassword) {
//   return await bcrypt.compare(enteredPassword, this.password);
// };

// module.exports = mongoose.model("Customer", CustomerSchema);
