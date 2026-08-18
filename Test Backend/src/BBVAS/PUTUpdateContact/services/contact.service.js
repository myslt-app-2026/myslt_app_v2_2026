const Contact = require("../models/contact.model");

class ContactService {
  async updateContact(id, updateData) {
    return await Contact.findOneAndUpdate(
      { id }, // match by our custom id (not _id)
      updateData,
      { new: true }
    );
  }
}

module.exports = new ContactService();
