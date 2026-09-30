const { v4: uuidv4 } = require("uuid");
const dataGiftService = require("../services/dataGiftEnroll.service");

exports.addDataGiftEnroll = async (req, res) => {
  try {
    const giftData = {
      id: uuidv4(),
      senderId: req.body.senderId || req.body.accountNumber || "0312241780",
      receiverId: req.body.receiverId || req.body.recipientMobile || "0771234567",
      bundleName: req.body.bundleName || "Data Gift Package",
      dataVolume: req.body.dataVolume || (req.body.amountGB ? `${req.body.amountGB} GB` : "5 GB"),
      validity: req.body.validity || "30 days",
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
