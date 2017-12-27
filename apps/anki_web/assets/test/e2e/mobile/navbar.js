import start from '../start.js';
import navbar from '../navbar.js';

module.exports = {
  'navbar mobile': (browser) => {
    start.mobile(browser);
    
    navbar.mobile(browser);

    browser.end();
  }
}
