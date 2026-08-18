const mongoose = require('mongoose');

const BillDownloadRequestSchema = new mongoose.Schema({
  // fields inferred from your screenshot & TMF example
  eContact: { type: String },        // eContact (query param)
  accountNo: { type: String, index: true }, // account number
  ebillMonth: { type: String },      // e.g. "2023/05"
  tpNo: { type: String },            // telephone number
  status: { type: String, default: 'created' }, // created, processed, failed, etc.
  fileUrl: { type: String },         // url to downloadable bill file
  description: { type: String },
  name: { type: String },
  billingAccount: { type: mongoose.Schema.Types.Mixed }, // store TMF-like ref
  relatedParty: { type: mongoose.Schema.Types.Mixed },
  // track timestamps
}, { timestamps: true });

module.exports = mongoose.model('BillDownloadRequest', BillDownloadRequestSchema);
