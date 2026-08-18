const DigitalIdentity = require('../../../../src/models/TMF720_DigitalIdentity.js');

exports.verifyOTP = async (req, res) => {
  try {
    // 1. Destructure Postman Request
    const { requestType, otpCode, otpSource, otpContact } = req.body;

    // SIMULATION: In a real app, you would query the DB to find the OTP.
    // Here we are creating a response based on TMF720 validation logic.

    // 2. Logic to check credential (TMF720 pattern)
    // We assume we are checking against a Digital Identity found by 'otpContact'
    
    // For demonstration, we assume success if otpCode exists
    if (!otpCode) {
      return res.status(400).json({ code: "ERR_MISSING_CREDENTIAL", message: "otpCode is required" });
    }

    const response = {
      id: "generated-uuid-1234",
      href: `/digitalIdentity/generated-uuid-1234`,
      status: "Active",
      credential: [{
        token: otpCode,
        status: "Validated"
      }],
      characteristic: [
        { name: "verificationSource", value: otpSource },
        { name: "contactValidated", value: otpContact }
      ]
    };

    res.status(200).json(response);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};