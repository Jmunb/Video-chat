<? 
session_start();
$hisusername = $_GET["hisusername"]; 
$username = $_SESSION["username"];
if (isset($_GET["stratus"])) {
	$stratus = $_GET["stratus"];
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"> 
    <head>
        <title></title>
        <meta name="google" value="notranslate">         
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style type="text/css" media="screen"> 
            html, body  { height:100%; }
            body { margin:0; padding:0; overflow:auto; }   
            object:focus { outline:none; }
            #flashContent { display:none; }
        </style>
        <script type="text/javascript" src="js/jquery.js"></script>
		<script>

		function connected(username , stratus) {
			<? if (isset($_GET["stratus"])) { ?>//если получили ключь то соединяемся
				document.getElementById("chat").startChat('<?=$hisusername?>' , '<?=$stratus?>');
			<? } else { ?>//если нет ключа то получаем его и записываем в бд
			$.post("updateStratus.php",{username:username, stratus:stratus, hisusername:"<?=$hisusername?>"},function (result){
			});
			<? } ?>
			
		}
		function endChat() {
			this.close();
		}
		
		</script>

            
        <script type="text/javascript" src="swfobject.js"></script>
        <script type="text/javascript">

            var swfVersionStr = "10.1.0";
            var xiSwfUrlStr = "playerProductInstall.swf";
            var flashvars = {username:"<?=$username?>"};
            var params = {};
            params.quality = "high";
            params.bgcolor = "#ffffff";
			params.wmode = "transparent";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            var attributes = {};
            attributes.id = "chat";
            attributes.name = "chat";
            attributes.align = "middle";
            swfobject.embedSWF(
                "chat.swf", "flashContent", 
                "666", "289", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
            swfobject.createCSS("#flashContent", "display:block;text-align:left;");
        </script>
    </head>
    <body>

        <div id="flashContent">
            <p>
                To view this page ensure that Adobe Flash Player version 
                10.1.0 or greater is installed. 
            </p>
            <script type="text/javascript"> 
                var pageHost = ((document.location.protocol == "https:") ? "https://" : "http://"); 
                document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
                                + pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
            </script> 
        </div>
    
        
  
</body>
</html>
