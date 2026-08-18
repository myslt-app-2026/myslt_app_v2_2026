const UsageManagement =
require("../../../models/TMF635_UsageManagement");

const getVoiceUsage = async () => {

    const data = await UsageManagement.find();

    console.log(data);

    return data;

};

module.exports = {
    getVoiceUsage
};