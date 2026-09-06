const fs = require('fs');
const html = fs.readFileSync('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'utf8');

// We can just extract the animateTerminal function and test it.
const match = html.match(/async function animateTerminal.*?\n        }/s);
if (match) {
    console.log("Found animateTerminal!");
} else {
    console.log("Could not find animateTerminal.");
}
