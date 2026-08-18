const ServiceInventory = require('../../../models/TMF638_ServiceModel');
const Customer = require('../../../models/TMF629_Customer');
const { v4: uuidv4 } = require('uuid');

exports.registerEbill = async (req, res) => {
  try {
    const {
      eventSource,
      email,
      contactNumber,
      accountNumber,
      enableSms,
      isPrestigeCustomer
    } = req.body;

    // 1. Validate required fields
    if (!accountNumber || !email) {
      return res.status(400).json({
        code: "INVALID_INPUT",
        message: "accountNumber and email are required"
      });
    }

    // 2. Check customer exists
    const customer = await Customer.findOne({ "account.id": accountNumber });

    if (!customer) {
      return res.status(404).json({
        code: "CUSTOMER_NOT_FOUND",
        message: "Customer not found"
      });
    }

    // 3. Check if eBill already exists
    const existingService = await ServiceInventory.findOne({
      name: "eBill Service",
      "serviceCharacteristic": {
        $elemMatch: { name: "accountNumber", value: accountNumber }
      }
    });

    if (existingService) {
      return res.status(409).json({
        code: "EBILL_ALREADY_EXISTS",
        message: "eBill already registered for this account"
      });
    }

    // 4. Build TMF638 Service object
    const servicePayload = {
      id: uuidv4(),
      name: "eBill Service",
      state: "active",
      startDate: new Date(),

      serviceSpecification: {
        id: "EBILL_SPEC_001",
        name: "eBill",
        "@type": "ServiceSpecificationRef"
      },

      relatedParty: [
        {
          id: customer._id.toString(),
          role: "Customer",
          "@referredType": "Individual"
        }
      ],

      serviceCharacteristic: [
        { name: "eventSource", value: eventSource },
        { name: "email", value: email },
        { name: "contactNumber", value: contactNumber },
        { name: "accountNumber", value: accountNumber },
        { name: "enableSms", value: Boolean(enableSms) },
        { name: "isPrestigeCustomer", value: Boolean(isPrestigeCustomer) }
      ],

      "@type": "CustomerFacingService",
      "@baseType": "Service"
    };

    // 5. Save
    const service = new ServiceInventory(servicePayload);
    await service.save();

    return res.status(201).json(service);

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      code: "INTERNAL_SERVER_ERROR",
      message: error.message
    });
  }
};