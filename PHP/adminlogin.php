<?php
error_reporting(E_ALL & ~E_NOTICE);
$errMsg = "Username or password incorrect";
$emailId = null;
$passwd = null;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if(!empty($_POST["emailId"]) && !empty($_POST["password"])) {
        $emailId = $_POST["emailId"];
        $passwd = password_hash($_POST["password"], PASSWORD_DEFAULT);
        $serverName = "localhost";
        $userName = "root";
        $password = "";
        $dbName = "apartments";

        // Create connection
        include("../Assets/dbconnect.php");

        $result = $pdo->prepare("SELECT * FROM ADMIN WHERE EMAIL = :email");
        $result->bindParam(':email',$emailId);
        $result->execute();

        if($result->rowCount() > 0)  {
            while($row = $result->fetch(PDO::FETCH_ASSOC))    {
                $pass = $row["PASSWORD"];
                if(password_verify($_POST['password'], $pass))    {
                    $name = $row["NAME"];
                    $errMsg = null;
                    session_start();
                    $_SESSION["authenticated"] = 'true';
                    $_SESSION["username"] = $name;
                    $_SESSION['email'] = $emailId;
                    // date_default_timezone_set('Asia/Kolkata');
                    // $t = time();
                    // $sql1 = "UPDATE ADMIN SET TIMESTAMP = '$t' WHERE EMAIL = '$emailId'";
                    // $conn->query($sql1);
                    header("Location: admin.php");
                }
                else {
                    $errMsg = "Incorrect Password";
                    header("Location: adminlogin.php?err=$errMsg");
                }

            }
        }   else {
                $errMsg = "User not found";
                header("Location: adminlogin.php?err=$errMsg");
            }
        }
        else {
            header('Location: adminlogin.php');
        }
    }       else {
?>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>ADMIN LOGIN</title>

    
    <link href="../Assets/CSS/bootstrap.css" rel="stylesheet">

    <link href="../Assets/CSS/signin.css" rel="stylesheet">
</head>

<body class="text-center">
    <div class="container-fluid">
        <div class="row justify-content-md-center">
            <form id="login" method="post">
                <h1 class="h3 mb-3 head1">Administrator Sign-in</h1>
                <div class="centerish">
                    <div class="col-md">
                        <label for="inputEmail" class="sr-only">Email address</label>
                        <input type="email" name="emailId" class="form-group form-control-lg tbox" placeholder="Email address" required>
                    </div>

                    <div class="col-md">
                        <label for="inputPassword" class="sr-only">Password</label>
                        <input type="password" name="password" class="form-group form-control-lg tbox" placeholder="Password" required>
                    </div>
                    <div class="form-group">
                        <input class="btn btn-lg btn-primary submitbtn" type="submit" value="Login">
                            <?php 
                                if(isset($_GET["err"]))
                                {
                                    error_reporting(E_ALL & ~E_NOTICE);
                                    $Err = $_GET["err"];
                                    echo '<p><span style="color: red";>'.$Err.'</span></p>';
                                }
                            ?>
                    </div>
                    <a href="./user.php" class="hypertexts1">Not Admin?</a>
                    <br />
                    <a href="./addadminamin.php" class="hypertexts1">Not Admin yet?</a>
                </div>

            </form>
        </div>
    </div>
</body>

</html>

<?php
    error_reporting(E_ALL & ~E_NOTICE);
    
    }?>
