// controllers/salesLeadController.js
const { v4: uuidv4 } = require('uuid');
const salesLeadService = require('../services/salesLeadService');

const baseUrl = "http://127.0.0.1:3000/tmf-api/sales/v4/salesLead";

exports.createSalesLead = async (req, res) => {
  try {
    const now = new Date();
    const newId = uuidv4();
    const bodyData = { ...req.body };

    // // ----- Backward compatibility: handle legacy query params -----
    // const firstName = req.query.firstName;
    // const lastName = req.query.lastName;
    // const nic = req.query.nic;
    // const contactTelNo = req.query.ContactTelNo;

    // if (!bodyData.relatedParty && (firstName || nic)) {
    //   bodyData.relatedParty = [{
    //     id: nic,
    //     name: `${firstName || ''} ${lastName || ''}`.trim(),
    //     role: 'prospect',
    //     '@referredType': 'individual'
    //   }];
    // }

    // if (!bodyData.prospectContact && contactTelNo) {
    //   bodyData.prospectContact = [{
    //     preferred: true,
    //     mediumType: 'phone',
    //     characteristic: { phoneNumber: contactTelNo }
    //   }];
    // }

    // ----- Enforce TMF mandatory attribute -----
    if (!bodyData.name || bodyData.name.trim() === "") {
      return res.status(400).json({
        status: 400,
        message: "Missing mandatory attribute: name"
      });
    }

    // ----- Detect LTE-specific request -----
    const isLTE = bodyData.servicetype?.toUpperCase() === "LTE";
    if (isLTE) {
      bodyData.type = bodyData.type || "LTE Lead";
      bodyData.productOffering = bodyData.productOffering || {
        id: "LTE001",
        href: "http://localhost:3000/tmf-api/productCatalogManagement/v4/productOffering/LTE001",
        name: "SLT 4G/LTE Broadband"
      };
      bodyData.category = bodyData.category || {
        id: "CATLTE",
        href: "http://localhost:3000/tmf-api/productCatalogManagement/v4/category/CATLTE",
        name: "LTE Category"
      };
    }

    // ----- Merge TMF attributes -----
    const leadData = {
      id: newId,
      href: `${baseUrl}/${newId}`,
      name: bodyData.name,
      description: bodyData.description,
      referredDate: bodyData.referredDate,
      type: bodyData.type,
      rating: bodyData.rating,
      priority: bodyData.priority,
      estimatedRevenue: bodyData.estimatedRevenue,
      validFor: bodyData.validFor,
      marketSegment: bodyData.marketSegment,
      marketingCampaign: bodyData.marketingCampaign,
      channel: bodyData.channel,
      productOffering: bodyData.productOffering,
      product: bodyData.product,
      category: bodyData.category,
      salesOpportunity: bodyData.salesOpportunity,
      note: bodyData.note,
      relatedParty: bodyData.relatedParty,
      prospectContact: bodyData.prospectContact,
      creationDate: now,
      status: bodyData.status || "acknowledged",
      statusChangeDate: now,
      statusChangeReason: bodyData.statusChangeReason || "Lead created"
    };

    const newLead = await salesLeadService.createSalesLead(leadData);
    res.status(201).json(newLead);

  } catch (error) {
    res.status(500).json({ status: 500, message: error.message });
  }
};
