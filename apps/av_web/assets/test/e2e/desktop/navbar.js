import start from '../start.js';
import navbar from '../navbar.js';

module.exports = {
  'navbar desktop': (browser) => {
    start.desktop(browser);
    
    navbar.desktop(browser);

    start.resize(browser);

    navbar.mobile(browser);

    browser.end();
  }
}
