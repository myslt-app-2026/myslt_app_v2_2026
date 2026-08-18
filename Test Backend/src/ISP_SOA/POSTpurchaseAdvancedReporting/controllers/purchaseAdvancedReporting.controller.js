const ProductOffering = require("../../../../src/models/TMF620_ProductOffering");
const ProductOrder = require("../../../models/TMF622_ProductOrder");
const { randomUUID } = require("crypto");

exports.purchaseAdvancedReporting = async (req, res) => {

    try {

        const { packageId, commitUser, channel } = req.body;

        const offering = await ProductOffering.findById(packageId);

        if (!offering) {

            return res.status(404).json({
                message: "Package not found"
            });

        }

        const order = new ProductOrder({

            id: randomUUID(),

            category: "AdvancedReporting",

            description: `Purchase ${offering.name}`,

            channel: [{
                id: channel,
                name: channel
            }],

            relatedParty: [{
                id: commitUser,
                name: commitUser,
                role: "Customer"
            }],

            productOrderItem: [{
                id: "1",
                action: "add",
                state: "acknowledged",
                productOffering: {
                    id: offering._id,
                    name: offering.name
                }
            }]

        });

        await order.save();

        return res.status(201).json(order);

    } catch (error) {

        return res.status(500).json({
            message: error.message
        });

    }

};