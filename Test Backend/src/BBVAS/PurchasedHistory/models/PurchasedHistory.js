// src/BBVAS/PurchasedHistory/models/PurchasedHistory.js

const mongoose = require('mongoose');

const relatedPartySchema = new mongoose.Schema({
    id: String,
    name: String,
    role: String
});

const usageSpecificationSchema = new mongoose.Schema({
    id: String,
    href: String,
    name: String
});

const usageCharacteristicSchema = new mongoose.Schema({
    id: String,
    name: String,
    value: String
});

const usageItemSchema = new mongoose.Schema({
    id: String,
    itemPrice: {
        price: Number,
        unitOfMeasure: String
    },
    product: {
        id: String,
        href: String,
        name: String
    },
    usageCharacteristic: [usageCharacteristicSchema]
});

const purchasedHistorySchema = new mongoose.Schema({
    id: {
        type: String,
        required: true,
        unique: true
    },
    href: String,
    description: String,
    usageDate: Date,
    relatedParty: [relatedPartySchema],
    usageSpecification: {
        type: usageSpecificationSchema,
        required: true
    },
    usageItem: [usageItemSchema]
});

const PurchasedHistory = mongoose.model('PurchasedHistory', purchasedHistorySchema);

module.exports = PurchasedHistory;