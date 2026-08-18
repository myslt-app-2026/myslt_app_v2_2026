const Product =
require("../../../models/TMF637_Product");

const getAddonsDashboard = async () => {

  const data =
    await Product.find();

  return {
    success: true,
    statusCode: 200,
    totalRecords: data.length,
    data
  };

};

module.exports = {
  getAddonsDashboard
};