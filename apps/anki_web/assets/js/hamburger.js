import { select } from './utils.js';

var hamburger = select('.hamburger');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  select('.mobile-navbar-menu').classList.toggle('right-100');
});

function resizeHamburger() {
  document.querySelector('.mobile-navbar-menu').style.height = (window.innerHeight - document.querySelector('header.header').clientHeight) + 'px';
}

window.addEventListener('load', resizeHamburger);
window.addEventListener('resize', resizeHamburger);
