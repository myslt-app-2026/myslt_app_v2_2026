const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const digitalIdentitySchema = new mongoose.Schema({
  id: {
    type:     String,
    required: true,
    unique:   true,
    default:  uuidv4
  },
  status: {
    type:     String,
    required: true,
    default:  'Active'
  },
  party: [{
    id:   String,
    name: String,
    href: String
  }],
  credential: [{
    token:    String,
    validFor: {
      startDateTime: Date,
      endDateTime:   Date
    },
    status: String
  }]
});

module.exports = mongoose.model('DigitalIdentity', digitalIdentitySchema);