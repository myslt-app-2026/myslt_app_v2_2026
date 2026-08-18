const mongoose = require('mongoose');

const PurchasedProductSchema = new mongoose.Schema({
  telephoneNo: { type: String, required: true },
  productid: { type: String, required: true },
  pin: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('PurchasedProduct', PurchasedProductSchema);
