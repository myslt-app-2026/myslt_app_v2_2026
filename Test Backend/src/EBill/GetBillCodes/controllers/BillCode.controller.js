const BillCode = require('../models/BillCode.model');

/**
 * TMF Operation: List or find BillDeliveryMethod objects.
 * GET /tmf-api/customerBillManagement/v5/billDeliveryMethod
 */
exports.getBillCodes = async (req, res) => {
    try {
        // Find all BillDeliveryMethod documents in MongoDB
        const billCodes = await BillCode.find().select('-_id -__v -createdAt -updatedAt');

        // TMF Compliance: Return a simple array of resources
        const baseUrl = `${req.protocol}://${req.get('host')}`;
        const tmfResponse = billCodes.map(code => {
            const codeObject = code.toObject();
            return {
                // TMF Mandatory/Standard Attributes
                id: codeObject.id,
                // Construct TMF href using the compliant path
                href: `${baseUrl}/tmf-api/customerBillManagement/v5/billDeliveryMethod/${codeObject.id}`,
                name: codeObject.name,
                description: codeObject.description,
                deliveryChannel: codeObject.deliveryChannel,
                
                // TMF Meta-attributes
                '@type': codeObject['@type'],
                '@baseType': codeObject['@baseType'],
            };
        });

        // TMF Standard: Respond with a 200 OK and an array of resources
        return res.status(200).json(tmfResponse);

    } catch (error) {
        console.error("TMF Error (500) retrieving Bill Delivery Methods:", error.message);
        
        // TMF Standard: Return a 500 Internal Server Error with TMF Error formatting
        return res.status(500).json({
            code: "500",
            reason: "Internal Server Error",
            message: `Failed to retrieve Bill Delivery Methods. Reason: ${error.message}`,
            '@type': 'Error'
        });
    }
};