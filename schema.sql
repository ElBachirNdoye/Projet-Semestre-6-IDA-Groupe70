-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `solaire_energie`
--

-- --------------------------------------------------------

--
-- Structure de la table `categories_produits`
--

CREATE TABLE `categories_produits` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(60) NOT NULL,
  `nom` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `categories_produits`
--

INSERT INTO `categories_produits` (`id`, `slug`, `nom`, `description`, `created_at`) VALUES
(1, 'panneaux', 'Panneaux solaires', 'Panneaux photovoltaïques mono/polycristallins et bifaciaux', '2026-07-09 17:43:15'),
(2, 'batteries', 'Batteries de stockage', 'Solutions de stockage d\'énergie lithium-ion', '2026-07-09 17:43:15'),
(3, 'onduleurs', 'Onduleurs', 'Onduleurs string, micro-onduleurs et hybrides', '2026-07-09 17:43:15'),
(4, 'kits', 'Kits complets', 'Kits clé-en-main résidentiels et commerciaux', '2026-07-09 17:43:15');

-- --------------------------------------------------------

--
-- Structure de la table `demandes_contact`
--

CREATE TABLE `demandes_contact` (
  `id` int(10) UNSIGNED NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  `type_client` enum('particulier','professionnel','agriculteur','collectivite') NOT NULL,
  `surface_m2` smallint(5) UNSIGNED DEFAULT NULL,
  `service` enum('installation','batterie','maintenance','audit','autre') NOT NULL,
  `message` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `statut` enum('nouveau','en_cours','traite','archive') DEFAULT 'nouveau',
  `notes_internes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `traite_par` int(10) UNSIGNED DEFAULT NULL,
  `traite_le` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `devis`
--

CREATE TABLE `devis` (
  `id` int(10) UNSIGNED NOT NULL,
  `numero` varchar(20) NOT NULL,
  `demande_id` int(10) UNSIGNED DEFAULT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  `adresse` varchar(300) DEFAULT NULL,
  `code_postal` char(10) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `montant_ht` decimal(12,2) DEFAULT NULL,
  `montant_tva` decimal(12,2) DEFAULT NULL,
  `montant_ttc` decimal(12,2) DEFAULT NULL,
  `taux_tva` decimal(5,2) DEFAULT 10.00,
  `statut` enum('brouillon','envoye','accepte','refuse','expire') DEFAULT 'brouillon',
  `validite_jours` tinyint(4) DEFAULT 30,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `devis_lignes`
--

CREATE TABLE `devis_lignes` (
  `id` int(10) UNSIGNED NOT NULL,
  `devis_id` int(10) UNSIGNED NOT NULL,
  `produit_id` int(10) UNSIGNED DEFAULT NULL,
  `designation` varchar(300) NOT NULL,
  `quantite` decimal(8,2) DEFAULT 1.00,
  `unite` varchar(20) DEFAULT 'unité',
  `prix_ht` decimal(10,2) NOT NULL,
  `taux_tva` decimal(5,2) DEFAULT 10.00,
  `remise_pct` decimal(5,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `installations`
--

CREATE TABLE `installations` (
  `id` int(10) UNSIGNED NOT NULL,
  `devis_id` int(10) UNSIGNED DEFAULT NULL,
  `client_prenom` varchar(100) DEFAULT NULL,
  `client_nom` varchar(100) DEFAULT NULL,
  `client_email` varchar(254) DEFAULT NULL,
  `client_telephone` varchar(30) DEFAULT NULL,
  `adresse` varchar(300) DEFAULT NULL,
  `code_postal` char(10) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `puissance_kwc` decimal(8,2) DEFAULT NULL,
  `nb_panneaux` smallint(6) DEFAULT NULL,
  `type_installation` enum('residentiel','commercial','industriel','agricole') DEFAULT 'residentiel',
  `date_installation` date DEFAULT NULL,
  `date_mise_en_service` date DEFAULT NULL,
  `technicien_id` int(10) UNSIGNED DEFAULT NULL,
  `statut` enum('planifiee','en_cours','terminee','en_garantie') DEFAULT 'planifiee',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `newsletter_abonnes`
--

CREATE TABLE `newsletter_abonnes` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(254) NOT NULL,
  `prenom` varchar(100) DEFAULT NULL,
  `actif` tinyint(1) DEFAULT 1,
  `token_desabo` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `id` int(10) UNSIGNED NOT NULL,
  `categorie_id` int(10) UNSIGNED NOT NULL,
  `reference` varchar(60) NOT NULL,
  `nom` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `caracteristiques` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`caracteristiques`)),
  `prix_ht` decimal(10,2) DEFAULT NULL,
  `prix_ttc` decimal(10,2) DEFAULT NULL,
  `devise` char(3) DEFAULT 'EUR',
  `badge` varchar(40) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `actif` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`id`, `categorie_id`, `reference`, `nom`, `description`, `caracteristiques`, `prix_ht`, `prix_ttc`, `devise`, `badge`, `image_url`, `stock`, `actif`, `created_at`, `updated_at`) VALUES
(1, 1, 'PAN-MONO-400', 'Monocristallin 400W', 'Rendement jusqu à 21,5%. Idéal pour toitures résidentielles avec surface limitée.', '{\"puissance\":\"400W\",\"rendement\":\"21.5%\",\"garantie\":\"25 ans\",\"certification\":\"IEC 61215\"}', 241.67, 290.00, 'EUR', 'Bestseller', 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400', 150, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(2, 1, 'PAN-POLY-320', 'Polycristallin 320W', 'Excellent rapport qualité-prix. Solution économique pour grandes surfaces.', '{\"puissance\":\"320W\",\"rendement\":\"17%\",\"garantie\":\"20 ans\"}', 175.00, 210.00, 'EUR', 'Éco', 'https://images.unsplash.com/photo-1558449028-b53a39d100fc?w=400', 200, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(3, 1, 'PAN-BIF-HJT-480', 'Bifacial HJT 480W', 'Technologie hétérojonction double face. Rendement exceptionnel.', '{\"puissance\":\"480W\",\"rendement\":\"23%\",\"garantie\":\"30 ans\",\"technologie\":\"HJT bifacial\"}', 350.00, 420.00, 'EUR', 'Nouveau', 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=400', 80, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(4, 2, 'BAT-LI-10KWH', 'Batterie Lithium 10kWh', 'Stockage énergie solaire pour usage nocturne ou nuageux.', '{\"capacite\":\"10 kWh\",\"cycles\":\"6000\",\"montage\":\"mural\",\"garantie\":\"10 ans\"}', 2666.67, 3200.00, 'EUR', 'Pro', 'https://images.unsplash.com/photo-1609940823547-4ef0bc7e37d5?w=400', 30, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(5, 2, 'BAT-PW-13.5', 'Powerwall 13,5kWh', 'Système tout-en-un avec onduleur intégré et app mobile.', '{\"capacite\":\"13.5 kWh\",\"onduleur_integre\":true,\"monitoring\":\"app mobile\",\"garantie\":\"10 ans\"}', 7083.33, 8500.00, 'EUR', NULL, 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400', 15, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(6, 3, 'OND-HYB-5KW', 'Onduleur Hybride 5kW', 'Gère simultanément panneaux, batterie et réseau. Monitoring WiFi.', '{\"puissance\":\"5 kW\",\"rendement\":\"97.5%\",\"monitoring\":\"WiFi\",\"phases\":\"monophase\"}', 1500.00, 1800.00, 'EUR', NULL, 'https://images.unsplash.com/photo-1548391350-968f58dedaed?w=400', 50, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(7, 4, 'KIT-RESI-3KWC', 'Kit Résidentiel 3kWc', 'Kit clé-en-main maison. Inclut panneaux, onduleur, câblage, installation.', '{\"panneaux\":\"8 x 375W\",\"puissance_totale\":\"3 kWc\",\"installation\":true,\"demarches_admin\":true}', 6583.33, 7900.00, 'EUR', 'Promo', 'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=400', 20, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15'),
(8, 4, 'KIT-COM-20KWC', 'Kit Commercial 20kWc', 'Solution industrielle pour entreprises. ROI garanti en moins de 5 ans.', '{\"panneaux\":\"50 x 400W\",\"puissance_totale\":\"20 kWc\",\"monitoring_temps_reel\":true,\"financement\":true}', NULL, NULL, 'EUR', 'Entreprise', 'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=400', 0, 1, '2026-07-09 17:43:15', '2026-07-09 17:43:15');

-- --------------------------------------------------------

--
-- Structure de la table `services`
--

CREATE TABLE `services` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(60) NOT NULL,
  `nom` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `icone` varchar(60) DEFAULT NULL,
  `ordre` tinyint(4) DEFAULT 0,
  `actif` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `services`
--

INSERT INTO `services` (`id`, `slug`, `nom`, `description`, `icone`, `ordre`, `actif`, `created_at`) VALUES
(1, 'etude-conseil', 'Étude et Conseil', 'Analyse gratuite de toiture, consommation et potentiel solaire. Simulation ROI.', 'bi-search', 1, 1, '2026-07-09 17:43:16'),
(2, 'installation', 'Installation Professionnelle', 'Pose par techniciens certifiés RGE QualiPV. Mise en service avec tests.', 'bi-house-gear', 2, 1, '2026-07-09 17:43:16'),
(3, 'demarches-admin', 'Démarches Administratives', 'Déclaration travaux, raccordement Enedis, aides financières (MaPrimeRénov, CEE).', 'bi-file-earmark-text', 3, 1, '2026-07-09 17:43:16'),
(4, 'monitoring', 'Monitoring et Supervision', 'Espace client en ligne, suivi temps réel de la production et économies.', 'bi-activity', 4, 1, '2026-07-09 17:43:16'),
(5, 'maintenance-sav', 'Maintenance et SAV', 'Contrats annuels : nettoyage, vérification électrique, intervention rapide.', 'bi-wrench-adjustable', 5, 1, '2026-07-09 17:43:16'),
(6, 'financement', 'Financement sur mesure', 'Comptant, LOA ou crédit préférentiel. Partenaires bancaires certifiés.', 'bi-bank2', 6, 1, '2026-07-09 17:43:16');

-- --------------------------------------------------------

--
-- Structure de la table `temoignages`
--

CREATE TABLE `temoignages` (
  `id` int(10) UNSIGNED NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom_initial` char(1) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `code_postal` char(5) DEFAULT NULL,
  `type_client` enum('particulier','professionnel') DEFAULT 'particulier',
  `entreprise` varchar(150) DEFAULT NULL,
  `note` tinyint(4) NOT NULL CHECK (`note` between 1 and 5),
  `commentaire` text NOT NULL,
  `installation_id` int(10) UNSIGNED DEFAULT NULL,
  `publie` tinyint(1) DEFAULT 0,
  `mis_en_avant` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `temoignages`
--

INSERT INTO `temoignages` (`id`, `prenom`, `nom_initial`, `ville`, `code_postal`, `type_client`, `entreprise`, `note`, `commentaire`, `installation_id`, `publie`, `mis_en_avant`, `created_at`) VALUES
(1, 'Marie', 'M', 'Lyon', '69000', 'particulier', NULL, 5, 'Installation impeccable en une journée. Ma facture d électricité a diminué de 70% en 3 mois. Je recommande vivement !', NULL, 1, 0, '2026-07-09 17:43:17'),
(2, 'Pierre', 'D', 'Bordeaux', '33000', 'professionnel', NULL, 5, 'Nous avons équipé notre entrepôt de 500m². Le ROI est impressionnant. Service exceptionnel !', NULL, 1, 1, '2026-07-09 17:43:17'),
(3, 'Sophie', 'L', 'Marseille', '13000', 'particulier', NULL, 4, 'Très contente de mon installation. Le suivi via l application est pratique. Économies au rendez-vous.', NULL, 1, 0, '2026-07-09 17:43:17');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` int(10) UNSIGNED NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` enum('admin','commercial','technicien') DEFAULT 'commercial',
  `actif` tinyint(1) DEFAULT 1,
  `derniere_cnx` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `prenom`, `nom`, `email`, `mot_de_passe`, `role`, `actif`, `derniere_cnx`, `created_at`) VALUES
(1, 'Admin', 'SolaireEnergie', 'admin@solaire-energie.fr', '$2y$12$REMPLACEZ_CE_HASH_PAR_UN_VRAI_HASH_BCRYPT_GENERE_EN_PHP', 'admin', 1, NULL, '2026-07-09 17:43:17');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_demandes_nouvelles`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_demandes_nouvelles` (
`id` int(10) unsigned
,`created_at` timestamp
,`prenom` varchar(100)
,`nom` varchar(100)
,`email` varchar(254)
,`telephone` varchar(30)
,`type_client` enum('particulier','professionnel','agriculteur','collectivite')
,`service` enum('installation','batterie','maintenance','audit','autre')
,`statut` enum('nouveau','en_cours','traite','archive')
,`age_heures` bigint(21)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_note_moyenne`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_note_moyenne` (
`note_moyenne` decimal(5,1)
,`nb_avis` bigint(21)
,`cinq_etoiles` decimal(22,0)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_stats_produits`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_stats_produits` (
`categorie` varchar(120)
,`nb_produits` bigint(21)
,`prix_min` decimal(10,2)
,`prix_max` decimal(10,2)
,`stock_total` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure de la vue `v_demandes_nouvelles`
--
DROP TABLE IF EXISTS `v_demandes_nouvelles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_demandes_nouvelles`  AS SELECT `dc`.`id` AS `id`, `dc`.`created_at` AS `created_at`, `dc`.`prenom` AS `prenom`, `dc`.`nom` AS `nom`, `dc`.`email` AS `email`, `dc`.`telephone` AS `telephone`, `dc`.`type_client` AS `type_client`, `dc`.`service` AS `service`, `dc`.`statut` AS `statut`, timestampdiff(HOUR,`dc`.`created_at`,current_timestamp()) AS `age_heures` FROM `demandes_contact` AS `dc` WHERE `dc`.`statut` = 'nouveau' ORDER BY `dc`.`created_at` DESC ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_note_moyenne`
--
DROP TABLE IF EXISTS `v_note_moyenne`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_note_moyenne`  AS SELECT round(avg(`temoignages`.`note`),1) AS `note_moyenne`, count(0) AS `nb_avis`, sum(case when `temoignages`.`note` = 5 then 1 else 0 end) AS `cinq_etoiles` FROM `temoignages` WHERE `temoignages`.`publie` = 1 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_stats_produits`
--
DROP TABLE IF EXISTS `v_stats_produits`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stats_produits`  AS SELECT `cp`.`nom` AS `categorie`, count(`p`.`id`) AS `nb_produits`, min(`p`.`prix_ttc`) AS `prix_min`, max(`p`.`prix_ttc`) AS `prix_max`, sum(`p`.`stock`) AS `stock_total` FROM (`categories_produits` `cp` left join `produits` `p` on(`p`.`categorie_id` = `cp`.`id` and `p`.`actif` = 1)) GROUP BY `cp`.`id`, `cp`.`nom` ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `categories_produits`
--
ALTER TABLE `categories_produits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Index pour la table `demandes_contact`
--
ALTER TABLE `demandes_contact`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_demandes_statut` (`statut`),
  ADD KEY `idx_demandes_email` (`email`),
  ADD KEY `idx_demandes_created` (`created_at`),
  ADD KEY `idx_demandes_service` (`service`);

--
-- Index pour la table `devis`
--
ALTER TABLE `devis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`),
  ADD KEY `demande_id` (`demande_id`);

--
-- Index pour la table `devis_lignes`
--
ALTER TABLE `devis_lignes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `devis_id` (`devis_id`),
  ADD KEY `produit_id` (`produit_id`);

--
-- Index pour la table `installations`
--
ALTER TABLE `installations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `devis_id` (`devis_id`);

--
-- Index pour la table `newsletter_abonnes`
--
ALTER TABLE `newsletter_abonnes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `produits`
--
ALTER TABLE `produits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`),
  ADD KEY `categorie_id` (`categorie_id`);

--
-- Index pour la table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Index pour la table `temoignages`
--
ALTER TABLE `temoignages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `installation_id` (`installation_id`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `categories_produits`
--
ALTER TABLE `categories_produits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `demandes_contact`
--
ALTER TABLE `demandes_contact`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `devis`
--
ALTER TABLE `devis`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `devis_lignes`
--
ALTER TABLE `devis_lignes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `installations`
--
ALTER TABLE `installations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `newsletter_abonnes`
--
ALTER TABLE `newsletter_abonnes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `temoignages`
--
ALTER TABLE `temoignages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `devis`
--
ALTER TABLE `devis`
  ADD CONSTRAINT `devis_ibfk_1` FOREIGN KEY (`demande_id`) REFERENCES `demandes_contact` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `devis_lignes`
--
ALTER TABLE `devis_lignes`
  ADD CONSTRAINT `devis_lignes_ibfk_1` FOREIGN KEY (`devis_id`) REFERENCES `devis` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `devis_lignes_ibfk_2` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `installations`
--
ALTER TABLE `installations`
  ADD CONSTRAINT `installations_ibfk_1` FOREIGN KEY (`devis_id`) REFERENCES `devis` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `produits`
--
ALTER TABLE `produits`
  ADD CONSTRAINT `produits_ibfk_1` FOREIGN KEY (`categorie_id`) REFERENCES `categories_produits` (`id`);

--
-- Contraintes pour la table `temoignages`
--
ALTER TABLE `temoignages`
  ADD CONSTRAINT `temoignages_ibfk_1` FOREIGN KEY (`installation_id`) REFERENCES `installations` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
