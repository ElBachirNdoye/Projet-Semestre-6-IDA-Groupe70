// Page d'accueil et contact : interactions JS

document.addEventListener('DOMContentLoaded', function () {
  const navbar = document.getElementById('navbar');
  const pageContent = document.getElementById('pageContent');
  const navCollapse = document.getElementById('navbarNav');
  const backToTopBtn = document.getElementById('backToTop');
  const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
  const sections = document.querySelectorAll('section[id]');

  function getNavbarHeight() { return navbar ? navbar.offsetHeight : 0; }

  function closeBootstrapMenu() {
    if (!navCollapse || typeof bootstrap === 'undefined') return;
    const collapseInstance = bootstrap.Collapse.getInstance(navCollapse);
    if (collapseInstance) collapseInstance.hide();
  }

  function scrollToSection(selector) {
    const target = document.querySelector(selector);
    if (!target) return;
    const position = target.offsetTop - getNavbarHeight();
    window.scrollTo({ top: position, behavior: 'smooth' });
  }

  document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (event) {
      const href = anchor.getAttribute('href');
      if (!href || href === '#') return;
      const target = document.querySelector(href);
      if (!target) return;
      event.preventDefault();
      scrollToSection(href);
      if (navCollapse && navCollapse.classList.contains('show')) closeBootstrapMenu();
    });
  });

  function closeMobileMenuOnClickOutside(event) {
    if (!navCollapse || !navCollapse.classList.contains('show')) return;
    if (navCollapse.contains(event.target)) return;
    const toggler = document.querySelector('.navbar-toggler');
    if (toggler && toggler.contains(event.target)) return;
    closeBootstrapMenu();
  }

  if (pageContent && navCollapse) {
    pageContent.addEventListener('click', closeMobileMenuOnClickOutside);
    pageContent.addEventListener('touchstart', closeMobileMenuOnClickOutside);
  }

  function updatePageOnScroll() {
    const scrollY = window.pageYOffset;
    if (navbar) navbar.classList.toggle('scrolled', scrollY > 40);
    if (backToTopBtn) backToTopBtn.classList.toggle('visible', scrollY > 400);

    let currentSectionId = '';
    sections.forEach(function (section) {
      const sectionTop = section.offsetTop - getNavbarHeight() - 20;
      if (scrollY >= sectionTop) currentSectionId = section.getAttribute('id');
    });

    navLinks.forEach(function (link) {
      const href = link.getAttribute('href');
      link.classList.toggle('active', href === '#' + currentSectionId);
    });
  }

  window.addEventListener('scroll', updatePageOnScroll, { passive: true });
  updatePageOnScroll();

  if (backToTopBtn) backToTopBtn.addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });

  // Simple toggle helper
  window.afficher = function (id) {
    const contenu = document.getElementById(id);
    if (!contenu) return;
    contenu.style.display = (contenu.style.display === 'block') ? 'none' : 'block';
  };

  // Formulaire de contact (envoi via fetch vers PHP/contact.php)
  const form = document.getElementById('contactForm');
  if (form) {
    form.addEventListener('submit', function (event) {
      event.preventDefault();
      const data = new FormData(form);
      fetch('PHP/contact.php', { method: 'POST', body: data })
        .then(r => r.json())
        .then(json => {
          if (json.success) {
            alert(json.message || 'Message envoyé avec succès');
            form.reset();
          } else {
            alert(json.error || 'Erreur lors de l\'envoi');
          }
        })
        .catch(() => alert('Erreur réseau. Veuillez réessayer plus tard.'));
    });
  }

});