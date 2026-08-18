const { checkEbillStatus } = require("../services/eBillStatusService");

const eBillStatusRequest = async (req, res) => {
  try {
    const { accountId, tpNo } = req.query;
    const result = await checkEbillStatus(accountId, tpNo);

    if (!result.isSuccess) {
      return res.status(result.statusCode || 400).json(result);
    }

    return res.json(result);
  } catch (err) {
    console.error("eBillStatusRequest error:", err);
    res.status(500).json({
      isSuccess: false,
      errorMessage: "Internal Server Error"
    });
  }
};

module.exports = { eBillStatusRequest };
