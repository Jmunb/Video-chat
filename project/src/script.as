import flash.display.Sprite;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.events.SampleDataEvent;
import flash.external.ExternalInterface;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundCodec;
import flash.media.MicrophoneEnhancedMode;
import flash.media.MicrophoneEnhancedOptions;
import flash.media.Sound;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.core.FlexGlobals;

import spark.formatters.DateTimeFormatter;

[Bindable] public var myConfig:Config = new Config();
[Bindable] public var myUser:User = new User();
[Bindable] public var hisUser:User = new User();

private static const _TRIM_PATTERN:RegExp = /^\s*|\s*$/g;
private var netConnection:NetConnection;	
private var outgoingStream:NetStream;
private var incomingStream:NetStream;
private var remoteVideo:Video;

public var microphone:Microphone;
public var camera:Camera;
public var video:Video;
public var netStreamSendClient:Object;
public var soundflag:Boolean = true;
public var sendend:Boolean = true;
public var t:Timer = new Timer(1000);
public var thisSeconds:int = 0;

public function startChat(username:String, iden:String):void {	
	hisUser.username = username;
	hisUser.iden = iden;
	receiveStream();
}

private function receiveStream():void {
	incomingStream = new NetStream(netConnection,  hisUser.iden);
	incomingStream.addEventListener(NetStatusEvent.NET_STATUS, netStreamReceiveHandler);
	incomingStream.client = this;	
	remoteVideo.attachNetStream(incomingStream);	
	myUser.connectedWith = hisUser.username;
	incomingStream.play(hisUser.iden);
}

private function netStreamReceiveHandler(event:NetStatusEvent):void	{
	if (event.info.code == "NetStream.Play.Start") {
		myUser.connectedWithSomeOne = true;
	}
}

private function init():void {
	videobutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	videobutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	audiobutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	audiobutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	callbutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	callbutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	speakerVolumeSlider.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	speakerVolumeSlider.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	endchatbutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	endchatbutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	sendbutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	sendbutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	mailbutton.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	mailbutton.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	son.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	son.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	sof.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverinbtn);
	sof.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutBUTTON);
	
	
	myUser.username = FlexGlobals.topLevelApplication.parameters.username;
	speakerVolumeSlider.value = 80;
	ExternalInterface.addCallback("startChat" , startChat);
	remoteVideo = new Video(remoteVideoDisplay.width, remoteVideoDisplay.height);
	remoteVideoDisplay.addChild(remoteVideo);
	netConnection = new NetConnection();
	netConnection.addEventListener(NetStatusEvent.NET_STATUS , netConnectionHandler);
	netConnection.connect(myConfig.StratusAddress + "/" + myConfig.DeveloperKey);
	prepareWebcamAndMicro();
}

private function prepareWebcamAndMicro():void {
	microphone = Microphone.getEnhancedMicrophone()
	//microphone = Microphone.getMicrophone();		//тут настраиваем микрафон - избавляемся от эхо
	if (microphone) {
		microphone.rate = 11;
		microphone.setSilenceLevel(0);
		//microphone = Microphone.getEnhancedMicrophone()
		var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
		options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
		options.autoGain = false;//true
		options.echoPath = 128; //256
		options.nonLinearProcessing = true;
		microphone.enableVAD = true;
		microphone.encodeQuality = 5;
		microphone.enhancedOptions = options;
		microphone.codec = SoundCodec.SPEEX;
		microphone.setUseEchoSuppression(true);
		/*microphone.codec = SoundCodec.SPEEX;
		//microphone.codec = SoundCodec.NELLYMOSER;
		
		microphone.setUseEchoSuppression(true); 
		microphone.gain = 35;
		microphone.setLoopBack(false);
	
		if(microphone.codec.length == 10) {
			microphone.rate = 44;
			microphone.setSilenceLevel(0);
		}
		if(microphone.codec.length == 5) {
			microphone.framesPerPacket = 1;
			microphone.encodeQuality = 10
			microphone.setSilenceLevel(0);
		}*/
	}
	camera = Camera.getCamera();
	if (myConfig.DEBUG) Alert.show(camera.width.toString() +":"+ camera.height.toString()+":"+camera.fps.toString());
	if (camera == null) {
		Alert.show("Веб камера отсутствует!");
		return;
	} else {
		if (camera.muted) {
			Security.showSettings(SecurityPanel.PRIVACY);
		}
		camera.setMode(280 , 210 , 10);
		camera.setQuality(0,80);
	}	
}

private function prepareStreams():void {
	myUser.iden = netConnection.nearID;
	if (myConfig.DEBUG) Alert.show("prepareStreams myUser.iden ="+myUser.iden);
	netStreamSendClient = {
		onPeerConnect: function(subscriber:NetStream):Boolean{
			if (hisUser.iden == subscriber.farID) return true;
			hisUser = new User();
			hisUser.iden = subscriber.farID;
			receiveStream();
			return true;
		}
	}  	
	myUser.connected = true;
	outgoingStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
	outgoingStream.dataReliable = true;			//а тут настраиваем наше подключение для минимальных потерь при передаче
	outgoingStream.videoReliable = true;		//
	outgoingStream.audioReliable = true;		//
	outgoingStream.multicastAvailabilitySendToAll = false;	//тут говорим что данные отдаем только однаму
	outgoingStream.addEventListener(NetStatusEvent.NET_STATUS , netStreamSendHandler);
	outgoingStream.client = netStreamSendClient;
	
	if (microphone){
		outgoingStream.attachAudio(microphone);
	}
	if (camera) {
		outgoingStream.attachCamera(camera);
	}
	var timer:Timer = new Timer(50);
	timer.start();	
	outgoingStream.publish(myUser.iden);
	
}

private function netStreamSendHandler(event:NetStatusEvent):void {
	if (event.info.code=="NetStream.Play.Start") {
		if (camera.muted) Security.showSettings(SecurityPanel.PRIVACY); 
		hisUser.username = "guest";
	}
}

private function netConnectionHandler(event:NetStatusEvent):void {
	switch (event.info.code){
		case "NetConnection.Connect.Success":
			if (myConfig.DEBUG) Alert.show("NetConnection.Connect.Success");
			myUser.iden = netConnection.nearID;
			ExternalInterface.call("connected" , myUser.username , myUser.iden );
			prepareStreams();
			break;
		case "NetConnection.Connect.Closed":
			if (myConfig.DEBUG) Alert.show("NetConnection.Connect.Closed");
			myUser.connected = false;
			break;
		case "NetStream.Connect.Success":
			if (myConfig.DEBUG) Alert.show("NetStream.Connect.Success");
			startTimer();
			myUser.connectedWithSomeOne = true;
			break;
		case "NetConnection.Connect.Failed":
			if (myConfig.DEBUG) Alert.show("NetConnection.Connect.Failed");
			break;
		case "NetStream.Connect.Closed":
			if (myConfig.DEBUG) Alert.show("NetStream.Connect.Closed");
			outgoingStream.send("stopTimer");
			stopTimer();
			clearDisplay();
			resetStreams();
			myUser.connectedWithSomeOne = false;
			if(sendend) {
				Alert.show("Ваш собеседник вышел!");
				sendend = false;
			}
			ExternalInterface.call("endChat");
			break;
	}
}

private function resetStreams():void	{
	var i:int;
	if(outgoingStream != null) {
		for(i = 0; outgoingStream.peerStreams.length[i]; i++) {
			outgoingStream.peerStreams[i].close();
		}
	}
	if(incomingStream != null) return;
	return
}

private function speakerVolumeChanged(e:Event):void {
	if (incomingStream) {
		var volume:Number = e.target.value / 100;
		var st:SoundTransform = new SoundTransform(volume);
		incomingStream.soundTransform = st;
	}
}

private function stopCall():void {
	callbutton.selected = true;
	videobutton.selected = false;
	audiobutton.selected = false;
	outgoingStream.attachAudio(null);
	outgoingStream.attachCamera(null);
	incomingStream.receiveAudio(false);
	incomingStream.receiveVideo(false);
	remoteVideo.attachNetStream(null);
	outgoingStream.send("clearDisplay");
	clearDisplay();
	outgoingStream.send("stopTimer");
	stopTimer();
}

private function startAudio():void {
	if(!callbutton.selected)
		if (audiobutton.selected) {
			audiobutton.selected = false;
			if (outgoingStream) {
				if (microphone) {
					outgoingStream.attachAudio(microphone);
				}
			}
		}
		else {
			audiobutton.selected = true;
			if (outgoingStream) {
				if (microphone) {
					outgoingStream.attachAudio(null);
				}
			}
		}
}

private function startVideo():void {
	if(!callbutton.selected)
		if (videobutton.selected) {
			videobutton.selected = false;
			if (camera) {
				if (outgoingStream) {
					if(camera) {
						outgoingStream.attachCamera(camera);
					}
				}
			}
		}
		else {
			videobutton.selected = true;
			if (outgoingStream) {
				if(camera) {
					outgoingStream.attachCamera(null);
					outgoingStream.send("clearDisplay");
				}
			}
		}
}

private function sendText():void {
	var txt:String = trim(input_txt.text);
	if(txt.length) {
		txt = "<b>"+ myUser.username+"</b>:"+ txt;
		input_txt.text="";
		chat_txt.validateNow();
		outgoingStream.send("receiveText", txt , 0);
		txt = txt+"<br>";
		chat_txt.htmlText+=getthistime() + "|" + txt;
		chat_txt.validateNow();
		chat_txt.verticalScrollPosition = chat_txt.maxVerticalScrollPosition;
		if(soundflag)
			SoundSend.play();
	}
}

public function receiveText(txt:String, color:uint):void {
	chat_txt.htmlText+=getthistime() + "|" + txt;
	chat_txt.validateNow();
	chat_txt.verticalScrollPosition = chat_txt.maxVerticalScrollPosition;
	if(soundflag)
		SoundIn.play();
}

private function getthistime():String {
	var myDate:Date = new Date();
	var h:int = myDate.hours;
	var hover:String;
	if(h < 10) hover = "0" + h.toString();
	else hover = h.toString();
	var m:int = myDate.minutes;
	var min:String;
	if(m < 10) min = "0" + m.toString();
	else min = m.toString();
	var s:int = myDate.seconds;
	var sec:String;
	if(s < 10) sec = "0" + s.toString();
	else sec = s.toString();
	var ttime:String = hover + ":" + min + ":" + sec;
	return ttime;
}

public static function trim(text:String):String {
	return text.replace(_TRIM_PATTERN, "");
}

public function ctrlEnter(e:KeyboardEvent):void {
	if (e.keyCode == Keyboard.ENTER && e.ctrlKey == true)
		sendText();	
}

public function saundon():void {
	son.visible = false;
	sof.visible = true;
	soundflag = false;
}

public function saundof():void {
	sof.visible = false;
	son.visible = true;
	soundflag = true;
}

public function clearDisplay():void {
	remoteVideo.clear();			
}

public function startTimer():void {
	t.addEventListener(TimerEvent.TIMER,onTimerStep); // подписываемся на событие срабатывания таймера
	t.start(); // запуск таймера
}

public function stopTimer():void {
	t.stop();
	timecall.x = 534;
	timecall.y = 185;
	timecall.width = 110;
	timecall.text = 'Звонок завершен';
}

public function onTimerStep(event:TimerEvent):void {
	thisSeconds += 1000;
	var myDate:Date = new Date(thisSeconds);
	var h:int = myDate.hoursUTC;
	var hover:String;
	if(h < 10) hover = "0" + h.toString();
	else hover = h.toString();
	var m:int = myDate.minutesUTC;
	var min:String;
	if(m < 10) min = "0" + m.toString();
	else min = m.toString();
	var s:int = myDate.secondsUTC;
	var sec:String;
	if(s < 10) sec = "0" + s.toString();
	else sec = s.toString();
	var ttime:String = hover + ":" + min + ":" + sec;
	timecall.text = ttime;
}


public function onMouseOverinbtn(event:MouseEvent):void {
	Mouse.cursor = MouseCursor.BUTTON; 
}

public function onMouseOutBUTTON(event:MouseEvent):void {
	Mouse.cursor = MouseCursor.AUTO; 
}