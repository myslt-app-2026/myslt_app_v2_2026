// controllers/customerBillOnDemandController.js
const { v4: uuidv4 } = require("uuid");
const { CustomerBillOnDemand } = require("../../../models/TMF678_CustomerBill"); // Updated import to destructure CustomerBillOnDemand

/**
 * @desc Create CustomerBillOnDemand (TMF678 POST /customerBillOnDemand)
 * @route POST /tmf-api/Customer_Bill_Management/v5/customerBillOnDemand?fields=
 */
exports.createCustomerBillOnDemand = async (req, res) => {
  try {
    const data = req.body;

    // 🧩 Mandatory field validation (per TMF678)
    if (!data.description) {
      return res.status(400).json({ code: 400, reason: "description is mandatory" });
    }
    if (!data["@type"]) {
      return res.status(400).json({ code: 400, reason: "@type is mandatory" });
    }
    if (!data.billingAccount || !data.billingAccount.id) {
      return res.status(400).json({
        code: 400,
        reason: "billingAccount.id is mandatory",
      });
    }

    // Generate resource identifiers
    const id = `D-${uuidv4()}`;
    const href = `${req.protocol}://${req.get("host")}/tmf-api/Customer_Bill_Management/v5/customerBillOnDemand/${id}`;

    // Construct object
    const newBillRequest = new CustomerBillOnDemand({
      id,
      href,
      description: data.description,
      name: data.name || "BillOnCustomerDemand",
      billingAccount: {
        id: data.billingAccount.id,
        href: `${req.protocol}://${req.get("host")}/tmf-api/Account_Management/v5/billingAccount/${data.billingAccount.id}`,
        name: data.billingAccount.name || "Billing Account",
        "@referredType": "BillingAccount",
        "@type": "BillingAccountRef",
      },
      relatedParty: data.relatedParty || {
        role: "requester",
        "@type": "RelatedPartyRefOrRelatedPartyRoleRef",
        partyOrPartyRole: {
          id: "Unknown",
          name: "Anonymous",
          "@referredType": "Individual",
          "@type": "PartyRef",
        },
      },
      characteristic: data.characteristic || [],
      state: data.state || "inProgress",
      "@type": data["@type"],
    });

    const savedRequest = await newBillRequest.save();

    // 🧾 Handle `?fields=` query parameter
    let responseData = savedRequest.toObject();
    const { fields } = req.query;
    if (fields) {
      const requestedFields = fields.split(",").map((f) => f.trim());
      responseData = Object.fromEntries(
        Object.entries(responseData).filter(([key]) => requestedFields.includes(key))
      );
    }

    return res.status(201).json(responseData);
  } catch (error) {
    console.error("Error creating CustomerBillOnDemand:", error);
    return res.status(500).json({
      code: 500,
      reason: "Internal Server Error",
    });
  }
};
