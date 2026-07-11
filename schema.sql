-- ================================================================
-- SOLAIRE ÉNERGIE — Schéma de base de données MySQL
-- ================================================================


-- ================================================================
-- CRÉATION DE LA BASE DE DONNÉES
--
-- CREATE DATABASE → crée la base de données
-- IF NOT EXISTS   → ne génère pas d'erreur si elle existe déjà
-- CHARACTER SET utf8mb4  → encodage Unicode étendu (supporte emojis, etc.)
-- COLLATE utf8mb4_unicode_ci → règles de tri/comparaison (ci = case-insensitive)
-- ================================================================
CREATE DATABASE IF NOT EXISTS solaire_energie
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- USE → sélectionner la base à utiliser pour les commandes suivantes
USE solaire_energie;


-- ================================================================
-- TABLE 1 : categories_produits
--
-- Stocke les familles de produits (panneaux, batteries, onduleurs, kits).
-- Utilisée en lien avec la table "produits" (relation parent-enfant).
-- ================================================================
CREATE TABLE IF NOT EXISTS categories_produits (

  -- Clé primaire : identifiant unique auto-incrémenté
  -- INT UNSIGNED   → entier positif (pas de négatif)
  -- AUTO_INCREMENT → la valeur augmente automatiquement à chaque INSERT
  -- PRIMARY KEY    → identifiant unique de chaque ligne (obligatoire)
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Identifiant textuel court pour les URLs et le code
  -- VARCHAR(60)  → chaîne de caractères variable, max 60 caractères
  -- NOT NULL     → ce champ ne peut pas être vide
  -- UNIQUE       → deux lignes ne peuvent pas avoir le même slug
  slug        VARCHAR(60)  NOT NULL UNIQUE,

  -- Nom complet affiché à l'utilisateur
  nom         VARCHAR(120) NOT NULL,

  -- Description longue (optionnelle → pas de NOT NULL)
  -- TEXT → texte sans limite de taille (contrairement à VARCHAR)
  description TEXT,

  -- Date et heure de création (remplie automatiquement)
  -- TIMESTAMP DEFAULT CURRENT_TIMESTAMP → valeur automatique = maintenant
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP

-- ENGINE=InnoDB → moteur de stockage MySQL qui supporte les clés étrangères
-- DEFAULT CHARSET → encodage par défaut de cette table
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des 4 catégories de produits
-- INSERT INTO table (colonne1, colonne2) VALUES (valeur1, valeur2)
INSERT INTO categories_produits (slug, nom, description) VALUES
  ('panneaux',  'Panneaux solaires',    'Panneaux photovoltaïques mono/polycristallins et bifaciaux'),
  ('batteries', 'Batteries de stockage','Solutions de stockage d''énergie lithium-ion'),
  -- Note : '' (deux apostrophes) = caractère apostrophe dans une chaîne SQL
  ('onduleurs', 'Onduleurs',            'Onduleurs string, micro-onduleurs et hybrides'),
  ('kits',      'Kits complets',        'Kits clé-en-main résidentiels et commerciaux');


-- ================================================================
-- TABLE 2 : produits
--
-- Catalogue de tous les produits vendus.
-- Liée à categories_produits via categorie_id (clé étrangère).
-- ================================================================
CREATE TABLE IF NOT EXISTS produits (

  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Référence à la catégorie parente
  -- FOREIGN KEY → liaison avec une autre table (voir en bas de CREATE TABLE)
  categorie_id     INT UNSIGNED     NOT NULL,

  -- Code référence interne unique du produit (ex: "PAN-MONO-400")
  reference        VARCHAR(60)      NOT NULL UNIQUE,

  -- Nom complet du produit
  nom              VARCHAR(200)     NOT NULL,

  -- Description détaillée
  description      TEXT,

  -- Caractéristiques techniques stockées au format JSON
  -- JSON → format texte structuré pour données complexes
  -- Exemple : {"puissance":"400W","rendement":"21.5%","garantie":"25 ans"}
  -- MySQL 5.7+ supporte nativement le type JSON
  caracteristiques JSON,

  -- Prix hors taxes (peut être NULL si "sur devis")
  -- DECIMAL(10,2) → nombre décimal : 10 chiffres max, 2 après la virgule
  prix_ht          DECIMAL(10,2),

  -- Prix toutes taxes comprises
  prix_ttc         DECIMAL(10,2),

  -- Devise (EUR par défaut)
  -- CHAR(3) → chaîne de longueur FIXE de 3 caractères (codes ISO: EUR, USD...)
  devise           CHAR(3)          DEFAULT 'EUR',

  -- Badge affiché sur la carte (ex: "Bestseller", "Nouveau", "Promo")
  -- NULL si pas de badge
  badge            VARCHAR(40),

  -- URL de l'image du produit
  image_url        VARCHAR(500),

  -- Quantité en stock
  stock            INT              DEFAULT 0,

  -- 1 = produit actif (affiché sur le site), 0 = désactivé
  -- TINYINT(1) → équivalent à un booléen (0 ou 1)
  actif            TINYINT(1)       DEFAULT 1,

  -- Date de création
  created_at       TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,

  -- Date de dernière modification (mise à jour automatiquement)
  -- ON UPDATE CURRENT_TIMESTAMP → se met à jour à chaque modification
  updated_at       TIMESTAMP        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Définition de la clé étrangère (Foreign Key)
  -- FOREIGN KEY (colonne_locale) REFERENCES autre_table(colonne)
  -- ON DELETE RESTRICT → interdit de supprimer une catégorie si elle a des produits
  FOREIGN KEY (categorie_id) REFERENCES categories_produits(id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion de 8 produits
-- Chaque ligne respecte l'ordre des colonnes de l'INSERT
INSERT INTO produits
  (categorie_id, reference, nom, description, caracteristiques, prix_ht, prix_ttc, badge, image_url, stock)
VALUES

  -- Produit 1 : Panneau Monocristallin (catégorie id=1 = panneaux)
  (1, 'PAN-MONO-400', 'Monocristallin 400W',
   'Rendement jusqu à 21,5%. Idéal pour toitures résidentielles avec surface limitée.',
   '{"puissance":"400W","rendement":"21.5%","garantie":"25 ans","certification":"IEC 61215"}',
   241.67,  -- prix HT
   290.00,  -- prix TTC (TVA 20%)
   'Bestseller',
   'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400',
   150),    -- 150 unités en stock

  -- Produit 2 : Panneau Polycristallin
  (1, 'PAN-POLY-320', 'Polycristallin 320W',
   'Excellent rapport qualité-prix. Solution économique pour grandes surfaces.',
   '{"puissance":"320W","rendement":"17%","garantie":"20 ans"}',
   175.00, 210.00, 'Éco',
   'https://images.unsplash.com/photo-1558449028-b53a39d100fc?w=400',
   200),

  -- Produit 3 : Panneau Bifacial HJT (dernière technologie)
  (1, 'PAN-BIF-HJT-480', 'Bifacial HJT 480W',
   'Technologie hétérojonction double face. Rendement exceptionnel.',
   '{"puissance":"480W","rendement":"23%","garantie":"30 ans","technologie":"HJT bifacial"}',
   350.00, 420.00, 'Nouveau',
   'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=400',
   80),

  -- Produit 4 : Batterie Lithium (catégorie id=2 = batteries)
  (2, 'BAT-LI-10KWH', 'Batterie Lithium 10kWh',
   'Stockage énergie solaire pour usage nocturne ou nuageux.',
   '{"capacite":"10 kWh","cycles":"6000","montage":"mural","garantie":"10 ans"}',
   2666.67, 3200.00, 'Pro',
   'https://images.unsplash.com/photo-1609940823547-4ef0bc7e37d5?w=400',
   30),

  -- Produit 5 : Powerwall (système tout-en-un)
  (2, 'BAT-PW-13.5', 'Powerwall 13,5kWh',
   'Système tout-en-un avec onduleur intégré et app mobile.',
   '{"capacite":"13.5 kWh","onduleur_integre":true,"monitoring":"app mobile","garantie":"10 ans"}',
   7083.33, 8500.00, NULL,  -- NULL = pas de badge
   'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400',
   15),

  -- Produit 6 : Onduleur Hybride (catégorie id=3 = onduleurs)
  (3, 'OND-HYB-5KW', 'Onduleur Hybride 5kW',
   'Gère simultanément panneaux, batterie et réseau. Monitoring WiFi.',
   '{"puissance":"5 kW","rendement":"97.5%","monitoring":"WiFi","phases":"monophase"}',
   1500.00, 1800.00, NULL,
   'https://images.unsplash.com/photo-1548391350-968f58dedaed?w=400',
   50),

  -- Produit 7 : Kit Résidentiel (catégorie id=4 = kits)
  (4, 'KIT-RESI-3KWC', 'Kit Résidentiel 3kWc',
   'Kit clé-en-main maison. Inclut panneaux, onduleur, câblage, installation.',
   '{"panneaux":"8 x 375W","puissance_totale":"3 kWc","installation":true,"demarches_admin":true}',
   6583.33, 7900.00, 'Promo',
   'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=400',
   20),

  -- Produit 8 : Kit Commercial (prix sur devis = NULL)
  (4, 'KIT-COM-20KWC', 'Kit Commercial 20kWc',
   'Solution industrielle pour entreprises. ROI garanti en moins de 5 ans.',
   '{"panneaux":"50 x 400W","puissance_totale":"20 kWc","monitoring_temps_reel":true,"financement":true}',
   NULL, NULL,  -- prix sur devis (non fixé)
   'Entreprise',
   'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=400',
   0);


-- ================================================================
-- TABLE 3 : services
--
-- Liste des prestations proposées par l'entreprise.
-- ================================================================
CREATE TABLE IF NOT EXISTS services (

  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug        VARCHAR(60)  NOT NULL UNIQUE,  -- identifiant URL (ex: "installation")
  nom         VARCHAR(200) NOT NULL,
  description TEXT,

  -- Classe CSS de l'icône Bootstrap Icons (ex: "bi-search")
  icone       VARCHAR(60),

  -- Ordre d'affichage sur le site (1 = premier affiché)
  -- TINYINT → entier très petit (−128 à 127), suffisant pour un ordre
  ordre       TINYINT      DEFAULT 0,

  -- 1 = service actif (affiché), 0 = masqué
  actif       TINYINT(1)   DEFAULT 1,

  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO services (slug, nom, description, icone, ordre) VALUES
  ('etude-conseil',   'Étude et Conseil',
   'Analyse gratuite de toiture, consommation et potentiel solaire. Simulation ROI.',
   'bi-search', 1),

  ('installation',    'Installation Professionnelle',
   'Pose par techniciens certifiés RGE QualiPV. Mise en service avec tests.',
   'bi-house-gear', 2),

  ('demarches-admin', 'Démarches Administratives',
   'Déclaration travaux, raccordement Enedis, aides financières (MaPrimeRénov, CEE).',
   'bi-file-earmark-text', 3),

  ('monitoring',      'Monitoring et Supervision',
   'Espace client en ligne, suivi temps réel de la production et économies.',
   'bi-activity', 4),

  ('maintenance-sav', 'Maintenance et SAV',
   'Contrats annuels : nettoyage, vérification électrique, intervention rapide.',
   'bi-wrench-adjustable', 5),

  ('financement',     'Financement sur mesure',
   'Comptant, LOA ou crédit préférentiel. Partenaires bancaires certifiés.',
   'bi-bank2', 6);


-- ================================================================
-- TABLE 4 : demandes_contact
--
-- Stocke chaque soumission du formulaire de contact du site.
-- C'est la table la plus importante : elle relie le site et la BDD.
--
-- FLUX : Visiteur remplit le formulaire → PHP valide et insère ici
-- ================================================================
CREATE TABLE IF NOT EXISTS demandes_contact (

  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Informations du visiteur
  prenom       VARCHAR(100) NOT NULL,
  nom          VARCHAR(100) NOT NULL,

  -- VARCHAR(254) pour l'email : 254 = longueur max selon la norme RFC 5321
  email        VARCHAR(254) NOT NULL,

  -- Téléphone optionnel (pas de NOT NULL)
  telephone    VARCHAR(30),

  -- ENUM → liste de valeurs autorisées seulement (comme un menu déroulant)
  -- Si on essaie d'insérer une valeur non listée, MySQL génère une erreur
  type_client  ENUM('particulier','professionnel','agriculteur','collectivite') NOT NULL,

  -- Surface de toiture en m² (SMALLINT = entier pour des valeurs jusqu'à 32 767)
  -- UNSIGNED → seulement positif
  surface_m2   SMALLINT UNSIGNED,

  -- Service demandé par le visiteur
  service      ENUM('installation','batterie','maintenance','audit','autre') NOT NULL,

  -- Message libre du visiteur
  message      TEXT,

  -- Informations techniques (pour sécurité et débogage)
  -- VARCHAR(45) → assez pour IPv4 (15 chars) et IPv6 (39 chars)
  ip_address   VARCHAR(45),

  -- Navigateur et système d'exploitation du visiteur
  user_agent   VARCHAR(500),

  -- Statut de traitement de la demande par l'équipe commerciale
  statut       ENUM('nouveau','en_cours','traite','archive') DEFAULT 'nouveau',

  -- Notes internes (pour les commerciaux)
  notes_internes TEXT,

  -- Dates
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Qui a traité cette demande (lien vers utilisateurs, optionnel)
  -- NULL autorisé si pas encore traité
  traite_par   INT UNSIGNED,

  -- Quand la demande a été traitée
  -- DATETIME → date + heure (TIMESTAMP aussi, mais DATETIME sans fuseau horaire)
  traite_le    DATETIME

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- INDEX → accélèrent les recherches sur certaines colonnes
-- Sans index, MySQL doit lire toutes les lignes (lent avec beaucoup de données)
-- Avec index, MySQL utilise un "raccourci" pour trouver rapidement les données

-- Index sur le statut (pour filtrer "toutes les demandes non traitées")
CREATE INDEX idx_demandes_statut  ON demandes_contact (statut);

-- Index sur l'email (pour rechercher "tous les contacts de jean@mail.com")
CREATE INDEX idx_demandes_email   ON demandes_contact (email);

-- Index sur la date (pour trier par date, très fréquent)
CREATE INDEX idx_demandes_created ON demandes_contact (created_at);

-- Index sur le service (pour statistiques par type de service)
CREATE INDEX idx_demandes_service ON demandes_contact (service);


-- ================================================================
-- TABLE 5 : devis
--
-- Devis commerciaux générés par l'équipe à partir des demandes.
-- ================================================================
CREATE TABLE IF NOT EXISTS devis (

  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Numéro de devis lisible par les humains (ex: "DEV-2025-0001")
  -- UNIQUE → un seul devis par numéro
  numero          VARCHAR(20)  NOT NULL UNIQUE,

  -- Lien optionnel vers la demande de contact à l'origine du devis
  -- NULL si devis créé manuellement
  demande_id      INT UNSIGNED,

  -- Coordonnées client (dupliquées ici pour archive même si la demande change)
  prenom          VARCHAR(100) NOT NULL,
  nom             VARCHAR(100) NOT NULL,
  email           VARCHAR(254) NOT NULL,
  telephone       VARCHAR(30),
  adresse         VARCHAR(300),
  code_postal     CHAR(10),   -- CHAR = longueur fixe, les codes postaux ont toujours ~5 chars
  ville           VARCHAR(100),

  -- Montants financiers
  montant_ht      DECIMAL(12,2),  -- 12 chiffres dont 2 décimales (peut atteindre 9 999 999 999,99)
  montant_tva     DECIMAL(12,2),
  montant_ttc     DECIMAL(12,2),

  -- Taux de TVA appliqué (installations solaires = 10% réduit en France)
  taux_tva        DECIMAL(5,2) DEFAULT 10.00,

  -- Statut du devis dans le cycle commercial
  statut          ENUM('brouillon','envoye','accepte','refuse','expire') DEFAULT 'brouillon',

  -- Durée de validité du devis (30 jours par défaut)
  validite_jours  TINYINT      DEFAULT 30,

  notes           TEXT,
  created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Si la demande source est supprimée, mettre demande_id à NULL (pas d'erreur)
  FOREIGN KEY (demande_id) REFERENCES demandes_contact(id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ================================================================
-- TABLE 6 : devis_lignes
--
-- Chaque ligne de produit/prestation dans un devis.
-- Un devis peut avoir plusieurs lignes (relation 1 devis → N lignes).
-- ================================================================
CREATE TABLE IF NOT EXISTS devis_lignes (

  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Référence au devis parent (obligatoire)
  devis_id    INT UNSIGNED NOT NULL,

  -- Référence au produit du catalogue (optionnel : peut être une ligne libre)
  produit_id  INT UNSIGNED,

  -- Description de la ligne (peut être différent du nom produit)
  designation VARCHAR(300) NOT NULL,

  -- Quantité commandée (DECIMAL pour autoriser ex: 1.5 m²)
  quantite    DECIMAL(8,2) DEFAULT 1,

  -- Unité de mesure
  unite       VARCHAR(20)  DEFAULT 'unité',

  -- Prix unitaire hors taxe
  prix_ht     DECIMAL(10,2) NOT NULL,

  -- TVA pour cette ligne
  taux_tva    DECIMAL(5,2)  DEFAULT 10.00,

  -- Remise en pourcentage (0 = pas de remise)
  remise_pct  DECIMAL(5,2)  DEFAULT 0,

  -- Clé étrangère vers devis :
  -- ON DELETE CASCADE → si le devis est supprimé, ses lignes le sont aussi
  FOREIGN KEY (devis_id)   REFERENCES devis(id)    ON DELETE CASCADE,

  -- Clé étrangère vers produits :
  -- ON DELETE SET NULL → si le produit est supprimé, la ligne reste avec produit_id = NULL
  FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ================================================================
-- TABLE 7 : installations
--
-- Suivi des installations solaires réalisées chez les clients.
-- Créée après acceptation d'un devis.
-- ================================================================
CREATE TABLE IF NOT EXISTS installations (

  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Devis d'origine (optionnel)
  devis_id        INT UNSIGNED,

  -- Coordonnées client
  client_prenom   VARCHAR(100),
  client_nom      VARCHAR(100),
  client_email    VARCHAR(254),
  client_telephone VARCHAR(30),

  -- Adresse du chantier
  adresse         VARCHAR(300),
  code_postal     CHAR(10),
  ville           VARCHAR(100),

  -- Caractéristiques techniques de l'installation
  -- kWc = kilowatt-crête (puissance nominale des panneaux)
  puissance_kwc   DECIMAL(8,2),

  -- Nombre de panneaux installés
  nb_panneaux     SMALLINT,

  -- Type d'installation
  type_installation ENUM('residentiel','commercial','industriel','agricole') DEFAULT 'residentiel',

  -- Dates clés du chantier
  date_installation   DATE,         -- DATE = format AAAA-MM-JJ (sans l'heure)
  date_mise_en_service DATE,

  -- Technicien affecté (lien vers utilisateurs)
  technicien_id   INT UNSIGNED,

  -- Avancement du chantier
  statut          ENUM('planifiee','en_cours','terminee','en_garantie') DEFAULT 'planifiee',

  notes           TEXT,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (devis_id) REFERENCES devis(id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ================================================================
-- TABLE 8 : temoignages
--
-- Avis clients collectés et publiés sur le site.
-- ================================================================
CREATE TABLE IF NOT EXISTS temoignages (

  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Prénom du client (affiché)
  prenom       VARCHAR(100) NOT NULL,

  -- Initiale du nom (ex: "M" pour "Martin") pour protéger l'anonymat
  nom_initial  CHAR(1),

  -- Localisation (affiché : "Lyon (69)")
  ville        VARCHAR(100),
  code_postal  CHAR(5),

  -- Type de client
  type_client  ENUM('particulier','professionnel') DEFAULT 'particulier',

  -- Nom de l'entreprise si professionnel
  entreprise   VARCHAR(150),

  -- Note de 1 à 5 étoiles
  -- CHECK → contrainte : la valeur doit respecter cette condition
  note         TINYINT      NOT NULL CHECK (note BETWEEN 1 AND 5),

  -- Texte du témoignage
  commentaire  TEXT         NOT NULL,

  -- Lien optionnel vers l'installation concernée
  installation_id INT UNSIGNED,

  -- 0 = en attente de modération, 1 = publié sur le site
  publie       TINYINT(1)   DEFAULT 0,

  -- 1 = mis en avant (affiché en premier)
  mis_en_avant TINYINT(1)   DEFAULT 0,

  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (installation_id) REFERENCES installations(id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des 3 témoignages affichés sur le site
INSERT INTO temoignages (prenom, nom_initial, ville, code_postal, type_client, note, commentaire, publie, mis_en_avant)
VALUES
  -- Témoignage 1 : 5 étoiles, particulier
  ('Marie',  'M', 'Lyon',      '69000', 'particulier',   5,
   'Installation impeccable en une journée. Ma facture d électricité a diminué de 70% en 3 mois. Je recommande vivement !',
   1,  -- publié = oui
   0), -- mis en avant = non

  -- Témoignage 2 : 5 étoiles, professionnel (mis en avant)
  ('Pierre', 'D', 'Bordeaux',  '33000', 'professionnel', 5,
   'Nous avons équipé notre entrepôt de 500m². Le ROI est impressionnant. Service exceptionnel !',
   1,  -- publié = oui
   1), -- mis en avant = oui (affiché au centre)

  -- Témoignage 3 : 4 étoiles, particulier
  ('Sophie', 'L', 'Marseille', '13000', 'particulier',   4,
   'Très contente de mon installation. Le suivi via l application est pratique. Économies au rendez-vous.',
   1,  -- publié = oui
   0); -- mis en avant = non


-- ================================================================
-- TABLE 9 : newsletter_abonnes
--
-- Emails des personnes inscrites à la newsletter.
-- ================================================================
CREATE TABLE IF NOT EXISTS newsletter_abonnes (

  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  -- Email unique (on ne veut pas de doublons)
  email        VARCHAR(254) NOT NULL UNIQUE,

  -- Prénom optionnel (pour personnaliser les emails)
  prenom       VARCHAR(100),

  -- 1 = abonné actif, 0 = désabonné
  actif        TINYINT(1)   DEFAULT 1,

  -- Token unique pour le lien de désabonnement sécurisé
  -- Le visiteur clique "se désabonner" → on vérifie ce token
  token_desabo VARCHAR(64),

  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ================================================================
-- TABLE 10 : utilisateurs
--
-- Comptes du back-office (administrateurs, commerciaux, techniciens).
-- NE JAMAIS stocker les mots de passe en clair ! Toujours en hash.
-- ================================================================
CREATE TABLE IF NOT EXISTS utilisateurs (

  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  prenom       VARCHAR(100) NOT NULL,
  nom          VARCHAR(100) NOT NULL,
  email        VARCHAR(254) NOT NULL UNIQUE,

  -- Mot de passe HACHÉ (jamais le mot de passe réel)
  -- bcrypt génère un hash de ~60 caractères : '$2y$12$...'
  -- VARCHAR(255) est la taille recommandée pour les hashs bcrypt
  mot_de_passe VARCHAR(255) NOT NULL,

  -- Niveau d'accès
  role         ENUM('admin','commercial','technicien') DEFAULT 'commercial',

  -- 0 = compte désactivé (ex: employé parti)
  actif        TINYINT(1)   DEFAULT 1,

  -- Dernière connexion (utile pour détecter les comptes inactifs)
  -- DATETIME peut stocker NULL (contrairement à TIMESTAMP qui met une date par défaut)
  derniere_cnx DATETIME,

  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Création d'un compte administrateur par défaut
-- ⚠️ IMPORTANT : Changer le mot de passe IMMÉDIATEMENT après installation !
-- Le hash ci-dessous est un exemple à remplacer par un vrai hash bcrypt.
-- En PHP : password_hash('VotreMotDePasse123!', PASSWORD_BCRYPT)
INSERT INTO utilisateurs (prenom, nom, email, mot_de_passe, role) VALUES
  ('Admin', 'SolaireEnergie', 'admin@solaire-energie.fr',
   '$2y$12$REMPLACEZ_CE_HASH_PAR_UN_VRAI_HASH_BCRYPT_GENERE_EN_PHP',
   'admin');


-- ================================================================
-- VUES SQL
--
-- Une VUE est une requête SQL sauvegardée sous forme de "table virtuelle".
-- On peut la requêter comme une vraie table mais elle ne stocke pas de données.
-- Elle simplifie les requêtes complexes récurrentes.
--
-- CREATE OR REPLACE VIEW → crée la vue ou la remplace si elle existe déjà
-- ================================================================

-- Vue : Nouvelles demandes non traitées
-- Permet d'afficher d'un coup les demandes en attente avec leur ancienneté
CREATE OR REPLACE VIEW v_demandes_nouvelles AS
SELECT
  dc.id,
  dc.created_at,
  dc.prenom,
  dc.nom,
  dc.email,
  dc.telephone,
  dc.type_client,
  dc.service,
  dc.statut,

  -- TIMESTAMPDIFF(HOUR, date1, date2) → différence en heures entre les deux dates
  -- Utile pour savoir depuis combien d'heures la demande attend
  TIMESTAMPDIFF(HOUR, dc.created_at, NOW()) AS age_heures

FROM demandes_contact dc
WHERE dc.statut = 'nouveau'     -- seulement les nouvelles demandes
ORDER BY dc.created_at DESC;   -- les plus récentes en premier


-- Vue : Statistiques des produits par catégorie
CREATE OR REPLACE VIEW v_stats_produits AS
SELECT
  cp.nom AS categorie,

  -- COUNT(p.id) → nombre de produits actifs dans cette catégorie
  COUNT(p.id) AS nb_produits,

  -- MIN / MAX → prix le plus bas et le plus haut
  MIN(p.prix_ttc) AS prix_min,
  MAX(p.prix_ttc) AS prix_max,

  -- SUM → total de stock toutes références confondues
  SUM(p.stock) AS stock_total

FROM categories_produits cp

-- LEFT JOIN → inclut les catégories même sans produit (nb_produits = 0)
LEFT JOIN produits p ON p.categorie_id = cp.id AND p.actif = 1

-- GROUP BY → regrouper les résultats par catégorie
GROUP BY cp.id, cp.nom;


-- Vue : Note moyenne des témoignages publiés
CREATE OR REPLACE VIEW v_note_moyenne AS
SELECT
  -- ROUND(x, 1) → arrondir à 1 décimale (ex: 4.8333 → 4.8)
  ROUND(AVG(note), 1) AS note_moyenne,

  COUNT(*) AS nb_avis,

  -- CASE WHEN ... THEN ... ELSE ... END : condition dans une requête
  -- Compte combien d'avis ont la note maximale (5 étoiles)
  SUM(CASE WHEN note = 5 THEN 1 ELSE 0 END) AS cinq_etoiles

FROM temoignages
WHERE publie = 1;  -- seulement les avis publiés


-- ================================================================
-- FIN DU SCRIPT
-- Pour exécuter : mysql -u root -p < db/schema.sql
-- ================================================================
