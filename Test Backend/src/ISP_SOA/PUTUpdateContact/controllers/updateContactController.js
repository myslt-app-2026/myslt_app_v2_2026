const {
  updateContact
} = require("../services/updateContactService");

const updateContactRequest = async (req, res) => {

  try {

    const { id } = req.params;
    const result = await updateContact(id, req.body);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = {
  updateContactRequest
};