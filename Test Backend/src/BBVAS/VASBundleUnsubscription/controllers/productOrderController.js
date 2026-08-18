const ProductOrder = require("../models/ProductOrder");

exports.unsubscribeVASBundle = async (req, res) => {
  try {
    const { customerId, productId, productName } = req.body;

    const order = new ProductOrder({
      state: "acknowledged",

      relatedParty: [{
        id: customerId,
        role: "customer"
      }],

      orderItem: [{
        id: "1",
        action: "delete",
        productOffering: {
          id: productId,
          name: productName
        }
      }]
    });


    await order.save();
    res.status(201).json({
      message: "VAS Bundle unsubscription order created",
      order
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
