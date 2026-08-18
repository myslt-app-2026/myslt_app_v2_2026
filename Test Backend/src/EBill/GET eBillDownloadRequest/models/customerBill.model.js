const mongoose = require('mongoose');

const customerBillSchema = new mongoose.Schema({
  billId: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  href: {
    type: String,
  },
  amountDue: {
    value: Number,
    unit: String,
  },
  billingPeriod: {
    startDateTime: Date,
    endDateTime: Date,
  },
  state: {
    type: String,
    enum: ['new', 'onHold', 'validated', 'sent', 'settled', 'cancelled'],
    default: 'new',
  },
  fileLocation: {
    type: String,
  }
}, { timestamps: true });

// A static method to create a mock bill for testing if one doesn't exist
customerBillSchema.statics.ensureMockData = async function() {
  const count = await this.countDocuments({ billId: '12345' });
  if (count === 0) {
    console.log("Mock bill not found. Creating one with billId: 12345...");
    await this.create({
      billId: '12345',
      href: '/tmf-api/customerBillManagement/v5/customerBill/12345',
      amountDue: { value: 2500.00, unit: 'LKR' },
      billingPeriod: {
        startDateTime: new Date('2023-10-01T00:00:00Z'),
        endDateTime: new Date('2023-10-31T23:59:59Z'),
      },
      state: 'sent',
      fileLocation: '/files/bills/12345.pdf'
    });
    console.log("Mock bill created successfully.");
  }
};

const CustomerBill = mongoose.model('CustomerBill', customerBillSchema);

// Run the check on startup
(async () => {
  try {
    await CustomerBill.ensureMockData();
  } catch (error) {
    console.error("Error creating mock data:", error);
  }
})();

module.exports = CustomerBill;
