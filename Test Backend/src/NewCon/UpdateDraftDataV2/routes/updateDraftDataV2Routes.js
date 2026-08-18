const express = require('express');
const router = express.Router();
const { updateDraftDataV2Request } = require('../controllers/updateDraftDataV2Controller');

router.post('/', updateDraftDataV2Request);

module.exports = router;
