/*
Copyright (c) 2015, Miron Brezuleanu
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
import me.mbrezu.haxisms.Json;
import me.mbrezu.napetest.KeyboardState.KeySet;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class KeySet {
	public var leftPressed(default, default): Bool;
	public var rightPressed(default, default): Bool;
	public var firePressed(default, default): Bool;
	
	public function new() {
		leftPressed = false;
		rightPressed = false;
		firePressed = false;
	}
	
	public function toJson(): JsonValue {
		var map = new Map<String, JsonValue>();
		map["left"] = Js.bool(leftPressed);
		map["right"] = Js.bool(rightPressed);
		map["fire"] = Js.bool(firePressed);
		return Js.obj(map);
	}
	
	public static function fromJson(js: JsonValue) {
		var result = new KeySet();
		result.leftPressed = js.obj.get("left").bool;
		result.rightPressed = js.obj.get("right").bool;
		result.firePressed = js.obj.get("fire").bool;
		return result;
	}
	
	public function copyFrom(other: KeySet) {
		leftPressed = other.leftPressed;
		rightPressed = other.rightPressed;
		firePressed = other.firePressed;
	}
}

class KeyboardState
{
	public var keySet1: KeySet;
	public var keySet2: KeySet;

	public function new() 
	{
		keySet1 = new KeySet();
		keySet2 = new KeySet();
	}
	
	private function setKeys(evt: KeyboardEvent, value: Bool) {
		var left1KeyCode = 80;
		var right1KeyCode = 81;
		var fire1KeyCode = 83;
		var left2KeyCode = 90;
		var right2KeyCode = 123;
		var fire2KeyCode = 88;

		if (evt.keyCode == left1KeyCode) {
			keySet1.leftPressed = value;
		} else if (evt.keyCode == right1KeyCode) {
			keySet1.rightPressed = value;
		} else if (evt.keyCode == fire1KeyCode) {
			keySet1.firePressed = value;
		} else if (evt.keyCode == left2KeyCode) {
			keySet2.leftPressed = value;
		} else if (evt.keyCode == right2KeyCode) {
			keySet2.rightPressed = value;
		} else if (evt.keyCode == fire2KeyCode) {
			keySet2.firePressed = value;
		}
	}
	
	public function handleKeyDown(e: KeyboardEvent) {
		setKeys(e, true);
	}
	
	public function handleKeyUp(e: KeyboardEvent) {
		//trace(e.keyCode);
		setKeys(e, false);		
	}
	
	public function toJson(): JsonValue {
		return Js.arr([keySet1.toJson(), keySet2.toJson()]);
	}
	
	public static function fromJson(js: JsonValue) {
		var result = new KeyboardState();
		result.keySet1 = KeySet.fromJson(js.arr[0]);
		result.keySet2 = KeySet.fromJson(js.arr[1]);
		return result;
	}
	
	public function copyFrom(other: KeyboardState) {
		keySet1.copyFrom(other.keySet1);
		keySet2.copyFrom(other.keySet2);
	}
	
}