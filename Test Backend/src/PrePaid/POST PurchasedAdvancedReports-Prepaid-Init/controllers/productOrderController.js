// CHANGED: Imported renamed model
const PrepaidProductOrder = require('../models/productOrderModel');

exports.createProductOrder = async (req, res) => {
  try {
    const { reporterPackage, activatedBy } = req.body;
    const subscriberId = req.headers['subscriberid']; 

    const productOrderData = {
      description: "Purchase Advanced Reports - Prepaid - Init",
      category: "Prepaid",
      relatedParty: [
        {
          id: subscriberId,
          role: "customer", // TMF Standard Role
          name: "Subscriber"
        },
        {
          name: activatedBy,
          role: "initiator" // Captures 'activatedBy' as a RelatedParty role
        }
      ],
      productOrderItem: [
        {
          id: "1", 
          action: "add",
          productOffering: {
            id: reporterPackage,
            name: "Advanced Reports Package"
          }
        }
      ]
    };

    // CHANGED: Used PrepaidProductOrder
    const newOrder = await PrepaidProductOrder.create(productOrderData);

    res.status(201).json({
      id: newOrder._id,
      href: `/tmf-api/productOrdering/v4/productOrder/${newOrder._id}`,
      ...productOrderData,
      state: newOrder.state
    });
  } catch (err) {
    res.status(400).json({
      message: "Failed to initialize product order",
      error: err.message
    });
  }
};