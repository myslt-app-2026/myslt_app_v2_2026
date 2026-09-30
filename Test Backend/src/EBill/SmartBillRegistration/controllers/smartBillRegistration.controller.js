const { v4: uuidv4 } = require("uuid");
const CustomerBill = require("../../../models/TMF678_CustomerBill");

/**
 * POST /ebill/SmartBillRegistration
 * Original params: tpNo, accountNo, econtact, billCode
 * TMF reimplementation: params moved to request body
 */
exports.smartBillRegistration = async (req, res) => {
  try {
    const tpNo = req.body.tpNo || req.body.telephoneNumber || req.body.mobile || "0112345678";
    const accountNo = req.body.accountNo || req.body.accountNumber;
    const econtact = req.body.econtact || req.body.email;
    const billCode = req.body.billCode || req.body.eBillType || "PDF";

    if (!accountNo || !econtact) {
      return res.status(400).json({
        error:
          "Missing required fields in request body: accountNumber (or accountNo), email (or econtact)",
      });
    }

    // Check if already registered
    const existingBill = await CustomerBill.findOne({
      "billingAccount.id": accountNo,
      category: "SmartBillRegistration",
      state: { $in: ["new", "validated", "sent"] },
    });

    if (existingBill) {
      return res.status(409).json({
        error:
          "This account is already registered for SmartBill and cannot be registered again.",
      });
    }

    const billId = uuidv4();

    const newBill = new CustomerBill({
      id: billId,
      href: `http://localhost:3000/tmf-api/customerBill/v4/ebill/SmartBillRegistration/${billId}`,
      description: "SmartBill Registration Request",
      category: "SmartBillRegistration",
      state: "new",
      runType: "offCycle",
      billNo: `SBR-${Date.now()}`,
      billDate: new Date(),
      lastUpdate: new Date(),
      relatedParty: [
        {
          id: accountNo,
          role: "Customer",
          name: tpNo,
          "@referredType": "Customer",
          "@type": "RelatedParty",
        },
      ],
      billingAccount: {
        id: accountNo,
        name: `Billing Account - ${accountNo}`,
        "@referredType": "BillingAccount",
        "@type": "BillingAccountRef",
      },
      taxItem: [
        {
          taxCategory: String(billCode),
          taxRate: 0,
          "@type": "TaxItem",
        },
      ],
      billDocument: [
        {
          id: uuidv4(),
          description: `eContact: ${econtact} | Bill Code: ${billCode} | TP No: ${tpNo}`,
          "@type": "Attachment",
        },
      ],
      "@type": "CustomerBill",
      "@baseType": "CustomerBill",
    });

    await newBill.save();

    return res.status(201).json({
      message: "SmartBill Registration successful",
      data: newBill,
    });
  } catch (error) {
    console.error("Error in SmartBillRegistration:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};