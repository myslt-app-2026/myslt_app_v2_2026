// TMF622 - Product Ordering Management v4 - FTTH Request Charts
const FTTHRequestChart = require('../../../models/TMF622_ProductOrder');

exports.getFTTHRequestCharts = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
      return res.status(400).json({
        "@type": "Error",
        code: "ERR_MISSING_PARAMS",
        reason: "startDate and endDate are required as query parameters."
      });
    }

    // Validate date format
    const start = new Date(startDate);
    const end = new Date(endDate);

    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      return res.status(400).json({
        "@type": "Error",
        code: "ERR_INVALID_DATE",
        reason: "Invalid date format. Please use YYYY-MM-DD format."
      });
    }

    // Set end date to end of day
    end.setHours(23, 59, 59, 999);

    // Aggregate request data for charts - group by date and status
    const chartData = await FTTHRequestChart.aggregate([
      {
        $match: {
          requestDate: {
            $gte: start,
            $lte: end
          }
        }
      },
      {
        $group: {
          _id: {
            date: { $dateToString: { format: "%Y-%m-%d", date: "$requestDate" } },
            status: "$status"
          },
          count: { $sum: 1 }
        }
      },
      {
        $sort: { "_id.date": 1 }
      },
      {
        $group: {
          _id: "$_id.date",
          statusData: {
            $push: {
              status: "$_id.status",
              count: "$count"
            }
          },
          totalCount: { $sum: "$count" }
        }
      },
      {
        $project: {
          _id: 0,
          date: "$_id",
          statusData: 1,
          totalCount: 1
        }
      },
      {
        $sort: { date: 1 }
      }
    ]);

    res.status(200).json({
      "@type": "ProductOrderReport",
      "@schemaLocation": "/tmf-api/productOrderingManagement/v4/schema/productOrderReport",
      href: `/tmf-api/productOrderingManagement/v4/ftthRequest/charts`,
      startDate,
      endDate,
      chartData
    });
  } catch (err) {
    res.status(500).json({
      "@type": "Error",
      code: "ERR_INTERNAL",
      reason: "Server Error",
      message: err.message
    });
  }
};
