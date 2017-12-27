function select (el) { return document.querySelector(el); }

var hamburger = select('.hamburger');
var header = select('header.header');
var mobileNavbarMenu = select('.mobile-navbar-menu');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  mobileNavbarMenu.classList.toggle('right-100');
});

function resizeHamburger() {
  mobileNavbarMenu.style.height = (window.innerHeight - header.clientHeight) + 'px';
}

window.addEventListener('load', resizeHamburger);
window.addEventListener('resize', resizeHamburger);
