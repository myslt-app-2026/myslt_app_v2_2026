const FTTHDashboardUser = require('../../../models/TMF720_DigitalIdentity');
const { v4: uuidv4 } = require('uuid');

exports.ftthDashboardLogin = async (req, res) => {
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

    let user = await FTTHDashboardUser.findOne({ "party.id": userName });

    if (!user) {
      user = await FTTHDashboardUser.create({
        id:     uuidv4(),
        status: "Active",
        party:  [{ id: userName, name: userName }],
        credential: [{
          token:    `token-${Date.now()}`,
          validFor: {
            startDateTime: new Date(),
            endDateTime:   new Date(Date.now() + 24 * 60 * 60 * 1000)
          },
          status: "active"
        }]
      });

      return res.status(201).json({
        "@type":   "UserRole",
        id:        user.id,
        href:      `/tmf-api/userRolesPermissions/v4/permission/ftthLogin`,
        userName:  userName,
        privilege: privilegeNum,
        state:     "created",
        lastLogin: new Date()
      });
    }

    user.credential.push({
      token:    `token-${Date.now()}`,
      validFor: {
        startDateTime: new Date(),
        endDateTime:   new Date(Date.now() + 24 * 60 * 60 * 1000)
      },
      status: "active"
    });
    await user.save();

    return res.status(200).json({
      "@type":   "UserRole",
      id:        user.id,
      href:      `/tmf-api/userRolesPermissions/v4/permission/ftthLogin`,
      userName:  userName,
      privilege: privilegeNum,
      state:     "authenticated",
      lastLogin: new Date()
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