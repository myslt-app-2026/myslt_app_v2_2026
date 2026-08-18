require('dotenv').config();
const mongoose = require('mongoose');
const DataGiftPackage = require('./models/DataGiftPackageModel');
const connectDB = require('../../config/db');

const dummyServices = [{
  id: '1',
  href: '/tmf-api/serviceActivation/v4.0.0/service/1',
  category: 'Data Gift',
  name: '1GB Data Gift Pack',
  description: '1GB of data valid for 7 days.',
  isBundle: false,
  state: 'active',
  serviceDate: new Date(),
  startDate: new Date(),
  endDate: new Date(new Date().setDate(new Date().getDate() + 7)),
  serviceSpecification: {
    id: 'spec-1',
    href: '/tmf-api/serviceActivation/v4.0.0/serviceSpecification/spec-1',
    name: 'Data Gift Service Specification',
  },
  serviceCharacteristic: [{
    name: 'Data Volume',
    valueType: 'string',
    value: '1GB',
  }, ],
  relatedParty: [{
    id: '94771234567',
    href: '/tmf-api/customerManagement/v5.0.0/customer/94771234567',
    role: 'Recipient Customer',
  }, ],
}, {
  id: '2',
  href: '/tmf-api/serviceActivation/v4.0.0/service/2',
  category: 'Data Gift',
  name: '5GB Data Gift Pack',
  description: '5GB of data valid for 30 days.',
  isBundle: false,
  state: 'active',
  serviceDate: new Date(),
  startDate: new Date(),
  endDate: new Date(new Date().setDate(new Date().getDate() + 30)),
  serviceSpecification: {
    id: 'spec-1',
    href: '/tmf-api/serviceActivation/v4.0.0/serviceSpecification/spec-1',
    name: 'Data Gift Service Specification',
  },
  serviceCharacteristic: [{
    name: 'Data Volume',
    valueType: 'string',
    value: '5GB',
  }, ],
  relatedParty: [{
    id: '94771234567',
    href: '/tmf-api/customerManagement/v5.0.0/customer/94771234567',
    role: 'Recipient Customer',
  }, ],
}, ];

const seedDB = async () => {
  try {
    await connectDB();
    console.log('✅ MongoDB connected for seeding.');

    await DataGiftPackage.deleteMany({});
    console.log('✅ Existing DataGiftPackage data removed.');

    await DataGiftPackage.insertMany(dummyServices);
    console.log('✅ Database seeded with dummy services.');

  } catch (error) {
    console.error('❌ Error seeding database:', error.message);
  } finally {
    if (mongoose.connection.readyState === 1) {
      await mongoose.connection.close();
      console.log('✅ MongoDB connection closed.');
    }
  }
};

seedDB();