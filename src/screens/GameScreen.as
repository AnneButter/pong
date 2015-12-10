package screens 
{
	import actors.AI;
	import actors.Ball;
	import actors.Obstacle;
	import actors.Paddle;
	import actors.Player;
	import actors.Powerup;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import utils.MovementCalculator;
	import screens.Scoreboard;
	
	/**
	 * ...
	 * @author erwin henraat
	 */
	public class GameScreen extends Screen
	{
		private var balls:Array = [];
		private var paddles:Array = [];
		private var scoreboard:Scoreboard;
		private var obstacles:Array = [];
		private var powerups:Array = [];
		
		static public const GAME_OVER:String = "game over";
		static public const BALL_BOUNCE:String = "ballBounce";
		public function GameScreen() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);			
		}				
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Opdr Getters en Setters
			var speler:Player = new Player();
			speler.setMaxSpeed(15);
			
				for (var i:int = 0; i < 3; i++)					//aantal balletjes 
				{
				balls.push(new Ball(speler.getMaxSpeed()));	//Opdr Getters en Setters
				addChild(balls[i]);
				balls[i].reset();
				
				balls[i].addEventListener(Ball.OUTSIDE_RIGHT, onRightOut);
				balls[i].addEventListener(Ball.OUTSIDE_LEFT, onLeftOut);
				
				}	
			paddles.push(new AI());
			paddles.push(speler);
			paddles[0].balls = balls;
			
			for (i = 0; i < 2; i++) 
			{
				addChild(paddles[i]);
				paddles[i].y = stage.stageHeight / 2;
			}	
			paddles[0].x = stage.stageWidth - 100;
			
			paddles[1].x = 100;
			
			for (var j:int = 0; j < 4; j++) 
			{
				obstacles.push(new Obstacle());
				addChild(obstacles[j]);
			}
			for (var p:int = 0; p < 1; p++) 
			{
				powerups.push(new Powerup());
				addChild(powerups[p]);
			}

			scoreboard = new Scoreboard();
			addChild(scoreboard);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}		
		
		private function loop(e:Event):void 
		{
			checkCollision();
		}	
		private function checkCollision():void 
		{
			for (var i:int = 0; i < balls.length; i++) 
			{
				for (var j:int = 0; j < obstacles.length; j++)
				{
					if (obstacles[j].hitTestObject(balls[i]))
					{
						if (balls[i].xMove > 0 && balls[i].x < obstacles[j].x || balls[i].xMove < 0 && balls[i].x > obstacles[j].x)
						{
							balls[i].xMove *= -1;							
							//balls[i].x += obstacles[j].x - balls[i].x;
							dispatchEvent(new Event(BALL_BOUNCE));
						}	
						if (balls[i].yMove > 0 && balls[i].y < obstacles[j].y || balls[i].yMove < 0 && balls[i].y > obstacles[j].y)
						{
							balls[i].yMove *= -1;							
							//balls[i].y += obstacles[j].y - balls[i].y;
							dispatchEvent(new Event(BALL_BOUNCE));
							
							obstacles[j].remove();
							
						}
						
					}
					
						
				}
				for (var p:int = 0; p < powerups.length; p++)
				{
					if (powerups[p].hitTestObject(balls[i]))
					{
						if (balls[i].xMove > 0 && balls[i].x < powerups[p].x || balls[i].xMove < 0 && balls[i].x > powerups[p].x)
						{
							balls[i].xMove *= -1;							
							//balls[i].x += obstacles[j].x - balls[i].x;
							dispatchEvent(new Event(BALL_BOUNCE));
						}	
						if (balls[i].yMove > 0 && balls[i].y < powerups[p].y || balls[i].yMove < 0 && balls[i].y > powerups[p].y)
						{
							balls[i].yMove *= -1;							
							//balls[i].y += obstacles[j].y - balls[i].y;
							dispatchEvent(new Event(BALL_BOUNCE));
						
							powerups[p].remove();
							
							for (var b:int = 0; b < balls.length; b++){
								balls[b].changeSize(); 
							}
						}
					}
				}
				
				for (j = 0; j < paddles.length; j++) 
				{
					if (paddles[j].hitTestObject(balls[i]))
					{
						if (balls[i].xMove > 0 && balls[i].x < paddles[j].x || balls[i].xMove < 0 && balls[i].x > paddles[j].x)
						{
							balls[i].xMove *= -1;							
							//balls[i].x += paddles[j].x - balls[i].x;
							dispatchEvent(new Event(BALL_BOUNCE));
						}	
						if (balls[i].yMove > 0 && balls[i].y < paddles[j].y || balls[i].yMove < 0 && balls[i].y > paddles[j].y)
						{
							balls[i].yMove *= -1;							
							//balls[i].y += paddles[j].y - balls[i].y;
							dispatchEvent(new Event(BALL_BOUNCE));
							
						}
						
						
					}
				}
			}
			
		}
		private function onLeftOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			
			scoreboard.player2 += 1;
			
			checkScore();
		}		
		private function onRightOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			scoreboard.player1 += 1;
			
			checkScore();
		}		
		
		private function checkScore():void 
		{
			if (scoreboard.player1 >= 20 || scoreboard.player2 >= 20)
			{
				destroy();
					
				dispatchEvent(new Event(GAME_OVER));
				
			}

			
		}
			
		private function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			for (var i:int = 0; i < balls.length; i++) 
			{
				balls[i].destroy();
				removeChild(balls[i]);
			}
			for (i = 0; i < paddles.length; i++) 
			{
				if (paddles[i] is Player) paddles[i].destroy();
			}
			for (i = 0; i < obstacles.length; i++) 
			{
				obstacles[i].destroy();
			}
			for (i = 0; i < powerups.length; i++) 
			{
				powerups[i].destroy();
			}
			balls.splice(0, balls.length);
		}
	}

}