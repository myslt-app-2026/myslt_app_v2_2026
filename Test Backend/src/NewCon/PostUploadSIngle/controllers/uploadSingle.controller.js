// controllers/uploadSingle.controller.js

const Document = require("../../../../src/models/TMF663_DocumentManagement.js");

exports.uploadSingle = async (req, res) => {
  try {
    const { nic, rtom } = req.query;
    let { application_file } = req.body;

    if (!application_file) {
      return res.status(400).json({ error: 'application_file required' });
    }

    // Strip prefix if present
    if (application_file.includes('base64,')) {
      application_file = application_file.split('base64,')[1];
    }

    const doc = new Document({
      name: `application_${nic || 'unknown'}.pdf`,
      mimeType: 'application/pdf',
      content: application_file,
      size: Buffer.from(application_file, 'base64').length,
      documentType: 'application',

      relatedEntity: [
        {
          id: nic,
          role: 'customer',
          referredType: 'Individual'
        },
        {
          id: rtom,
          role: 'location',
          referredType: 'Place'
        }
      ]
    });

    const saved = await doc.save();

    return res.status(201).json({
      message: 'Base64 upload successful',
      document: saved
    });

  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};