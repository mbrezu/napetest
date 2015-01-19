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
package me.mbrezu.napetest ;

import haxe.ds.Vector;
import me.mbrezu.haxisms.Random;
import me.mbrezu.haxisms.Time.Cooldown;
import me.mbrezu.haxisms.Time.TimeManager;
import me.mbrezu.hxmp.Client;
import me.mbrezu.hxmp.Client.IClientState;
import me.mbrezu.hxmp.Server;
import me.mbrezu.hxmp.Server.IServerState;
import me.mbrezu.nape.DebugView;
import me.mbrezu.napetest.Main.ServerState;
import me.mbrezu.napetest.view.Data;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.dynamics.InteractionGroup;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import openfl._v2.Memory;
import openfl.display.Sprite;
import nape.geom.Vec2;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import me.mbrezu.haxisms.Json;

#if neko
import neko.vm.Thread;
#elseif windows
import cpp.vm.Thread;
#end

class ServerState implements IServerState {	
	
	private var tm: TimeManager;
	private var gs: GameState;
	
	public function new(w: Float, h: Float) {
		tm = new TimeManager();
		gs = new GameState(w, h, null);
	}
	
	public function getState(): String {
		return Js.stringify(gs.toJson());
	}
	
	public function handleCommand(command: String): String {
		return null;
	}
	
	public function mainLoop(): String {
		var deltaTime = tm.getDeltaTime();
		var frameTime = 1.0 / 60.0;
		trace(deltaTime, frameTime);
		if (deltaTime < frameTime) {
			Sys.sleep(frameTime - deltaTime);
		}
		gs.update();
		//return null;
		return getState();
	}	
}

class ClientState implements IClientState {
	private var uiThread: Thread;
	public var client: Client;
	public function new(uiThread: Thread) {
		this.uiThread = uiThread;
	}
	public function handleUpdate(update: String): Void {	
		uiThread.sendMessage(update);
	}
}

class Button extends Sprite {
	public function new(text: String, action: Void -> Void) {
		super();
		var textField = new TextField();
		textField.selectable = false;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.backgroundColor = 0xaacc44;
		textField.background = true;
		textField.text = text;
		textField.scaleX = 2;
		textField.scaleY = 2;
		textField.border = true;
		textField.borderColor = 0x0;
		textField.addEventListener(MouseEvent.CLICK, function(e) {
			action();
		});
		addChild(textField);
	}
}

class Main extends Sprite {
	
	private static inline var COMMANDS_PORT = 12567;
	private static inline var UPDATES_PORT = 12568;
	
	public function new () {
		
		super ();
		
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		var server = null;
		var client = null;
		
		var btnServer = new Button("Server", function() {
			if (server == null) {
				server = new Server(COMMANDS_PORT, UPDATES_PORT, new ServerState(w, h));
			}
			trace("server started");
		});		
		addChild(btnServer);
		
		var btnClient = new Button("Client", function() {
			if (client == null) {
				var clientState = new ClientState(Thread.current());
				client = new Client("127.0.0.1", COMMANDS_PORT, UPDATES_PORT, clientState);
				clientState.client = client;
			}			
		});
		btnClient.x = 200;
		addChild(btnClient);
		
		stage.addEventListener(Event.ENTER_FRAME, function(e) {
			var counter = 0;
			var message: String = null;
			while (true) {
				//trace("g1");
				var msg = Thread.readMessage(false);
				//trace("g2");
				if (msg == null) {
					break;
				}
				counter ++;
				message = cast(msg, String);
				trace(message.length);
				//trace("g2.1");
				//trace("g3");
			}
			if (counter > 0) {
				trace(counter);
			}
			if (message != null) {
				graphics.clear();
				//trace("g2.2");
				var js = Js.parse(new StringReader(message));
				//trace("g2.3");
				new Data(js).draw(graphics);					
			}
		});
	}
}
