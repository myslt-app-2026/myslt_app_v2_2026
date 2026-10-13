exports.subscribeChannel = async (req, res) => {
  try {
    const { productId, accountNumber } = req.body;

    if (!productId || !accountNumber) {
      return res.status(400).json({
        code: "ERR_MISSING_FIELD",
        message: "productId and accountNumber are required",
      });
    }

    // Mirrors the shape you already saw in GetPurchasedProducts' response
    const response = {
      _id: `PROD-${Date.now()}`,
      id: productId,
      category: "broadband",
      name: "PEO TV Value Added Service",
      status: "active",
      publicIdentifier: accountNumber,
      productOffering: { id: "PO-PEOVAS", name: "PEOVAS" },
      relatedParty: [{ id: accountNumber, role: "customer" }],
      startDate: new Date(),
      "@type": "Product",
      "@baseType": "Product",
    };

    res.status(201).json(response);
  } catch (error) {
    res.status(500).json({ message: "Failed to subscribe", error: error.message });
  }
};