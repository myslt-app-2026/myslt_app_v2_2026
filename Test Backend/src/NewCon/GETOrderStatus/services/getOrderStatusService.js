
const ProductOrder = require('../../../models/TMF622_ProductOrder');

const getOrderStatus = async (query = {}) => {
  const { id, accountNo } = query;

  if (!id && !accountNo) {
    return {
      success: false,
      statusCode: 400,
      message: 'Please provide at least one query param: id (order id e.g. ORD-xxx) or accountNo'
    };
  }

  // Lookup by specific order ID
  if (id) {
    const order = await ProductOrder.findOne({ id });
    if (!order) {
      return {
        success: false,
        statusCode: 404,
        message: `Order not found for id: ${id}. Create one first via POST /tmf-api/productOrdering/v4/ApplicationGenerator`
      };
    }
    return {
      success: true,
      statusCode: 200,
      data: {
        id:                     order.id,
        href:                   order.href,
        state:                  order.state,
        category:               order.category,
        description:            order.description,
        creationDate:           order.creationDate,
        completionDate:         order.completionDate,
        expectedCompletionDate: order.expectedCompletionDate,
        relatedParty:           order.relatedParty,
        productOrderItem:       order.productOrderItem,
        note:                   order.note,
        '@type':                order['@type']
      }
    };
  }

  // Lookup by accountNo — stored as relatedParty[0].id in ApplicationGenerator
  const orders = await ProductOrder.find({ 'relatedParty.id': accountNo })
    .select('id href state category description creationDate completionDate expectedCompletionDate relatedParty productOrderItem note @type')
    .sort({ creationDate: -1 });

  if (orders.length === 0) {
    return {
      success: false,
      statusCode: 404,
      message: `No orders found for accountNo: ${accountNo}. Create one first via POST /tmf-api/productOrdering/v4/ApplicationGenerator`
    };
  }

  return {
    success: true,
    statusCode: 200,
    data: orders
  };
};

module.exports = { getOrderStatus };
