const CustomerBill = require('../models/customerBill.model');

// This function handles the logic for the download request
exports.requestBillDownload = async (req, res) => {
    try {
        const { id } = req.params;
        const { fileExtension = 'pdf', billFormat = 'standard', billLanguage = 'english' } = req.query;

        if (!id) {
            return res.status(400).json({ error: "Customer Bill ID is required." });
        }

        const bill = await CustomerBill.findOne({ billId: id });

        if (!bill) {
            return res.status(404).json({ error: `Customer Bill with ID ${id} not found.` });
        }
 
        const mockDownloadUrl = `https://cdn.example.com/bills/${bill.billId}_${billFormat}.${fileExtension}`;

        res.status(200).json({
            message: "E-Bill download request processed successfully.",
            downloadUrl: mockDownloadUrl,
            requestDetails: {
                customerBillId: id,
                fileExtension,
                billFormat,
                billLanguage,
            }
        });

    } catch (error) {
        console.error("Error processing e-bill download request:", error);
        res.status(500).json({ error: "An internal server error occurred." });
    }
};
