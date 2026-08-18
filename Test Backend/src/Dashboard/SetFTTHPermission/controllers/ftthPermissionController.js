const FTTHPermission = require('../../../models/TMF720_DigitalIdentity');

exports.setFTTHPermission = async (req, res) => {
  try {
    const { userName, privilege } = req.query;

    if (!userName || privilege === undefined) {
      return res.status(400).json({
        "@type": "Error",
        code:    "ERR_MISSING_PARAMS",
        reason:  "userName and privilege are required as query parameters."
      });
    }

    const privilegeNum = parseInt(privilege);
    if (isNaN(privilegeNum)) {
      return res.status(400).json({
        "@type": "Error",
        code:    "ERR_INVALID_PRIVILEGE",
        reason:  "privilege must be a valid number."
      });
    }

    const permission = await FTTHPermission.findOneAndUpdate(
      { "party.id": userName },
      {
        party:  [{ id: userName, name: userName }],
        status: "Active",
      },
      {
        new:           true,
        upsert:        true,
        runValidators: true
      }
    );

    return res.status(200).json({
      "@type":          "Permission",
      id:               permission._id,
      href:             `/tmf-api/userRolesPermissions/v4/permission/ftth`,
      userName:         userName,
      privilege:        privilegeNum,
      state:            "granted",
      lastModifiedDate: new Date()
    });

  } catch (err) {
    return res.status(500).json({
      "@type":  "Error",
      code:     "ERR_INTERNAL",
      reason:   "Server Error",
      message:  err.message
    });
  }
};