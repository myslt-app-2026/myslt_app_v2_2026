const ProductOffering = require("../../../models/TMF620_ProductOffering");

class GetCityListController {
  static async getCityList(req, res) {
    try {
      const cities = await ProductOffering.find({
        category: { $regex: /city/i }
      });

      if (!cities || cities.length === 0) {
        return res.status(200).json([
          { id: "CITY-001", name: "Colombo",      "@type": "City" },
          { id: "CITY-002", name: "Kandy",        "@type": "City" },
          { id: "CITY-003", name: "Galle",        "@type": "City" },
          { id: "CITY-004", name: "Jaffna",       "@type": "City" },
          { id: "CITY-005", name: "Negombo",      "@type": "City" },
          { id: "CITY-006", name: "Matara",       "@type": "City" },
          { id: "CITY-007", name: "Kurunegala",   "@type": "City" },
          { id: "CITY-008", name: "Ratnapura",    "@type": "City" },
          { id: "CITY-009", name: "Anuradhapura", "@type": "City" },
          { id: "CITY-010", name: "Badulla",      "@type": "City" },
        ]);
      }

      return res.status(200).json(cities);

    } catch (error) {
      console.error("[GetCityList] Error:", error);
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

module.exports = GetCityListController;