/**
 * getSelectLOVService.js
 * TMF621 - Trouble Ticket Management API
 *
 * Returns List of Values (LOV) — dropdown options for the Fault Dashboard filters.
 * These are the valid enum values for status, severity, priority, and ticketType
 * fields used in TroubleTicket (TMF621), so the frontend can populate filter dropdowns.
 *
 * Optional query param: ?type=status|severity|priority|ticketType
 * If no type specified, returns all LOVs.
 */

const getSelectLOV = async (query = {}) => {
  const { type } = query;

  const LOVs = {
    status: [
      { value: 'acknowledged', label: 'Acknowledged' },
      { value: 'rejected',     label: 'Rejected' },
      { value: 'pending',      label: 'Pending' },
      { value: 'held',         label: 'Held' },
      { value: 'inProgress',   label: 'In Progress' },
      { value: 'cancelled',    label: 'Cancelled' },
      { value: 'closed',       label: 'Closed' },
      { value: 'resolved',     label: 'Resolved' }
    ],
    severity: [
      { value: 'critical',    label: 'Critical' },
      { value: 'major',       label: 'Major' },
      { value: 'minor',       label: 'Minor' },
      { value: 'nonCritical', label: 'Non Critical' }
    ],
    priority: [
      { value: 'critical', label: 'Critical' },
      { value: 'high',     label: 'High' },
      { value: 'medium',   label: 'Medium' },
      { value: 'low',      label: 'Low' }
    ],
    ticketType: [
      { value: 'FTTH',          label: 'FTTH Fault' },
      { value: 'LTE',           label: 'LTE Fault' },
      { value: 'Broadband',     label: 'Broadband Fault' },
      { value: 'Voice',         label: 'Voice Fault' },
      { value: 'Network',       label: 'Network Issue' },
      { value: 'PowerOutage',   label: 'Power Outage' },
      { value: 'Configuration', label: 'Configuration Issue' },
      { value: 'Other',         label: 'Other' }
    ]
  };

  // If a specific type is requested
  if (type) {
    if (!LOVs[type]) {
      return {
        success: false,
        statusCode: 400,
        message: `Invalid LOV type: "${type}". Valid types are: status, severity, priority, ticketType`
      };
    }
    return {
      success: true,
      statusCode: 200,
      data: {
        '@type': 'LOVResponse',
        type,
        values: LOVs[type]
      }
    };
  }

  // Return all LOVs
  return {
    success: true,
    statusCode: 200,
    data: {
      '@type': 'LOVResponse',
      href: '/api/Dashboard/GetFaultDashboard',
      lovs: LOVs
    }
  };
};

module.exports = { getSelectLOV };
