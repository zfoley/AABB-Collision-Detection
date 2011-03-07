package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Zach
	 */
	public class BoxCollisionDetection extends Sprite
	{
		private var _movingBox:AABB
		private var boxes:Vector.<AABB> = new Vector.<AABB>();
		private var redGlow:Array;
		private var noGlow:Array;
		//private var separationVector:Vector3D
		public function BoxCollisionDetection() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Make Moving boxes and floor.
			_movingBox = new AABB();
			
			while (boxes.length < 3) {
				var b:AABB = new AABB(50,50);
				b.y = 200;
				b.x = 150 + (b.halfwidth.x * 2 * boxes.length);
				b.position.x = b.x;
				b.position.y = b.y;
				addChild(b);
				boxes.push(b);
			}
			addChild(_movingBox);
			
			// create two arrays of filters for showing the collision
			redGlow = [new GlowFilter(0xFF0000, 1, 8, 8, 2, 3)];
			noGlow = [];
			
			// Add a listener to move one fo the balls.
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var velocity:Vector3D = _movingBox.position.subtract(new Vector3D(stage.mouseX, stage.mouseY));
			_movingBox.position.x = stage.mouseX;
			_movingBox.position.y = stage.mouseY;
			
			for (var i:int = 0; i < boxes.length; i++) 
			{
				var separation:Vector3D = boxes[i].position.subtract(_movingBox.position);							
				var tangentDistanceX:Number = (boxes[i].halfwidth.x + _movingBox.halfwidth.x);
				var tangentDistanceY:Number = (boxes[i].halfwidth.y + _movingBox.halfwidth.y);
				if (Math.abs(separation.x) < (tangentDistanceX) && Math.abs(separation.y) < (tangentDistanceY)){
					// Box Is Colliding
					trace(i, _movingBox.position, separation);
					boxes[i].filters = redGlow;
					//Find Out which separation is shorter.
					var ySeparation:Number = Math.abs(Math.abs(separation.y) - tangentDistanceY);
					var xSeparation:Number = Math.abs(Math.abs(separation.x) - tangentDistanceX);
					if (xSeparation >= ySeparation) {
						// ySeparation is smaller, so separate along the Y axis
						if(separation.y <0){
							_movingBox.position.y += ySeparation;//boxes[i].position.y + tangentDistanceY;
						} else {
							_movingBox.position.y -= ySeparation;//boxes[i].position.y - tangentDistanceY;
						}
							
					} else if (ySeparation > xSeparation) {
						// xSeparation is smaller, so separate along the X axis
						if(separation.x <0){
							_movingBox.position.x += xSeparation; //boxes[i].position.x + tangentDistanceX;
						} else {
							_movingBox.position.x -= xSeparation; //= boxes[i].position.x - tangentDistanceX;
						}
					}
				} else {
					boxes[i].filters = noGlow;
				}

			}			
			_movingBox.x = _movingBox.position.x//-_movingBox.halfwidth.x;
			_movingBox.y = _movingBox.position.y//-_movingBox.halfwidth.y;
		}
		
				
	}

}