const { applicationGenerator } = require("../services/applicationGeneratorService");

const applicationGeneratorRequest = async (req, res) => {
  try {
    const result = await applicationGenerator(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("ApplicationGenerator error:", error);
    return res.status(500).json({ success: false, message: "Internal Server Error" });
  }
};

module.exports = { applicationGeneratorRequest };