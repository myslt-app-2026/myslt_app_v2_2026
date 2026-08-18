const {
  ossLoopReservation,
} = require("../services/ossLoopReservationService");

const ossLoopReservationRequest = async (req, res) => {
  try {
    const result = await ossLoopReservation(req.body);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("OSSLoopReservation error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { ossLoopReservationRequest };