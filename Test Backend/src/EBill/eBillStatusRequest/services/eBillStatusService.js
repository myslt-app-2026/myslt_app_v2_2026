const BillingAccount = require("../../../models/TMF666_Account");
const Customer = require("../../../models/TMF629_Customer");

const checkEbillStatus = async (accountId, tpNo) => {
  // 1. Find BillingAccount
  const billingAccount = await BillingAccount.findOne({ id: accountId });
  // console.log(billingAccount);
  if (!billingAccount) {
    return {
      isSuccess: false,
      statusCode: 404,
      errorMessage: "Billing Account not found"
    };
  }

  // 2. Find related Customer
  const relatedPartyId = billingAccount.relatedParty?.[0]?.partyOrPartyRole?.id;
  // console.log(relatedPartyId);
  const customer = await Customer.findOne({ id: relatedPartyId }).lean();

  if (!customer) {
    return {
      isSuccess: false,
      statusCode: 404,
      errorMessage: "Customer not found"
    };
  }
  

  // 3. Validate tpNo
  const mobileContact = customer.contactMedium?.find(
    (cm) => cm.mediumType === "mobile"
  );
  const customerPhone = mobileContact?.characteristic?.phoneNumber?.replace(/\D/g, "").trim();
  const normalizedTpNo = tpNo?.replace(/\D/g, "").trim();

  // console.log("Normalized DB phone:", customerPhone, "Normalized Request phone:", normalizedTpNo);

  if (normalizedTpNo && customerPhone && customerPhone !== normalizedTpNo) {
    return {
      isSuccess: false,
      statusCode: 403,
      errorMessage: "Telephone number does not match registered customer"
    };
  }

  // 4. Check billHandlingCode
  const billHandlingCode = billingAccount.characteristic?.find(
    (c) => c.name === "billHandlingCode"
  )?.value;

  return {
    isSuccess: true,
    eBillRegistered: billHandlingCode === "2" || billHandlingCode === "3",
    billingAccount,
    customer
  };
};

module.exports = { checkEbillStatus };
