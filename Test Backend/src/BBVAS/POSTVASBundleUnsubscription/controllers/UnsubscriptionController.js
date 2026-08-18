const { createUnsubscriptionOrder } = require("../services/UnsubscriptionService");

const vasBundleUnsubscription = async (req, res) => {
  try {
    const result = await createUnsubscriptionOrder(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("VASBundleUnsubscription error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { vasBundleUnsubscription };