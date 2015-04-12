package siyeol.player.playlist{
	import siyeol.player.core.Player;
	import flash.net.SharedObject;
	
	public class Playlist {

		public var saving : SharedObject = SharedObject.getLocal("m_player");
		public var home : Player;
		private var list_path : Array = new Array;
		private var list_name : Array = new Array;
		
		public function Playlist() {
			if(saving.data.list_path != null){
				list_path = saving.data.list_path;
				list_name = saving.data.list_name;
			}else{
				saving.data.list_path = list_path;
				saving.data.list_name = list_name;
				saveList();
			}
		}
		
		public function getPaths():Array{
			return list_path;
		}
		
		public function getNames():Array{
			return list_name;
		}
		
		public function lastIdx():int{
			if(saving.data.ldx == null){
				return 0;
			}else{
				return saving.data.idx;
			}
			
			return 0;
		}
		
		private function saveList():void{
			saving.data.list_path = list_path;
			saving.data.list_name = list_name;
			saving.flush();
		}
		
		public function addList( path : String , name : String ):void{
			for(var i = 0; i < list_path.length; i++){
				if(list_path[i] == path){
					trace("파일이 이미 존재 합니다.");
					return;
				}
			}
			list_path.push(path);
			list_name.push(name);
			home.graphic.addList(name,list_name.length-1);
			saveList();
		}
		
		public function resetList():void{
			saving.data.list = null;
		}
		
		public function removeList( idx : int ):void{
			list_path.splice(idx,1);
			list_name.splice(idx,1);
		}
		
		

	}
	
}
/*
function scroll_arr(_from : int , _to : int , _arr : Array):Array{
	
	var temp_1;
	var temp_2 = _arr[_from];
	
	for(var i = _to; i < _from+1; i++){
		temp_1 = _arr[i];
		_arr[i] = temp_2;
		temp_2 = temp_1;
	}
	
	return _arr;
	
}

function i_scroll_arr(_from : int , _to : int , _arr : Array):Array{
	
	var temp_1;
	var temp_2 = _arr[_from];
	
	for(var i = _to; i > _from-1; i--){
		temp_1 = _arr[i];
		_arr[i] = temp_2;
		temp_2 = temp_1;
	}

	return _arr;
	
}
*/