package actors 
{
	import utils.Controller;	
	import flash.events.Event;
	/**
	 * ...
	 * @author erwin henraat
	 */
	public class Player extends Paddle 
	{
		private var controller:Controller;
		private var speed:Number = 0;
		private var maxSpeed:Number = 10;
		
		public function Player() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);		
		}		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			controller = new Controller(stage);
			this.addEventListener(Event.ENTER_FRAME, loop);			
		}
		private function loop(e:Event):void 
		{
			if (controller.up)
			{
				speed = -17;
			}
			else if(controller.down)
			{
				speed = 17;
			}else
			{
				if (speed > 0) speed--;
				if (speed < 0) speed++;
				
			}
			if (controller.fire)
			{
				
				
			}
			if (this.y < 0) this.y = 0;
			if (this.y > stage.stageHeight) this.y = stage.stageHeight;

			this.y += speed;
			
			
		}
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);	
			
		}
		
		//Opdr Getters en Setters
		public function setMaxSpeed(waarde:Number):void {
			if (waarde > 30){
				trace ("maxspeed cannot be more than 30!");
				maxSpeed = 30;
				return;
			}
			maxSpeed = waarde;
		}
		
		//Opdr Getters en Setters
		public function getMaxSpeed():Number{
			return maxSpeed;
		}
		
	}

}