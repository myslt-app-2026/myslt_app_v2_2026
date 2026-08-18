const mongoose = require('mongoose');
require('dotenv').config(); 

const connectDB = require('../../config/db'); 
const FTTHFullData = require('./models/ftthModel');

async function seedFTTHData() {
    try {
        console.log('--- Starting Database Seeding (TMF FTTH Full Data) ---');
        await connectDB();

        await FTTHFullData.deleteMany({});
        console.log('Cleared existing FTTHFullData documents.');

        const initialData = [
            {
                service: {
                    id: "SRV12345",
                    name: "SLTMOBITEL FIBRE HOME LINE",
                    state: "active",
                    serviceCharacteristic: [
                        { name: "iddActivate", value: "true" }
                    ]
                },
                product: {
                    id: "PRD67890",
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
                            { name: "email", value: "test@slt.lk" },
                            { name: "gender", value: "Male" }
                        ]
                    }]
                },
                resources: [{ id: "ONT001", resourceType: "ONT", serialNumber: "HWTC123" }],
                location: {
                    id: "LOC001",
                    address1: "No 12, Galle Road",
                    city: "Colombo 03",
                    district: "Colombo",
                    latitude: "6.9271",
                    longitude: "79.8612"
                },
                serviceStatus: "ACTIVE"
            }
        ];

        await FTTHFullData.insertMany(initialData);
        console.log(`Successfully inserted ${initialData.length} TMF FTTH Full Data documents. ✅`);
        
    } catch (error) {
        console.error('--- Error seeding database ---', error.message);
        process.exit(1);
    } finally {
        await mongoose.connection.close();
        console.log('--- Database Seeding Complete and connection closed. ---');
    }
}

seedFTTHData();