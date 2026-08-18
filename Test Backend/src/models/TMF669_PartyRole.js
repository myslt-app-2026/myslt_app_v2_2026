/**
 * TMF669_AgentCode.js
 * The ONLY TMF669 (Party Role) model for the Omni-Channel project.
 * Covers all party roles — primary use case is SLT Sales Agent management.
 *
 * TMF669 PartyRole fields:
 *   - id / href / @type / @baseType
 *   - role, status, engagedParty, validFor
 *
 * SLT-specific extensions:
 *   - agentCode    : unique agent identifier (e.g. "AGT001")
 *   - agentName / agentEmail / agentMobile
 *   - secCode      : FTTH one-time security code sent to the agent
 *   - secCodeExpiry / secCodeVerified
 *   - region / district : SLT coverage area
 */

const mongoose = require('mongoose');

const PartyRoleSchema = new mongoose.Schema(
  {
    /* ── TMF669 Core Fields ───────────────────────── */
    id:    { type: String },
    href:  { type: String },

    /* ── SLT Agent Identifier ─────────────────────── */
    agentCode:  { type: String, required: true, unique: true },

    /* ── Agent Contact Info ───────────────────────── */
    agentName:   { type: String },
    agentEmail:  { type: String },
    agentMobile: { type: String },

    /* ── FTTH Security Code ───────────────────────── */
    secCode:         { type: String },
    secCodeExpiry:   { type: Date },
    secCodeVerified: { type: Boolean, default: false },

    /* ── SLT Coverage Area ────────────────────────── */
    region:   { type: String },
    district: { type: String },

    /* ── TMF669 PartyRole Fields ──────────────────── */
    role:   { type: String, default: 'SalesAgent' },
    status: {
      type: String,
      enum: ['active', 'inactive', 'suspended'],
      default: 'active'
    },

    engagedParty: {
      id:              { type: String },
      name:            { type: String },
      '@referredType': { type: String, default: 'Individual' },
      '@type':         { type: String, default: 'PartyRef' }
    },

    validFor: {
      startDateTime: { type: Date },
      endDateTime:   { type: Date }
    },

    '@type':     { type: String, default: 'PartyRole' },
    '@baseType': { type: String, default: 'PartyRole' }
  },
  {
    timestamps: true,
    versionKey: false,
    strict: false   // allows extra SLT-specific fields without schema changes
  }
);

// Export as a distinct model name to avoid schema collisions.
// Keep the collection name as 'partyroles' for backward compatibility.
module.exports = mongoose.models.TMF669PartyRole ||
  mongoose.model('TMF669PartyRole', PartyRoleSchema, 'partyroles');
