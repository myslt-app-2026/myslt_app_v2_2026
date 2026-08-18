/**
 * updateAgentCodeService
 * Updates agent details (name, contact, region, status, etc.)
 * Also used to create a new agent if one doesn't exist (upsert pattern)
 */
const AgentCode = require('../../../models/TMF669_PartyRole');

const updateAgentCode = async (body = {}) => {
  const {
    agentCode,
    agentName,
    agentEmail,
    agentMobile,
    region,
    district,
    status,
    role,
    engagedParty,
    validFor
  } = body;

  if (!agentCode) {
    return {
      success: false,
      statusCode: 400,
      message: 'Missing mandatory attribute: agentCode'
    };
  }

  // Try to find existing agent
  let agent = await AgentCode.findOne({ agentCode });

  if (!agent) {
    // Create new agent if not found (upsert)
    const roleId = `PR-${Date.now()}`;
    agent = new AgentCode({ id: roleId, agentCode });
  }

  // Apply updates for any provided fields
  if (agentName !== undefined) agent.agentName = agentName;
  if (agentEmail !== undefined) agent.agentEmail = agentEmail;
  if (agentMobile !== undefined) agent.agentMobile = agentMobile;
  if (region !== undefined) agent.region = region;
  if (district !== undefined) agent.district = district;
  if (status !== undefined) agent.status = status;
  if (role !== undefined) agent.role = role;
  if (engagedParty !== undefined) agent.engagedParty = engagedParty;
  if (validFor !== undefined) agent.validFor = validFor;

  const saved = await agent.save();

  return {
    success: true,
    statusCode: 200,
    message: 'Agent code updated successfully',
    data: saved
  };
};

module.exports = { updateAgentCode };
