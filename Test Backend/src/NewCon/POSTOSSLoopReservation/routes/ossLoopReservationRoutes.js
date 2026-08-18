const express = require("express");
const router = express.Router();

const {
  ossLoopReservationRequest,
} = require("../controllers/ossLoopReservationController");

router.post(
  "/OSSLoopReservation",
  ossLoopReservationRequest
);

module.exports = router;