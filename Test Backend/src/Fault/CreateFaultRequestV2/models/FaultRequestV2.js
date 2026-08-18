const mongoose = require('mongoose');
const { Schema } = mongoose;

// Sub-schemas for TMF621 components 
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
});

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
});

const NoteSchema = new Schema({
  author: { type: String },
  date: { type: Date, default: Date.now },
  text: { type: String, required: true },
  '@type': { type: String, default: 'Note' },
});

const ChannelSchema = new Schema({
  id: { type: String, required: true },
  name: { type: String, required: true },
  '@type': { type: String, default: 'ChannelRef' },
});

const StatusChangeSchema = new Schema({
  statusChangeDate: { type: Date, default: Date.now },
  statusChangeReason: { type: String },
  status: { type: String, required: true, enum: ['acknowledged', 'rejected', 'pending', 'held', 'inProgress', 'cancelled', 'closed', 'resolved'] },
  '@type': { type: String, default: 'StatusChange' },
});

// Main Trouble Ticket Schema (Fault Request)
const FaultRequestV2Schema = new Schema({ // Schema name updated
  // Mandatory Attributes for TMF621 POST
  name: { type: String, required: true },
  description: { type: String, required: true },
  severity: { type: String, enum: ['High', 'Medium', 'Low', 'Major'], required: true }, 
  status: { type: String, required: true, enum: ['acknowledged', 'rejected', 'pending', 'held', 'inProgress', 'cancelled', 'closed', 'resolved'] },
  ticketType: { type: String, required: true },
  
  // Optional TMF Attributes
  expectedResolutionDate: { type: Date }, 
  requestedResolutionDate: { type: Date }, 
  attachment: [Schema.Types.Mixed], 
  channel: { type: ChannelSchema },
  note: [NoteSchema],
  relatedEntity: [RelatedEntitySchema],
  relatedParty: [RelatedPartyRefOrPartyRoleRefSchema],
  statusChangeHistory: [StatusChangeSchema],

  // TMF Standard Attributes (System Managed)
  id: { type: String, unique: true }, 
  href: { type: String },
  creationDate: { type: Date, default: Date.now },
  lastUpdate: { type: Date, default: Date.now },
  '@type': { type: String, default: 'TroubleTicket' },
  '@schemaLocation': { type: String },
  '@baseType': { type: String },
}, {
  timestamps: false 
});

// Pre-save hook to generate 'id' and 'href' as per TMF standard
FaultRequestV2Schema.pre('save', function(next) {
  if (this.isNew) {
    this.id = new mongoose.Types.ObjectId().toString(); 
    this.href = `http://localhost:3000/api/v2/troubleTicket/${this.id}`;
    this.creationDate = new Date();
    
    if (!this.statusChangeHistory || this.statusChangeHistory.length === 0) {
      this.statusChangeHistory.push({
        status: this.status,
        statusChangeReason: 'Initial creation',
        statusChangeDate: new Date(),
        '@type': 'StatusChange'
      });
    }
  }
  this.lastUpdate = new Date(); 
  next();
});

const FaultRequestV2 = mongoose.models.FaultRequestV2
  ? mongoose.model('FaultRequestV2') 
  : mongoose.model('FaultRequestV2', FaultRequestV2Schema);

module.exports = FaultRequestV2;
