package siyeol.player.core{
	import siyeol.player.playlist.Playlist;
	import siyeol.player.graphic.Graphic;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	import flash.media.SoundTransform;
	
	public class Player {
		
		public var list : Playlist;
		public var control : Controller;
		public var graphic : Graphic;
		public var Loop : Boolean;
		public var Shuffle : Boolean;
		public var sound : Sound;
		public var soundChannel : SoundChannel;
		public var transform : SoundTransform;
		public var index : int = 0;
		public var pausePosition : int = 0;
		public var isPlay : Boolean;
		public var time : int;
		public var volume : int;
		public var minutes : int;
		public var seconds : int;
		
		public function Player( list : Playlist , control : Controller , graphic : Graphic ) {
			this.list = list;
			this.control = control;
			this.graphic = graphic;
			
			list.home = this;
			control.home = this;
			graphic.home = this;
			
			if(list.saving.data.loop == null || list.saving.data.loop == undefined){
				list.saving.data.loop = false;
			}else{
				Loop = list.saving.data.loop;
			}
			
			if(list.saving.data.shuffle == null || list.saving.data.shuffle == undefined){
				list.saving.data.shuffle = false;
			}else{
				Shuffle = list.saving.data.shuffle;
			}
			
			if( list.saving.data.volume == null || list.saving.data.volume == undefined ){
				list.saving.data.volume = 1;
				volume = 1;
			}else{
				volume = list.saving.data.volume;
			}
			
			for(var i = 0; i < list.getNames().length; i++){
				graphic.addList(list.getNames()[i],i);
			}
			
			if(list.getPaths()[index] == null){
				return;
			}

			sound = new Sound(new URLRequest(list.getPaths()[index]));
			sound.addEventListener(Event.COMPLETE,fileComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		public function process(){
			var estimatedLength : int = Math.ceil(sound.length);
			var playbackPercentage : uint = Math.round(100*(soundChannel.position/estimatedLength));
			
			var running_time = Math.round(soundChannel.position/1000);

			graphic.setTimeText(Math.floor(running_time / 60)+":"+(running_time % 60) + " / "+minutes+":"+seconds);
			graphic.setX((265.95 / 100) * playbackPercentage);
		}
		
		public function isLoop():Boolean{
			return Loop;
		}
		
		private function fileComplete(e:Event):void{
			minutes = Math.floor((sound.length/1000) / 60);
			seconds = Math.floor((sound.length/1000) % 60);
			time = Math.floor(sound.length/1000);
			graphic.setTimeText("0:0 / "+minutes+":"+seconds);
			soundChannel = sound.play();
			soundChannel.stop();
			transform = soundChannel.soundTransform;
			transform.volume = volume;
			soundChannel.soundTransform = transform;
			graphic.setInfoText(list.getNames()[index]);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			graphic.removeList(index);
			list.getPaths().splice(index,1);
			list.getNames().splice(index,1);
			if(list.getPaths()[index] == undefined){
				control.next();
			}else{
				sound = new Sound(new URLRequest(list.getPaths()[index]));
				sound.addEventListener(Event.COMPLETE,fileComplete);
				sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			}
		}

	}
	
}
