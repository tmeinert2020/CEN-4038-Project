<!DOCTYPE html>
<html>
<head>
  <title>Simple Login</title>
</head>
<body>

<?php
$correctPassword = "1234"; 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $enteredPassword = $_POST['password'];

  if ($enteredPassword == $correctPassword) {
    echo "Correct!";
  } else {
    echo "Incorrect!";
  }
}
?>

<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
  <label for="password">Enter Password:</label><br>
  <input type="password" id="password" name="password"><br><br>
  <input type="submit" value="Login"> 1 
</form>

</body>
</html>