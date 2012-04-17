<? 
session_start();
include("sql.php");
$seconds = 30;
$username = $_SESSION["username"];
$sql = "select username from peer_userstatus where username<>'$username' and now()-date<$seconds";
$res = mysql_query($sql);
while ($users = mysql_fetch_array($res)) { ?>
	<a href="javascript:void(0)" onClick="chatWith('<?=$users["username"]?>')">Chat with <?=$users["username"];?></a>
	<br />
<? } ?>