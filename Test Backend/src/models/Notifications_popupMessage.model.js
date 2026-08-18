const mongoose = require("mongoose");

const ValidForSchema = new mongoose.Schema(
  {
    startDateTime: Date,
    endDateTime: Date
  },
  { _id: false }
);

const RelatedPartySchema = new mongoose.Schema(
  {
    id: String,
    role: String,
    name: String
  },
  { _id: false }
);

const PopupMessageSchema = new mongoose.Schema(
  {
    

    id: {
      type: String,
      required: true,
      unique: true
    },

    href: {
      type: String
    },

    "@type": {
      type: String,
      default: "PopupMessage"
    },

    "@baseType": {
      type: String,
      default: "Notification"
    },

    "@schemaLocation": {
      type: String
    },

    lifecycleStatus: {
      type: String,
      enum: ["ACTIVE", "INACTIVE"],
      default: "ACTIVE"
    },

    validFor: ValidForSchema,

    relatedParty: [RelatedPartySchema],

    // ================= BUSINESS FIELDS ================= 

    subscriber_id: {
      type: String,
      index: true
    },

    title: String,

    message: String,

    popup_URL: String,

    action: String,

    popup_TYPE: String,

    button_TITLE: String,

    noT_TYPE: String,

    noT_DATE: Date,

    status: {
      type: String,
      default: "ACTIVE"
    },

    button_NAME: String,

    created_USER: String,

    created_DATE: Date
  },
  {
    collection: "popup_messages",
    timestamps: false
  }
);

module.exports = mongoose.model("PopupMessage", PopupMessageSchema);
