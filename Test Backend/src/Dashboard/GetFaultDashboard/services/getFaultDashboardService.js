/**
 * getFaultDashboardService.js
 * TMF621 - Trouble Ticket Management API
 *
 * Aggregates fault/trouble ticket data for the Dashboard.
 * Returns summary counts grouped by status, severity, and ticketType,
 * plus a list of recent tickets filtered by optional date range.
 */
const TroubleTicket = require('../../../models/TMF621_TroubleTicket');

const getFaultDashboard = async (query = {}) => {
  const { startDate, endDate, status, severity, ticketType } = query;

  // Build date filter
  const dateFilter = {};
  if (startDate || endDate) {
    dateFilter.creationDate = {};
    if (startDate) {
      const start = new Date(startDate);
      if (isNaN(start.getTime())) {
        return { success: false, statusCode: 400, message: 'Invalid startDate format. Use YYYY-MM-DD.' };
      }
      dateFilter.creationDate.$gte = start;
    }
    if (endDate) {
      const end = new Date(endDate);
      if (isNaN(end.getTime())) {
        return { success: false, statusCode: 400, message: 'Invalid endDate format. Use YYYY-MM-DD.' };
      }
      end.setHours(23, 59, 59, 999);
      dateFilter.creationDate.$lte = end;
    }
  }

  // Build additional filters
  const matchFilter = { ...dateFilter };
  if (status)     matchFilter.status = status;
  if (severity)   matchFilter.severity = severity;
  if (ticketType) matchFilter.ticketType = ticketType;

  // Aggregate: count by status
  const statusCounts = await TroubleTicket.aggregate([
    { $match: matchFilter },
    { $group: { _id: '$status', count: { $sum: 1 } } },
    { $project: { _id: 0, status: '$_id', count: 1 } },
    { $sort: { count: -1 } }
  ]);

  // Aggregate: count by severity
  const severityCounts = await TroubleTicket.aggregate([
    { $match: matchFilter },
    { $group: { _id: '$severity', count: { $sum: 1 } } },
    { $project: { _id: 0, severity: '$_id', count: 1 } },
    { $sort: { count: -1 } }
  ]);

  // Aggregate: count by ticketType
  const typeCounts = await TroubleTicket.aggregate([
    { $match: matchFilter },
    { $group: { _id: '$ticketType', count: { $sum: 1 } } },
    { $project: { _id: 0, ticketType: '$_id', count: 1 } },
    { $sort: { count: -1 } }
  ]);

  // Total count
  const totalCount = statusCounts.reduce((sum, s) => sum + s.count, 0);

  // Recent 10 tickets
  const recentTickets = await TroubleTicket.find(matchFilter)
    .select('id name ticketType status severity priority creationDate lastUpdate relatedParty')
    .sort({ creationDate: -1 })
    .limit(10);

  return {
    success: true,
    statusCode: 200,
    data: {
      '@type': 'FaultDashboard',
      href: '/api/Dashboard/GetFaultDashboard',
      totalCount,
      filters: { startDate, endDate, status, severity, ticketType },
      statusCounts,
      severityCounts,
      typeCounts,
      recentTickets
    }
  };
};

module.exports = { getFaultDashboard };
