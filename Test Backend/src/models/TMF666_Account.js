/**
 * ⚠️ TMF666 - Account Management DOMAIN MODELS
 *
 * This file contains ONLY resource models defined in TMF666 (Account Management API).
 *
 * 📌 Guidelines:
 *
 * 1. All Account-related models MUST be defined in this file.
 *    (e.g., BillingAccount, PartyAccount, FinancialAccount, etc.)
 *
 * 2. When additional TMF666 resource models are needed,
 *    implement them HERE as separate Mongoose models.
 *
 * 3. Do NOT create Account-related models in other files.
 *
 * 4. Always follow TMF666 structure:
 *    - state (NOT status)
 *    - relatedParty with partyOrPartyRole reference
 *    - account relationships, balances, credit limits
 *    - @type, @referredType, href, validFor, etc.
 *
 * 5. Reuse common structures (Money, RelatedParty, AccountRef)
 *    to ensure consistency.
 *
 * 6. Use:
 *    mongoose.models.ModelName || mongoose.model(...)
 *    to avoid model overwrite errors.
 *
 * 🚫 Do NOT:
 * - Duplicate account models across files
 * - Modify structure without checking TMF666 user guide
 *
 * ✅ Goal:
 * Maintain a single, TMF-compliant source of truth for Account domain models.
 */
const mongoose = require("mongoose");

const billingAccountSchema = new mongoose.Schema(
{
  id: { type: String, required: true, unique: true },
  href: String,
  name: String,
  description: String,

  state: String, // NOT status
  accountType: String,
  paymentStatus: String,
  lastUpdate: Date,

  // 🔹 Related Party (Correct Structure)
  relatedParty: [
    {
      role: String,
      "@type": String,
      partyOrPartyRole: {
        id: String,
        href: String,
        name: String,
        "@referredType": String,
        "@type": String
      }
    }
  ],

  // 🔹 Billing Structure
  billStructure: {
    format: {
      id: String,
      name: String
    },
    presentationMedia: [
      {
        id: String,
        name: String
      }
    ]
  },

  // 🔹 Financials
  accountBalance: [
    {
      amount: {
        unit: String,
        value: Number
      },
      balanceType: String
    }
  ],

  creditLimit: {
    unit: String,
    value: Number
  },

  // 🔹 Relationships
  accountRelationship: [
    {
      relationshipType: String,
      account: {
        id: String,
        name: String
      }
    }
  ],

  // 🔹 Extension (your existing logic)
  characteristic: [
    {
      name: String,
      value: String
    }
  ],

  // 🔹 TMF Meta
  "@type": { type: String, default: "BillingAccount" },
  "@baseType": String,
  "@schemaLocation": String
},
{ strict: false }
);

module.exports = mongoose.models.BillingAccount || mongoose.model("BillingAccount", billingAccountSchema);