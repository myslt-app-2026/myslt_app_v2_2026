/**
 * getAgentCodeService
 * Retrieves agent details by agentCode, region, or status
 * Used to look up agent information for FTTH new connection workflow
 */
const AgentCode = require('../../../models/TMF669_PartyRole');

const getAgentCode = async (query = {}) => {
  const { agentCode, region, district, status } = query;

  // Lookup by specific agent code
  if (agentCode) {
    const agent = await AgentCode.findOne({ agentCode });
    if (!agent) {
      return {
        success: false,
        statusCode: 404,
        message: `Agent not found for agentCode: ${agentCode}`
      };
    }
    return {
      success: true,
      statusCode: 200,
      data: agent
    };
  }

  // Build filter for list queries
  const filter = {};
  if (region) filter.region = region;
  if (district) filter.district = district;
  if (status) filter.status = status;

  const agents = await AgentCode.find(filter).sort({ createdAt: -1 });

  return {
    success: true,
    statusCode: 200,
    data: agents
  };
};

module.exports = { getAgentCode };
