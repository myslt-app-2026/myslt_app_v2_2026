/*const mongoose = require('mongoose');

// TMF681: Communication Message Resource
// Mandatory attributes based on User Guide: content, receiver, state, type
const communicationMessageSchema = new mongoose.Schema({
  // Mandatory: Type of communication (e.g., "OTP", "Notification")
  type: {
    type: String,
    required: true,
    default: 'OTP'
  },
  // Mandatory: The actual content of the message
  content: {
    type: String,
    required: true
  },
  // Mandatory: Status of the message (e.g., "Initial", "Sent", "Failed")
  state: {
    type: String,
    required: true,
    enum: ['Initial', 'InProgress', 'Completed', 'Failed'],
    default: 'Initial'
  },
  // Mandatory: Who receives the message
  receiver: [{
    id: String, // Optional ID if known
    name: String,
    // Maps to 'otpContact'
    email: String,
    phoneNumber: String,
    // Maps to 'otpSource' (The medium used)
    mediumType: {
      type: String,
      enum: ['EMAIL', 'MOBILE', 'SMS'],
      required: true
    }
  }],
  // Non-Mandatory / Extension: Store custom attributes like 'requestPeriod'
  characteristic: [{
    name: String,
    value: String
  }],
  // Standard TMF fields
  creationDate: {
    type: Date,
    default: Date.now
  }
});
*/