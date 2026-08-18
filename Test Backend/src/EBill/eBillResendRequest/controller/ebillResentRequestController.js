const {
  TMF678_CustomerBill
} = require("../../../models/TMF678_CustomerBill");

/**
 * POST /api/ebill/eBillResendRequest
 * Retrieves bill document/data for a given month
 */
exports.eBillResendRequest = async (req, res) => {
  try {
    const {
      eContact,
      accountNo,
      ebillMonth,
      tpNo
    } = req.body;

    // 1. Validate required fields
    if (!accountNo || !ebillMonth) {
      return res.status(400).json({
        code: "INVALID_INPUT",
        message: "accountNo and ebillMonth are required"
      });
    }

    // 2. Convert 2023/07 => start/end dates
    const [year, month] = ebillMonth.split("/");

    if (!year || !month) {
      return res.status(400).json({
        code: "INVALID_MONTH",
        message: "Use format YYYY/MM"
      });
    }

    const startDate = new Date(`${year}-${month}-01T00:00:00.000Z`);
    const endDate = new Date(Number(year), Number(month), 1);

    // 3. Find bill by account + billing period
    const bill = await TMF678_CustomerBill.findOne({
      "billingAccount.id": accountNo,
      billDate: {
        $gte: startDate,
        $lt: endDate
      }
    });

    if (!bill) {
      return res.status(404).json({
        code: "BILL_NOT_FOUND",
        message: "No bill found for given month/account"
      });
    }

    // 4. Return response
    return res.status(200).json({
      requestType: "eBillResendRequest",
      deliveredTo: eContact,
      contactNumber: tpNo,
      bill: {
        id: bill.id,
        billNo: bill.billNo,
        billDate: bill.billDate,
        amountDue: bill.amountDue,
        state: bill.state,
        billingAccount: bill.billingAccount,
        documents: bill.billDocument
      }
    });

  } catch (error) {
    console.error(error);

    return res.status(500).json({
      code: "INTERNAL_SERVER_ERROR",
      message: error.message
    });
  }
};