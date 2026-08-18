const Customer = require('../../../models/TMF629_Customer');
const ServiceInventory = require('../../../models/TMF638_ServiceModel');

exports.checkEbillUserExists = async (req, res) => {
  try {
    const {
      accountNo,
      tpNo,
      econtact,
      econtactType
    } = req.query;

    // 1. Validate input
    if (!accountNo) {
      return res.status(400).json({
        code: "INVALID_INPUT",
        message: "accountNo is required"
      });
    }

    // 2. Find customer by account
    const customer = await Customer.findOne({
      "account.id": accountNo
    });

    if (!customer) {
      return res.status(404).json({
        code: "CUSTOMER_NOT_FOUND",
        message: "Customer not found"
      });
    }

    // 3. Validate contact (optional but important)
    let contactMatch = false;

    if (econtactType === "EMAIL") {
      contactMatch = customer.contactMedium.some(
        cm =>
          cm.mediumType === "email" &&
          cm.characteristic?.emailAddress === econtact
      );
    }

    if (tpNo) {
      const phoneMatch = customer.contactMedium.some(
        cm =>
          cm.mediumType === "phone" &&
          cm.characteristic?.phoneNumber === tpNo
      );

      contactMatch = contactMatch || phoneMatch;
    }

    const ebillService = await ServiceInventory.findOne({
      "serviceSpecification.name": "eBill",
      "serviceCharacteristic": {
        $elemMatch: { name: "accountNumber", value: accountNo }
      }
    });

    // 5. Build response
    return res.status(200).json({
      accountNo,
      customerExists: true,
      contactMatched: contactMatch,
      eBillRegistered: !!ebillService
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      code: "INTERNAL_SERVER_ERROR",
      message: error.message
    });
  }
};