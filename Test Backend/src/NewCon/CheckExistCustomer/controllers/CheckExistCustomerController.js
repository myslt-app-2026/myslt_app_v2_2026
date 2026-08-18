/**
 * CheckExistCustomerController - simple existence check for customers
 * Public GET /api/NewCon/CheckExistCustomer?NIC=xxx&PP=yyy
 */
const CheckExistCustomerService = require('../services/CheckExistCustomerService');

class CheckExistCustomerController {
  /**
   * Check if customer exists by NIC or PP
   */
  static async check(req, res) {
    try {
      const result = await CheckExistCustomerService.checkExistence(req.query);
      if (!result) {
        return res.status(404).json({ code: 'NOT_FOUND', message: 'Customer not found' });
      }
      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({
        code: '500',
        reason: 'Internal Server Error',
        message: error.message
      });
    }
  }
}

module.exports = CheckExistCustomerController;
