const ServiceReservation = require("../../../models/TMF633_ServiceReservation");

class GetFacilityCheckController {
  static async getFacilityCheckV2(req, res) {
    try {
      const { subscriberId, facilityId } = req.query;

      if (!subscriberId) {
        return res.status(400).json({
          code:    "400",
          reason:  "Validation Error",
          message: "Missing required parameter: subscriberId",
          status:  "400",
          "@type": "Error",
        });
      }

      const reservations = await ServiceReservation.find({
        "relatedParty.id": subscriberId,
      });

      if (!reservations || reservations.length === 0) {
        return res.status(404).json({
          code:    "404",
          reason:  "Not Found",
          message: "No facility check found for subscriber",
          status:  "404",
          "@type": "Error",
        });
      }

      return res.status(200).json(reservations);

    } catch (error) {
      console.error("[GetFacilityCheckV2] Error:", error);
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

module.exports = GetFacilityCheckController;