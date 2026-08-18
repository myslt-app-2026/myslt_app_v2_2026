const serviceInventoryService = require("./seviceInventoryService");

class ServiceInventoryController {

  /**
   * TMF638 GET /service
   * Used internally by CheckOmniTP
   */
  async getService(req, res) {
    const { telephoneNo } = req.query;

    if (!telephoneNo) {
      return res.status(400).json({
        error: "telephoneNo is required"
      });
    }

    const service =
      await serviceInventoryService.findActiveOmniTPServiceByTelephone(telephoneNo);

    /**
     * TMF rule:
     * - 200 + array when found
     * - 404 or empty array when not found
     */
    if (!service) {
      return res.status(404).json([]);
    }

    return res.status(200).json([service]);
  }

}

module.exports = new ServiceInventoryController();
