const {
  createExtraGBPrepaidOrder,
  createVASDataBundleOrder,
  createLoyaltyUpgradeOrder,
} = require("../services/ServiceOrderService.js");

const { successResponse, errorResponse } = require("../utils/responseHandler.js");

const purchaseExtraGBPrepaidInit = async (req, res) => {
  try {
    const result = await createExtraGBPrepaidOrder(req.body);
    return successResponse(res, result, 201);
  } catch (err) {
    return errorResponse(res, err.message, 400);
  }
};

const purchaseVASPostpaidInit = async (req, res) => {
  try {
    const result = await createVASDataBundleOrder(req.body);
    return successResponse(res, result, 201);
  } catch (err) {
    return errorResponse(res, err.message, 400);
  }
};

const upgradeLoyaltyInit = async (req, res) => {
  try {
    const result = await createLoyaltyUpgradeOrder(req.body);
    return successResponse(res, result, 201);
  } catch (err) {
    return errorResponse(res, err.message, 400);
  }
};

module.exports = {
  purchaseExtraGBPrepaidInit,
  purchaseVASPostpaidInit,
  upgradeLoyaltyInit,
};
