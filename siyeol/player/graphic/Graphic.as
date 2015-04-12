package siyeol.player.graphic{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import siyeol.player.core.Player;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	
	public class Graphic extends Sprite {

		public var home : Player;
		private var progress : MovieClip;
		private var lists : MovieClip;
		private var time : TextField;
		private var control : MovieClip;
		private var info : TextField;
		private var content : MovieClip;
		private var content_in : mlist;
		private var contentArr : Array;
		private var win : NativeWindow;
		private var opts : NativeWindowInitOptions;
		private var win_point : Point = new Point(200,200);
		private var win_size : Point = new Point(320,500);
		
		public function Graphic( progress : MovieClip , lists : MovieClip , time : TextField , control : MovieClip , info : TextField , content_in : mlist ) {
			this.progress = progress;
			this.lists = lists;
			this.time = time;
			this.control = control;
			this.info = info;
			this.content = lists.content_box;
			this.content_in = content_in;
			this.contentArr = new Array();
			
			this.progress.addEventListener(MouseEvent.CLICK,pControl);
			this.lists.addEventListener(MouseEvent.MOUSE_WHEEL,onScroll);
			
			initListView();
		}
		
		public function setX( _x : int ):void{
			progress.bar.x = _x;
		}
		
		public function addList( _text : String , _index : int ):void{
			//trace(_text,_index);
			var mc : mlist = new mlist;
			var upButtonText:TextField = DisplayObjectContainer(mc.upState as DisplayObjectContainer).getChildAt(1) as TextField;
			var overButtonText:TextField = DisplayObjectContainer(mc.overState as DisplayObjectContainer).getChildAt(1) as TextField;
			var downButtonText:TextField = DisplayObjectContainer(mc.downState as DisplayObjectContainer).getChildAt(1) as TextField;
			upButtonText.text = _text;
			overButtonText.text = _text;
			downButtonText.text = _text;
			mc.y = 35 * _index;
			mc.index = _index;
			mc.addEventListener(MouseEvent.CLICK,onListClick);
			content.addChild(mc);
			contentArr.push(mc);
		}
		
		public function removeList( _index : int ):void{
			content.removeChild(contentArr[_index]);
			for(var i = _index; i < home.list.getPaths().length; i++){
				contentArr[i].index --;
				contentArr[i].y -= 35;
			}
			contentArr.splice(_index,1);
		}
		
		public function setTimeText( _text : String ):void{
			time.text = _text;
		}
		
		public function setControlFrame( _frame : int ):void{
			trace(11);
			control.gotoAndStop(_frame);
			//race(progress.currentFrame);
		}
		
		public function setInfoText( _text : String ):void{
			info.text = _text;
		}
		
		private function pControl(e:MouseEvent):void{

			var temp_position = Math.round((progress.mouseX / 265.95)*100) / 100 * home.sound.length;
			home.control.moveTo(temp_position);
			setX(progress.mouseX);
			
		}
		
		private function onComplete(e:Event):void{
			if(home.isLoop()){
				home.control.next();
			}else{
				home.isPlay = false;
			}
		}
		
		private function onScroll(e:MouseEvent):void{
			if(e.delta < 0){
				//Scroll Down
				content.y -= 5;
			}else{
				//Scroll Up
				content.y += 5;
			}
		}
		
		private function onListClick(e:MouseEvent):void{
			home.control.changeMusic(e.target.index);
		}
		
		private function initListView():void{
			opts = new NativeWindowInitOptions();
 			opts.systemChrome = NativeWindowSystemChrome.NONE;
			opts.type = NativeWindowType.LIGHTWEIGHT;
			opts.transparent = true;
			win = new NativeWindow(opts);
			win.activate();
			win.close();
		}
		
		public function openListView():void{
			if(win.closed){
				opts = new NativeWindowInitOptions();
 
				win = new NativeWindow(opts);
				win.title = "Playlist";
				win.stage.align = StageAlign.TOP_LEFT;
				win.stage.scaleMode = StageScaleMode.NO_SCALE;
				win.maxSize = new Point(320,500);
				win.minSize = new Point(220,300);
				win.x = win_point.x;
				win.y = win_point.y;
				win.width = win_size.x;
				win.height = win_size.y;
				
				win.addEventListener(NativeWindowBoundsEvent.MOVE,moved_window);
				win.addEventListener(NativeWindowBoundsEvent.RESIZE,resized_window);
				
				win.activate();
				win.stage.addChild(lists);
			}else{
				if(NativeWindow.supportsNotification){
					win.notifyUser("NotificationType.INFORMATIONAL");
				}
			}
		}
		
		public function closeListView():void{
			win.close();
		}
		
		private function moved_window(e:NativeWindowBoundsEvent):void{
			win_point = new Point(e.afterBounds.x,e.afterBounds.y);
		}
		
		private function resized_window(e:NativeWindowBoundsEvent):void{
			win_size = new Point(e.afterBounds.width,e.afterBounds.height);
		}
		
	}
	
}
