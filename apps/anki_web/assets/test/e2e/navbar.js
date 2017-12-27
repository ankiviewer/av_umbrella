const assert = require('assert');

const parsePx = (pxString) => parseInt(pxString.split('px')[0]);

const desktop = (browser) => {
  browser.expect.element('.hamburger').to.not.be.visible;
};

const mobile = (browser) => {
  browser.expect.element('.hamburger').to.be.visible;

  browser.getCssProperty('.mobile-navbar-menu', 'right', ({ value: navbarMenuRight} ) => {
    browser.getCssProperty('body', 'width', ({ value: bodyWidth }) => {
      assert.equal(navbarMenuRight, bodyWidth);
    });
  });

  browser.click('.hamburger')
    .pause(500); // wait for it to fully slide

  browser.getCssProperty('.mobile-navbar-menu', 'right', ({ value: navbarMenuRight }) => {
    assert.equal(navbarMenuRight, '0px');
  });

  browser.getCssProperty('.header', 'height', ({ value: headerHeight }) => {
    browser.getCssProperty('.mobile-navbar-menu', 'height', ({ value: navbarMenuHeight }) => {
      browser.windowSize('current', (windowSize) => {
        // seems that window size is consistently off by 114px locally and by 105px in a headless browser
        const heights = [windowSize.value.height - 114, windowSize.value.height - 105]
        assert.ok(heights.includes(parsePx(headerHeight) + parsePx(navbarMenuHeight)));
      });
    });
  });
};

export default { desktop, mobile };
