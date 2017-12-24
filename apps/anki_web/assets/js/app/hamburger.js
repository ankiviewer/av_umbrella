import { select } from '../utils/index.js';

var hamburger = select('.hamburger');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  select('.mobile-navbar-menu').classList.toggle('right-100');
});

function resizeHamburger() {
  var headerHeight = select('header.header').clientHeight;
  select('.mobile-navbar-menu').style.height = (window.innerHeight - headerHeight) + 'px';
}

window.addEventListener('load', resizeHamburger);
window.addEventListener('resize', resizeHamburger);
