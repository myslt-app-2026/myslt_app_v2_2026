// models/document.model.js

const mongoose = require('mongoose');

const RelatedEntitySchema = new mongoose.Schema({
  id: { type: String, required: true },
  href: { type: String },
  name: { type: String },
  role: { type: String, required: true },
  referredType: { type: String } // maps to @referredType
}, { _id: false });

const DocumentSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },

  documentType: { type: String, required: true },
  mimeType: { type: String, required: true },

  content: { type: String, required: true }, // base64
  size: { type: Number },

  relatedEntity: [RelatedEntitySchema],

  creationDate: {
    type: Date,
    default: Date.now
  },

  // TMF meta fields
  type: { type: String, default: 'Document' },       // @type
  baseType: { type: String, default: 'Document' }    // @baseType

}, {
  timestamps: true
});

module.exports = mongoose.model('Document', DocumentSchema);