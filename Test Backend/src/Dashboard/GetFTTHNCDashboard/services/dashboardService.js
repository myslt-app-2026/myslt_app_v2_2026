const ProductOrder =
require("../../../models/TMF622_ProductOrder");

async function getDashboardData() {

  const totalRequests =
    await ProductOrder.countDocuments({
      category: "FTTH New Connection"
    });

  const pendingRequests =
    await ProductOrder.countDocuments({
      category: "FTTH New Connection",
      state: "pending"
    });

  const inProgressRequests =
    await ProductOrder.countDocuments({
      category: "FTTH New Connection",
      state: "inProgress"
    });

  const completedRequests =
    await ProductOrder.countDocuments({
      category: "FTTH New Connection",
      state: "completed"
    });

  const cancelledRequests =
    await ProductOrder.countDocuments({
      category: "FTTH New Connection",
      state: "cancelled"
    });

  return {

    "@type": "ProductOrderDashboard",

    totalRequests,

    pendingRequests,

    inProgressRequests,

    completedRequests,

    cancelledRequests
  };
}

module.exports = {
  getDashboardData
};