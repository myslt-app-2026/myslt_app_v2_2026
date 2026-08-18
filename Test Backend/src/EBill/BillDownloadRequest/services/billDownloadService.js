const BillDownloadRequest = require('../models/BillDownloadRequest');

/**
 * Build a query object from supported query params
 */
function buildQueryFromParams(params) {
  const q = {};
  if (params.eContact) q.eContact = params.eContact;
  if (params.accountNo) q.accountNo = params.accountNo;
  if (params.ebillMonth) q.ebillMonth = params.ebillMonth;
  if (params.tpNo) q.tpNo = params.tpNo;
  return q;
}

const list = async (params = {}, options = {}) => {
  const q = buildQueryFromParams(params);
  const { limit = 50, skip = 0, sort = '-createdAt' } = options;
  const docs = await BillDownloadRequest.find(q).sort(sort).skip(parseInt(skip)).limit(parseInt(limit)).lean();
  const total = await BillDownloadRequest.countDocuments(q);
  return { total, items: docs };
};

const getById = async (id) => {
  return BillDownloadRequest.findById(id).lean();
};

const create = async (payload) => {
  const doc = new BillDownloadRequest(payload);
  return doc.save();
};

const updateById = async (id, changes) => {
  return BillDownloadRequest.findByIdAndUpdate(id, changes, { new: true });
};

const removeById = async (id) => {
  return BillDownloadRequest.findByIdAndDelete(id);
};

module.exports = {
  list,
  getById,
  create,
  updateById,
  removeById,
};
