const DigitalIdentity = require("../../../models/TMF720_DigitalIdentity");

exports.getSubscriberToken = async () => {

    const digitalIdentity = await DigitalIdentity.findOne();

    if (!digitalIdentity) {
        return null;
    }

    return digitalIdentity;
};