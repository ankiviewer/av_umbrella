var hamburger = document.querySelector('.hamburger');

hamburger.addEventListener('click', function () {
  hamburger.classList.toggle('is-active');
  document.querySelector('.mobile-navbar-menu').classList.toggle('right-100');
});
