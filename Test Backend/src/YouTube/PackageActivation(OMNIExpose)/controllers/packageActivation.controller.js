const ServiceInventory = require('../../../models/TMF638_ServiceModel');

// ── Controller ────────────────────────────────────────────────
const activatePackage = async (req, res) => {
  const { telephoneno, packageid } = req.query;

  try {
    // Build and save TMF638 Service document to MongoDB
    const serviceRecord = new ServiceInventory({
      id: `ACT-${Date.now()}`,
      state: 'active',

      serviceSpecification: {
        id: packageid,
        name: `Package-${packageid}`,
        '@type': 'ServiceSpecificationRef',
      },

      relatedParty: [
        {
          id: telephoneno,
          role: 'Subscriber',
          '@referredType': 'Individual',
        },
      ],

      serviceCharacteristic: [
        { name: 'telephoneNo', value: telephoneno },
        { name: 'packageId',   value: packageid  },
      ],

      '@type':     'Service',
      '@baseType': 'Service',
    });

    const saved = await serviceRecord.save();

    return res.status(201).json(saved);

  } catch (error) {
    console.error('[PackageActivation] Error:', error);
    return res.status(500).json({
      code: 500,
      status: 'Internal Server Error',
      message: 'An unexpected error occurred while processing the package activation.',
    });
  }
};

module.exports = { activatePackage };
