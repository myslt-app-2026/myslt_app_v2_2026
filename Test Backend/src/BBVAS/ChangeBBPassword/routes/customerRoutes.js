const express = require("express");
const router = express.Router();
const { requestPasswordChange, changePassword } = require("../controllers/customerController");
const { protect } = require("../middleware/authMiddleware");

// Step 1: Request password change (verify customer + issue JWT)
router.post("/tmf-api/customerManagement/v5/customer/requestPasswordChange", requestPasswordChange);

// Step 2: Change password (JWT required, TMF-629 aligned)
router.put("/tmf-api/customerManagement/v5/customer/:id/changePassword", protect, changePassword);

module.exports = router;
