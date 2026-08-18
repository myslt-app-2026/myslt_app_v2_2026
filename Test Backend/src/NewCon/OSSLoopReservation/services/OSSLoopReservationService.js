/**
 * OSSLoopReservationService
 * Handles creation of OSS loop reservation records (TMF-like structure)
 */
const OSSLoopReservation = require('../../../models/TMF633_ServiceReservation');

class OSSLoopReservationService {
  static async createReservation(data = {}) {
    const payload = {
      description: data.description || 'OSS Loop Reservation',
      relatedParty: data.relatedParty || [],
      requestedStartDate: data.requestedStartDate ? new Date(data.requestedStartDate) : undefined,
      requestedEndDate: data.requestedEndDate ? new Date(data.requestedEndDate) : undefined,
      reservationState: data.reservationState || 'IN_PROGRESS',
      attributes: data.attributes || {}
    };

    const created = await OSSLoopReservation.create(payload);
    return created.toObject ? created.toObject() : created;
  }
}

module.exports = OSSLoopReservationService;
