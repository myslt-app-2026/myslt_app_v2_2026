const UsageManagement =
require('../../../models/TMF635_UsageManagement');

const getExtraGBDashboard = async () => {

    const records =
    await UsageManagement.find({
        status: "active"
    });

    let totalVolume = 0;
    let remainingVolume = 0;

    records.forEach(record => {

        totalVolume +=
        record.volume || 0;

        remainingVolume +=
        record.remainingAmount || 0;

    });

    return {

        "@type": "UsageDashboard",

        dashboardName:
        "ExtraGBDashboard",

        totalSubscribers:
        records.length,

        totalVolume,

        remainingVolume,

        usedVolume:
        totalVolume - remainingVolume,

        unit: "MB"
    };
};

module.exports = {
    getExtraGBDashboard
};