/**
 * CheckExistCustomerService
 * - Uses TMF629 Customer model to locate a customer by NIC or PP
 */
const Customer = require('../../../models/TMF629_Customer');

class CheckExistCustomerService {
  /**
   * Check customer existence by query params
   * Supports: NIC, PP
   * Returns Customer document or null
   */
  static async checkExistence(query = {}) {
    const { NIC, PP } = query;

    const mongoQuery = { $or: [] };

    if (NIC && String(NIC).trim()) {
      const v = String(NIC).trim();
      mongoQuery.$or.push({ id: v });
      mongoQuery.$or.push({ 'engagedParty.id': v });
      mongoQuery.$or.push({ 'engagedParty.identification': v });
    }

    if (PP && String(PP).trim()) {
      const v = String(PP).trim();
      // try phoneNumber or email or other identifiers
      mongoQuery.$or.push({ 'contactMedium.characteristic.phoneNumber': v });
      mongoQuery.$or.push({ 'contactMedium.characteristic.emailAddress': v });
      mongoQuery.$or.push({ id: v });
    }

    // If no search criteria provided, return null
    if (!mongoQuery.$or.length) return null;

    const customer = await Customer.findOne(mongoQuery).lean();
    return customer || null;
  }
}

module.exports = CheckExistCustomerService;
