const FaultRequestV2 = require("../../CreateFaultRequestV2/models/FaultRequestV2");
const mongoose = require("mongoose");

// exports.getTicketByTelephone = async (req, res) => {
//   const { faultyTelephoneNo } = req.query;

//   if (!faultyTelephoneNo) {
//     return res
//       .status(400)
//       .json({ error: "faultyTelephoneNo query parameter is required" });
//   }

//   try {
//     const ticket = await TroubleTicket.findOne({
//       telephone: faultyTelephoneNo,
//     });
//     if (!ticket) {
//       return res.status(404).json({ error: "Ticket not found" });
//     }

//     let ticketObj = ticket.toObject();
//     ticketObj.id = ticket._id.toString();
//     ticketObj["@type"] = ticketObj["@type"] || "TroubleTicket";

//     if (req.query.fields) {
//       const fields = req.query.fields.split(",");
//       const filtered = {
//         id: ticketObj.id,
//         "@type": ticketObj["@type"],
//       };
//       fields.forEach((f) => {
//         if (ticketObj.hasOwnProperty(f)) {
//           filtered[f] = ticketObj[f];
//         }
//       });
//       return res.status(200).json(filtered);
//     }

//     return res.status(200).json(ticketObj);
//   } catch (error) {
//     return res.status(500).json({
//       message: "Internal Server Error",
//       error: error.message,
//     });
//   }
// };


exports.getTicketById = async (req, res) => {
  const ticketId = req.params.id;
  try {
    const ticket = await FaultRequestV2.findOne({ id: ticketId }).lean();
    if (!ticket) return res.status(404).json({ message: 'Trouble ticket not found' });
    return res.json(ticket);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Server error' });
  }
};