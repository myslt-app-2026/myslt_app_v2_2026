/**
 * Routes for OSSLoopReservation
 */
const express = require('express');
const router = express.Router();
const OSSLoopReservationController = require('../controllers/OSSLoopReservationController');

router.post('/OSSLoopReservation', OSSLoopReservationController.createReservation);

module.exports = router;
