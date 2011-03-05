package  
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class AABB extends Sprite
	{
		private var _halfwidth:Vector3D = new Vector3D();
		private var _position:Vector3D = new Vector3D();
		private var _color:uint;
		public function AABB(w:Number=25, h:Number = 25) 
		{	
			_color = Math.random() * 0xFFFFFF;			
			halfwidth = new Vector3D(w, h);
		}
		
		public function get halfwidth():Vector3D { return _halfwidth; }
		
		public function set halfwidth(value:Vector3D):void 
		{
			_halfwidth = value;
			draw();
		}
		
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(_color, 1);
			this.graphics.drawRect( -_halfwidth.x, -_halfwidth.y, _halfwidth.x * 2, _halfwidth.y * 2);
			this.graphics.beginFill(0, 1);
			this.graphics.drawCircle(0, 0, 2);
			this.graphics.endFill();
		}
		
		public function get position():Vector3D { return _position; }
		
		public function set position(value:Vector3D):void 
		{
			_position = value;
		}
		
		
	}

}