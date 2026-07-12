
// Script JavaScript pour la page d'accueil
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

  // ================================================================
  // Fonction pour obtenir la hauteur de la navbar
  // ================================================================
  function getNavbarHeight() {
    if (!navbar) {
      return 0;
    }
    return navbar.offsetHeight;
  }

  // ================================================================
  // Fonction pour fermer le menu mobile Bootstrap
  // ================================================================
  function closeBootstrapMenu() {
    if (!navCollapse || !window.bootstrap) {
      return;
    }
    const collapseInstance = bootstrap.Collapse.getInstance(navCollapse);
    if (collapseInstance) {
      collapseInstance.hide();
    }
  }

  // ================================================================
  // Fonction pour scroller vers une section
  // ================================================================
  function scrollToSection(selector) {
    const target = document.querySelector(selector);
    if (!target) {
      return;
    }
    const position = target.offsetTop - getNavbarHeight();
    window.scrollTo({ top: position, behavior: 'smooth' });
  }

  // ================================================================
  // Gestion des clics sur les liens d'ancres
  // ================================================================
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

      // Fermer le menu mobile si ouvert
      if (navCollapse && navCollapse.classList.contains('show')) {
        closeBootstrapMenu();
      }
    });
  });

  // ================================================================
  // Fermeture du menu mobile au clic en dehors
  // ================================================================
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

  // ================================================================
  // Gestion du scroll : navbar shadow + bouton retour en haut
  // ================================================================
  function updatePageOnScroll() {
    const scrollY = window.pageYOffset;

    // Ajouter une ombre à la navbar au scroll
    if (navbar) {
      if (scrollY > 40) {
        navbar.classList.add('scrolled');
      } else {
        navbar.classList.remove('scrolled');
      }
    }

    // Afficher/masquer le bouton retour en haut
    if (backToTopBtn) {
      if (scrollY > 400) {
        backToTopBtn.classList.add('visible');
      } else {
        backToTopBtn.classList.remove('visible');
      }
    }

    // Mettre en surbrillance le lien de navigation actif
    sections.forEach(function (section) {
      const sectionTop = section.offsetTop - getNavbarHeight() - 100;
      const sectionHeight = section.offsetHeight;

      if (scrollY >= sectionTop && scrollY < sectionTop + sectionHeight) {
        navLinks.forEach(function (link) {
          link.classList.remove('active');
        });

        const activeLink = document.querySelector(
          '.navbar-nav a[href="#' + section.id + '"]'
        );
        if (activeLink) {
          activeLink.classList.add('active');
        }
      }
    });
  }

  // Écouter les événements de scroll
  window.addEventListener('scroll', updatePageOnScroll);

  // Appeler la fonction au chargement
  updatePageOnScroll();

  // ================================================================
  // Bouton retour en haut
  // ================================================================
  if (backToTopBtn) {
    backToTopBtn.addEventListener('click', function (event) {
      event.preventDefault();
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  }

  // ================================================================
  // Gestion du formulaire de contact
  // ================================================================
  const contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', function (event) {
      event.preventDefault();

      // Validation Bootstrap
      if (!contactForm.checkValidity()) {
        event.stopPropagation();
        contactForm.classList.add('was-validated');
        return;
      }

      // Préparer les données
      const formData = new FormData(contactForm);

      // Afficher un message de chargement
      const submitBtn = contactForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.textContent;
      submitBtn.textContent = 'Envoi en cours...';
      submitBtn.disabled = true;

      // Envoyer les données
      fetch('PHP/contact.php', {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // Succès
          alert('Merci ! Votre demande a été envoyée avec succès. Nous vous répondrons sous 24h.');
          contactForm.reset();
          contactForm.classList.remove('was-validated');
          window.scrollTo({ top: 0, behavior: 'smooth' });
        } else {
          // Erreur
          alert('Erreur : ' + (data.error || 'Une erreur est survenue'));
        }
      })
      .catch(error => {
        console.error('Erreur:', error);
        alert('Erreur de connexion. Veuillez réessayer.');
      })
      .finally(() => {
        submitBtn.textContent = originalText;
        submitBtn.disabled = false;
      });
    });
  }

  // ================================================================
  // Gestion des boutons "Demander un devis"
  // ================================================================
  const devisButtons = document.querySelectorAll('.btn-warning');
  devisButtons.forEach(function (button) {
    button.addEventListener('click', function (event) {
      if (button.textContent.toLowerCase().includes('demander') || 
          button.textContent.toLowerCase().includes('devis')) {
        event.preventDefault();
        const contactSection = document.querySelector('#contact');
        if (contactSection) {
          scrollToSection('#contact');
          const nameInput = document.querySelector('#prenom');
          if (nameInput) {
            setTimeout(function () {
              nameInput.focus();
            }, 500);
          }
        }
      }
    });
  });

  // ================================================================
  // Initialisation des tooltips Bootstrap (optionnel)
  // ================================================================
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

});

// ================================================================
// Fonction pour ajouter l'animation aux éléments au scroll
// ================================================================
function observeElements() {
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
  };

  const observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add('fade-in-up');
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);

  document.querySelectorAll('.product-card, .avantage-card').forEach(function (el) {
    observer.observe(el);
  });
}

// Appeler la fonction au chargement
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', observeElements);
} else {
  observeElements();
}

// Code JS de Services
// ---------- DONNÉES DES SERVICES ----------
const servicesData = {
    vente: {
        id: 'vente',
        titre: 'Vente de panneaux solaires',
        icone: 'bi-cart3',
        couleur: '#1d4ed8',
        description: 'Panneaux solaires haute performance pour particuliers et professionnels, sélectionnés pour leur rendement et durabilité.',
        caracteristiques: [
            'Garantie produit 25 ans',
            'Livraison et logistique assurées',
            'Conseil dimensionnement',
            'Options de financement'
        ],
        action: 'Voir les produits'
    },
    installation: {
        id: 'installation',
        titre: 'Installation solaire clé en main',
        icone: 'bi-wrench',
        couleur: '#16a34a',
        description: 'Installation complète par nos équipes certifiées : étude technique, montage, mise en service et formation.',
        caracteristiques: [
            'Étude personnalisée',
            'Techniciens certifiés',
            'Respect des normes',
            'Mise en service et tests'
        ],
        action: 'Planifier une installation'
    },
    maintenance: {
        id: 'maintenance',
        titre: 'Maintenance et SAV',
        icone: 'bi-headset',
        couleur: '#d97706',
        description: "Contrats de maintenance, dépannage et suivi pour assurer la longévité de vos installations solaires.",
        caracteristiques: [
            'Diagnostic et dépannage rapide',
            'Contrats préventifs',
            'Pièces d’origine',
            'Assistance technique dédiée'
        ],
        action: 'Contacter le SAV'
    }
};

// ---------- COMPOSANT PRINCIPAL ----------
class ServiceManager {
    constructor() {
        this.currentService = 'vente';
        this.init();
    }

    /**
     * Initialisation du module
     */
    init() {
        this.renderTabs();
        this.renderContent();
        this.setupEventListeners();
        this.setupFormValidation();
        this.setupFloatingAction();
    }

    /**
     * Création des onglets de navigation
     */
    renderTabs() {
        const tabsContainer = document.getElementById('services-tabs');
        if (!tabsContainer) return;

        tabsContainer.innerHTML = '';
        const services = Object.keys(servicesData);

        services.forEach((key, index) => {
            const service = servicesData[key];
            const tab = document.createElement('button');
            tab.className = `tab-btn ${index === 0 ? 'active' : ''}`;
            tab.dataset.service = key;
            tab.innerHTML = `
                <i class="bi ${service.icone}"></i>
                <span>${this.capitalize(key)}</span>
            `;
            tab.style.setProperty('--tab-color', service.couleur);
            tabsContainer.appendChild(tab);
        });
    }

    /**
     * Affichage du contenu du service sélectionné
     */
    renderContent() {
        const contentContainer = document.getElementById('service-content');
        if (!contentContainer) return;

        const service = servicesData[this.currentService];
        const isActive = (id) => this.currentService === id ? 'active' : '';

        contentContainer.innerHTML = `
            <div class="service-panel active" data-service="${service.id}">
                <div class="service-header">
                    <div class="service-icon" style="background: ${service.couleur}20; color: ${service.couleur}">
                        <i class="bi ${service.icone}"></i>
                    </div>
                    <div class="service-title">
                        <h2>${service.titre}</h2>
                        <p>${service.description}</p>
                    </div>
                </div>
                <div class="service-features">
                        ${service.caracteristiques.map(feat => `
                        <div class="feature-item">
                            <i class="bi bi-check-circle" style="color: ${service.couleur}"></i>
                            <span>${feat}</span>
                        </div>
                    `).join('')}
                </div>
                <div class="service-action">
                    <button class="btn-primary" style="background: ${service.couleur}" onclick="serviceManager.openAction('${service.id}')">
                        <i class="bi ${service.icone}"></i> ${service.action}
                    </button>
                </div>
            </div>
        `;

        // Ajouter une animation d'entrée
        const panel = contentContainer.querySelector('.service-panel');
        if (panel) {
            panel.style.animation = 'fadeInUp 0.5s ease forwards';
        }
    }

    /**
     * Gestion des événements (clic sur les onglets)
     */
    setupEventListeners() {
        const tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                // Supprimer la classe active de tous les onglets
                document.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                // Mettre à jour le service courant
                this.currentService = tab.dataset.service;
                this.renderContent();
                this.updateURL(tab.dataset.service);
            });
        });
    }

    /**
     * Validation du formulaire de demande
     */
    setupFormValidation() {
        const form = document.getElementById('service-form');
        if (!form) return;

        // Gestion du champ téléphone (formatage automatique)
        const phoneInput = document.getElementById('phone');
        if (phoneInput) {
            phoneInput.addEventListener('input', (e) => {
                e.target.value = e.target.value.replace(/[^0-9+]/g, '');
            });
        }

        form.addEventListener('submit', (e) => {
            e.preventDefault();

            if (this.validateForm(form)) {
                this.submitForm(form);
            }
        });
    }

    /**
     * Validation des champs du formulaire
     */
    validateForm(form) {
        let isValid = true;
        const fields = form.querySelectorAll('[data-required]');
        const errorMessages = [];

        fields.forEach(field => {
            const errorEl = document.getElementById(`${field.id}-error`);

            if (field.type === 'checkbox') {
                if (!field.checked) {
                    isValid = false;
                    field.classList.add('error');
                    if (errorEl) {
                        errorEl.textContent = 'Vous devez accepter ce champ';
                        errorEl.style.display = 'block';
                    }
                    errorMessages.push(`Le champ ${field.name} est obligatoire`);
                } else {
                    field.classList.remove('error');
                    if (errorEl) {
                        errorEl.style.display = 'none';
                    }
                }
                return;
            }

            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('error');
                if (errorEl) {
                    errorEl.textContent = 'Ce champ est obligatoire';
                    errorEl.style.display = 'block';
                }
                errorMessages.push(`Le champ ${field.placeholder || field.name} est obligatoire`);
            } else {
                field.classList.remove('error');
                if (errorEl) {
                    errorEl.style.display = 'none';
                }
            }

            // Validation email
            if (field.type === 'email' && field.value.trim()) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(field.value.trim())) {
                    isValid = false;
                    field.classList.add('error');
                    if (errorEl) {
                        errorEl.textContent = 'Email invalide';
                        errorEl.style.display = 'block';
                    }
                }
            }
        });

        if (!isValid) {
            this.showNotification('Veuillez remplir tous les champs correctement', 'error');
        }

        return isValid;
    }

    /**
     * Simulation d'envoi du formulaire
     */
    submitForm(form) {
        const formData = new FormData(form);
        const selectedService = formData.get('service');

        if (!selectedService || selectedService === '') {
            formData.set('service', this.currentService);
        }

        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.disabled = true;
        submitBtn.textContent = 'Envoi en cours...';

        fetch('PHP/contact.php', {
            method: 'POST',
            body: formData,
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                this.showNotification(
                    `✅ Votre demande pour "${servicesData[this.currentService].titre}" a été envoyée avec succès !`,
                    'success'
                );
                form.reset();
            } else {
                this.showNotification(result.error || 'Une erreur est survenue lors de l’envoi.', 'error');
            }
        })
        .catch(error => {
            console.error('Erreur:', error);
            this.showNotification('Erreur de connexion. Veuillez réessayer.', 'error');
        })
        .finally(() => {
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
        });
    }

    /**
     * Bouton d'action flottant pour chaque service
     */
    setupFloatingAction() {
        const floatBtn = document.querySelector('.float-action');
        if (floatBtn) {
            floatBtn.addEventListener('click', () => {
                const formSection = document.getElementById('form-section');
                if (formSection) {
                    formSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    // Mettre en évidence le formulaire
                    formSection.style.transition = 'box-shadow 0.3s';
                    formSection.style.boxShadow = '0 0 0 3px #2563eb';
                    setTimeout(() => {
                        formSection.style.boxShadow = 'none';
                    }, 2000);
                }
            });
        }
    }

    /**
     * Action principale des services (redirection ou ouverture de modal)
     */
    openAction(serviceId) {
        const service = servicesData[serviceId];
        console.log(`🔔 Action: ${service.action} pour ${service.titre}`);

        this.showNotification(
            `🚀 Redirection vers : ${service.action}`,
            'info'
        );

        // Simulation de redirection
        setTimeout(() => {
            // Ici vous pouvez faire une redirection réelle :
            // window.location.href = `${serviceId}.php`;

            // Ou afficher une modale
            this.showModal(service);
        }, 1000);
    }

    /**
     * Affichage d'une notification toast
     */
    showNotification(message, type = 'info') {
        const container = document.getElementById('notification-container');
        if (!container) {
            // Créer le conteneur s'il n'existe pas
            this.createNotificationContainer();
            return this.showNotification(message, type);
        }

        const colors = {
            success: '#10b981',
            error: '#ef4444',
            info: '#3b82f6',
            warning: '#f59e0b'
        };

        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.style.cssText = `
            background: ${colors[type] || '#3b82f6'};
            color: white;
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            animation: slideInRight 0.4s ease forwards;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-width: 300px;
            max-width: 500px;
        `;
        notification.innerHTML = `
            <span>${message}</span>
            <button onclick="this.parentElement.remove()" style="background: none; border: none; color: white; font-size: 1.2rem; cursor: pointer; margin-left: 16px;">
                <i class="bi bi-x-lg"></i>
            </button>
        `;

        container.appendChild(notification);

        // Supprimer automatiquement après 5 secondes
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.4s ease forwards';
            setTimeout(() => notification.remove(), 400);
        }, 5000);
    }

    /**
     * Création du conteneur de notifications
     */
    createNotificationContainer() {
        const container = document.createElement('div');
        container.id = 'notification-container';
        container.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        `;
        document.body.appendChild(container);
    }

    /**
     * Affichage d'une modale
     */
    showModal(service) {
        // Vérifier si une modale existe déjà
        let modal = document.getElementById('service-modal');
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'service-modal';
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                backdrop-filter: blur(8px);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 10000;
                animation: fadeIn 0.3s ease;
            `;
            document.body.appendChild(modal);
        }

        modal.innerHTML = `
            <div style="
                background: white;
                border-radius: 24px;
                padding: 40px;
                max-width: 500px;
                width: 90%;
                position: relative;
                animation: scaleIn 0.3s ease;
            ">
                <button onclick="this.closest('#service-modal').style.display='none'" style="
                    position: absolute;
                    top: 16px;
                    right: 16px;
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    cursor: pointer;
                    color: #64748b;
                ">
                    <i class="bi bi-x-lg"></i>
                </button>
                
                <div style="
                    width: 70px;
                    height: 70px;
                    background: ${service.couleur}20;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 2rem;
                    color: ${service.couleur};
                    margin: 0 auto 20px;
                ">
                    <i class="bi ${service.icone}"></i>
                </div>
                
                <h2 style="text-align: center; margin-bottom: 12px; color: #0f172a;">${service.titre}</h2>
                <p style="text-align: center; color: #64748b; margin-bottom: 24px;">
                    ${service.description}
                </p>
                
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    ${service.caracteristiques.map(feat => `
                        <div style="display: flex; align-items: center; gap: 10px; padding: 8px; background: #f8fafc; border-radius: 8px;">
                            <i class="bi bi-check-circle" style="color: ${service.couleur}"></i>
                            <span style="color: #1e293b;">${feat}</span>
                        </div>
                    `).join('')}
                </div>
                
                <button onclick="serviceManager.openAction('${service.id}')" style="
                    width: 100%;
                    padding: 14px;
                    margin-top: 24px;
                    background: ${service.couleur};
                    color: white;
                    border: none;
                    border-radius: 12px;
                    font-size: 1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s;
                ">
                    <i class="bi ${service.icone}"></i> ${service.action}
                </button>
            </div>
        `;

        modal.style.display = 'flex';
    }

    /**
     * Mise à jour de l'URL (pour le partage)
     */
    updateURL(service) {
        if (window.history && window.history.pushState) {
            const url = new URL(window.location);
            url.searchParams.set('service', service);
            window.history.pushState({}, '', url);
        }
    }

    /**
     * Capitalisation d'une chaîne
     */
    capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }
}

// ---------- INITIALISATION ----------
let serviceManager;

document.addEventListener('DOMContentLoaded', () => {
    serviceManager = new ServiceManager();
    // exposer globalement après création pour les appels inline
    window.serviceManager = serviceManager;

    // Récupérer le service depuis l'URL
    const urlParams = new URLSearchParams(window.location.search);
    const serviceParam = urlParams.get('service');
    if (serviceParam && servicesData[serviceParam]) {
        serviceManager.currentService = serviceParam;
        // Mettre à jour les onglets
        document.querySelectorAll('.tab-btn').forEach(tab => {
            tab.classList.toggle('active', tab.dataset.service === serviceParam);
        });
        serviceManager.renderContent();
    }
});

// ---------- ANIMATIONS CSS (injectées dynamiquement) ----------
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    @keyframes slideInRight {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100px);
        }
    }
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    @keyframes scaleIn {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    .tab-btn {
        position: relative;
        padding: 12px 24px;
        border: none;
        background: transparent;
        font-size: 1rem;
        font-weight: 500;
        color: #64748b;
        cursor: pointer;
        transition: all 0.3s ease;
        border-radius: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .tab-btn:hover {
        background: #f1f5f9;
        color: #0f172a;
    }
    .tab-btn.active {
        background: var(--tab-color, #2563eb);
        color: white;
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }
    .tab-btn.active i {
        color: white !important;
    }
    .tab-btn i {
        font-size: 1.1rem;
        color: #64748b;
    }
    .service-panel {
        display: none;
        animation: fadeInUp 0.5s ease;
    }
    .service-panel.active {
        display: block;
    }
    .service-header {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }
    .service-icon {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        flex-shrink: 0;
    }
    .service-title h2 {
        font-size: 1.8rem;
        color: #0f172a;
        margin-bottom: 6px;
    }
    .service-title p {
        color: #64748b;
        font-size: 1.05rem;
    }
    .service-features {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 12px;
        margin: 24px 0;
    }
    .feature-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 16px;
        background: #f8fafc;
        border-radius: 10px;
        transition: transform 0.2s;
    }
    .feature-item:hover {
        transform: translateX(5px);
    }
    .feature-item i {
        font-size: 1.1rem;
    }
    .service-action {
        margin-top: 30px;
        text-align: center;
    }
    .btn-primary {
        padding: 14px 36px;
        border: none;
        border-radius: 12px;
        color: white;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.2s, box-shadow 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(0,0,0,0.15);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 6px;
        color: #0f172a;
    }
    .form-group input,
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 1rem;
        transition: border-color 0.3s;
        background: white;
    }
    .form-group input:focus,
    .form-group textarea:focus,
    .form-group select:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }
    .form-group input.error,
    .form-group textarea.error {
        border-color: #ef4444;
    }
    .error-message {
        color: #ef4444;
        font-size: 0.85rem;
        margin-top: 4px;
        display: none;
    }
    .float-action {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: #2563eb;
        color: white;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        box-shadow: 0 8px 24px rgba(37, 99, 235, 0.4);
        transition: transform 0.3s, box-shadow 0.3s;
        z-index: 1000;
    }
    .float-action:hover {
        transform: scale(1.1) rotate(90deg);
        box-shadow: 0 12px 32px rgba(37, 99, 235, 0.5);
    }
    @media (max-width: 768px) {
        .service-header {
            flex-direction: column;
            text-align: center;
        }
        .service-title h2 {
            font-size: 1.4rem;
        }
        .tab-btn {
            padding: 10px 16px;
            font-size: 0.9rem;
        }
        .tab-btn span {
            display: none;
        }
        .float-action {
            bottom: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            font-size: 1.2rem;
        }
    }
`;

document.head.appendChild(style);
// =============================================================
//   ===================================================================================================================
//   JS page de contact
