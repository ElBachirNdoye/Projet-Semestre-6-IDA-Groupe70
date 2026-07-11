# Projet-Semestre-6-IDA-Groupe70
Site de vente, d'installation et de maintenance de produits solaires

# ☀️ Projet Solaire Énergie

Ce projet est un site vitrine et de contact pour une entreprise spécialisée dans les produits solaires, l'installation et la maintenance.

Il combine :
- HTML, CSS et JavaScript pour l'affichage du site
- PHP avec PDO pour traiter le formulaire de contact
- MySQL pour enregistrer les demandes
- Bootstrap pour la mise en page

---

## 📁 Structure du projet

```text
Produits-Solaires/
├── index.html
├── script.js
├── styles.css
├── schema.sql
└── PHP/
    ├── config.php
    └── contact.php
```

---

## 🚀 Fonctionnement

- La page d'accueil affiche les informations du site.
- Le formulaire de contact envoie les données vers le fichier PHP.
- Les données sont validées puis enregistrées dans la base de données MySQL.
- Un message de confirmation peut être envoyé au visiteur.

---

## ⚙️ Installation

1. Installer XAMPP ou WAMP.
2. Démarrer Apache et MySQL.
3. Placer le dossier du projet dans le dossier htdocs.
4. Importer le fichier schema.sql dans phpMyAdmin.
5. Ouvrir le projet dans le navigateur avec :

```text
http://localhost/Produits-Solaires/index.html
```

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

