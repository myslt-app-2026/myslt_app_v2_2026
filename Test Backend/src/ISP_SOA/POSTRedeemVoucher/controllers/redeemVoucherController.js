const redeemVoucherService = require("../services/redeemVoucherService");

const redeemVoucher = async (req, res) => {
  try {
    const { subscriberId, voucherCode } = req.body;

    if (!subscriberId) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberId is required",
      });
    }

    if (!voucherCode) {
      return res.status(400).json({
        error: "Bad Request",
        message: "voucherCode is required",
      });
    }

    const response = await redeemVoucherService.redeemVoucher(req.body);

    return res.status(201).json(response);
  } catch (error) {
    console.error("Redeem Voucher error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  redeemVoucher,
};