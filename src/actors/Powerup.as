package actors 
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import screens.GameScreen;
	/**
	 * ...
	 * @author ...
	 */
	public class Powerup extends MovieClip
	{
		private var t:Timer =  new Timer(4000);
		private var p:MovieClip;
		
		public function Powerup() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(new PowerupArt());
			this.enabled = false;
			
			this.visible = true;
			p = parent as MovieClip;
			onTime(null);
		}		
		private function toggle(ms:uint = 4000):void 
		{
			t.stop();
			t.delay = ms;
			t.repeatCount = 1;
			t.addEventListener(TimerEvent.TIMER, onTime);
			t.start();
		}		
		private function onTime(e:TimerEvent):void 
		{
			if (this.visible)
			{
				remove();
			}
			else
			{
				add();
			}			
			
		}
		public function remove():void
		{
			this.visible = false;
			this.x = - 1000;
			toggle(6000 + Math.random() * 6000);
			
		}
		private function add():void
		{
			this.visible = true;
			this.x = 250 + Math.random() * (stage.stageWidth - 500);  //wtf no stage?!!?!?!
			this.y = Math.random() * stage.stageHeight;
			toggle(6000 + Math.random() * 6000);
		}
		
		public function destroy():void
		{
			t.stop();
			t.removeEventListener(TimerEvent.TIMER, onTime);
		}
		
	}

}