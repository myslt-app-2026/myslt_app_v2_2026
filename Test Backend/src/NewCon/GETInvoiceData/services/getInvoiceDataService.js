const Invoice = require("../../../models/TMF678_CustomerBillManagement");

const getInvoiceData = async (query) => {
  const { invoiceId, accountNo } = query;

  const filter = {};
  if (invoiceId) filter.invoiceId = invoiceId;
  if (accountNo) filter.accountNo = accountNo;

  const data = await Invoice.find(filter);

  return { success: true, statusCode: 200, data };
};

module.exports = { getInvoiceData };