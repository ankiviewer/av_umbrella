var hamburger = document.querySelector('.hamburger');
var mobileNavbarMenu = document.querySelector('.mobile-navbar-menu');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  mobileNavbarMenu.classList.toggle('right-100');
});
