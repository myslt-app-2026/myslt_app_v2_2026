const {
  getAdvertisementList
} = require("../services/advertisementListService");

const advertisementListRequest = async (req, res) => {

  try {

    const result =
      await getAdvertisementList(req.query);

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
  advertisementListRequest
};