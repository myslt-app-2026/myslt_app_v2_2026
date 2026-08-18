const { v4: uuidv4 } = require("uuid");
const CustomerBill = require("../../../models/TMF678_CustomerBill");

/**
 * POST /ebill/SmartBillRegistrationSource
 * Original params: eventSource, accountNumber, billingContact,
 *                  billHandingCode, sourceTypeId, isCustomerConfirmed
 * TMF reimplementation: params moved to request body
 */
exports.smartBillRegistrationSource = async (req, res) => {
  try {
    const {
      eventSource,
      accountNumber,
      billingContact,
      billHandingCode,
      sourceTypeId,
      isCustomerConfirmed,
    } = req.body;

    if (
      !eventSource ||
      !accountNumber ||
      !billingContact ||
      !billHandingCode ||
      !sourceTypeId ||
      isCustomerConfirmed === undefined
    ) {
      return res.status(400).json({
        error:
          "Missing required fields in request body: eventSource, accountNumber, billingContact, billHandingCode, sourceTypeId, isCustomerConfirmed",
      });
    }

    const billId = uuidv4();

    const newBill = new CustomerBill({
      id: billId,
      href: `http://localhost:3000/tmf-api/customerBill/v4/ebill/SmartBillRegistrationSource/${billId}`,
      description: "SmartBill Registration Source Request",
      category: "SmartBillRegistrationSource",
      state: "new",
      runType: "offCycle",
      billNo: `SBR-SRC-${Date.now()}`,
      billDate: new Date(),
      lastUpdate: new Date(),
      relatedParty: [
        {
          id: accountNumber,
          role: "Customer",
          name: eventSource,
          "@referredType": "Customer",
          "@type": "RelatedParty",
        },
      ],
      billingAccount: {
        id: accountNumber,
        name: `Billing Account - ${accountNumber}`,
        "@referredType": "BillingAccount",
        "@type": "BillingAccountRef",
      },
      taxItem: [
        {
          taxCategory: String(billHandingCode),
          taxRate: 0,
          "@type": "TaxItem",
        },
      ],
      billDocument: [
        {
          id: uuidv4(),
          description: `Source Type: ${sourceTypeId} | Billing Contact: ${billingContact} | Customer Confirmed: ${isCustomerConfirmed}`,
          "@type": "Attachment",
        },
      ],
      "@type": "CustomerBill",
      "@baseType": "CustomerBill",
    });

    await newBill.save();

    return res.status(201).json({
      message: "SmartBill Registration Source successful",
      data: newBill,
    });
  } catch (error) {
    console.error("Error in SmartBillRegistrationSource:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};