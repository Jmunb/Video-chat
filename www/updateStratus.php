<? 
include("sql.php");
$username = $_POST["username"];
$hisusername = $_POST["hisusername"];
$stratus = $_POST["stratus"];

$message="";

$sql = "insert into peer_chat (`from` , `to` , `message` , `sent` , `stratus` , `action`) values ('".mysql_real_escape_string($username)."', '".mysql_real_escape_string($hisusername)."','".mysql_real_escape_string($message)."',NOW() , '$stratus', 1)";
mysql_query($sql);
?>
