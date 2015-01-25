package me.mbrezu.napetest;

import openfl.Assets;
import sys.io.File;
import me.mbrezu.haxisms.Json;

class Config
{

	public var maxBattery(default, null): Float;
	public var minBattery(default, null): Float;
	public var fireCost(default, null): Float;
	public var hitCost(default, null): Float;
	public var rechargeBase(default, null): Float;
	public var rechargeExp(default, null): Float;
	public var enemyAppearInterval(default, null): Float;
	public var enemyFireInterval(default, null): Float;
	public var enemyMinSpeed(default, null): Float;
	public var enemyMaxSpeed(default, null): Float;
	
	private function new() 
	{
		var js = Js.parse(new StringReader(Assets.getText("assets/config.json")));
		maxBattery = js.obj.get("maxBattery").float;
		minBattery = js.obj.get("minBattery").float;
		fireCost = js.obj.get("fireCost").float;
		hitCost = js.obj.get("hitCost").float;
		rechargeBase = js.obj.get("rechargeBase").float;
		rechargeExp = js.obj.get ("rechargeExp").float;
		enemyAppearInterval = js.obj.get ("enemyAppearInterval").float;
		enemyFireInterval = js.obj.get ("enemyFireInterval").float;
		enemyMinSpeed = js.obj.get ("enemyMinSpeed").float;
		enemyMaxSpeed = js.obj.get ("enemyMaxSpeed").float;
	}
	
	private static var instance;
	
	public static function getInstance() {
		if (instance == null) {
			instance = new Config();
		}
		return instance;
	}
	
}