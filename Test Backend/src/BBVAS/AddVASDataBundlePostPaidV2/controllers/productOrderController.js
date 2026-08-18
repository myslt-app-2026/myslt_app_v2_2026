const ProductOrder = require('../../../../src/models/TMF622_ProductOrder.js');
const { v4: uuidv4 } = require('uuid');

exports.createProductOrder = async (req, res) => {
  try {
    const generatedId = uuidv4();

    const newOrder = new ProductOrder({
      id: generatedId,
      href: `/productOrder/${generatedId}`,

      description: req.body.description,
      category: req.body.category,
      priority: req.body.priority,

      state: "acknowledged",

      // 🔥 FIX: ensure proper TMF externalId structure
      externalId: req.body.payId
        ? [
            {
              id: req.body.payId,
              owner: "BBVAS",
              externalIdentifierType: "PAYMENT_ID"
            }
          ]
        : [],

      productOrderItem: (req.body.orderItem || []).map(item => ({
        id: item.id,
        action: item.action,
        state: item.state || "acknowledged",

        productOffering: item.productOffering
          ? {
              id: item.productOffering.id,
              name: item.productOffering.name
            }
          : undefined
      })),

      relatedParty: req.body.relatedParty,
      channel: req.body.channel
        ? Array.isArray(req.body.channel)
          ? req.body.channel
          : [req.body.channel]
        : [],

      externalReference: req.body.externalReference || [],

      requestedStartDate: req.body.requestedStartDate,
      requestedCompletionDate: req.body.requestedCompletionDate
    });

    const savedOrder = await newOrder.save();

    res.status(201).json({
      id: savedOrder.id, // 🔥 FIX: return TMF id, not _id
      href: savedOrder.href,

      externalId: savedOrder.externalId,
      description: savedOrder.description,
      category: savedOrder.category,
      priority: savedOrder.priority,

      requestedStartDate: savedOrder.requestedStartDate,
      requestedCompletionDate: savedOrder.requestedCompletionDate,

      state: savedOrder.state,
      channel: savedOrder.channel,
      relatedParty: savedOrder.relatedParty,
      productOrderItem: savedOrder.productOrderItem,

      creationDate: savedOrder.creationDate,
      completionDate: savedOrder.completionDate
    });

  } catch (err) {
    console.error('Error saving ProductOrder:', err);
    res.status(500).json({
      error: 'Internal Server Error',
      details: err.message
    });
  }
};
/*const ProductOrder = require('../../VASBundleUnsubscription/models/ProductOrder');

// POST /productOrder
exports.createProductOrder = async (req, res) => {
  try {
    const newOrder = new ProductOrder({
      externalId: req.body.externalId,
      description: req.body.description,
      category: req.body.category,
      priority: req.body.priority,

      state: "acknowledged",

      orderItem: req.body.productOrderItem, // rename
      relatedParty: req.body.relatedParty,
      channel: req.body.channel ? [req.body.channel] : []
    });


    const savedOrder = await newOrder.save();

    res.status(201).json({
      id: savedOrder._id,
      href: `/productOrder/${savedOrder._id}`,
      externalId: savedOrder.externalId,
      description: savedOrder.description,
      category: savedOrder.category,
      priority: savedOrder.priority,
      requestedStartDate: savedOrder.requestedStartDate,
      requestedCompletionDate: savedOrder.requestedCompletionDate,
      state: savedOrder.state,
      channel: savedOrder.channel,
      relatedParty: savedOrder.relatedParty,
      productOrderItem: savedOrder.productOrderItem,
      creationDate: savedOrder.creationDate,
      completionDate: savedOrder.completionDate
    });
  } catch (err) {
    console.error('Error saving ProductOrder:', err);
    res.status(500).json({ error: 'Internal Server Error', details: err.message });
  }
};
*/