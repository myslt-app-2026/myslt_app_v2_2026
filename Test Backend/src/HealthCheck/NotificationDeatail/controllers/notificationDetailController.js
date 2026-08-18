// TMF681 - Communication Management v4 - NotificationDetail
exports.getNotificationDetails = async (req, res) => {
    try {
        const telephoneNo = req.query.telephoneNo;
        const accountNo = req.query.accountNo;

        console.log(`NotificationDetails request received: Tel=${telephoneNo}, Acc=${accountNo}`);

        const notifications = [
            {
                "@type": "CommunicationMessage",
                id: "notif-001",
                href: "/tmf-api/communicationManagement/v4/communicationMessage/notif-001",
                type: "Maintenance",
                content: "Scheduled maintenance on 30th Jan",
                sendDateTime: new Date().toISOString(),
                state: "Unread",
                receiver: [
                    {
                        "@type": "CommunicationMessageReceiver",
                        telephoneNo: telephoneNo || null,
                        accountNo: accountNo || null
                    }
                ]
            },
            {
                "@type": "CommunicationMessage",
                id: "notif-002",
                href: "/tmf-api/communicationManagement/v4/communicationMessage/notif-002",
                type: "Billing",
                content: "Bill for Dec 2025 is ready",
                sendDateTime: new Date(Date.now() - 86400000).toISOString(),
                state: "Read",
                receiver: [
                    {
                        "@type": "CommunicationMessageReceiver",
                        telephoneNo: telephoneNo || null,
                        accountNo: accountNo || null
                    }
                ]
            }
        ];

        res.status(200).json({
            "@type": "CommunicationMessageCollection",
            "@schemaLocation": "/tmf-api/communicationManagement/v4/schema/communicationMessage",
            totalCount: notifications.length,
            communicationMessage: notifications
        });

    } catch (err) {
        console.error("Error in getNotificationDetails:", err);
        res.status(500).json({
            "@type": "Error",
            code: "ERR_INTERNAL",
            reason: "Internal Server Error",
            message: err.message
        });
    }
};
