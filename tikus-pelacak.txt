<?php
// --- ANTI CRAWLER & BOT ---
// Mengirim Header HTTP agar tidak diindex search engine
header("X-Robots-Tag: noindex, nofollow", true);
// --------------------------
// Password untuk menjalankan skrip ini (GANTI INI!)
$password_akses = 'Yektinurhahasan4h__123'; 
// Simpan di luar public_html (mundur satu folder)
$database_file = dirname(__FILE__) . '/../fingerprint_data.db';
// DAFTAR EKSTENSI "PARANOID" (LENGKAP)
$extensions = [
    // 1. Keluarga PHP (Eksekusi Kode)
    'php', 'php5', 'php7', 'php8', 'phtml', 'phar', 'pht', 'pgif',
    
    // 2. Keluarga OJS & Web (Sering disisipi script)
    'html', 'htm', 'js', 'inc', 'xml', 
    'tpl',   // <--- WAJIB UNTUK OJS (Smarty Template)
    'json',  // <--- Sering dipakai config (composer.json)
    
    // 3. Konfigurasi Server (Sangat Sensitif)
    'htaccess', 'htpasswd', 'ini', 'config', 'env',
    
    // 4. File Backup & Sampah (Sumber Kebocoran Password!)
    'bak', 'old', 'swp', 'temp', 'tmp', 'sql', 'log',
    
    // 5. Script Shell & Bahasa Lain
    'sh', 'bash', 'pl', 'py', 'cgi', 'rb', 'asp', 'aspx', 'shtml',
    
    // 6. Trik Penyamaran
    'suspected', '00'
]; 
// -------------------

session_start();

// 1. Proteksi Login Sederhana
if (isset($_GET['logout'])) { session_destroy(); header("Location: ?"); exit; }
if (!isset($_SESSION['logged_in'])) {
    if (isset($_POST['pass']) && $_POST['pass'] === $password_akses) {
        $_SESSION['logged_in'] = true;
    } else {
        echo '<form method="post">Password: <input type="password" name="pass"><input type="submit"></form>';
        exit;
    }
}

echo "<h2>🕵️ Laporan Integritas File (Satpam Server)</h2>";
echo "<a href='?action=scan'>[SCAN PERUBAHAN]</a> | <a href='?action=update'>[UPDATE DATABASE (Saya habis edit file)]</a> | <a href='?logout'>[LOGOUT]</a><hr>";

// Fungsi Scan Rekursif
function scan_dir($dir, $exts) {
    $files = [];
    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir));
    foreach ($iterator as $file) {
        if ($file->isFile()) {
            $ext = pathinfo($file->getFilename(), PATHINFO_EXTENSION);
            if (in_array($ext, $exts) && $file->getFilename() !== basename(__FILE__) && $file->getFilename() !== $GLOBALS['database_file']) {
                // Buat sidik jari (MD5)
                $files[$file->getPathname()] = md5_file($file->getPathname());
            }
        }
    }
    return $files;
}

// Logika Utama
if (isset($_GET['action'])) {
    $current_state = scan_dir('.', $extensions);

    if ($_GET['action'] == 'update') {
        file_put_contents($database_file, serialize($current_state));
        echo "<font color='green'>✅ Database sidik jari berhasil diperbarui! Kondisi sekarang dianggap aman.</font>";
    } 
    elseif ($_GET['action'] == 'scan') {
        if (!file_exists($database_file)) {
            echo "Database belum ada. Silakan klik UPDATE DATABASE dulu.";
        } else {
            $old_state = unserialize(file_get_contents($database_file));
            $changes = 0;

            // Cek File Berubah & Baru
            foreach ($current_state as $path => $hash) {
                if (!isset($old_state[$path])) {
                    echo "<font color='red'>⚠️ FILE BARU DITEMUKAN: $path</font><br>";
                    $changes++;
                } elseif ($old_state[$path] !== $hash) {
                    echo "<font color='red'>⚠️ FILE BERUBAH (DI-EDIT): $path</font><br>";
                    $changes++;
                }
                unset($old_state[$path]);
            }

            // Cek File Dihapus
            foreach ($old_state as $path => $hash) {
                echo "<font color='orange'>🗑️ FILE DIHAPUS: $path</font><br>";
                $changes++;
            }

            if ($changes == 0) echo "<font color='green'>✅ Aman terkendali. Tidak ada file sistem yang berubah.</font>";
        }
    }
}
?>
