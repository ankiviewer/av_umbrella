import { select } from './utils.js';

var hamburger = select('.hamburger');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  select('.mobile-navbar-menu').classList.toggle('right-100');
});

document.querySelector('.mobile-navbar-menu').style.height = (document.querySelector('.mobile-navbar-menu').clientHeight - document.querySelector('header.header').clientHeight) + 'px';
