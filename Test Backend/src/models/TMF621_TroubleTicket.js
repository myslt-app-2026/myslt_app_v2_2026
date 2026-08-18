const mongoose = require('mongoose');
const { Schema } = mongoose;

// ExternalIdentifier (used for externalId list)
const ExternalIdentifierSchema = new Schema({
  id: { type: String },
  owner: { type: String },
  externalIdentifierType: { type: String },
  '@type': { type: String, default: 'ExternalIdentifier' },
}, { _id: false });

// RelatedPartyRefOrPartyRoleRef
const RelatedPartyRefOrPartyRoleRefSchema = new Schema({
  role: { type: String, required: true },
  '@type': { type: String, default: 'RelatedPartyRefOrPartyRoleRef' },
  partyOrPartyRole: {
    id: { type: String, required: true },
    href: { type: String },
    name: { type: String, required: true },
    '@type': { type: String, required: true },
    '@referredType': { type: String, required: true },
  },
}, { _id: false });

// RelatedEntity
const RelatedEntitySchema = new Schema({
  role: { type: String, required: true },
  '@type': { type: String, default: 'RelatedEntity' },
  entity: {
    id: { type: String, required: true },
    href: { type: String },
    name: { type: String, required: true },
    '@type': { type: String, required: true },
    '@referredType': { type: String, required: true },
  },
}, { _id: false });

// AttachmentRefOrValue (generic attachment structure)
const AttachmentRefOrValueSchema = new Schema({
  id: { type: String },
  href: { type: String },
  attachmentType: { type: String },
  description: { type: String },
  url: { type: String },
  size: {
    amount: { type: Number },
    units: { type: String },
  },
  mimeType: { type: String },
  '@type': { type: String, default: 'AttachmentRefOrValue' },
}, { _id: false });

// Note
const NoteSchema = new Schema({
  id: { type: String },
  author: { type: String },
  date: { type: Date, default: Date.now },
  text: { type: String, required: true },
  '@type': { type: String, default: 'Note' },
}, { _id: false });

// Channel
const ChannelSchema = new Schema({
  id: { type: String, required: true },
  href: { type: String },
  name: { type: String, required: true },
  role: { type: String },
  '@referredType': { type: String },
  '@type': { type: String, default: 'ChannelRef' },
}, { _id: false });

// TroubleTicketRelationship
const TroubleTicketRelationshipSchema = new Schema({
  id: { type: String, required: true },
  href: { type: String },
  relationshipType: { type: String, required: true },
  '@type': { type: String, default: 'TroubleTicketRelationship' },
}, { _id: false });

// StatusChange (history)
const StatusChangeSchema = new Schema({
  statusChangeDate: { type: Date, default: Date.now },
  statusChangeReason: { type: String },
  status: {
    type: String,
    required: true,
    enum: [
      'acknowledged',
      'rejected',
      'pending',
      'held',
      'inProgress',
      'cancelled',
      'closed',
      'resolved',
    ],
  },
  '@type': { type: String, default: 'StatusChange' },
}, { _id: false });

// Main TMF621 TroubleTicket Schema
const TroubleTicketSchema = new Schema({
  // Core identifiers
  id: { type: String, unique: true },
  href: { type: String },
  externalId: { type: [ExternalIdentifierSchema], default: [] },

  // Main attributes
  name: { type: String, required: true },
  description: { type: String, required: true },
  ticketType: { type: String, required: true },
  severity: {
    type: String,
    enum: ['critical', 'major', 'minor', 'nonCritical'],
  },
  priority: {
    type: String,
    enum: ['critical', 'high', 'medium', 'low'],
  },
  status: {
    type: String,
    required: true,
    enum: [
      'acknowledged',
      'rejected',
      'pending',
      'held',
      'inProgress',
      'cancelled',
      'closed',
      'resolved',
    ],
  },

  // Dates
  creationDate: { type: Date, default: Date.now },
  lastUpdate: { type: Date, default: Date.now },
  expectedResolutionDate: { type: Date },
  requestedResolutionDate: { type: Date },
  resolutionDate: { type: Date },

  // Related information
  attachment: { type: [AttachmentRefOrValueSchema], default: [] },
  channel: { type: ChannelSchema },
  note: { type: [NoteSchema], default: [] },
  relatedEntity: { type: [RelatedEntitySchema], default: [] },
  relatedParty: { type: [RelatedPartyRefOrPartyRoleRefSchema], default: [] },
  troubleTicketRelationship: {
    type: [TroubleTicketRelationshipSchema],
    default: [],
  },
  statusChange: { type: [StatusChangeSchema], default: [] },

  // TMF standard meta-attributes
  '@type': { type: String, default: 'TroubleTicket' },
  '@baseType': { type: String },
  '@schemaLocation': { type: String },
}, {
  timestamps: false,
});

// Keep lastUpdate in sync
TroubleTicketSchema.pre('save', function (next) {
  this.lastUpdate = new Date();
  next();
});

const TroubleTicketModel = mongoose.models.TMF621_TroubleTicket
  ? mongoose.model('TMF621_TroubleTicket')
  : mongoose.model('TMF621_TroubleTicket', TroubleTicketSchema);

module.exports = TroubleTicketModel;

