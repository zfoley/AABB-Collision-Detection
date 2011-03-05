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
			
			while (boxes.length < 6) {
				var b:AABB = new AABB();
				b.y = 200;
				b.x = 50 + (b.halfwidth.x * 2 * boxes.length);
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
			_movingBox.position.x = stage.mouseX;
			_movingBox.position.y = stage.mouseY;
			for (var i:int = 0; i < boxes.length; i++) 
			{
				var separation:Vector3D = boxes[i].position.subtract(_movingBox.position);			
				trace(separation);
				if (Math.abs(separation.x) < (boxes[i].halfwidth.x + _movingBox.halfwidth.x) && Math.abs(separation.y) < (boxes[i].halfwidth.y + _movingBox.halfwidth.y)){
					// Box Is Colliding
					boxes[i].filters = redGlow;
				} else {
					boxes[i].filters = noGlow;
				}
				//var closestPoint:Vector3D = findClosestPoint(_movingBox, lines[i]);
				//collisionReaction(_movingBox, closestPoint, i);	
			}			
			_movingBox.x = _movingBox.position.x//-_movingBox.halfwidth.x;
			_movingBox.y = _movingBox.position.y//-_movingBox.halfwidth.y;
		}
				
	}

}