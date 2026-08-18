// src/BBVAS/PurchasedHistory/controllers/purchasedHistoryController.js

const PurchasedHistory = require('../models/PurchasedHistory');

const getPurchasedHistory = async (req, res) => {
    try {
        const { historyFrom, historyTo, subscriberId } = req.query;
        let query = {};

        if (historyFrom || historyTo) {
            query.usageDate = {};
            if (historyFrom) {
                query.usageDate.$gte = new Date(historyFrom);
            }
            if (historyTo) {
                query.usageDate.$lte = new Date(historyTo);
            }
        }

        if (subscriberId) {
            query['relatedParty.id'] = subscriberId;
        }

        const purchasedHistory = await PurchasedHistory.find(query);

        if (purchasedHistory.length === 0) {
            return res.status(404).json({ message: 'No purchased history found matching the criteria.' });
        }

        res.status(200).json(purchasedHistory);

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
};

module.exports = {
    getPurchasedHistory
};