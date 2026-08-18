/**
 * OSSLoopReservationController
 * POST /api/NewCon/OSSLoopReservation
 */
const OSSLoopReservationService = require('../services/OSSLoopReservationService');

class OSSLoopReservationController {
  static async createReservation(req, res) {
    try {
      const data = req.body || {};
      const reservation = await OSSLoopReservationService.createReservation(data);

      res.status(201).json({
        id: reservation._id,
        href: `/tmf-api/serviceReservation/v1/ossLoopReservation/${reservation._id}`,
        ...reservation
      });
    } catch (err) {
      res.status(400).json({
        code: '400',
        reason: 'Bad Request',
        message: err.message
      });
    }
  }
}

module.exports = OSSLoopReservationController;
