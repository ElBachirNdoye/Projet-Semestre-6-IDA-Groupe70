<?php

// Début du script PHP pour traiter le formulaire de contact

declare(strict_types=1);

// Répondre au navigateur en JSON
header('Content-Type: application/json; charset=utf-8');
header('X-Content-Type-Options: nosniff');

// Vérifie que la page reçoit bien une requête POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Méthode non autorisée.']);
    exit;
}

// Charge la configuration de la base de données et des emails
require_once __DIR__ . '/config.php';

// Nettoie les données envoyées par le formulaire
function sanitize(mixed $value): string
{
    return htmlspecialchars(trim((string) $value), ENT_QUOTES, 'UTF-8');
}

// Retourne une erreur au navigateur
function jsonError(string $message, int $code = 400): never
{
    http_response_code($code);
    echo json_encode(['success' => false, 'error' => $message]);
    exit;
}

// Retourne un message de succès au navigateur
function jsonSuccess(string $message, array $extra = []): never
{
    echo json_encode(array_merge(
        ['success' => true, 'message' => $message],
        $extra
    ));
    exit;
}

// Protection contre les envois répétés
$ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
$rateLimitFile = sys_get_temp_dir() . '/se_rl_' . md5($ip) . '.json';
$now = time();
$rateData = ['count' => 0, 'window_start' => $now];

if (file_exists($rateLimitFile)) {
    $rateData = json_decode(file_get_contents($rateLimitFile), true) ?? $rateData;

    if ($now - $rateData['window_start'] > 3600) {
        $rateData = ['count' => 0, 'window_start' => $now];
    }
}

$rateData['count']++;
file_put_contents($rateLimitFile, json_encode($rateData));

if ($rateData['count'] > 5) {
    jsonError('Trop de tentatives. Veuillez réessayer dans 1 heure.', 429);
}

// Récupère les données envoyées par le formulaire
$prenom = sanitize($_POST['prenom'] ?? '');
$nom = sanitize($_POST['nom'] ?? '');
$email = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
$telephone = sanitize($_POST['telephone'] ?? '');
$type_client = sanitize($_POST['type_client'] ?? '');
$surface_raw = $_POST['surface'] ?? '';
$surface = ($surface_raw !== '') ? (int) $surface_raw : null;
$service = sanitize($_POST['service'] ?? '');
$message = sanitize($_POST['message'] ?? '');
$rgpd = !empty($_POST['rgpd']);

// Vérifie que les champs obligatoires sont bien remplis
if (empty($prenom)) {
    jsonError('Le prénom est requis.');
}

if (empty($nom)) {
    jsonError('Le nom est requis.');
}

if (!$email) {
    jsonError('L\'adresse e-mail est invalide.');
}

if (!in_array($type_client, ['particulier', 'professionnel', 'agriculteur', 'collectivite'])) {
    jsonError('Le type de client est invalide.');
}

if (!in_array($service, ['installation', 'batterie', 'maintenance', 'audit', 'autre'])) {
    jsonError('Le service sélectionné est invalide.');
}

if (!$rgpd) {
    jsonError('Vous devez accepter la politique de confidentialité.');
}

if (mb_strlen($prenom) > 100 || mb_strlen($nom) > 100) {
    jsonError('Prénom ou nom trop long (100 caractères maximum).');
}

if (mb_strlen($message) > 3000) {
    jsonError('Le message est trop long (3 000 caractères maximum).');
}

if ($surface !== null && ($surface < 10 || $surface > 10000)) {
    jsonError('La surface doit être entre 10 et 10 000 m².');
}

// Enregistre la demande dans la base de données MySQL
try {
    $db = getDB();
    $stmt = $db->prepare(
        'INSERT INTO demandes_contact
         (prenom, nom, email, telephone, type_client, surface_m2, service, message, ip_address, user_agent)
         VALUES
         (:prenom, :nom, :email, :telephone, :type_client, :surface_m2, :service, :message, :ip, :ua)'
    );

    $stmt->execute([
        ':prenom' => $prenom,
        ':nom' => $nom,
        ':email' => $email,
        ':telephone' => $telephone ?: null,
        ':type_client' => $type_client,
        ':surface_m2' => $surface,
        ':service' => $service,
        ':message' => $message ?: null,
        ':ip' => $ip,
        ':ua' => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500),
    ]);

    $insertId = $db->lastInsertId();
} catch (PDOException $e) {
    if (APP_DEBUG) {
        error_log('[SolaireÉnergie][DB] ' . $e->getMessage());
    }

    jsonError('Erreur serveur. Veuillez nous appeler directement au +33 4 12 34 56 78.', 500);
}

// Prépare l'email envoyé à l'équipe
$sujetAdmin = sprintf('[SE] Nouvelle demande – %s %s (%s)', $prenom, $nom, $service);
$corpsAdmin = implode("\r\n", [
    '=== NOUVELLE DEMANDE DE CONTACT ===',
    str_repeat('─', 50),
    'Référence    : #' . $insertId,
    'Date         : ' . date('d/m/Y H:i'),
    '',
    'COORDONNÉES CLIENT :',
    'Prénom       : ' . $prenom,
    'Nom          : ' . $nom,
    'Email        : ' . $email,
    'Téléphone    : ' . ($telephone ?: 'Non renseigné'),
    '',
    'PROJET :',
    'Profil       : ' . $type_client,
    'Surface      : ' . ($surface ? $surface . ' m²' : 'Non renseignée'),
    'Service      : ' . $service,
    'Message      : ' . ($message ?: 'Aucun message'),
    '',
    str_repeat('─', 50),
    'IP du visiteur : ' . $ip,
    '',
    '→ Merci de traiter cette demande dans les 24 heures ouvrées.',
]);

$headersAdmin = implode("\r\n", [
    'From: ' . NOTIF_FROM_NAME . ' <' . NOTIF_FROM . '>',
    'Reply-To: ' . $prenom . ' ' . $nom . ' <' . $email . '>',
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    'Content-Transfer-Encoding: 8bit',
    'X-Mailer: SolaireEnergie/1.0',
]);

@mail(NOTIF_EMAIL, $sujetAdmin, $corpsAdmin, $headersAdmin);

// Prépare l'email de confirmation envoyé au client
$sujetClient = 'SolaireÉnergie – Confirmation de votre demande #' . $insertId;
$corpsClient = implode("\r\n", [
    'Bonjour ' . $prenom . ',',
    '',
    'Nous avons bien reçu votre demande concernant : ' . $service . '.',
    'Un expert SolaireÉnergie vous contactera sous 24 heures ouvrées.',
    '',
    '── RÉCAPITULATIF DE VOTRE DEMANDE (réf. #' . $insertId . ') ──',
    '  Service    : ' . $service,
    '  Profil     : ' . $type_client,
    ($surface ? '  Surface    : ' . $surface . " m²\r\n" : ''),
    ($message ? '  Message    : ' . $message . "\r\n" : ''),
    '─────────────────────────────────────────────',
    '',
    'Pour toute question urgente, contactez-nous :',
    '  📞 +221 77 874 51 54  (Lun – Ven, 9h – 18h, Sam -9h -16h)',
    '  ✉  contact@solaire-energie.fr',
    '',
    'Cordialement,',
    'L\'équipe SolaireÉnergie',
    '123 Bountou Pikine, 11000 Pikine/Sénégal',
    '',
    '─────────────────────────────────────────────',
    'Ce message est envoyé automatiquement, merci de ne pas y répondre.',
    'Pour nous contacter : elbachir.ndoye@unchk.edu.sn',
]);

$headersClient = implode("\r\n", [
    'From: SolaireÉnergie <' . NOTIF_FROM . '>',
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    'Content-Transfer-Encoding: 8bit',
]);

@mail($email, $sujetClient, $corpsClient, $headersClient);

// Retourne la réponse finale au navigateur
jsonSuccess(
    'Votre demande a été envoyée avec succès ! Nous vous recontacterons sous 24 heures ouvrées.',
    ['id' => (int) $insertId]
);
