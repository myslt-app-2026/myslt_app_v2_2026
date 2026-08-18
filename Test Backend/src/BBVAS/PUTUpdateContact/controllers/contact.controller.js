const contactService = require("../services/contact.service");

exports.updateContact = async (req, res) => {
  try {
    const contactId = req.params.id;
    const updatedContact = await contactService.updateContact(contactId, req.body);

    if (!updatedContact) {
      return res.status(404).json({
        isSuccess: false,
        errorMessage: "Contact not found",
        exceptionDetail: null,
        dataBundle: null,
        errorShow: "Contact not found",
        errorCode: "404",
      });
    }

    res.json({
      isSuccess: true,
      errorMessage: "Contact updated successfully",
      exceptionDetail: null,
      dataBundle: updatedContact,
      errorShow: "Contact updated successfully",
      errorCode: "",
    });
  } catch (err) {
    res.status(500).json({
      isSuccess: false,
      errorMessage: "Server error",
      exceptionDetail: err.message,
      dataBundle: null,
      errorShow: "Server error",
      errorCode: "500",
    });
  }
};
