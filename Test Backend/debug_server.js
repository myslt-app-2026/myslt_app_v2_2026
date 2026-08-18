const express = require('express');
const app = express();

// Middleware - EXACTLY as in app.js
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Import the specific route we are debugging
const registerRoute = require('./src/BBExternal/RegisterForBBFreedom_Nethmi/routes/registerForBBFreedomRoutes');

// Mount it exactly as in app.js
app.use("/api/BBExternal", registerRoute);

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`Debug server running on port ${PORT}`);
    console.log(`Test URL: http://localhost:${PORT}/api/BBExternal/RegisterForBBFreedom`);
});
