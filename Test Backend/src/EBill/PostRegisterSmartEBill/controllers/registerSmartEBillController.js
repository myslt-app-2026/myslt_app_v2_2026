exports.registerSmartEBill = async (req, res) => {
  try {
    const { accountNo, email, billFormat } = req.body;

    if (!accountNo || !email) {
      return res.status(400).json({
        code: "ERR_MISSING_FIELD",
        message: "accountNo and email are required",
      });
    }

    // TMF-style response (no DB persistence yet — add a Mongoose
    // model later if you need this to actually be saved/queried)
    const response = {
      id: `EBILL-${Date.now()}`,
      accountNo,
      email,
      billFormat: billFormat || "PDF",
      status: "active",
      registeredAt: new Date(),
    };

    res.status(201).json(response);
  } catch (error) {
    res.status(500).json({ message: "Failed to register Smart E-Bill", error: error.message });
  }
};