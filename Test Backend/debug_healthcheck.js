
const fs = require('fs');
const path = require('path');

const healthCheckDir = path.join(__dirname, 'n:/Omni-Channel/src/HealthCheck');
const targetDir = path.join(healthCheckDir, 'HealthCheckRequest');

console.log('--- Directory Check ---');
if (fs.existsSync(healthCheckDir)) {
    console.log(`Contents of ${healthCheckDir}:`);
    fs.readdirSync(healthCheckDir).forEach(file => {
        console.log(' - ' + file);
    });
} else {
    console.error(`Directory not found: ${healthCheckDir}`);
}

console.log('\n--- Module Resolve Check ---');
try {
    const routePath = 'n:/Omni-Channel/src/HealthCheck/HealthCheckRequest/routes/healthCheckRoutes';
    const resolved = require.resolve(routePath);
    console.log(`Successfully resolved: ${resolved}`);
    const module = require(routePath);
    console.log('Module loaded successfully');
} catch (err) {
    console.error('Failed to resolve/load module:', err.message);
}
