/*
Copyright (c) 2014, Miron Brezuleanu
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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