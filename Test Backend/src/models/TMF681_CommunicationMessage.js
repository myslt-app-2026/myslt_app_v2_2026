const mongoose = require('mongoose');

/**
 * ===== Common Sub Schemas =====
 */

const ContactMediumSchema = new mongoose.Schema({
  '@type': String,
  mediumType: {
    type: String,
    enum: ['EMAIL', 'SMS', 'MOBILE', 'PUSH'],
  },
  emailAddress: String,
  phoneNumber: String
}, { _id: false });

const RelatedPartySchema = new mongoose.Schema({
  '@type': { type: String, default: 'RelatedParty' },
  id: String,
  name: String,
  role: String,
  contactMedium: [ContactMediumSchema]
}, { _id: false });

const PartyOrPartyRoleSchema = new mongoose.Schema({
  id: String,
  href: String,
  name: String,
  '@type': String
}, { _id: false });

const RelatedPartyOrPartyRoleSchema = new mongoose.Schema({
  role: String,
  partyOrPartyRole: PartyOrPartyRoleSchema,
  '@type': String
}, { _id: false });

const AttachmentSchema = new mongoose.Schema({
  '@type': String,
  url: String,
  name: String,
  content: String,
  attachmentType: String,
  mimeType: String
}, { _id: false });

const CharacteristicSchema = new mongoose.Schema({
  name: String,
  value: mongoose.Schema.Types.Mixed,
  valueType: String,
  '@type': String
}, { _id: false });

const RelatedEntitySchema = new mongoose.Schema({
  '@type': String,
  id: String,
  href: String
}, { _id: false });

/**
 * ===== TMF 681 CommunicationMessage =====
 */

const CommunicationMessageSchema = new mongoose.Schema({
  id: {
    type: String,
    unique: true
  },
  href: String,

  '@type': {
    type: String,
    default: 'CommunicationMessage'
  },

  subject: String,
  description: String,

  content: {
    type: String,
    required: true
  },

  messageType: {
    type: String,
    enum: ['SMS', 'Email', 'Push', 'Banner', 'InApp', 'OTP'],
    required: true
  },

  state: {
    type: String,
    enum: [
      'Initial',
      'InProgress',
      'Scheduled',
      'Completed',
      'Delivered',
      'Failed',
      'Cancelled'
    ],
    default: 'Initial'
  },

  sendTime: Date,
  scheduledSendTime: Date,

  sender: {
    '@type': String,
    id: String,
    name: String,
    phoneNumber: String,
    party: RelatedPartyOrPartyRoleSchema
  },

  receiver: [
    {
      '@type': String,
      id: String,
      name: String,
      phoneNumber: String,
      party: RelatedPartyOrPartyRoleSchema,
      contactMedium: [ContactMediumSchema]
    }
  ],

  attachment: [AttachmentSchema],

  characteristic: [CharacteristicSchema],

  relatedEntity: [RelatedEntitySchema]

}, {
  timestamps: true,
  collection: 'communicationMessage'
});

module.exports = mongoose.model(
  'CommunicationMessage',
  CommunicationMessageSchema
);
