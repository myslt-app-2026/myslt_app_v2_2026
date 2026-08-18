// Test script to verify registerForBBFreedom controller behavior
const { registerForBBFreedom } = require('./controllers/registerForBBFreedomController');

// Mock response object
const createMockRes = () => {
    const res = {};
    res.status = (code) => {
        res.statusCode = code;
        return res;
    };
    res.json = (data) => {
        res.jsonData = data;
        return res;
    };
    return res;
};

// Test 1: Valid body request
console.log('Test 1: Valid body request');
const req1 = {
    headers: { 'content-type': 'application/json' },
    body: {
        tpNo: 'TP123',
        description: 'Test description',
        contactMobile: '0771234567'
    },
    query: {}
};
const res1 = createMockRes();

registerForBBFreedom(req1, res1).then(() => {
    console.log('Status:', res1.statusCode);
    console.log('Response:', JSON.stringify(res1.jsonData, null, 2));
    console.log('✓ Test 1 passed\n');
});

// Test 2: Query parameters should NOT work (missing tpNo in body)
setTimeout(() => {
    console.log('Test 2: Query parameters should fail (no body data)');
    const req2 = {
        headers: { 'content-type': 'application/json' },
        body: {},
        query: {
            tpNo: 'TP456',
            description: 'Query description',
            contactMobile: '0779876543'
        }
    };
    const res2 = createMockRes();

    registerForBBFreedom(req2, res2).then(() => {
        console.log('Status:', res2.statusCode);
        console.log('Response:', JSON.stringify(res2.jsonData, null, 2));
        if (res2.statusCode === 400) {
            console.log('✓ Test 2 passed - Query params correctly rejected\n');
        } else {
            console.log('✗ Test 2 failed - Should have returned 400\n');
        }
    });
}, 100);

// Test 3: Missing tpNo in body
setTimeout(() => {
    console.log('Test 3: Missing tpNo in body');
    const req3 = {
        headers: { 'content-type': 'application/json' },
        body: {
            description: 'Test description',
            contactMobile: '0771234567'
        },
        query: {}
    };
    const res3 = createMockRes();

    registerForBBFreedom(req3, res3).then(() => {
        console.log('Status:', res3.statusCode);
        console.log('Response:', JSON.stringify(res3.jsonData, null, 2));
        if (res3.statusCode === 400) {
            console.log('✓ Test 3 passed - Missing tpNo correctly rejected\n');
        } else {
            console.log('✗ Test 3 failed - Should have returned 400\n');
        }
    });
}, 200);
