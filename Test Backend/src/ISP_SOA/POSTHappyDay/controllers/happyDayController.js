const happyDayService = require("../services/happyDayService");

const enrollHappyDay = async (req, res) => {
  try {
    const { subscriberId, happyDay, happyDayDate, selectedDate } = req.body;

    const selectedHappyDay = happyDay || happyDayDate || selectedDate;

    if (!subscriberId) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberId is required",
      });
    }

    if (!selectedHappyDay) {
      return res.status(400).json({
        error: "Bad Request",
        message: "happyDay is required",
      });
    }

    const response = await happyDayService.enrollHappyDay(req.body);

    return res.status(201).json(response);
  } catch (error) {
    console.error("Happy Day enrollment error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  enrollHappyDay,
};