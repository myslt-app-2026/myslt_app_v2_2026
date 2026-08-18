const ServiceReservation = require("../../../models/TMF633_ServiceReservation");
const { v4: uuidv4 } = require("uuid");

class ReserveFacilityController {
  static async reserveFacility(req, res) {
    try {
      const {
        description,
        relatedParty,
        requestedStartDate,
        requestedEndDate,
        attributes,
      } = req.body;

      if (!relatedParty || !attributes) {
        return res.status(400).json({
          code:    "400",
          reason:  "Validation Error",
          message: "Missing required fields: relatedParty and attributes",
          status:  "400",
          "@type": "Error",
        });
      }

      const reservation = new ServiceReservation({
        _id:                uuidv4(),
        description:        description || "Facility Reservation",
        relatedParty:       relatedParty,
        requestedStartDate: requestedStartDate || new Date(),
        requestedEndDate:   requestedEndDate || null,
        reservationState:   "reserved",
        attributes:         attributes,
        "@type":            "ServiceReservation",
      });

      const saved = await reservation.save();

      return res.status(201).json({
        id:                 saved._id,
        description:        saved.description,
        relatedParty:       saved.relatedParty,
        requestedStartDate: saved.requestedStartDate,
        requestedEndDate:   saved.requestedEndDate,
        reservationState:   saved.reservationState,
        attributes:         saved.attributes,
        "@type":            saved["@type"],
      });

    } catch (error) {
      console.error("[ReserveFacility] Error:", error);
      return res.status(500).json({
        code:    "500",
        reason:  "Internal Server Error",
        message: error.message,
        status:  "500",
        "@type": "Error",
      });
    }
  }
}

module.exports = ReserveFacilityController;