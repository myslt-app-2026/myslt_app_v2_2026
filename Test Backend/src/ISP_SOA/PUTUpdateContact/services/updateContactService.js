const Customer = require("../../../models/TMF629_Customer");

const updateContact = async (id, body) => {

  if (!id) {
    return {
      success: false,
      statusCode: 400,
      message: "Customer ID is required"
    };
  }

  const { contactMedium } = body;

  if (!contactMedium || !Array.isArray(contactMedium) || contactMedium.length === 0) {
    return {
      success: false,
      statusCode: 400,
      message: "contactMedium is required and must be an array"
    };
  }

  const updatedCustomer = await Customer.findOneAndUpdate(
    { id },
    { $set: { contactMedium } },
    { new: true, runValidators: true }
  );

  if (!updatedCustomer) {
    return {
      success: false,
      statusCode: 404,
      message: `Customer with ID ${id} not found`
    };
  }

  return {
    success: true,
    statusCode: 200,
    id: updatedCustomer.id,
    href: `/tmf-api/customerManagement/v5/customer/${updatedCustomer.id}`,
    status: updatedCustomer.status,
    contactMedium: updatedCustomer.contactMedium,
    "@type": "Customer"
  };
};

module.exports = { updateContact };