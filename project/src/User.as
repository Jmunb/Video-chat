package  
{
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;
	
	[Bindable] public class User
	{
		public var username:String;
		public var id:int;
		public var iden:String="0";
		public var online:Boolean=true;
		public var connected:Boolean = false;
		public var connectedWithSomeOne:Boolean = false;
		public var connectedWith:String;
		public var numberConnected:int = 0;
		public var doNotDisturb:Boolean = false;
		public var room:String = "lobby";
		public var red5Connected:Boolean = false;
		public var showMessages:Boolean = true;
		public var rooms:String="";
		public var cameraName:String ="0";
		public var microName:int =0;		
		
		public function User(){
			this.username = UIDUtil.createUID();
			this.username = this.username;
			this.connectedWith = "";
			this.connectedWithSomeOne = false;
		}
		
	}
}