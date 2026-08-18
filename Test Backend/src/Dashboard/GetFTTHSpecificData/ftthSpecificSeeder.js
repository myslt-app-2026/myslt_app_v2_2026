const mongoose = require('mongoose');
require('dotenv').config(); 

const connectDB = require('../../config/db'); 
const FTTHSpecificData = require('./models/ftthSpecificModel');

connectDB();

async function seedFTTHSpecific() {
    try {
        console.log('--- Starting Database Seeding (TMF FTTH Specific Data Aggregation) ---');
        
        await FTTHSpecificData.deleteMany({});
        console.log('Cleared existing FTTHSpecificData documents.');

        const initialEntry = {
            service: {
                id: "SPEC-SRV-001",
                name: "SLTMOBITEL FIBRE HOME LINE",
                state: "active"
            },
            product: {
                id: "SPEC-PRD-001",
                name: "Fiber Unlimited 100Mbps",
                productCharacteristic: [
                    { name: "bbPackages", value: "Fibre_Family" },
                    { name: "billType", value: "eBill" }
                ],
                relatedParty: [{
                    id: "971234567V",
                    name: "Thameera Perera",
                    characteristic: [
                        { name: "mobile", value: "0712345678" },
                        { name: "email", value: "thameera@slt.lk" }
                    ]
                }]
            },
            resources: [{ id: "SPEC-ONT-01", resourceType: "ONT", serialNumber: "SN-SPEC-789" }],
            location: {
                id: "LOC-SPEC-01",
                address1: "No 12, Galle Road",
                city: "Colombo",
                latitude: "6.9271",
                longitude: "79.8612"
            },
            serviceStatus: "ACTIVE"
        };

        await FTTHSpecificData.create(initialEntry);
        console.log('Successfully inserted TMF FTTH Specific Data document.');
        
    } catch (error) {
        console.error('--- Error seeding database ---', error.message);
        process.exit(1);
    } finally {
        await mongoose.connection.close();
        console.log('--- Database Seeding Complete and connection closed. ---');
    }
}

seedFTTHSpecific();