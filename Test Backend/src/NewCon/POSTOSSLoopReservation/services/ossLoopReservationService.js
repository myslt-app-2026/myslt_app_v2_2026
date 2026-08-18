const ProductOrder = require("../../../models/TMF622_ProductOrder");

const ossLoopReservation = async (body = {}) => {
  const { accountNo, customerName, loopType } = body;

  if (!accountNo || !customerName) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo and customerName are required",
    };
  }

  const reservationId = "LOOP-" + Date.now();

  const reservation = await ProductOrder.create({
    id: reservationId,

    category: "OSSLoopReservation",

    description: "OSS Loop Reserved",

    state: "acknowledged",

    productOrderItem: [
      {
        id: "1",
        action: "add",
        quantity: 1,

        productOffering: {
          id: reservationId,
          name: loopType || "Fiber Loop",
        },
      },
    ],

    relatedParty: [
      {
        id: accountNo,
        name: customerName,
        role: "Customer",
      },
    ],
  });

  return {
    success: true,
    statusCode: 201,
    message: "OSS Loop Reserved Successfully",
    data: reservation,
  };
};

module.exports = { ossLoopReservation };