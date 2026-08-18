const CommunicationMessage = require("../../../models/TMF681_CommunicationMessage");

const getAdvertisementList = async () => {
  const data = await CommunicationMessage.find({
    messageType: "Banner"
  });

  return {
    success: true,
    statusCode: 200,
    count: data.length,
    data
  };
};

module.exports = {
  getAdvertisementList
};