// Page d'accueil
/* Ce code gère :
   -> le scroll fluide vers les ancres
   -> la fermeture du menu mobile
   -> la navbar qui change de style après défilement
   -> un bouton "retour en haut"
*/

document.addEventListener('DOMContentLoaded', function () {
  const navbar = document.getElementById('navbar');
  const pageContent = document.getElementById('pageContent');
  const navCollapse = document.getElementById('navbarNav');
  const backToTopBtn = document.getElementById('backToTop');
  const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
  const sections = document.querySelectorAll('section[id]');

  function getNavbarHeight() {
    if (!navbar) {
      return 0;
    }
    return navbar.offsetHeight;
  }

  function closeBootstrapMenu() {
    if (!navCollapse || !window.bootstrap) {
      return;
    }
    const collapseInstance = bootstrap.Collapse.getInstance(navCollapse);
    if (collapseInstance) {
      collapseInstance.hide();
    }
  }

  function scrollToSection(selector) {
    const target = document.querySelector(selector);
    if (!target) {
      return;
    }
    const position = target.offsetTop - getNavbarHeight();
    window.scrollTo({ top: position, behavior: 'smooth' });
  }

  document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (event) {
      const href = anchor.getAttribute('href');
      if (!href || href === '#') {
        return;
      }

      const target = document.querySelector(href);
      if (!target) {
        return;
      }

      event.preventDefault();
      scrollToSection(href);

      if (navCollapse && navCollapse.classList.contains('show')) {
        closeBootstrapMenu();
      }
    });
  });

  function closeMobileMenuOnClickOutside(event) {
    if (!navCollapse || !navCollapse.classList.contains('show')) {
      return;
    }
    if (navCollapse.contains(event.target)) {
      return;
    }
    const toggler = document.querySelector('.navbar-toggler');
    if (toggler && toggler.contains(event.target)) {
      return;
    }
    closeBootstrapMenu();
  }

  if (pageContent && navCollapse) {
    pageContent.addEventListener('click', closeMobileMenuOnClickOutside);
    pageContent.addEventListener('touchstart', closeMobileMenuOnClickOutside);
  }

  function updatePageOnScroll() {
    const scrollY = window.pageYOffset;

    if (navbar) {
      if (scrollY > 40) {
        navbar.classList.add('scrolled');
      } else {
        navbar.classList.remove('scrolled');
      }
    }

    if (backToTopBtn) {
      if (scrollY > 400) {
        backToTopBtn.classList.add('visible');
      } else {
        backToTopBtn.classList.remove('visible');
      }
    }

    let currentSectionId = '';
    sections.forEach(function (section) {
      const sectionTop = section.offsetTop - getNavbarHeight() - 20;
      if (scrollY >= sectionTop) {
        currentSectionId = section.getAttribute('id');
      }
    });

    navLinks.forEach(function (link) {
      const href = link.getAttribute('href');
      if (href === '#' + currentSectionId) {
        link.classList.add('active');
      } else {
        link.classList.remove('active');
      }
    });
  }

  //ici on exécute la fonction, si l'utilisateur fait défiler la page 
  window.addEventListener('scroll', updatePageOnScroll, { passive: true });
  updatePageOnScroll();

  if (backToTopBtn) {
    backToTopBtn.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }
  // Fin  de la page d'accueille
  
  
});