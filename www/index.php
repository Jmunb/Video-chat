<?php session_start();
$_SESSION['username'] = $_GET["username"];
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd" >
<html>
<head>
<title>peer2peer one1one chat demo</title>
<link type="text/css" rel="stylesheet" media="all" href="css/chat.css" />
<link type="text/css" rel="stylesheet" media="all" href="css/screen.css" />
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/chat.js"></script>

<!--[if lte IE 7]>
<link type="text/css" rel="stylesheet" media="all" href="css/screen_ie.css" />
<![endif]-->
<script>
var refreshRate = 10000;
function refreshOnlineUsers() {
	$.post("getOnlineUsers.php" , {} , function (text){
		$("#onlineUsers").html(text);
	});
	setTimeout(refreshOnlineUsers , refreshRate);
}
$(function(){
	refreshOnlineUsers();
});
</script>
</head>
<body>
<div id="onlineUsers"></div>
<br>
<a href="logout.php">logout</a>
</body>
</html>