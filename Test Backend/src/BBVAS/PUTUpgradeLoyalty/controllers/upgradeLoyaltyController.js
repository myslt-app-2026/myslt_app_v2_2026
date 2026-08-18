const ProductOrder = require("../../../models/TMF622_ProductOrder");

exports.upgradeLoyalty = async (req, res) => {
  try {

    const { subscriberID, productOfferingId } = req.body;

    if (!subscriberID || !productOfferingId) {
      return res.status(400).json({
        message: "subscriberID and productOfferingId are required"
      });
    }

    const order = new ProductOrder({
      id: "ORD_" + Date.now(),

      category: "LoyaltyUpgrade",

      state: "acknowledged",

      relatedParty: [
        {
          id: subscriberID,
          role: "Customer"
        }
      ],

      productOrderItem: [
        {
          id: "1",
          action: "add",

          productOffering: {
            id: productOfferingId,
            name: "Loyalty Upgrade"
          }
        }
      ]
    });

    await order.save();

    res.status(200).json({
      success: true,
      message: "Loyalty upgrade order created",
      data: order
    });

  } catch (error) {
    res.status(500).json({
      message: "Server error",
      error: error.message
    });
  }
};
