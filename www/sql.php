<?
$hostname	= 'openserver';
$sqluser	= 'mysql';
$sqlpass	= 'mysql';
$dbName		= 'db_stratus';

@mysql_connect($hostname, $sqluser, $sqlpass) or die( 'Connexion au serveur de donn�es impossible' );
@mysql_select_db( $dbName ) or die( 'Unable to connect DATABASE' ) ;
?>