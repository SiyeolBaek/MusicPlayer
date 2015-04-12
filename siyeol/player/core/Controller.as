package siyeol.player.core{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Controller {

		public var home : Player;
		
		public function Controller() {
			
		}
		
		public function next(){

			if(home.soundChannel != null){
				home.soundChannel.stop();	
			}
			
			if(home.Shuffle){
				shuffle();
				return;
			}
			
			if(home.index < home.list.getPaths().length-1){
				home.index ++;
			}else{
				home.index = 0;
			}
			
			home.sound = new Sound(new URLRequest(home.list.getPaths()[home.index]));
			home.sound.addEventListener(Event.COMPLETE,fileComplete);
			home.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			home.pausePosition = 0;
			home.graphic.setX(0);
			
		}
		
		public function prev(){
			
			if(home.soundChannel != null){
				home.soundChannel.stop();	
			}
			
			if(home.index > 0){
				home.index --;
			}else{
				home.index = home.list.getPaths().length -1;
			}
			
			home.sound = new Sound(new URLRequest(home.list.getPaths()[home.index]));
			home.sound.addEventListener(Event.COMPLETE,fileComplete);
			home.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			home.pausePosition = 0;
			home.graphic.setX(0);
			
		}
		
		public function changeMusic( _index : int ):void{
			if(home.soundChannel != null){
				home.soundChannel.stop();	
			}
			
			home.pausePosition = 0;
			home.graphic.setX(0);
			home.index = _index;
			home.sound = new Sound(new URLRequest(home.list.getPaths()[home.index]));
			home.sound.addEventListener(Event.COMPLETE,fileComplete);
			home.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		public function play(){
			home.soundChannel = home.sound.play(home.pausePosition);
			home.soundChannel.addEventListener(Event.SOUND_COMPLETE,onComplete);
			home.isPlay = true;
		}
		
		public function pause(){
			home.isPlay = false;
			home.pausePosition = home.soundChannel.position;
			home.soundChannel.stop();
		}
		
		public function moveTo( temp_position : int ):void{
			home.soundChannel.stop();
			home.soundChannel = home.sound.play(temp_position);
			home.soundChannel.addEventListener(Event.SOUND_COMPLETE,onComplete);
			var temp_time = Math.round(home.soundChannel.position/1000);
			home.graphic.setTimeText(Math.floor(temp_time / 60) + ":"+temp_time % 60+" / "+home.minutes+":"+home.seconds);
			if(!home.isPlay){
				home.pausePosition = home.soundChannel.position;
				home.soundChannel.stop();
				return;
			}
		}
		
		public function setLoop(){
			if(home.Loop){
				home.Loop = false;
				home.list.saving.data.loop = false;
			}else{
				home.Loop = true;
				home.list.saving.data.loop = true;
			}
			home.list.saving.flush();
			trace(home.list.saving.data.loop);
		}
		
		public function setShuffle(){
			trace(home.list.saving.data.shuffle);
			if(home.Shuffle){
				home.Shuffle = false;
				home.list.saving.data.shuffle = false;
			}else{
				home.Shuffle = true;
				home.list.saving.data.shuffle = true;
			}
			home.list.saving.flush();
			trace(home.list.saving.data.shuffle);
		}
		
		public function setVolume( volume : int ){			
			home.volume = volume;
			home.transform.volume = volume;
			home.list.saving.data.volume = volume;
			home.soundChannel.soundTransform = home.transform;
		}
		
		private function shuffle(){
			var rd_index = int(Math.random() * home.list.getPaths().length);
			while(rd_index == home.index){
				rd_index = int(Math.random() * home.list.getPaths().length);
			}
			home.index = rd_index;
			home.sound = new Sound(new URLRequest(home.list.getPaths()[home.index]));
			home.sound.addEventListener(Event.COMPLETE,fileComplete);
			home.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			home.pausePosition = 0;
			home.graphic.setX(0);
		}
		
		private function fileComplete(e:Event):void{
			if(home.isPlay){
				home.soundChannel = home.sound.play();
				home.soundChannel.addEventListener(Event.SOUND_COMPLETE,onComplete);
			}
			home.transform = home.soundChannel.soundTransform;
			home.transform.volume = home.volume;
			home.soundChannel.soundTransform = home.transform;
			home.minutes = Math.floor((home.sound.length/1000) / 60);
			home.seconds = Math.floor((home.sound.length/1000) % 60);
			home.time = Math.floor(home.sound.length/1000);
			home.graphic.setTimeText("0:0 / "+home.minutes+":"+home.seconds);
			home.graphic.setInfoText(home.list.getNames()[home.index]);
		}
		
		private function onComplete(e:Event):void{
			if(home.index < home.list.getPaths().length-1 || home.isLoop()){
				if(home.Shuffle){
					shuffle();
				}else{
					next();
				}
			}else{
				home.graphic.setControlFrame(1);
				home.graphic.setX(0);
				home.pausePosition = 0;
				home.graphic.setTimeText("0:0 / "+home.minutes+":"+home.seconds);
				home.isPlay = false;
			}
		}
		
		private function onIOError(e:IOErrorEvent):void{
			home.graphic.removeList(home.index);
			home.list.getPaths().splice(home.index,1);
			home.list.getNames().splice(home.index,1);
			if(home.list.getPaths()[home.index] == undefined){
				next();
			}else{
				home.sound = new Sound(new URLRequest(home.list.getPaths()[home.index]));
				home.sound.addEventListener(Event.COMPLETE,fileComplete);
				home.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			}
		}

	}
	
}
