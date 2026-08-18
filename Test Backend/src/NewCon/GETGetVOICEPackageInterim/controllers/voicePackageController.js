const {
  getVOICEPackageInterim,
} = require("../services/voicePackageService");

const getVOICEPackageInterimRequest = async (req, res) => {
  try {
    const result = await getVOICEPackageInterim(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("GetVOICEPackageInterim error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { getVOICEPackageInterimRequest };