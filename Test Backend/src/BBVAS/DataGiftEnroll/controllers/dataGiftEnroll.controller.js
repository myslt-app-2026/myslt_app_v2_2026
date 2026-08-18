const { v4: uuidv4 } = require("uuid");
const dataGiftService = require("../services/dataGiftEnroll.service");

exports.addDataGiftEnroll = async (req, res) => {
  try {
    const giftData = {
      id: uuidv4(),
      senderId: req.body.senderId,
      receiverId: req.body.receiverId,
      bundleName: req.body.bundleName,
      dataVolume: req.body.dataVolume,
      validity: req.body.validity,
      status: "initiated",
    };

    const newGift = await dataGiftService.createDataGift(giftData);

    res.status(201).json({
      href: `/tmf-api/productOrdering/v4/DataGiftEnroll/${newGift.id}`,
      id: newGift.id,
      status: newGift.status,
      senderId: newGift.senderId,
      receiverId: newGift.receiverId,
      bundleName: newGift.bundleName,
      dataVolume: newGift.dataVolume,
      validity: newGift.validity,
      createdAt: newGift.createdAt,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
