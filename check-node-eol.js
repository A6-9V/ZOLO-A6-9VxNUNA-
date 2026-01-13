// check-node-eol.js
const fs = require('fs');
const path = require('path');

async function checkNodeEOL() {
    try {
        // 1. Read and parse package.json
        const packageJsonPath = path.resolve(process.cwd(), 'package.json');
        const packageJsonContent = fs.readFileSync(packageJsonPath, 'utf8');
        const packageJson = JSON.parse(packageJsonContent);

        const nodeVersionRange = packageJson.engines && packageJson.engines.node;

        if (!nodeVersionRange) {
            console.warn('[WARNING] The `engines.node` field is not defined in package.json. Skipping EOL check.');
            return;
        }

        // 2. Extract the major version number
        const majorVersionMatch = nodeVersionRange.match(/\d+/);
        if (!majorVersionMatch) {
            console.error(`[ERROR] Could not parse major version from 'engines.node' value: "${nodeVersionRange}".`);
            process.exit(1);
        }
        const majorVersion = majorVersionMatch[0];

        // 3. Fetch EOL data
        const response = await fetch('https://endoflife.date/api/nodejs.json');
        if (!response.ok) {
            throw new Error(`Failed to fetch EOL data: ${response.statusText}`);
        }
        const eolData = await response.json();

        // 4. Find version info
        const versionInfo = eolData.find(v => v.cycle === majorVersion);

        if (!versionInfo) {
            console.warn(`[WARNING] Could not find EOL information for Node.js v${majorVersion}.`);
            return;
        }

        // 5. Compare dates and report
        const eolDate = new Date(versionInfo.eol);
        const today = new Date();
        const sixMonthsFromNow = new Date();
        sixMonthsFromNow.setMonth(today.getMonth() + 6);

        console.log(`[INFO] Required Node.js version from package.json: ${nodeVersionRange}`);
        console.log(`[INFO] EOL date for v${majorVersion} is ${eolDate.toDateString()}`);

        if (eolDate < today) {
            console.error(`[ERROR] The Node.js version specified in package.json (v${majorVersion}) has reached its End-of-Life on ${eolDate.toDateString()}. Please upgrade the 'engines.node' field.`);
            process.exit(1);
        } else if (eolDate < sixMonthsFromNow) {
            console.warn(`[WARNING] The Node.js version specified in package.json (v${majorVersion}) will reach its End-of-Life on ${eolDate.toDateString()}. Please plan to upgrade soon.`);
        } else {
            console.log(`[OK] The Node.js version specified in package.json (v${majorVersion}) is actively supported.`);
        }

    } catch (error) {
        console.error('[ERROR] Failed to check Node.js EOL status:', error.message);
        process.exit(1);
    }
}

checkNodeEOL();
