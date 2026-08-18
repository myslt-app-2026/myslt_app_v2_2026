/**
 * sendFTTHSecCodeService
 * Generates and stores a 6-digit security/verification code for an FTTH agent
 * Used to verify agent identity before allowing new connection submissions
 */
const AgentCode = require('../../../models/TMF669_PartyRole');

const generateSecCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const sendFTTHSecCode = async (body = {}) => {
  const { agentCode, agentMobile, agentEmail } = body;

  if (!agentCode) {
    return {
      success: false,
      statusCode: 400,
      message: 'Missing mandatory attribute: agentCode'
    };
  }

  // Find the agent record
  const agent = await AgentCode.findOne({ agentCode });

  if (!agent) {
    return {
      success: false,
      statusCode: 404,
      message: `Agent not found for agentCode: ${agentCode}`
    };
  }

  // Generate a new 6-digit security code
  const secCode = generateSecCode();
  const secCodeExpiry = new Date(Date.now() + 5 * 60 * 1000); // expires in 5 minutes

  // Update the agent record with new sec code
  agent.secCode = secCode;
  agent.secCodeExpiry = secCodeExpiry;
  agent.secCodeVerified = false;
  if (agentMobile) agent.agentMobile = agentMobile;
  if (agentEmail) agent.agentEmail = agentEmail;

  await agent.save();

  // In real implementation, this would trigger an SMS/email to the agent
  // For mock: log to console
  console.log(`[sendFTTHSecCode] SecCode for agent ${agentCode}: ${secCode}`);

  return {
    success: true,
    statusCode: 200,
    message: 'Security code sent successfully',
    data: {
      agentCode: agent.agentCode,
      agentName: agent.agentName,
      secCodeExpiry,
      // Return secCode in response for mock/testing (remove in production)
      secCode
    }
  };
};

module.exports = { sendFTTHSecCode };
