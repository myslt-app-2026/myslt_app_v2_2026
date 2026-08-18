require('dotenv').config();
const mongoose = require('mongoose');
const CommunicationMessage = require('../../Notifications/PostPushNotifications/models/communicationMessage.model.js');

const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/OmniChannel';

// TMF 681 CommunicationMessage sample data
const sampleCommunications = [
  {
    id: "1",
    href: "http://localhost:3000/api/Banner/BannerDetailRequest/1",
    "@type": "CommunicationMessage",
    subject: "New Year Promotion 2026",
    scheduledSendTime: new Date("2026-01-01T00:00:00.000Z"),
    state: "Completed",
    description: "Special promotion for new year - Get 50% off on all data packages",
    content: "Dear $CustomerName, Here is the latest promotion: $PromotionDetails",
    messageType: "Banner",
    characteristic: [
      {
        "@type": "StringCharacteristic",
        name: "$CustomerName",
        value: "Randika",
        valueType: "string"
      },
      {
        "@type": "StringCharacteristic",
        name: "$PromotionDetails",
        value: "4G Data Bundle - 50% Discount",
        valueType: "string"
      }
    ],
    attachment: [
      {
        "@type": "Attachment",
        url: "https://example.com/banners/newyear2026.jpg",
        name: "NewYear_Banner_2026",
        content: "banner_image_data",
        attachmentType: "image",
        mimeType: "image/jpeg"
      }
    ],
    sender: {
      "@type": "Sender",
      id: "10001",
      name: "Omni Channel Service",
      phoneNumber: "1234567890",
      party: {
        role: "service provider",
        partyOrPartyRole: {
          id: "1001",
          href: "http://localhost:3000/tmf-api/partyManagement/v4/organization/1001",
          name: "Omni Channel Service",
          "@type": "Organization"
        },
        "@type": "RelatedPartyOrPartyRole"
      }
    },
    receiver: [
      {
        "@type": "Receiver",
        id: "randikaslt@gmail.com",
        name: "Randika",
        phoneNumber: "0771234567",
        party: {
          role: "customer",
          partyOrPartyRole: {
            id: "randikaslt@gmail.com",
            href: "http://localhost:3000/tmf-api/partyManagement/v4/individual/randikaslt@gmail.com",
            name: "Randika",
            "@type": "Individual"
          },
          "@type": "RelatedPartyOrPartyRole"
        }
      }
    ]
  },
  {
    id: "2",
    href: "http://localhost:3000/api/Banner/BannerDetailRequest/2",
    "@type": "CommunicationMessage",
    subject: "System Maintenance Notice",
    scheduledSendTime: new Date("2026-01-10T00:00:00.000Z"),
    state: "Scheduled",
    description: "Scheduled system maintenance notification",
    content: "Dear Customer, System maintenance is scheduled on $MaintenanceDate from $StartTime to $EndTime",
    messageType: "Banner",
    characteristic: [
      {
        "@type": "StringCharacteristic",
        name: "$MaintenanceDate",
        value: "January 15, 2026",
        valueType: "string"
      },
      {
        "@type": "StringCharacteristic",
        name: "$StartTime",
        value: "2:00 AM",
        valueType: "string"
      },
      {
        "@type": "StringCharacteristic",
        name: "$EndTime",
        value: "4:00 AM",
        valueType: "string"
      }
    ],
    attachment: [],
    sender: {
      "@type": "Sender",
      id: "10001",
      name: "Omni Channel Service",
      phoneNumber: "1234567890",
      party: {
        role: "service provider",
        partyOrPartyRole: {
          id: "1001",
          href: "http://localhost:3000/tmf-api/partyManagement/v4/organization/1001",
          name: "Omni Channel Service",
          "@type": "Organization"
        },
        "@type": "RelatedPartyOrPartyRole"
      }
    },
    receiver: [
      {
        "@type": "Receiver",
        id: "randikaslt@gmail.com",
        name: "Randika",
        phoneNumber: "0771234567",
        party: {
          role: "customer",
          partyOrPartyRole: {
            id: "randikaslt@gmail.com",
            href: "http://localhost:3000/tmf-api/partyManagement/v4/individual/randikaslt@gmail.com",
            name: "Randika",
            "@type": "Individual"
          },
          "@type": "RelatedPartyOrPartyRole"
        }
      }
    ]
  }
];

async function seedCommunications() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('✅ MongoDB connected');

    await CommunicationMessage.deleteMany({});
    console.log('🗑️  Cleared existing communication messages');

    await CommunicationMessage.insertMany(sampleCommunications);
    console.log(`✅ Inserted ${sampleCommunications.length} TMF 681 communication messages`);

    console.log('\n📋 Sample communications:');
    sampleCommunications.forEach(comm => {
      console.log(`  - ID: ${comm.id}, Subject: ${comm.subject}, State: ${comm.state}`);
    });

    console.log('\n✅ TMF 681 seeding completed!');
    console.log('\n🔗 Test the endpoint:');
    console.log('GET http://localhost:3000/api/Banner/BannerDetailRequest?username=randikaslt@gmail.com');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding communications:', error);
    process.exit(1);
  }
}

seedCommunications();
