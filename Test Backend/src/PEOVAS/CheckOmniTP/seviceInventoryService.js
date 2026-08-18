const Service = require("../../../src/models/TMF638_ServiceModel.js");

class ServiceInventoryService {

  /**
   * TMF638-compliant service lookup
   */
  async findActiveOmniTPServiceByTelephone(telephoneNo) {
    return Service.findOne({
      state: "active",
      "serviceSpecification.name": "OmniTP",
      serviceCharacteristic: {
        $elemMatch: {
          name: "telephoneNumber",
          value: telephoneNo
        }
      }
    }).lean();
  }

}

module.exports = new ServiceInventoryService();
