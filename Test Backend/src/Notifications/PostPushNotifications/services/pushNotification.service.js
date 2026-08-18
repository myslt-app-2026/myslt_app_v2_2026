const CommunicationMessage = require('../../../models/TMF681_CommunicationMessage.js');
const { v4: uuidv4 } = require('uuid');

async function processPushNotification(payload) {
  const {
    accountNo,
    billMonth,
    BillCode,
    BillMode,
    email,
    mobile,
    NotType
  } = payload;

  const communicationMessage = new CommunicationMessage({
    id: uuidv4(),

    messageType: 'Push',
    state: 'Initial',

    subject: NotType,
    content: `Bill Month: ${billMonth}, Bill Mode: ${BillMode}`,

    sendTime: new Date(),

    relatedEntity: [
      {
        '@type': 'Account',
        id: accountNo
      }
    ],

    receiver: [
      {
        '@type': 'RelatedParty',
        role: 'recipient',
        contactMedium: [
          email
            ? {
                '@type': 'ContactMedium',
                mediumType: 'EMAIL',
                emailAddress: email
              }
            : null,
          mobile
            ? {
                '@type': 'ContactMedium',
                mediumType: 'MOBILE',
                phoneNumber: mobile
              }
            : null
        ].filter(Boolean)
      }
    ],

    characteristic: [
      {
        name: 'billCode',
        value: BillCode,
        valueType: 'String'
      },
      {
        name: 'billMode',
        value: BillMode,
        valueType: 'String'
      }
    ]
  });

  // Persist TMF resource
  await communicationMessage.save();

  // TODO: Push provider integration (FCM / APNs)
  // await pushAdapter.send(communicationMessage);

  return communicationMessage;
}

module.exports = {
  processPushNotification
};
