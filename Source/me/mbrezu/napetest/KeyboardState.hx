package me.mbrezu.napetest;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class KeyboardState
{
	
	public var leftPressed(default, null): Bool;
	public var rightPressed(default, null): Bool;
	public var firePressed(default, null): Bool;

	public function new() 
	{
		leftPressed = false;
		rightPressed = false;
		firePressed = false;
	}
	
	private function setKeys(evt: KeyboardEvent, value: Bool) {
		#if !windows
		var leftKeyCode = 112;
		var rightKeyCode = 113;
		var fireKeyCode = 32;
		#else 
		var leftKeyCode = 80;
		var rightKeyCode = 81;
		var fireKeyCode = 32;
		#end

		if (evt.keyCode == leftKeyCode) {
			leftPressed = value;
		} else if (evt.keyCode == rightKeyCode) {
			rightPressed = value;
		} else if (evt.keyCode == fireKeyCode) {
			firePressed = value;
		}
	}
	
	public function handleKeyDown(e: KeyboardEvent) {
		setKeys(e, true);
	}
	
	public function handleKeyUp(e: KeyboardEvent) {
		setKeys(e, false);
	}
	
}