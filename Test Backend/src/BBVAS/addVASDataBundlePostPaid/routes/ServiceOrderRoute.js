const express = require("express");
const {
  purchaseExtraGBPrepaidInit,
  purchaseVASPostpaidInit,
  upgradeLoyaltyInit,
} = require("../controllers/ServiceOrderController.js");

const router = express.Router();

router.post("/", async (req, res) => {
  const { orderItem } = req.body;

  if (!orderItem || orderItem.length === 0) {
    return res.status(400).json({ message: "orderItem is required" });
  }

  try {
    const firstItem = orderItem[0];

    if (firstItem.productOffering?.name?.includes("Extra GB")) {
      return purchaseExtraGBPrepaidInit(req, res);
    } else if (firstItem.productOffering?.name?.includes("VAS")) {
      return purchaseVASPostpaidInit(req, res);
    } else if (firstItem.productOffering?.name?.includes("Loyalty")) {
      return upgradeLoyaltyInit(req, res);
    } else {
      return res.status(400).json({ message: "Unknown orderItem type" });
    }
  } catch (err) {
    console.error("Error in ServiceOrder router:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
