package  
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
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
		private var _projectionAxis:Line;
		private var stageCenter:Vector3D;
		private var mousePosition:Vector3D;		
		public function BoxCollisionDetection() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageCenter = new Vector3D(stage.stageWidth / 2, stage.stageHeight / 2);
			//Make Moving boxes and floor.
			_movingBox = new AABB();
			_movingBox.alpha = 0.5
			_movingBox.x = stageCenter.x;
			_movingBox.y = stageCenter.y;
			_projectionAxis = new Line();			
			addChild(_projectionAxis);
			while (boxes.length < 0) {
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
			graphics.clear();
			// Draw Line
			
			drawLine();
		}
		
		private function drawLine():void
		{
			
			mousePosition = new Vector3D(stage.mouseX - stageCenter.x, stage.mouseY- stageCenter.y);
			mousePosition.normalize();		
			mousePosition.scaleBy(100);					
			var cross:Vector3D = new Vector3D(mousePosition.y, -mousePosition.x);
			var antiCross:Vector3D = new Vector3D( -mousePosition.y, mousePosition.x);
			var maxExtent:Number = Number.MIN_VALUE;
			var minExtent:Number= Number.MAX_VALUE;
			trace(":::::");
			for (var i:int = 0; i < _movingBox.extents.length; i++) 
			{
				var closesetPoint:Vector3D = projectVectorOntoAxis(_movingBox.extents[i], cross);
				var direction:Number = closesetPoint.dotProduct(cross) < 0 ? -1 : 1;
				//trace(i, closesetPoint.length, direction);
				maxExtent = Math.max(direction * closesetPoint.length, maxExtent);
				minExtent = Math.min(direction * closesetPoint.length, minExtent);
			}
			trace("maxExtent, minExtent, ", maxExtent, minExtent);
			// Translate the points in order to draw our Line object.
			// This part is purely decorative. It does not figure into the collision calculation
			mousePosition = mousePosition.add(stageCenter);
			antiCross = antiCross.add(mousePosition);
			cross = cross.add(mousePosition);
			_projectionAxis.fromTo(cross, antiCross);
			
		}
		
		private function projectVectorOntoAxis(vector:Vector3D, axis:Vector3D):Vector3D
		{
			var v1:Vector3D = vector;
			var v2:Vector3D = axis;
			
			// Length of projection v1 onto v2. 
			//var projection:Number = (v1.dotProduct(v2) / (v2.lengthSquared)) * v2.length;
			
			// Alternate means of calculating using normalized v2.  
			// If v2 is a unit vector this is much faster because the divison of the lengthSquared is division by 1. Which means we can skip it altogether. 
			var w:Vector3D = v2.clone(); // We clone because normalize is destructive in actionscript.
			w.normalize(); // Convert to unit vector.
			// Projection 2 is the length of the projection of v1 onto v2. 
			var projection2:Number = v1.dotProduct(w) * w.length;			
			// We can get get a vector representing the projection of v1 onto v2 by scaling the normalized unit vector w by the projection length. 
			var orientedProjection:Vector3D = w.clone();
			orientedProjection.scaleBy(projection2);
			// Draw Closest point on line
			drawVectors(v1, v2, orientedProjection);		
			return orientedProjection;
		}
		
		private function drawVectors(a:Vector3D, b:Vector3D, pointOnLine:Vector3D):void
		{
			var offsetPoint:Vector3D = mousePosition.clone();
			offsetPoint = offsetPoint.add(stageCenter);

			this.graphics.beginFill(0x990000,1);
			this.graphics.drawCircle(offsetPoint.x + pointOnLine.x, offsetPoint.y + pointOnLine.y,2);
			this.graphics.endFill();
			
			graphics.lineStyle(1, 0x676767, 1);
			graphics.drawCircle(stageCenter.x, stageCenter.y, 4);
			graphics.lineStyle(1, 0x0000FF, 0.5);
			graphics.moveTo(stageCenter.x + a.x, stageCenter.y + a.y);
			graphics.lineTo(pointOnLine.x + offsetPoint.x, pointOnLine.y + offsetPoint.y);
			graphics.lineStyle();
		}
		
				
	}

}