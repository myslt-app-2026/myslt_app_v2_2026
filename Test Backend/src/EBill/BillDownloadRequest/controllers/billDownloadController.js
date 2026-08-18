const billService = require('../services/billDownloadService');

/**
 * GET /tmf-api/customerBillManagement/v5/BillDownloadRequest
 * Supports query params: eContact, accountNo, ebillMonth, tpNo, limit, skip
 */
const getList = async (req, res) => {
  try {
    const { eContact, accountNo, ebillMonth, tpNo, limit, skip } = req.query;
    const params = { eContact, accountNo, ebillMonth, tpNo };
    const options = {};
    if (limit) options.limit = limit;
    if (skip) options.skip = skip;
    const result = await billService.list(params, options);
    return res.json({
      total: result.total,
      items: result.items
    });
  } catch (err) {
    console.error('Error in getList:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * GET /tmf-api/customerBillManagement/v5/BillDownloadRequest/:id
 */
const getById = async (req, res) => {
  try {
    const id = req.params.id;
    const doc = await billService.getById(id);
    if (!doc) return res.status(404).json({ error: 'BillDownloadRequest not found' });
    return res.json(doc);
  } catch (err) {
    console.error('Error in getById:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * POST /tmf-api/customerBillManagement/v5/BillDownloadRequest
 * (helper to create test data)
 */
const create = async (req, res) => {
  try {
    const payload = req.body;
    const created = await billService.create(payload);
    return res.status(201).json(created);
  } catch (err) {
    console.error('Error in create:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * PUT /tmf-api/customerBillManagement/v5/BillDownloadRequest/:id
 */
const update = async (req, res) => {
  try {
    const id = req.params.id;
    const changes = req.body;
    const updated = await billService.updateById(id, changes);
    if (!updated) return res.status(404).json({ error: 'Not found' });
    return res.json(updated);
  } catch (err) {
    console.error('Error in update:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  getList,
  getById,
  create,
  update
};
