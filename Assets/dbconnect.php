<?php
    $hostName = "localhost";
    $userName = "root";
    $password = "";
    $dbName = "apartments";
    try {
        $pdo = new PDO("mysql:host=$hostName;dbname=$dbName",$userName,$password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
    } catch(PDOException $e)   {
        // return to the previous page and show the error message
        $error = true;
        header("Location: ../PHP/user.php?error=$error");
    }