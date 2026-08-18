const express = require('express');
const router = express.Router();
const { getDraftDataV2Request } = require('../controllers/getDraftDataV2Controller');

router.get('/', getDraftDataV2Request);

module.exports = router;
