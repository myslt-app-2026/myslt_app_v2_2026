require('dotenv').config();
const mongoose = require('mongoose');
const CustomerBill = require('./models/customerBill.model');
const connectDB = require('../../config/db'); // Import your existing DB connection function

// --- Sample Data ---
const sampleBills = [
    {
        billId: '12345',
        href: '/tmf-api/customerBillManagement/v5/customerBill/12345',
        amountDue: { value: 2500.00, unit: 'LKR' },
        billingPeriod: {
            startDateTime: new Date('2023-10-01T00:00:00Z'),
            endDateTime: new Date('2023-10-31T23:59:59Z'),
        },
        state: 'sent',
    },
    {
        billId: '67890',
        href: '/tmf-api/customerBillManagement/v5/customerBill/67890',
        amountDue: { value: 4850.50, unit: 'LKR' },
        billingPeriod: {
            startDateTime: new Date('2023-10-01T00:00:00Z'),
            endDateTime: new Date('2023-10-31T23:59:59Z'),
        },
        state: 'new',
    },
    {
        billId: 'ABCDE',
        href: '/tmf-api/customerBillManagement/v5/customerBill/ABCDE',
        amountDue: { value: 1200.00, unit: 'LKR' },
        billingPeriod: {
            startDateTime: new Date('2023-09-01T00:00:00Z'),
            endDateTime: new Date('2023-09-30T23:59:59Z'),
        },
        state: 'settled',
    }
];

const seedDB = async () => {
    try {
        // Use the centralized connection function
        await connectDB();
        console.log('✅ MongoDB connected for seeding.');

        // Clear existing bills
        await CustomerBill.deleteMany({});
        console.log('✅ Existing CustomerBill data removed.');

        // Insert new sample bills
        await CustomerBill.insertMany(sampleBills);
        console.log('✅ Database seeded with sample bills.');

    } catch (err) {
        console.error('❌ Error seeding database:', err.message);
    } finally {
        // Close the connection properly, just like in your example
        if (mongoose.connection.readyState === 1) {
            await mongoose.connection.close();
            console.log('✅ MongoDB connection closed.');
        }
    }
};

// Run the seeder function
seedDB();

