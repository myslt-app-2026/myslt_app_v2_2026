const Customer = require("../models/Customer");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Generate JWT token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: "15m", // short expiry for password change
  });
};

// Step 1: Request password change (verify + issue JWT)
exports.requestPasswordChange = async (req, res) => {
  const { subscriberID, currentPassword } = req.body;

  if (!subscriberID || !currentPassword) {
    return res
      .status(400)
      .json({ message: "subscriberID and currentPassword are required" });
  }

  try {
    const customer = await Customer.findOne({ subscriberID });
    if (!customer) {
      return res.status(404).json({ message: "Customer not found" });
    }

    const isMatch = await customer.matchPassword(currentPassword);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate a short-lived JWT
    const token = generateToken(customer._id);

    res.status(200).json({
      id: customer._id,
      subscriberID: customer.subscriberID,
      token,
      status: "verification_success",
      message:
        "Verification successful. Use this token to call changePassword endpoint.",
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Step 2: Change password (JWT required, TMF-629 aligned)
exports.changePassword = async (req, res) => {
  const { id } = req.params; // MongoDB _id
  const { newPassword } = req.body;

  if (!newPassword) {
    return res.status(400).json({ message: "newPassword is required" });
  }

  try {
    const customer = await Customer.findById(id);

    if (!customer) {
      return res.status(404).json({ message: "Customer not found" });
    }

    const salt = await bcrypt.genSalt(10);
    customer.password = await bcrypt.hash(newPassword, salt);

    await customer.save();

    res.status(200).json({
      id: customer._id,
      href: `${req.protocol}://${req.get(
        "host"
      )}/tmf-api/customerManagement/v5/customer/${customer._id}`,
      status: "updated",
      message: "Password updated successfully",
      relatedParty: {
        id: customer.subscriberID,
        role: "subscriber",
        name: customer.username,
        "@referredType": "Individual",
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
