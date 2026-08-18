const express = require("express");
const cors = require("cors");
const authMiddleware = require("./middleware/authMiddleware"); // Import the middleware


const app = express(); 

// Import Routes           
// const promotionRoutes = require('./BBVAS/BonusData/routes/promotionRoutes');
//Account
const register = require("./Account/RegisterV2/routes/registerroutes");
const OTPVerificationRoutes = require("./Account/OTP Verification/routes/authRoutes.js");
const resendOTPRoutes = require("./Account/Resend OTP/routes/resendOTPRoutes.js");
const refreshTokenRoutes = require("./Account/RefreshToken/routes/refreshTokenRoute.js");
const loginRoutes = require("./Account/Login/routes/loginRoute.js");
const changePasswordRoutes = require("./Account/ChangePassword/routes/changePasswordRoutes.js");
const authOpenFTTHLoginRoutes = require("./Account/AuthenticationOpenFTTHLogin/routes/authOpenFTTHLoginRoutes");
const authFTTHAdminRoutes     = require("./Account/AuthenticationFTTHAdmin/routes/authFTTHAdminRoutes");
const createFTTHAdminRoutes   = require("./Account/CreateFTTHAdmin/routes/createFTTHAdminRoutes");
const postPushNotificationRoutes = require("./Account/PostPushNotification/routes/pushNotificationRoutes");

//const updateUserInfoRoutes = require("./Account/POSTUpdateUserInfo/routes/updateUserInfoRoutes.js");
const getPeoTVGOAccessTokenRoutes = require("./Account/GetPeoTVGOAccessToken/routes/getPeoTVGOAccessTokenRoutes");
const getAlexaAccessTokenRoutes = require('./Account/GetAlexaAccessToken/routes/getAlexaAccessTokenRoutes');
const updateUserInfoRoutes = require('./Account/UpdateUserInfo/routes/updateUserInfoRoutes');
const getUserInfoRoutes = require('./Account/GetUserInfo/routes/getUserInfoRoutes');
const checkCallForwardingRoutes = require('./Account/GETCheckCallForwardingStatus/routes/checkCallForwardingRoutes');
//BBVAS
const validateBBPurchaseRequestRoutes = require("./BBVAS/ValidateBBPurchaseRequest/routes/validateBBPurchaseRequest.routes");
const getVASDataBundlePackagesRoutes = require("./BBVAS/GetVASDataBundlePackages/routes/getVASDataBundlePackages.routes");


const PurchaseAdvancedReportsPrepaidInitRoutes = require("./BBVAS/PurchaseAdvancedReportsPrepaidInit/routes/purchaseAdvancedReportsPrepaidInit.routes");
const PurchaseAdvancedReportsPrepaidConfirmRoutes = require("./BBVAS/PurchaseAdvancedReportsPrepaidConfirm/routes/purchaseAdvancedReportsPrepaidConfirm.routes");
const enhancedCurrentDailyUsageRoutes = require("./BBVAS/EnhancedCurrentDailyUsage/routes/EnhancedCurrentDailyUsageRoutes");
const dataGiftEnrollPrepaidInitRoutes = require("./BBVAS/DataGiftEnrollPrepaidInit/routes/dataGiftEnrollPrepaidInit.routes");
const dataGiftEnrollPrepaidConfirmRoutes = require("./BBVAS/DataGiftEnrollPrepaidConfirm/routes/dataGiftEnrollPrepaidConfirm.routes");
const customerRoutes = require("./BBVAS/ChangeBBPassword/routes/customerRoutes");
const productOrderRoutes = require("./BBVAS/VASBundleUnsubscription/routes/productOrderRoutes");
const dataGiftRoutes = require("./BBVAS/ValidateDataGiftSub/routes/dataGiftRoutes");
const usageRoutes = require("./BBVAS/WeeksUsage/routes/usageRoutes");
const serviceRoutes = require("./BBVAS/UnsubscribeAdvancedReports/routes/serviceRoutes");
const summeryRoutes = require("./BBVAS/UsageSummery/routes/usageRoutes.js");
const vasRoutes = require("./BBVAS/AddVASDataBundlePrepaidInit/routes/vasDataBundle.routes.js");
const contactRoutes = require("./BBVAS/PUTUpdateContact/routes/contact.routes");
const reportTimePeriodRoutes = require("./BBVAS/GetReportTimePeriod/routes/reportTimePeriod.routes");
const advancedReportingPackageRoutes = require("./BBVAS/GetAdvancedReportingPackage/routes/advancedReportingPackage.routes");
const updateISPContactRoutes = require("./BBVAS/PUTUpdateISPContact/routes/customer.routes.js");
const dailyUsageRoutes = require("./BBVAS/CurrentMonthsDailyUsage/routes/currentUsageRoutes");

const vasConfirmRoutes = require("./BBVAS/AddVASDataBundlePrepaidConfirm/routes/vasRoutes.js");
const validateDataGiftRoutes = require("./BBVAS/ValidateDataGiftSub/routes/dataGiftRoutes");
const addVASRoutes = require('./BBVAS/AddVASDataBundlePrepaidConfirm/routes/vasRoutes');
const purchasedHistoryRoutes = require('./BBVAS/PurchasedHistory/routes/purchasedHistoryRoutes');
const dataGiftPackagesRoutes = require('./BBVAS/GetDataGiftPackagesMobile/routes/dataGiftRoutes');
const DataBundlePostpaidRoutes = require("./BBVAS/AddVASDataBundlePostPaidV2/routes/productOrderRoute.js");
const AddVASDataBundlePostPaid = require("./BBVAS/addVASDataBundlePostPaid/routes/ServiceOrderRoute.js");
const DataTransferAmountRoutes = require('./BBVAS/DataTransferAmount/routes/dataTransferRoutes.js');
const PreviousMonthUsageRoutes = require('./BBVAS/PreviousMonthDailyUsage/routes/usageRoutes.js');
const RedeemVoucherRoutes = require('./BBVAS/RedeemVoucher/routes/voucherRoutes.js');
const GiftPackageRoutes = require('./BBVAS/DatagiftPackages/routes/dataGiftRoutes.js');
const AdvancedReportPostpaidRoutes = require('./BBVAS/Advancedreport-Postpaid/routes/advancedReportRoutes.js');
const productOfferingQualificationRoutes = require("./BBVAS/getBonusData/routes/ProductOfferingQualification.js");
const poqRoutes = require("./BBVAS/GetExtraGBPackagesMobile/routes/productOfferingQualificationRoutes");
const dashboardRoutes = require("./BBVAS/GetExtraGBDashboard/routes/dashboardRoutes.js");
const DataTransferAmountRoute = require("./BBVAS/DataTransferAmount/routes/dataTransferRoutes.js");
const TransferDataRoutes = require("./BBVAS/PostTransferData/routes/transferDataRoutes.js");


const ValidateDataTransferRoutes = require("./BBVAS/GETValidateDataTransferSub/routes/validateDataTransferRoutes.js");
const UpgradeLoyaltyRoutes = require("./BBVAS/PUTUpgradeLoyalty/routes/upgradeLoyaltyRoutes.js");
const getDashboardVASBundlesRoutes = require("./BBVAS/GetDashboardVASBundles/routes/dashboardVASBundlesRoutes");
//const promotionRoutesFreeData = require("./BBVAS/FreeData/routes/promotionRoutes.js");
// const accountRoutes = require('./routes/account.routes');

//Sales
const salesLeadRoutes = require("./Sales/SalesLeadCreationRequest/routes/salesLeadRoutes.js");

//Banner
const bannerRoutes = require("./Banner/BannerDetailRequest/routes/bannerRoutes.js");

//Faults
const serviceRequestRoutes = require("./Fault/CreateServiceRequest/routes/serviceRequest.routes");
const troubleTicketRoutes = require("./Fault/GetTroubleTicket/routes/troubleTicketRoutes.js");
const faultRequestRoutes = require('./Fault/CreateFaultRequestV2/routes/faultRequestRoutes');

//Ebill

const eBillRegisetrationRoutes = require("./eBill/eBill_Registration/routes/CustomerBill.js");
const billRoutes = require('./EBill/BillDownloadRequest/routes/billDownloadRoutes');
const customerBillOnDemandRoutes = require("./EBill/smartBillSendRequest/routes/CustomerBillOnDemandRoutes.js");
const eBillCheckUserExistRoutes = require("./EBill/eBillCheckUserExistV2/routes/eBillRoutes.js");
const smartBillRegistrationSourceRoutes = require("./EBill/SmartBillRegistrationSource/routes/smartBillRegistrationSource.routes");
const smartBillRegistrationRoutes = require("./EBill/SmartBillRegistration/routes/smartBillRegistration.routes");
const billStatusRoutes = require("./EBill/BillStatusRequest/routes/billStatusRoutes.js");
const smsServiceStatusRoutes = require("./Ebill/SMSServiceStatusRequest/routes/smsServiceStatusRoutes.js");
//PEOVAS
const productInventoryRoutes = require("./PEOVAS/CustomerValidation_malsha/productInventoryRoute");
const purchasedProductRoutes = require("./PEOVAS/PostPurchasedProduct/route/purchasedProductroutes.js");
const getPurchasedProductsRoutes = require("./PEOVAS/GetPurchasedProducts/routes/getPurchasedProductsroutes.js");
const serviceInventoryRoutes = require("./PEOVAS/CheckOmniTP/serviceInventoryRoutes.js");

const verifyOTPRoutes = require("./PEOVAS/POST VerifyOTPRequest/routes/verifyOTPRoutes.js");

//Notifications
const getPopupMessageBanner = require("./Notifications/GetPopupMessageBanner/routes/popupMessage.routes.js");
const postPushNotifications = require("./Notifications/PostPushNotifications/routes/pushNotification.routes.js");

//BB Package upgrade
const getBBpackageList = require('./BBPackageUpgrade/GetBBPackgesList/routes/productOfferingQualification.routes');

//TimelyPay
const packageActivationSOARoutes = require(
  "./TimelyPay/POSTPackageActivationSOA/routes/packageActivationSOARoutes"
);

//BBExternal
// const bbExternalGetPackagesV2 = require('./BBExternal/GetBBPackagesV2/routes/productOffering.routes');
// const getBBPackageDetails = require('./BBExternal/GetBBPackageDetails/routes/getBBPackageDetails.routes');
const getBBPackageComparison = require('./BBExternal/GetBBPackageComparison/routes/getBBPackageComparison.routes');
const getCurrentBBPackageV2 = require('./BBExternal/GetCurrentBBPackageV2/routes/getCurrentBBPackageV2.routes');

//Prepaid 
const dataGiftEnrollInit = require('./Prepaid/DataGiftEnrollInit/routes/dataGiftEnrollInit.routes.js')
const dataGiftEnrolInitConfirm = require('./Prepaid/DataGiftEnrollPrepaid-confirm/routes/purchaseRoutes.js')
const vasBundleConfirmRoutes = require(
  "./Prepaid/POSTAdd VAS Data Bundle - Prepaid Confirm/routes/vasBundleConfirm.routes"
);

const unsubscribeAdvancedReportsRoutes = require(
  "./Prepaid/POSTUnsubscribeAdvancedReports/routes/unsubscribeAdvancedReports.routes"
);

const ExtraGBPurchasePrepaidRoutes = require("./Prepaid/ExGBPurchasePrepaidInit/extraGBRoutes.js");
const prepaidOrderRoutes = require("./PrePaid/POST PurchasedAdvancedReports-Prepaid-Init/routes/productOrderRoutes.js");

//Dashboard
const ftthRoutes = require('./Dashboard/GetFTTHFullData/routes/ftthRoutes');
const ftthSpecificRoutes = require('./Dashboard/GetFTTHSpecificData/routes/ftthSpecificRoutes');
const ftthLoginRoutes = require('./Dashboard/FTTHDashboardLogin/routes/ftthLoginRoutes');
const ftthStatusRoutes = require('./Dashboard/GetFTTHRequestStatusCount/routes/ftthStatusRoutes');
const ftthPermissionRoutes = require('./Dashboard/SetFTTHPermission/routes/ftthPermissionRoutes');
const ftthChartRoutes = require('./Dashboard/GetFTTHRequestCharts/routes/ftthChartRoutes');
const getFaultDashboardRoutes = require('./Dashboard/GetFaultDashboard/routes/getFaultDashboardRoutes');
const getSelectLOVRoutes = require('./Dashboard/GetSelectLOV/routes/getSelectLOVRoutes');
const confirmRoutes = require('./PrePaid/POST PurchasedAdvancedReports-Prepaid-Confirm/routes/confirmOrderRoutes');
const ftthDashboard =require('./Dashboard/GetFTTHNCDashboard/routes/dashboardRoutes');
const extraGBDashboard =require('./Dashboard/GetExtraGBDashboard/routes/dashboardRoutes');
const ftthSpecificDataFilterRoutes = require("./Dashboard/GETFTTHSpecificDataFilter/routes/ftthSpecificDataFilterRoutes");
const ftthMapDataRoutes = require("./Dashboard/GETFTTHMapData/routes/ftthMapDataRoutes");
const ebillDashboardRoutes = require("./Dashboard/GetEbillDashboard/routes/ebillDashboardRoutes");
const addonsDashboardRoutes = require("./Dashboard/GetAddonsDashboard/routes/addonsDashboardRoutes");
const extraGBRoutes   = require("./Dashboard/ExtraGB/routes/extraGBRoutes");
const freeDataRoutes  = require("./Dashboard/FreeData/routes/freeDataRoutes");
const bonusDataRoutes = require("./Dashboard/BonusData/routes/bonusDataRoutes");


//HealthCheck
const HealthCheck = require("./HealthCheck/HealthCheckRequest/routes/healthCheckRoutes");
const NotificationDetail = require("./HealthCheck/NotificationDeatail/routes/notificationDetailRoutes")

//Ebill
const ebillStatusRequest = require("./eBill/eBillStatusRequest/routes/eBillStatusRoute.js");

//NewCon
const uploadMultipartSinglev2 = require("./NewCon/PostUploadMultipartSingleV2/routes/uploadMultipart.routes.js")
const uploadSingle = require("./NewCon/PostUploadSingle/routes/uploadSingle.routes.js")
const voicePackageRoutes = require("./NewCon/GETGetVOICEPackageInterim/routes/voicePackageRoutes");

const generateFTTHSecreatCode = require("./NewCon/PostGenerateFTTHSecreatCode/routes/ftthOrder.routes.js")
const ossLoopReservationRoutes = require("./NewCon/POSTOSSLoopReservation/routes/ossLoopReservationRoutes");
const checkExistCustomerRoutes = require("./NewCon/GETCheckExistCustomer/routes/checkExistCustomerRoutes");

// YouTube 
const packageActivationRoutes = require("./YouTube/PackageActivation(OMNIExpose)/routes/packageActivation.routes");
const checkOfferAvailabilityRoutes = require("./YouTube/CheckOfferAvailability/routes/checkOfferAvailabilityRoutes");
// YouTube Offer
const youtubeOfferRoutes = require("./Youtube/YouTubeOffer/routes/youtubeOfferRoutes");

//ISP_SOA
const previousMonthsDailyUsageRoutes = require("./ISP_SOA/GETPreviousMonthsDailyUsage/routes/previousMonthsDailyUsageRoutes.js");
const updateContactRoutes = require("./ISP_SOA/PUTUpdateContact/routes/updateContactRoutes.js");
const dataTransferAmountsRoutes = require("./ISP_SOA/GETDataTransferAmounts/routes/dataTransferAmountsRoutes.js");
const validateDataTransferSubRoutes = require("./ISP_SOA/GETValidateDataTransferSub/routes/validateDataTransferSubRoutes.js");
const authenticateRoutes = require("./ISP_SOA/GETAuthenticate/routes/authenticateRoutes.js");
const currentMonthDailyUsageRoutes = require("./ISP_SOA/GETCurrentMonthDailyUsage/routes/currentMonthDailyUsageRoutes.js");
const ispsoaFreeDataRoutes = require('./ISP_SOA/GETFreeData/routes/getFreeDataRoutes');
const ispsoaBonusDataRoutes = require('./ISP_SOA/GETBonusData/routes/getBonusDataRoutes');
const ispsoaDashboardVASBundlesRoutes = require('./ISP_SOA/GETDashboardVASBundles/routes/getDashboardVASBundlesRoutes');
const ispsoaMyPackageRoutes = require('./ISP_SOA/GETMyPackage/routes/getMyPackageRoutes');
const getVASDataBundlePackagesRouter =require("./ISP_SOA/GetVASDataBundlePackages/routes/getVASDataBundlePackagesRouter");
const addVASDataBundlePostPaidRouter =require("./ISP_SOA/AddVASDataBundlePostPaid/routes/addVASDataBundlePostPaidRouter");
const redeemVoucherRoutes = require("./ISP_SOA/POSTRedeemVoucher/routes/redeemVoucherRoutes");
const happyDayRoutes = require("./ISP_SOA/POSTHappyDay/routes/happyDayRoutes");
const upgradeLoyaltyRoutes = require("./ISP_SOA/PUTUpgradeLoyalty/routes/upgradeLoyaltyRoutes");
const changeBBPasswordRoutes = require("./ISP_SOA/PUTChangeBBPassword/routes/changeBBPasswordRoutes");
const vasBundleUnsubscriptionRouter =require("./ISP_SOA/VASBundleUnsubscription/routes/vasBundleUnsubscriptionRouter");
const transferDataRouter =require("./ISP_SOA/TransferData/routes/transferDataRouter");
const protocolReportRoutes = require("./ISP_SOA/GETProtocolReport/routes/protocolReportRoutes.js");
const advertisementListRoutes = require("./ISP_SOA/AdvertisementGetList/routes/advertisementListRoutes");
const subtokenDirectRoutes = require("./ISP_SOA/GETSubtokenDirect/routes/subtokenRoute");
const purchaseHistoryRoutes = require("./ISP_SOA/GETPurchaseHistory/routes/purchaseHistoryRoutes");
const weeksUsageRoutes = require("./ISP_SOA/GETWeeksUsage/routes/weeksUsageRoutes");
const dashboardSummaryRoutes = require('./ISP_SOA/GETDashboardSummary/routes/getDashboardSummaryRoutes');
const getExtraGbPackages = require("./ISP_SOA/GETExtraGBPackages/routes/getExtraGbPackages.routes.js");
const POSTExGBPurchasePostpaid = require("./ISP_SOA/POSTExGBPurchasePostpaid/routes/purchaseExtraGb.routes.js");
const getAdvancedReportingPackages = require("./ISP_SOA/GETAdvancedReportingPackages/routes/getAdvancedReportingPackages.routes.js");
const purchaseAdvancedReporting = require("./ISP_SOA/POSTpurchaseAdvancedReporting/routes/purchaseAdvancedReporting.routes.js");


//ISP_Direct
const purchaseAdvancedReportsRouter =require("./ISP_Direct/PurchaseAdvancedReportsPostPaid/routes/purchaseAdvancedReportsRouter");
const isp_direct_transferDataRouter =require("./ISP_Direct/TransferData/routes/transferDataRouter");
const getDashboardVASBundlesRouter =require("./ISP_Direct/GetDashboardVASBundles/routes/getDashboardVASBundlesRouter");
const previousMonthsDailyUsageRoutesV2 = require("./ISP_SOA/GETPreviousMonthsDailyUsage/routes/previousMonthsDailyUsageRoutes");
const ispDirectWeeksUsageRoutes = require("./ISP_Direct/GET WeeksUsage/Route/weeksUsageRoute.js");
const getVASBundlePackagesRoutes = require("./ISP_Direct/GetVASDataBundlePackages/routes/getVASBundlePackagesRoutes");
const ispDirectUpgradeLoyaltyRoutes = require("./ISP_Direct/PUTUpgradeLoyalty/routes/upgradeLoyaltyRoutes.js");
const ispDirectChangeBBPasswordRoutes = require("./ISP_Direct/PUTChangeBBPassword/routes/changeBBPasswordRoutes.js");
const vasBundleUnsubscriptionRoutes = require("./ISP_Direct/VASBundleUnsubscription/routes/vasBundleUnsubscriptionRoutes");
const addVASDataBundleRoutes = require("./ISP_Direct/AddVASDataBundlePostPaid/routes/addVASDataBundleRoutes");
const getPurchaseHistoryRouter = require("./ISP_Direct/GetPurchaseHistory/routes/getPurchaseHistoryRouter");
const ispDirectMyPackageRoutes = require("./ISP_Direct/MyPackage/routes/myPackageRoutes.js");
const ispDirectEnhancedCurrentDailyUsageRoutes = require("./ISP_Direct/EnhancedCurrentDailyUsage/routes/enhancedCurrentDailyUsageRoutes.js");
const ispDirectEnhancedPreviousDailyUsageRoutes = require("./ISP_Direct/EnhancedPreviousDailyUsage/routes/enhancedPreviousDailyUsageRoutes.js");
const bbUsageRequestRoutes = require("./VAS/POSTBBUsageRequest/routes/bbUsageRequestRoutes.js");
const protocolReportRouter = require("./ISP_Direct/GETProtocolReport/routes/protocolReportRouter");
const advertisementGetListRouter = require("./ISP_Direct/AdvertisementGetList/routes/advertisementGetListRouter");

//verify
const getVoiceUsageRouter =require("./verify/GETVoiceUsage/routes/getVoiceUsageRouter");
const protectedResourceRoutes = require("./Verify/POSTProtectedResource/routes/protectedResourceRoutes.js");

//VAS
const profileRequestRoutes = require("./VAS/GETProfileRequest/routes/profileRequestRoutes.js");
const vasProfileRoutes = require("./VAS/Getprofile/routes/profileRoutes");
const getCustConfirmationRouter =require("./VAS/GetCustConfirmation/routes/getCustConfirmationRouter");


//Voice
const callForwardingRequestRoutes = require("./Voice/GETCallForwardingRequest/routes/callForwardingRequestRoutes");

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Public routes (no authentication required)
//Account
app.use("/tmf-api", register);
app.use("/tmf-api", OTPVerificationRoutes);
app.use("/tmf-api", resendOTPRoutes);
app.use("/tmf-api", refreshTokenRoutes);
app.use("/tmf-api", loginRoutes);
app.use("/tmf-api", changePasswordRoutes);
app.use("/api/Account", authOpenFTTHLoginRoutes);
app.use("/api/Account", authFTTHAdminRoutes);
app.use("/api/Account", createFTTHAdminRoutes);
app.use("/api/Account", postPushNotificationRoutes);
app.use("/api/Account/UpdateUserInfo", updateUserInfoRoutes);
app.use("/api/Account", getPeoTVGOAccessTokenRoutes);
app.use("/tmf-api/customerManagement/v4",getPeoTVGOAccessTokenRoutes);
app.use('/api/Account/GetAlexaAccessToken', getAlexaAccessTokenRoutes);
app.use('/api/Account/UpdateUserInfo', updateUserInfoRoutes);
app.use('/api/Account/GetUserInfo', getUserInfoRoutes);
app.use('/api/Account/GETCheckCallForwardingStatus', checkCallForwardingRoutes);

//TimelyPay
app.use(
  "/api/TimelyPay/PackageActivationSOA",
  packageActivationSOARoutes
);

// Apply authMiddleware globally
app.use(authMiddleware);

// TMF640 style Service Activation endpoint
app.use("/tmf-api/ServiceActivationAndConfiguration/v4", youtubeOfferRoutes);

// Routes
app.use('/tmf-api/productOfferingQualification/v4', validateBBPurchaseRequestRoutes);
app.use('/tmf-api/productCatalogManagement/v4', getVASDataBundlePackagesRoutes);
app.use('/tmf-api/productCatalogManagement/v4', getDashboardVASBundlesRoutes);

//BBVAS
// app.use("/tmf-api/promotionManagement/v4/promotion", promotionRoutesFreeData);
app.use("/tmf-api/customerBill/v4", smartBillRegistrationSourceRoutes);
app.use("/tmf-api/customerBill/v4", smartBillRegistrationRoutes);
app.use("/tmf-api/usageManagement/v4", PurchaseAdvancedReportsPrepaidInitRoutes);
app.use("/tmf-api/usageManagement/v4", PurchaseAdvancedReportsPrepaidConfirmRoutes);
app.use("/tmf-api/usageManagement/v4/usage", enhancedCurrentDailyUsageRoutes);
app.use("/tmf-api/customerManagement/v5", customerRoutes);
app.use('/tmf-api/productOrdering/v4', dataGiftEnrollPrepaidInitRoutes);   
app.use('/tmf-api/productOrdering/v4', dataGiftEnrollPrepaidConfirmRoutes);
app.use("/tmf-api/productOrdering/v4/productOrder", productOrderRoutes);
app.use("/tmf-api/dataGift/v1", validateDataGiftRoutes);
app.use("/", vasRoutes);
app.use("/tmf-api/ServiceActivationAndConfiguration/v4", serviceRoutes);
app.use(
  "/tmf-api/productOrdering/v4",
  require("./BBVAS/DataGiftEnroll/routes/dataGiftEnroll.routes")
);
app.use("/tmf-api/usageManagement/v4", usageRoutes);
app.use("/tmf-api", contactRoutes);
app.use("/tmf-api/reportManagement/v5", reportTimePeriodRoutes);
app.use("/tmf-api/reportManagement/v5", advancedReportingPackageRoutes);
app.use("/", updateISPContactRoutes);
app.use('/tmf-api/usageManagement/v4/daily', dailyUsageRoutes);
app.use("/tmf-api/dataGift/v1", dataGiftRoutes);
app.use("/tmf-api/productOrdering/v4", vasConfirmRoutes);
app.use('/tmf-api/usage/v4', purchasedHistoryRoutes);
app.use('/tmf-api/serviceActivation/v4.0.0', dataGiftPackagesRoutes);
app.use('/tmf-api/productOrderingManagement/v4', DataBundlePostpaidRoutes);
// app.use('/api/Account', accountRoutes);
app.use("/", vasRoutes);
app.use("/tmf-api/ServiceActivationAndConfiguration/v4", serviceRoutes);
app.use(
  "/tmf-api/productOrdering/v4",
  require("./BBVAS/DataGiftEnroll/routes/dataGiftEnroll.routes")
);
// app.use("/tmf-api/promotionManagement/v4/promotion", promotionRoutes);
app.use("/tmf-api/usageManagement/v4", usageRoutes);
app.use("/tmf-api/usageManagement/v4/PreviousMonth", PreviousMonthUsageRoutes);
app.use("/tmf-api/usageManagement/v4/5", summeryRoutes);
app.use("/tmf-api", contactRoutes);
app.use("/tmf-api/reportManagement/v5", reportTimePeriodRoutes);
app.use("/tmf-api/reportManagement/v5", advancedReportingPackageRoutes);
app.use("/tmf-api/sales/v4/", salesLeadRoutes);
app.use("/tmf-api/productOrderingManagement/v4", DataBundlePostpaidRoutes);
app.use("/tmf-api/productOfferingQualification/v5", poqRoutes);
app.use("/tmf-api/usageManagement/v4/Vouchers", RedeemVoucherRoutes);
app.use("/tmf-api/usageManagement/v4/DataTransferAmounts", DataTransferAmountRoutes);
// app.use("/tmf-api/usageManagement/v4/Vouchers", voucherRoutes);
app.use("/tmf-api/usageManagement/v4/DataGiftPackages", GiftPackageRoutes);
app.use("/tmf-api/usageManagement/v4/AdvancedReports", AdvancedReportPostpaidRoutes);
app.use("/", serviceRequestRoutes);
app.use('/api/v2', faultRequestRoutes);
app.use('/tmf-api/customerBillManagement/v5', billRoutes);
app.use("/tmf-api/Customer_Bill_Management/v5", customerBillOnDemandRoutes);
app.use("/api/Dashboard", dashboardRoutes);
app.use("/tmf-api/usageManagement/v4/DataTransferAmounts", DataTransferAmountRoute);
app.use("/tmf-api/usageManagement/v4/TransferData", TransferDataRoutes);
app.use("/tmf-api/customerBillManagement/v5/BillStatusRequest", billStatusRoutes);
app.use("/tmf-api/customerBillManagement/v5/SMSServiceStatusRequest", smsServiceStatusRoutes);
app.use("/tmf-api/usageManagement/v4", ValidateDataTransferRoutes);
app.use("/tmf-api/productOrdering/v4", UpgradeLoyaltyRoutes);

// app.use('/api/Account', accountRoutes);

//Sales
app.use('/tmf-api/sales/v4/', salesLeadRoutes);

//Banner - TMF681 Communication Management
app.use('/tmf-api/communicationManagement/v4', bannerRoutes); //uses TMF681

//Faults
app.use("/", serviceRequestRoutes);
app.use("/tmf-api/troubleTicket/v5", troubleTicketRoutes);
app.use('/api/v2', faultRequestRoutes);

//Ebill
app.use("/tmf-api/customerBillManagement/v5", eBillCheckUserExistRoutes);
app.use('/tmf-api/customerBillManagement/v5', billRoutes);
app.use('/tmf-api/billManegement/v4', eBillRegisetrationRoutes);
app.use("/tmf-api/customerBillManagement/v5", ebillStatusRequest);

// YouTube
app.use("/omniexpose", packageActivationRoutes);
app.use("/api/TimelyPay/checkofferavailability",checkOfferAvailabilityRoutes);

// New Connection (Catalog)
const productOfferingPriceRoutes = require("./NewCon/GetIniationNewConCharges/routes/productOfferingPriceRoutes.js");
const productOfferingRoutes = require("./NewCon/GetBBPackageInterim/routes/productOfferingRoutes.js");
const locationCheckRoutes = require("./NewCon/LocationCheckNewProduction/routes/locationCheckRoutes");
const getFacilityCheckRoutes = require("./NewCon/GetFacilityCheckV2/routes/getFacilityCheckRoutes");
const getCityListRoutes = require("./NewCon/GetCityList/routes/getCityListRoutes");
const reserveFacilityRoutes = require("./NewCon/ReserveFacility/routes/reserveFacilityRoutes");
const reserveFacilityOfflineRoutes = require("./NewCon/ReserveFacilityOfflineV2/routes/reserveFacilityOfflineRoutes");
const getPaymentLogsRoutes = require("./NewCon/GETGetPaymentLogs/routes/getPaymentLogsRoutes");
const newConSalesLeadRoutes = require("./NewCon/POSTNewConSalesLeadCreation/routes/newConSalesLeadRoutes");

const applicationGeneratorRoutes = require("./NewCon/POSTApplicationGenerator/routes/applicationGeneratorRoutes");

const updatePaymentLogsRoutes = require("./NewCon/POSTUpdatePaymentLogs/routes/updatePaymentLogsRoutes");
const getTokenStatusRoutes = require("./NewCon/POSTGetTokenToCheckStatus/routes/getTokenStatusRoutes");

// NewCon - Draft Data Management
const SaveDraftDataRoutes = require("./NewCon/SaveDraftData/routes/saveDraftDataRoutes.js");
const SaveDraftDataLTERoutes = require("./NewCon/SaveDraftDataLTE/routes/saveDraftDataLTERoutes.js");
const UpdateDraftDataV2Routes = require("./NewCon/UpdateDraftDataV2/routes/updateDraftDataV2Routes.js");
const UpdateDraftDataLTERoutes = require("./NewCon/UpdateDraftDataLTE/routes/updateDraftDataLTERoutes.js");
const GetDraftDataV2Routes = require("./NewCon/GetDraftDataV2/routes/getDraftDataV2Routes.js");

// NewCon - Agent & Order Status
const SendFTTHSecCodeRoutes = require("./NewCon/POSTSendFTTHSecCode/routes/sendFTTHSecCodeRoutes.js");
const GetAgentCodeRoutes = require("./NewCon/GETAgentCode/routes/getAgentCodeRoutes.js");
const UpdateAgentCodeRoutes = require("./NewCon/POSTUpdateAgentCode/routes/updateAgentCodeRoutes.js");
const GetOrderStatusRoutes = require("./NewCon/GETOrderStatus/routes/getOrderStatusRoutes.js");
const CheckCRMLeadStatusRoutes = require("./NewCon/GETCheckCRMLeadStatus/routes/checkCRMLeadStatusRoutes.js");

//PEOVAS
app.use("/tmf-api/productInventory/v4", productInventoryRoutes);
app.use("/tmf-api/purchasedProduct/v1", purchasedProductRoutes);
app.use("/tmf-api", getPurchasedProductsRoutes);
app.use("/tmf-api/serviceInventory/v4/", serviceInventoryRoutes);

app.use("/tmf-api/digitalIdentity/v4", verifyOTPRoutes);

// New Connection (Catalog)
app.use("/tmf-api/productCatalogManagement/v4", productOfferingPriceRoutes);
app.use("/tmf-api/productCatalogManagement/v4", productOfferingRoutes);
app.use('/tmf-api/serviceReservation/v4', locationCheckRoutes);
app.use('/tmf-api/serviceReservation/v4', getFacilityCheckRoutes);
app.use('/tmf-api/productCatalogManagement/v4', getCityListRoutes);
app.use('/tmf-api/serviceReservation/v4', reserveFacilityRoutes);
app.use('/tmf-api/serviceReservation/v4', reserveFacilityOfflineRoutes);
app.use("/tmf-api/customerBillManagement/v5/GetPaymentLogs",getPaymentLogsRoutes);
app.use("/tmf-api/productOrdering/v4/NewConSalesLeadCreation",newConSalesLeadRoutes);

app.use("/tmf-api/productOrdering/v4/ApplicationGenerator", applicationGeneratorRoutes);

// NewCon - Agent & Order Status
app.use("/tmf-api/NewCon/v1/SendFTTHSecCode", SendFTTHSecCodeRoutes);
app.use("/tmf-api/NewCon/v1/GetAgentCode", GetAgentCodeRoutes);
app.use("/tmf-api/NewCon/v1/UpdateAgentCode", UpdateAgentCodeRoutes);
app.use("/tmf-api/NewCon/v1/GetOrderStatus", GetOrderStatusRoutes);
app.use("/tmf-api/NewCon/v1/CheckCRMLeadStatus", CheckCRMLeadStatusRoutes);

app.use("/tmf-api/customerBillManagement/v5/UpdatePaymentLogs",updatePaymentLogsRoutes);
app.use("/tmf-api/customerManagement/v5/GetTokenToCheckStatus",getTokenStatusRoutes);
app.use("/tmf-api/productCatalogManagement/v4",voicePackageRoutes);
app.use("/api/NewCon",ossLoopReservationRoutes);
app.use("/tmf-api/productCatalogManagement/v4",checkExistCustomerRoutes);

//Notifications
app.use("/api/notifications", getPopupMessageBanner);
app.use("/api/notifications", postPushNotifications); //uses TMF681

//BB package Upgrade
app.use('/tmf-api/productOfferingQualification/v4', getBBpackageList); //uses TMF620


//BBExternal
// app.use('/tmf-api/BBExternal/GetBBPackagesV2',bbExternalGetPackagesV2);
// app.use('/tmf-api/BBExternal/GetBBPackageDetails',getBBPackageDetails);
app.use('/tmf-api/BBExternal/GetBBPackageComparison', getBBPackageComparison);

//Prepaid 

app.use("/tmf-api", dataGiftEnrolInitConfirm),
app.use('/tmf-api', dataGiftEnrollInit)
app.use("/tmf-api", vasBundleConfirmRoutes);
app.use("/tmf-api", unsubscribeAdvancedReportsRoutes);
app.use("/tmf-api/productOrder/v5", ExtraGBPurchasePrepaidRoutes);

// BBExternal - TMF637 Product Inventory / TMF622 Product Ordering
app.use("/api/BBExternal", require("./BBExternal/GetBBFreedomStatus/routes/getBBFreedomStatusRoutes"));
app.use("/tmf-api/productOrderingManagement/v4", require("./BBExternal/RegisterForBBFreedom_Nethmi/routes/registerForBBFreedomRoutes")); //uses TMF622

//Dashboard - TMF622 Product Ordering / TMF672 User Roles & Permissions
app.use('/api/dashboard/ftth-full-data', ftthRoutes);
app.use('/tmf-api/dashboard/ftth-specific', ftthSpecificRoutes);
app.use('/api/dashboard', ftthLoginRoutes);
app.use('/api/Dashboard/GetFTTHRequestStatusCount', ftthStatusRoutes);
app.use('/api/dashboard', ftthPermissionRoutes);
app.use('/api/dashboard', ftthChartRoutes);
app.use('/api/Dashboard/GetFaultDashboard', getFaultDashboardRoutes);
app.use('/api/Dashboard/GetSelectLOV', getSelectLOVRoutes);
app.use('/tmf-api/productOrdering/v4/productOrder/confirm', confirmRoutes);
app.use('/api/Dashboard', ftthDashboard);
app.use('/api/Dashboard',extraGBDashboard);
app.use("/api/Dashboard", ftthSpecificDataFilterRoutes);
app.use("/api/Dashboard", ftthMapDataRoutes);
app.use("/api/Dashboard", ebillDashboardRoutes); //uses TMF678
app.use("/api/Dashboard", addonsDashboardRoutes); //uses TMF637
app.use("/api/dashboard", extraGBRoutes);
app.use("/api/dashboard", freeDataRoutes);
app.use("/api/dashboard", bonusDataRoutes);


// HealthCheck - TMF653 Service Test Management / TMF681 Communication Management
app.use("/tmf-api/serviceTestManagement/v4", HealthCheck); //uses TMF653
app.use("/tmf-api/communicationManagement/v4", NotificationDetail); //uses TMF681

//ISP_SOA
app.use("/api/ISP_SOA/PreviousMonthsDailyUsage",previousMonthsDailyUsageRoutes);
app.use("/api/ISP_SOA/UpdateContact", updateContactRoutes);
app.use("/api/ISP_SOA/GetDataTransferAmounts", dataTransferAmountsRoutes);
app.use("/api/ISP_SOA/ValidateDataTransferSub", validateDataTransferSubRoutes);
app.use("/api/ISP_SOA/Authenticate", authenticateRoutes);
app.use("/api/ISP_SOA/CurrentMonthDailyUsage",currentMonthDailyUsageRoutes);
app.use("/api/ISP_SOA/dashboard/free_data", ispsoaFreeDataRoutes);
app.use("/api/ISP_SOA/dashboard/bonus_data", ispsoaBonusDataRoutes);
app.use("/api/ISP_SOA/dashboard/vas_data", ispsoaDashboardVASBundlesRoutes);
app.use("/api/ISP_SOA/dashboard/mypackage", ispsoaMyPackageRoutes);
app.use("/api/ISP_SOA",getVASDataBundlePackagesRouter);
app.use("/api/isp-soa", redeemVoucherRoutes);
app.use("/tmf-api/productOrderingManagement/v4", redeemVoucherRoutes);
app.use("/api/isp-soa", happyDayRoutes);
app.use("/tmf-api/productOrderingManagement/v4", happyDayRoutes);
app.use("/api/isp-soa", upgradeLoyaltyRoutes);
app.use("/tmf-api/customerManagement/v4", upgradeLoyaltyRoutes);
app.use("/api/isp-soa", changeBBPasswordRoutes);
app.use("/tmf-api/customerManagement/v4", changeBBPasswordRoutes);
app.use("/api/ISP_SOA",addVASDataBundlePostPaidRouter);
app.use("/api/ISP_SOA",vasBundleUnsubscriptionRouter);
app.use("/api/ISP_SOA",transferDataRouter);
app.use("/api/ISP_SOA/ProtocolReport",protocolReportRoutes);
app.use("/api/ISP_SOA/AdvertisementGetList",advertisementListRoutes);
app.use("/api/ISP_SOA/SubtokenDirect", subtokenDirectRoutes);
app.use("/api/ISP_SOA/GetPurchaseHistory",purchaseHistoryRoutes);
app.use("/api/ISP_SOA/ExtraGB",extraGBRoutes);
app.use("/api/ISP_SOA/WeeksUsage",weeksUsageRoutes);

app.use("/api/ISP_SOA/dashboard/summary", dashboardSummaryRoutes);

app.use("/api/ISP_SOA/getExtraGbPackages",getExtraGbPackages);
app.use("/api/ISP_SOA/postExGBPurchasePostpaid",POSTExGBPurchasePostpaid);
app.use("/api/ISP_SOA/getAdvancedReportingPackages",getAdvancedReportingPackages);
app.use("/api/ISP_SOA/purchaseAdvancedReporting",purchaseAdvancedReporting);



//ISP_Direct
app.use("/api/ISP_Direct",purchaseAdvancedReportsRouter);
app.use("/api/ISP_Direct",isp_direct_transferDataRouter);
app.use("/api/ISP_Direct",getDashboardVASBundlesRouter);
app.use("/tmf-api/usageManagement/v4/PreviousMonthsDailyUsage",previousMonthsDailyUsageRoutesV2);
app.use("/tmf-api/usageManagement/v4/WeeksUsage",weeksUsageRoutes);
app.use("/api/isp-direct", getVASBundlePackagesRoutes);
app.use("/tmf-api/productCatalogManagement/v4", getVASBundlePackagesRoutes);
app.use("/api/ISP_Direct/UpgradeLoyalty", ispDirectUpgradeLoyaltyRoutes);
app.use("/api/ISP_Direct/ChangeBBPassword", ispDirectChangeBBPasswordRoutes);
app.use("/api/ISP_Direct/MyPackage", ispDirectMyPackageRoutes);
app.use("/api/ISP_Direct/EnhancedCurrentDailyUsage", ispDirectEnhancedCurrentDailyUsageRoutes);
app.use("/api/ISP_Direct/EnhancedPreviousDailyUsage", ispDirectEnhancedPreviousDailyUsageRoutes);
app.use("/api/isp-direct", vasBundleUnsubscriptionRoutes);
app.use("/tmf-api/productOrderingManagement/v4", vasBundleUnsubscriptionRoutes);
app.use("/api/isp-direct", addVASDataBundleRoutes);
app.use("/tmf-api/productOrderingManagement/v4", addVASDataBundleRoutes);
app.use("/api/isp-direct", getPurchaseHistoryRouter);
app.use("/tmf-api/usageManagement/v4/BBUsageRequest",bbUsageRequestRoutes);
app.use("/api/isp-direct",protocolReportRouter);
app.use("/api/isp-direct",advertisementGetListRouter);

//verify
app.use("/api/verify",getVoiceUsageRouter);
app.use("/api/Verify/ProtectedResource", protectedResourceRoutes);

//VAS
app.use("/api/VAS/ProfileRequest", profileRequestRoutes);
app.use("/api/vas", vasProfileRoutes);
app.use("/tmf-api/customerManagement/v4", vasProfileRoutes);

//voice
app.use("/tmf-api/voice/v4/CallForwardingRequest",callForwardingRequestRoutes);
app.use("/api/VAS",getCustConfirmationRouter);

//NewCon
// NewCon - Draft Data Management
app.use("/tmf-api/customerBillManagement/v5/SaveDraftData", SaveDraftDataRoutes);
app.use("/tmf-api/customerBillManagement/v5/SaveDraftDataLTE", SaveDraftDataLTERoutes);
app.use("/tmf-api/customerBillManagement/v5/UpdateDraftDataV2", UpdateDraftDataV2Routes);
app.use("/tmf-api/customerBillManagement/v5/UpdateDraftDataLTE", UpdateDraftDataLTERoutes);
app.use("/tmf-api/customerBillManagement/v5/GetDraftDataV2", GetDraftDataV2Routes);

app.use("/tmf-api/UploadMultipartSingle", uploadMultipartSinglev2) // TMF663
app.use("/tmf-api/UploadSingle", uploadSingle) // TMF663

app.use("/tmf-api/GenerateFTTHSecreatCode", generateFTTHSecreatCode)// tmf 622
// Health check
app.get('/', (req, res) => {
  res.send('Omini API Server is running ✅');
});

module.exports = app; // Export the Express app