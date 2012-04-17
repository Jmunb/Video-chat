package   {
	[Bindable] public class Config {
	public const DeveloperKey:String = "465655d8957d8104fb477abb-612a20b8012a";	
	public const StratusAddress:String = "rtmfp://p2p.rtmfp.net/" + DeveloperKey;
	
	public var DEBUG:Boolean = false;
		
		
		public function Config():void {	
			if (DEBUG) {
			}
		}
	}
}