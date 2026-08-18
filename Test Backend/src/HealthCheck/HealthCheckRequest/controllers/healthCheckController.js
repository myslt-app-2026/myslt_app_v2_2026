// TMF653 - Service Test Management v4 - HealthCheckRequest
exports.getHealthCheckStatus = async (req, res) => {
    try {
        const telephoneNo = req.query.telephoneNo;
        const accountNo = req.query.accountNo;

        if (!telephoneNo || !accountNo) {
            return res.status(400).json({
                "@type": "Error",
                code: "ERR_MISSING_PARAMS",
                reason: "telephoneNo and accountNo are required"
            });
        }

        console.log(`HealthCheckRequest received: Tel=${telephoneNo}, Acc=${accountNo}`);

        res.status(200).json({
            "@type": "ServiceTest",
            "@schemaLocation": "/tmf-api/serviceTestManagement/v4/schema/serviceTest",
            id: `healthcheck-${Date.now()}`,
            href: `/tmf-api/serviceTestManagement/v4/serviceTest/healthCheck`,
            name: "SystemHealthCheck",
            description: "System health check for service monitoring",
            state: "completed",
            testResult: "passed",
            startDateTime: new Date().toISOString(),
            endDateTime: new Date().toISOString(),
            relatedService: {
                telephoneNo,
                accountNo
            },
            characteristic: [
                { name: "systemStatus", value: "Operational" },
                { name: "lastCheck", value: new Date().toISOString() }
            ]
        });

    } catch (err) {
        console.error("Error in getHealthCheckStatus:", err);
        res.status(500).json({
            "@type": "Error",
            code: "ERR_INTERNAL",
            reason: "Internal Server Error",
            message: err.message
        });
    }
};
