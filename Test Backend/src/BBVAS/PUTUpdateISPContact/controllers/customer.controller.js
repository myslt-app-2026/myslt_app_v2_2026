const ISPContact = require("../models/customer.model");

const formatTMFResponse = (data) => {
  if (!data) return {};

  return {
    id: data.id,
    href: `/tmf-api/customerManagement/v5/customer/${data.id}`,
    relatedParty: data.relatedParty,
    characteristic: data.characteristic,
    contactMedium: data.contactMedium,
    status: data.status,
  };
};

exports.updateCustomerContact = async (req, res) => {
  try {
    const { id } = req.params;
    const { contactMedium } = req.body;

    const updatedCustomer = await ISPContact.findOneAndUpdate(
      { id: id },
      { $set: { contactMedium: contactMedium } },
      { new: true, runValidators: true }
    );

    if (!updatedCustomer) {
      return res.status(404).json({
        code: 404,
        reason: "Not Found",
        message: `Customer with ID ${id} not found.`,
      });
    }

    res.status(200).json(formatTMFResponse(updatedCustomer));
  } catch (error) {
    console.error("Error updating customer contact:", error);
    res.status(500).json({
      code: 500,
      reason: "Internal Server Error",
      message: error.message,
    });
  }
};