// controllers/uploadMultipart.controller.js

const Document = require("../../../../src/models/TMF663_DocumentManagement.js");
const fs = require('fs');

const toBase64 = (filePath) => {
  return fs.readFileSync(filePath).toString('base64');
};

exports.uploadMultipartSingle = async (req, res) => {
  try {
    const files = req.files;
    const { orderreff } = req.body;

    if (!files || Object.keys(files).length === 0) {
      return res.status(400).json({ error: 'No files uploaded' });
    }

    const savedDocs = [];

    for (const fieldName in files) {
      const file = files[fieldName][0];

      const base64 = toBase64(file.path);

      const doc = new Document({
        name: file.originalname,
        mimeType: file.mimetype,
        content: base64,
        size: Buffer.from(base64, 'base64').length,
        documentType: fieldName, // maps nicfront_file etc.

        relatedEntity: [
          {
            id: orderreff,
            role: 'relatedOrder',
            referredType: 'ProductOrder'
          }
        ]
      });

      const saved = await doc.save();
      savedDocs.push(saved);
    }

    return res.status(201).json({
      message: 'Multipart upload successful',
      count: savedDocs.length,
      documents: savedDocs
    });

  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};