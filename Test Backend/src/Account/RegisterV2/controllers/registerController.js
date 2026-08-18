const RegisterService = require('../services/registerService');

class RegisterController {
  static async registerV2(req, res) {
    try {
      const result = await RegisterService.register(req.body);

      return res.status(201).json({
        status: 'SUCCESS',
        data: result
      });
    } catch (error) {
      return res.status(400).json({
        status: 'ERROR',
        message: error.message
      });
    }
  }
}

module.exports = RegisterController;
