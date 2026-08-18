const CommunicationMessage = require('../../../../src/models/TMF681_CommunicationMessage.js');

exports.sendOTP = async (req, res) => {
  try {
    // 1. Destructure incoming request
    const { requestType, requestPeriod, otpSource, otpContact } = req.body;

    // 2. Generate OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000);

    // 3. Build TMF 681 CommunicationMessage
    const newMessage = new CommunicationMessage({
      messageType: 'OTP',
      state: 'Initial',
      content: `Your OTP code is ${otpCode}`,

      receiver: [
        {
          '@type': 'RelatedParty',
          contactMedium: [
            {
              '@type': 'ContactMedium',
              mediumType: otpSource, // EMAIL | MOBILE | SMS
              emailAddress: otpSource === 'EMAIL' ? otpContact : undefined,
              phoneNumber:
                otpSource !== 'EMAIL' ? otpContact : undefined
            }
          ]
        }
      ],

      characteristic: [
        {
          name: 'requestType',
          value: requestType,
          valueType: 'String'
        },
        {
          name: 'requestPeriod',
          value: requestPeriod,
          valueType: 'Number'
        }
      ]
    });

    // 4. Save message
    const savedMessage = await newMessage.save();

    // 5. TMF-style response
    res.status(201).json(savedMessage);

  } catch (error) {
    res.status(500).json({
      message: 'Failed to send OTP',
      error: error.message
    });
  }
};


/*const CommunicationMessage = require('../../Notifications/PostPushNotifications/models/communicationMessage.model.js');

exports.sendOTP = async (req, res) => {
  try {
    // 1. Destructure incoming Postman request fields
    const { requestType, requestPeriod, otpSource, otpContact } = req.body;

    // 2. Map to TMF681 CommunicationMessage Model
    const newMessage = new CommunicationMessage({
      type: 'OTP',
      state: 'Initial',
      content: `Your OTP code is ${Math.floor(100000 + Math.random() * 900000)}`, // Logic to generate OTP
      receiver: [{
        // Mapping 'otpContact' based on source
        email: otpSource === 'EMAIL' ? otpContact : undefined,
        phoneNumber: otpSource === 'MOBILE' ? otpContact : undefined,
        mediumType: otpSource // Maps 'otpSource'
      }],
      characteristic: [
        { name: 'requestType', value: requestType },
        { name: 'requestPeriod', value: requestPeriod.toString() }
      ]
    });

    // 3. Save to Database
    const savedMessage = await newMessage.save();

    // 4. Respond with TMF standard structure
    res.status(201).json(savedMessage);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};*/
