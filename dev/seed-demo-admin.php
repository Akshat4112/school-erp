<?php
// Intended exclusively for short-lived, private cloud development with an empty schema.
// The generated password is held in the gitignored .env file; never log it.
if (PHP_SAPI !== 'cli' || getenv('CI_ENV') !== 'development') {
    fwrite(STDERR, "Demo seeding is restricted to development CLI.\n");
    exit(1);
}
$password = getenv('SCHOOLERP_DEMO_ADMIN_PASSWORD');
if (!is_string($password) || strlen($password) < 24) {
    fwrite(STDERR, "A random demo admin password is required.\n");
    exit(1);
}
$host = getenv('SCHOOLERP_DB_HOST') ?: 'db';
$name = getenv('SCHOOLERP_DB_NAME') ?: 'school_erp';
$user = getenv('SCHOOLERP_DB_USER') ?: 'schoolerp';
$dbpass = getenv('SCHOOLERP_DB_PASSWORD') ?: '';
$email = 'cloud-demo@school.invalid';
try {
    $pdo = new PDO(
        'mysql:host='.$host.';dbname='.$name.';charset=utf8mb4',
        $user, $dbpass,
        array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
    );
    $check = $pdo->prepare('SELECT admin_id FROM admin WHERE admin_email = ? LIMIT 1');
    $check->execute(array($email));
    if (!$check->fetch()) {
        $insert = $pdo->prepare('INSERT INTO admin (admin_email, admin_password, admin_name) VALUES (?, ?, ?)');
        $insert->execute(array($email, password_hash($password, PASSWORD_DEFAULT), 'Cloud Demo Administrator'));
    }
    echo "Cloud demo admin exists (synthetic data only).\n";
} catch (Exception $exception) {
    fwrite(STDERR, "Could not seed synthetic admin (check database import and connection).\n");
    exit(1);
}
