// TMF622 - Product Ordering Management v4 - RegisterForBBFreedom
const { successResponse, errorResponse, badRequestResponse } = require('../utils/responseHandler');

exports.registerForBBFreedom = async (req, res) => {
    try {
        const contentType = req.headers['content-type'];
        console.log('Content-Type:', contentType);
        console.log('Incoming Body:', JSON.stringify(req.body, null, 2));

        // DETECT POSTMAN CONFIGURATION ERROR
        if (contentType && contentType.includes('application/x-www-form-urlencoded')) {
            const bodyKeys = Object.keys(req.body);
            if (bodyKeys.length > 0 && bodyKeys[0].trim().startsWith('{')) {
                return badRequestResponse(res, "CONFIGURATION ERROR: You are sending JSON data but the Content-Type header is set to 'application/x-www-form-urlencoded'. Please go to the 'Headers' tab in Postman and remove the manual Content-Type header, or set it to 'application/json'.");
            }
        }

        if (!contentType || !contentType.includes('application/json')) {
            console.warn('Warning: Content-Type is not application/json. Postman might be misconfigured.');
        }

        const tpNo = req.body.tpNo;
        const description = req.body.description;
        const contactMobile = req.body.contactMobile;

        if (!tpNo) {
            return badRequestResponse(res, "tpNo is required");
        }

        console.log(`RegisterForBBFreedom request received: TP=${tpNo}, Desc=${description}, Contact=${contactMobile}`);

        const responseData = {
            "@type": "ProductOrder",
            "@schemaLocation": "/tmf-api/productOrderingManagement/v4/schema/productOrder",
            id: `order-bbfreedom-${Date.now()}`,
            href: `/tmf-api/productOrderingManagement/v4/productOrder/bbFreedom`,
            externalId: tpNo,
            description: description || "BB Freedom Registration",
            state: "acknowledged",
            orderDate: new Date().toISOString(),
            productOrderItem: [
                {
                    "@type": "ProductOrderItem",
                    id: "1",
                    action: "add",
                    state: "acknowledged",
                    product: {
                        "@type": "Product",
                        name: "BB Freedom",
                        productCharacteristic: [
                            { name: "tpNo", value: tpNo },
                            { name: "contactMobile", value: contactMobile }
                        ]
                    }
                }
            ],
            relatedParty: [
                {
                    "@type": "RelatedParty",
                    id: tpNo,
                    role: "subscriber"
                }
            ]
        };

        return successResponse(res, responseData, 201);

    } catch (err) {
        console.error("Error in registerForBBFreedom:", err);
        return errorResponse(res, err.message, 500);
    }
};
