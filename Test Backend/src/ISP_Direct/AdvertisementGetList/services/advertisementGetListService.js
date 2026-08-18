const CommunicationMessage =
require("../../../models/TMF681_CommunicationMessage");

const getAdvertisementList = async (query = {}) => {

    const { pageid = 1 } = query;

    const data = await CommunicationMessage.find({
        messageType: "Banner"
    });

    return {
        success: true,
        statusCode: 200,
        page: Number(pageid),
        count: data.length,
        data
    };

};

module.exports = {
    getAdvertisementList
};