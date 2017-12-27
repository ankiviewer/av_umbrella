const seleniumServer = require('selenium-server');
const chromedriver = require('chromedriver');

const port = selenium_port = 4444;

const config = {
  src_folders: [
    'test/e2e/bundle/desktop',
    'test/e2e/bundle/mobile'
  ],
  selenium: {
    start_process: true,
    server_path: seleniumServer.path,
    log_path: '',
    port,
    cli_args: {
      'webdriver.chrome.driver': chromedriver.path
    }
  },

  test_settings: {
    default: {
      launch_url: 'http://localhost',
      selenium_port,
      selenium_host: 'localhost',
      silent: true,
      globals: {
        waitForConditionTimeout: 20000
      }
    },

    desktop: {
      desiredCapabilities: {
        browserName: 'chrome',
        javascriptEnabled: true,
        acceptSslCerts: true
      },
      exclude: './test/e2e/bundle/mobile/*'
    },

    mobile: {
      desiredCapabilities: {
        browserName: 'chrome',
        javascriptEnabled: true,
        acceptSslCerts: true,
        chromeOptions: {
          args: [
            '--window-size=450,600'
          ]
        }
      },
      exclude: './test/e2e/bundle/desktop/*'
    },
  }
}

module.exports = config;
