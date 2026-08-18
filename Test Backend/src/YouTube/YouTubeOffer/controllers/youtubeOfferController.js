const crypto = require("crypto");

const ALLOWED_VARIANTS = ["PackageActivation", "PackageActivationOSS"];

const getCharacteristicValue = (characteristics = [], name) => {
  const item = characteristics.find((char) => char.name === name);
  return item ? item.value : null;
};

// Custom assigned endpoint
// POST /api/mySltBss/youTube/uOffer
const packageActivation = async (req, res) => {
  try {
    const { telephone, packageId, offerCode, channel, variant } = req.body;

    if (!telephone) {
      return res.status(400).json({
        status: "FAILED",
        message: "telephone is required",
      });
    }

    if (!variant) {
      return res.status(400).json({
        status: "FAILED",
        message: "variant is required",
        allowedVariants: ALLOWED_VARIANTS,
      });
    }

    if (!ALLOWED_VARIANTS.includes(variant)) {
      return res.status(400).json({
        status: "FAILED",
        message: "Invalid variant",
        allowedVariants: ALLOWED_VARIANTS,
      });
    }

    return res.status(200).json({
      status: "SUCCESS",
      message: "YouTube offer package activation successful",
      data: {
        transactionId: `YT-${Date.now()}`,
        telephone,
        packageId: packageId || null,
        offerCode: offerCode || null,
        channel: channel || "WEB",
        variant,
        activationStatus: "COMPLETED",
        activatedDate: new Date().toISOString(),
      },
    });
  } catch (error) {
    console.error("YouTube offer activation error:", error);

    return res.status(500).json({
      status: "FAILED",
      message: "Internal server error",
    });
  }
};

// TMF640 style endpoint
// POST /tmf-api/ServiceActivationAndConfiguration/v4/service
const packageActivationTMF = async (req, res) => {
  try {
    const {
      name,
      description,
      state,
      serviceType,
      serviceSpecification,
      serviceCharacteristic = [],
      relatedParty = [],
    } = req.body;

    const telephone = getCharacteristicValue(serviceCharacteristic, "MSISDN");
    const offerCode = getCharacteristicValue(serviceCharacteristic, "offerCode");
    const variant = getCharacteristicValue(
      serviceCharacteristic,
      "activationVariant"
    );

    if (!state) {
      return res.status(400).json({
        error: "Bad Request",
        message: "state is required",
      });
    }

    if (!serviceSpecification || !serviceSpecification.id) {
      return res.status(400).json({
        error: "Bad Request",
        message: "serviceSpecification.id is required",
      });
    }

    if (!telephone) {
      return res.status(400).json({
        error: "Bad Request",
        message: "MSISDN serviceCharacteristic is required",
      });
    }

    if (!variant) {
      return res.status(400).json({
        error: "Bad Request",
        message: "activationVariant serviceCharacteristic is required",
        allowedVariants: ALLOWED_VARIANTS,
      });
    }

    if (!ALLOWED_VARIANTS.includes(variant)) {
      return res.status(400).json({
        error: "Bad Request",
        message: "Invalid activationVariant",
        allowedVariants: ALLOWED_VARIANTS,
      });
    }

    const id = crypto.randomUUID();

    return res.status(201).json({
      id,
      href: `${req.protocol}://${req.get(
        "host"
      )}/tmf-api/ServiceActivationAndConfiguration/v4/service/${id}`,
      name: name || "YouTube Offer Package Activation",
      description: description || "YouTube offer package activation service",
      category: "YouTubeOffer",
      serviceType: serviceType || "YouTubeOfferActivation",
      state,
      hasStarted: true,
      isBundle: false,
      isServiceEnabled: true,
      isStateful: true,
      serviceDate: new Date().toISOString(),
      startDate: new Date().toISOString(),
      serviceSpecification: {
        id: serviceSpecification.id,
        name:
          serviceSpecification.name || "YouTube Offer Service Specification",
        "@type": "ServiceSpecificationRef",
        "@referredType": "ServiceSpecification",
      },
      serviceCharacteristic: [
        {
          name: "MSISDN",
          valueType: "string",
          value: telephone,
        },
        {
          name: "offerCode",
          valueType: "string",
          value: offerCode || null,
        },
        {
          name: "activationVariant",
          valueType: "string",
          value: variant,
        },
        {
          name: "activationStatus",
          valueType: "string",
          value: "COMPLETED",
        },
      ],
      relatedParty,
      "@type": "Service",
    });
  } catch (error) {
    console.error("TMF YouTube offer activation error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  packageActivation,
  packageActivationTMF,
};