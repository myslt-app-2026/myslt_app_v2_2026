const Customer = require("../../../models/TMF629_Customer");

const changeBBPassword = async (body) => {
  const { subscriberID, bbPassword } = body;

  if (!subscriberID || !bbPassword) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID and bbPassword are required",
    };
  }

  const updated = await Customer.findOneAndUpdate(
    { subscriberID },
    { $set: { bbPassword } },
    { new: true, upsert: true }
  );

  return {
    success: true,
    statusCode: 200,
    data: updated,
  };
};

module.exports = { changeBBPassword };