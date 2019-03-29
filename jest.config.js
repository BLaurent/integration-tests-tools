const path = require('path');

module.exports = {
  verbose: true,
  setupFiles: [ path.join(process.cwd(), ".env.js")]
};
