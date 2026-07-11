# ☀️ SolaireÉnergie - Site Web

Site web moderne pour l'entreprise **SolaireÉnergie** - Installation et vente de panneaux solaires.

## ✨ Corrections Apportées (v2.0 - Bootstrap 5)

Refactorisation complète du projet avec intégration de **Bootstrap 5.3** pour une meilleure structure, responsivité et maintenabilité.

### 📋 Fichiers Corrigés

#### 1. **index.html** ✅ - Recréé complètement
- ✓ **Bootstrap 5.3** CDN intégré (CSS + JS Bundle)
- ✓ Bootstrap Icons pour iconographie
- ✓ Structure HTML5 valide (balises correctement fermées)
- ✓ Navbar sticky responsive avec collapse mobile
- ✓ Section héro avec animation gradient
- ✓ Cartes d'avantages Bootstrap
- ✓ Catalogue de produits en grille responsive (3 catégories : Panneaux, Onduleurs, Batteries)
- ✓ Formulaire de contact Bootstrap avec validation native
- ✓ Footer complet
- ✓ Bouton "Retour en haut" (floating button)

#### 2. **styles.css** ✅ - Complètement réécrit
- ✓ Variables CSS pour thème solaire (orange, ambre, gris)
- ✓ Styles Bootstrap customisés (navbar, boutons, cartes)
- ✓ Animations fluides (gradient, hover effects, transitions)
- ✓ Responsive design avec media queries
- ✓ Support mobile-first (< 576px, < 768px, < 992px)
- ✓ Accessibilité (focus states, outline, prefers-reduced-motion)
- ✓ Classes utilitaires Bootstrap étendues
- ✓ Plus de 500 lignes de CSS optimisé

#### 3. **script.js** ✅ - Complètement fonctionnel
- ✓ Gestion du scroll (navbar shadow, bouton top)
- ✓ Menu mobile Bootstrap auto-fermeture
- ✓ Navigation active en temps réel
- ✓ Scroll fluide vers sections (#anchor links)
- ✓ Formulaire contact : validation + envoi async JSON
- ✓ Messages de feedback utilisateur
- ✓ Animations Intersection Observer au scroll
- ✓ Support Bootstrap Collapse, Tooltip

#### 4. **contact.php** ✓
- Base de données avec validation complète
- Protection contre spam (rate limiting 5/h par IP)
- Sanitization avec htmlspecialchars
- PDO prepared statements (anti SQL injection)
- Emails auto (admin + client)

#### 5. **config.php** ✓
- Configuration BD (localhost, solaire_energie)
- Constantes email et environnement

## 🚀 Installation & Démarrage

### Prérequis
- **PHP** 7.4+
- **MySQL** 5.7+
- **XAMPP** (ou Apache + MySQL)
- Navigateur moderne (Chrome, Firefox, Safari, Edge)

### Étapes

1. **Démarrer les services**
   - Ouvrir XAMPP Control Panel
   - Démarrer Apache et MySQL

2. **Importer la base de données**
   - Ouvrir phpMyAdmin : `http://localhost/phpmyadmin`
   - Créer base `solaire_energie`
   - Importer `schema.sql`

3. **Tester le site**
   ```
   http://localhost/Produits-Solaires/
   ```

### Configuration (optionnel)

Modifier [PHP/config.php](PHP/config.php) :
```php
define('DB_HOST', 'localhost');        // Serveur BD
define('DB_NAME', 'solaire_energie');  // Nom BD
define('DB_USER', 'root');             // User MySQL
define('DB_PASS', '');                 // Password
define('NOTIF_EMAIL', 'contact@...');  // Email admin
```

## 📁 Structure du Projet

```
Produits-Solaires/
├── index.html              ← Page d'accueil (Bootstrap 5)
├── styles.css              ← Feuille de styles (500+ lignes)
├── script.js               ← JavaScript (300+ lignes)
├── schema.sql              ← Structure BD
├── README.md               ← Documentation (ce fichier)
│
└── PHP/
    ├── config.php          ← Configuration BD + email
    └── contact.php         ← Traitement formulaire
```

## 🎨 Bootstrap 5 - Composants Utilisés

### Composants Principaux
- **Navbar** : Navigation sticky avec collapse mobile
- **Grid System** : Grille responsive 12 colonnes
- **Cards** : Cartes pour produits et avantages
- **Forms** : Formulaire avec validation native
- **Badges** : Labels et statuts
- **Buttons** : Boutons stylisés
- **Utilities** : Spacing, text, color, display, flexbox

### Breakpoints Bootstrap
```css
xs  : < 576px   (Mobile)
sm  : ≥ 576px   (Petites tablettes)
md  : ≥ 768px   (Tablettes)
lg  : ≥ 992px   (Desktop)
xl  : ≥ 1200px  (Grand desktop)
xxl : ≥ 1400px  (Ultra large)
```

### Classes Bootstrap Utilisées
```html
<!-- Navbar -->
.navbar, .navbar-brand, .navbar-nav, .nav-link, .navbar-toggler

<!-- Grid -->
.container, .row, .col-lg-4, .col-md-6, .col-sm-6

<!-- Cards -->
.card, .card-body, .card-title

<!-- Forms -->
.form-control, .form-select, .form-label, .form-check

<!-- Buttons -->
.btn, .btn-warning, .btn-outline-light, .btn-lg

<!-- Utilities -->
.d-flex, .justify-content-between, .align-items-center
.mb-3, .py-5, .px-4, .gap-3
.bg-light, .text-warning, .text-muted, .fw-bold
.shadow-sm, .border-0
```

### Classes Customisées
```css
.logo-icon          /* Icône soleil animée */
.btn-solar          /* Bouton principal dégradé orange */
.hero-section       /* Section héro full-screen */
.hero-overlay       /* Overlay animé gradient */
.avantage-card      /* Cartes avantages 4x4 */
.product-card       /* Cartes produits avec hover */
.btn-floating       /* Bouton retour top fixe */
```

## 🔧 Fonctionnalités Détaillées

### 1️⃣ Navigation (Navbar Bootstrap)
- Sticky en haut
- Logo + texte "SolaireÉnergie"
- Menu responsive (collapse < 768px)
- Bouton "Devis gratuit" prominent
- Ligne de soulignement au hover
- Shadow au scroll

### 2️⃣ Sections du Site
```
├─ Accueil (#accueil)
│  └─ Hero avec titre + 2 CTA buttons
├─ Avantages 
│  └─ 4 cartes : Garantie, Installation, Économies, Énergie propre
├─ Produits (#produits)
│  ├─ Panneaux Solaires (3 modèles)
│  ├─ Onduleurs (3 modèles)
│  └─ Batteries (3 modèles)
├─ À Propos (#a-propos)
│  ├─ Qui sommes-nous
│  └─ Notre mission
├─ Contact (#contact)
│  └─ Formulaire complet
└─ Footer
   ├─ Infos entreprise
   ├─ Liens rapides
   └─ Coordonnées
```

### 3️⃣ Formulaire de Contact

**Champs obligatoires** (*)
- Prénom
- Nom
- Email
- Type de client (particulier, professionnel, agriculteur, collectivité)
- Service (installation, batterie, maintenance, audit, autre)
- Checkbox RGPD

**Champs optionnels**
- Téléphone
- Surface (m²)
- Message

**Traitement**
1. Validation HTML5 + Bootstrap
2. Sanitization (htmlspecialchars)
3. Stockage BD (table demandes_contact)
4. Email admin + client
5. Réponse JSON au navigateur

### 4️⃣ Responsive Design

| Device | Affichage | Colonnes Produits |
|--------|-----------|------------------|
| Mobile (< 576px) | Stack vertical | 1 colonne |
| Tablet (576-768px) | Layout adapté | 2 colonnes |
| Desktop (> 992px) | Grille complète | 3 colonnes |

## 🔐 Sécurité Implémentée

✅ **Validation**
- HTML5 required, email, number
- Validation PHP côté serveur

✅ **Sanitization**
- htmlspecialchars() pour XSS
- FILTER_VALIDATE_EMAIL
- Trim() pour espaces

✅ **Injection SQL**
- PDO prepared statements
- Paramètres liés (:prenom, :nom, etc.)

✅ **Rate Limiting**
- 5 tentatives par heure par IP
- Stockage temporaire en fichier

✅ **Headers HTTP**
- Content-Type: application/json
- X-Content-Type-Options: nosniff

## 📊 Base de Données

### Table demandes_contact
```sql
id (INT)
prenom, nom (VARCHAR)
email (VARCHAR)
telephone (VARCHAR)
type_client (ENUM)
surface_m2 (INT)
service (ENUM)
message (TEXT)
ip_address, user_agent
statut (ENUM: nouveau/en_cours/traite)
created_at, updated_at (TIMESTAMP)
```

### Autres tables
- categories_produits
- devis
- produits (optionnel)

## 🎯 Points Forts de cette Version

✅ **Bootstrap 5 Moderne**
- CDN officiel v5.3.0
- Dernier standard CSS/responsive
- Support complet mobile

✅ **Performance**
- CSS minimaliste (que ce qui est nécessaire)
- JavaScript optimisé (defer loading)
- Images légères (icons SVG)

✅ **Accessibilité**
- Structure HTML5 sémantique
- ARIA labels sur formulaire
- Focus states visibles
- Respect prefers-reduced-motion

✅ **Maintenabilité**
- Code propre et commenté
- Variables CSS pour thème
- Séparation concerns (HTML/CSS/JS)
- Responsive mobile-first

## 🚀 Améliorations Futures

- [ ] Admin dashboard pour gérer devis
- [ ] Blog/actualités
- [ ] Galerie avant/après
- [ ] Calculateur devis online
- [ ] Chat en direct
- [ ] Intégration Stripe paiement
- [ ] Analytics (Google Analytics)
- [ ] SEO avancé (sitemap, robots.txt)

## 📞 Support & Contact

- **Email** : contact@solaire-energie.fr
- **Téléphone** : +229 XX XX XX XX
- **Adresse** : Cotonou, Bénin

## 📄 Informations Projet

- **Classe** : IDA - Groupe 70
- **Semestre** : 6
- **Version** : 2.0 (Bootstrap 5)
- **Date MAJ** : Juillet 2024
- **Responsable** : Équipe développement

---

**© 2024 SolaireÉnergie** - Tous droits réservés

---

## 🗄️ Base de données

Le fichier schema.sql contient la structure de la table utilisée pour enregistrer les messages de contact.

---

## 🔧 Fichiers principaux

- index.html : page principale du site
- contact.html : formulaire de contact
- PHP/contact.php : traitement du formulaire côté serveur
- PHP/config.php : configuration de la connexion à la base de données

---

## ✅ Objectif du projet

Créer un site simple, fonctionnel et pédagogique pour montrer comment un formulaire web peut envoyer des données vers un serveur PHP puis les stocker en base MySQL.

