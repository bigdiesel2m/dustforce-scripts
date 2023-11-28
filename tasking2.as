/* 
Adjusted version of tasking.as
Made for the BRB during the Abrupt Showcase
*/

const string EMBED_stopwatch = "files/stopwatch.png";

class script {
	scene@ g;
	array <dustman@> players(4, null);
	controllable@ man = null;
	dustman@ king;
	
	bool jump_used = false;
	bool taunt_pressed = false;
	bool dash_pressed = false;
	int heavy_counter = 0;
	int light_counter = 0;

	bool left_active = false;
	bool right_active = false;
	bool up_active = false;
	bool down_active = false;
	bool jump_active = false;
	bool dash_active = false;
	bool light_active = false;
	bool heavy_active = false;
	bool advance_active = false;

	int time_main = 0;
	array <entity@> effects;
	int frame_count = 0;


	script() {
		@g = get_scene();
	}

    void build_sprites(message@ msg) {
		msg.set_string("stopwatch", "stopwatch");
    }
	
	// step and step_post handle the freezing and unfreezing of the TAS character
	// have to use both advance_active and advance_happening because the "advance" command is sent mid-step
	bool advance_happening = false;
	void step(int) {
		if( advance_active ) {
			time_main = 1;
			man.time_warp(time_main);
			if(man.hitbox() !is null)
				man.hitbox().time_warp(time_main);
			set_intents(@man);
			standardize_intents(@man);
			advance_active = false;
			advance_happening = true;
			frame_count++;
		}
		
		for(uint i = 0; i < effects.length(); i++) {
			effects[i].time_warp(time_main);
		}
		if (man.as_dustman().dead()) {
			king.kill(false);
		}
	}

	void step_post(int) {
		if( advance_happening ) {
			standardize_intents_post(@man);
			time_main = 0;
			man.time_warp(time_main);
			advance_happening = false;
			if(man.hitbox() !is null)
				man.hitbox().time_warp(time_main);
		}
		
		for(uint i = 0; i < effects.length(); i++) {
			effects[i].time_warp(time_main);
		}
	}

	// this makes sure attack and dash particles from the player are frozen too
	void entity_on_add(entity@ e) {
		if (e.type_name() == "effect") {
			string set = e.as_effect().sprite_set();
			if (set == 'vdustman' || set == 'vdustgirl' || set == 'vdustkid' || set == 'vdustworth') {
				effects.insertLast(e);
			}
		}
	}

	void on_level_start() {
		initialize();
	}
	
	void checkpoint_load() {
		initialize();
	}
	
	void initialize() {
		for(uint i=0; i < players.length(); i++) {
			if (@controller_controllable(i) != null) {
				@players[i] = controller_controllable(i).as_dustman();
			}
		}
		@king = players[0];

		@man = create_entity("dust_man").as_controllable();
		man.as_dustman().character(king.character());
		man.x(1020);
		man.y(0);
		man.time_warp(0);
		man.as_controllable().team(1);
		man.as_dustman().ai_disabled(true);
		man.as_dustman().auto_respawn(false);
		g.add_entity(man.as_entity(), false);
		
		king.character("trashking");
		king.filth_type(0);
	}

	// this part takes the inputs from the buttons and turns them into "mode 1" intents
	void set_intents(controllable@ man) {
		if (man is null)
			return;
		//direction intents
		if (left_active) {
			man.x_intent(-1);
		} else if (right_active) {
			man.x_intent(1);
		} else {
			man.x_intent(0);
		}
		if (down_active) {
			man.y_intent(1);
		} else if (up_active) {
			man.y_intent(-1);
		} else {
			man.y_intent(0);
		}
		//other intents
		if (light_active) {
			man.light_intent(10);
		} else {
			man.light_intent(0);
		}
		if (heavy_active) {
			man.heavy_intent(10);
		} else {
			man.heavy_intent(0);
		}
		if (jump_active) {
			man.jump_intent(1);
		} else {
			man.jump_intent(0);
		}
		if (dash_active) {
			man.dash_intent(1);
		} else {
			man.dash_intent(0);
		}
	}

	// all the following code for standardizing intents is courtesy of Skyhawk <3
	void standardize_intents(controllable@ player) {
		
		if (player is null)
			return;
		
		// dash is only 1 on the first frame it is pressed. after that, return it to 0
		int dash = player.dash_intent();
		if (dash > 0) {
			if (dash_pressed)
				player.dash_intent(0);
			
			// if it's the first frame dash is pressed, and the player is holding down
			// check if they should dash, fall, or both
			else if (player.y_intent() == 1) {
				player.fall_intent(1);
				if (!player.ground()) {
					player.dash_intent(0);
				}
			}
		}
		dash_pressed = dash > 0;
		
		// taunt is only 1 on the first frame it is pressed. after that, return it to 0
		int taunt = player.taunt_intent();
		if (taunt > 0 && taunt_pressed) {
			player.taunt_intent(0);
		}
		taunt_pressed = taunt > 0;
		
		// jump is 1 when held but unused, and 2 when it is held and already used
		if (player.jump_intent() > 0 && jump_used)
			player.jump_intent(2);
		else
			jump_used = false;
		
		// attacks are 10 when held but unused, and 11 when held and already used
		// when released and unused, attacks buffer by counting down to 0
		if (player.light_intent() == 10 && light_counter == 11) {
				player.light_intent(11);
		}
		else if (player.light_intent() == 0) {
			if (light_counter == 11)
				light_counter = 0;
			else if (light_counter > 0) {
				light_counter--;
				player.light_intent(light_counter);
			}
		}
		
		if (player.heavy_intent() == 10 && heavy_counter == 11) {
				player.heavy_intent(11);
		}
		else if (player.heavy_intent() == 0) {
			if (heavy_counter == 11)
				heavy_counter = 0;
			else if (heavy_counter > 0) {
				heavy_counter--;
				player.heavy_intent(heavy_counter);
			}
		}
	}
	
	/**
	 * Gathers information about which intents were used during the frame in order to correctly
	 * assign intents during future frames
	 */
	void standardize_intents_post(controllable@ player) {
		
		if (player is null)
			return;
		
		// even though the input mode has changed, the game will still change the intent to 2
		// if it was used during this frame
		if (player.jump_intent() == 2)
			jump_used = true;
		
		// for attacks, if the intent was used, it will be changed to 11. otherwise, it will stay 10
		if (player.light_intent() > 9)
			light_counter = player.light_intent();
		
		if (player.heavy_intent() > 9)
			heavy_counter = player.heavy_intent();
	}
}

class Leaderboard : trigger_base {
	script@ s;
	scripttrigger@ self;
	scene@ g;
	textfield@ tf;
	textfield@ tf2;
			
	void init(script@ s, scripttrigger@ self) {
		@this.s = s;
		@this.self = @self;
		@g = get_scene();

		@tf = create_textfield();
		tf.text("FRAME COUNT");
		tf.set_font("ProximaNovaReg", 72);
		tf.colour(0xFFFFFFFF);

		@tf2 = create_textfield();
		tf2.text("");
		tf2.set_font("ProximaNovaReg", 100);
		tf2.colour(0xFFFFFFFF);
	}

	void editor_draw(float subframe) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		float x = self.x();
		float y = self.y();
		tf.draw_world(20, 20, x, y, 1, 1, 0);
		tf2.text(""+s.frame_count);
		tf2.draw_world(20, 20, x-120, y+120, 1, 1, 0);
	}
}

[hidden]
class Button : trigger_base {
	script@ s;
	scripttrigger@ self;
	scene@ g;

	sprites@ spr;
	
	float x;
	float y;
	uint32 bg = 0xFFAAAAAA;
	uint32 color = 0xFF996600;

	void init(script@ s, scripttrigger@ self) {
		@this.s = s;
		@this.self = @self;
		@g = get_scene();
		
		@spr = create_sprites();
		spr.add_sprite_set("dustman");
		spr.add_sprite_set("props5");
		spr.add_sprite_set("script");
	}

	bool hitcheck() {
		int hits = g.get_entity_collision(y+20, y+80, x+20, x+80, 8);
		for (int i = 0; i < hits; i++) {
			hitbox@ hb = g.get_entity_collision_index(i).as_hitbox();
			if (hb.triggered() && hb.state_timer() == hb.activate_time() && hb.owner().is_same(s.king.as_controllable())) {
				return true;
			}
		}
		return false;
	}

    void editor_step() {
        self.x(round(self.x() / 6) * 6);
        self.y(round(self.y() / 6) * 6);
    }

	void editor_draw(float subframe) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		x = self.x();
		y = self.y();

		g.draw_quad_world(15, 20, false, x+25, y, x+25, y+100, x+75, y+100, x+75, y, bg, bg, bg, bg);
		g.draw_quad_world(15, 20, false, x, y+25, x, y+75, x+100, y+75, x+100, y+25, bg, bg, bg, bg);
		g.draw_quad_world(15, 20, false, x+25, y, x, y+25, x+75, y+100, x+100, y+75, bg, bg, bg, bg);
		g.draw_quad_world(15, 20, false, x, y+75, x+25, y+100, x+100, y+25, x+75, y, bg, bg, bg, bg);

		if (get_activation_state()) {
			color = 0xFFFFDD00;
		} else {
			color = 0xFF996600;
		}

		g.draw_quad_world(15, 20, false, x+27.5, y+5, x+27.5, y+95, x+72.5, y+95, x+72.5, y+5, color, color, color, color);
		g.draw_quad_world(15, 20, false, x+5, y+27.5, x+5, y+72.5, x+95, y+72.5, x+95, y+27.5, color, color, color, color);
		g.draw_quad_world(15, 20, false, x+27.5, y+5, x+5, y+27.5, x+72.5, y+95, x+95, y+72.5, color, color, color, color);
		g.draw_quad_world(15, 20, false, x+5, y+72.5, x+27.5, y+95, x+95, y+27.5, x+72.5, y+5, color, color, color, color);

		draw_image();
	}

	bool get_activation_state() {
		return false;  // dummy method
	}

	void draw_image() {
		return;  // dummy method
	}
}

class Left : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "symbol_1", 0, 0, x-36, y-48, 180, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			if (s.left_active) {
				s.left_active = false;
			} else {
				s.left_active = true;
				s.right_active = false;
			}
		}
	}

	bool get_activation_state() {
		return s.left_active;
	}
}

class Right : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "symbol_1", 0, 0, x+135, y+145, 0, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			if (s.right_active) {
				s.right_active = false;
			} else {
				s.right_active = true;
				s.left_active = false;
			}
		}
	}

	bool get_activation_state() {
		return s.right_active;
	}
}

class Up : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "symbol_1", 0, 0, x+145, y-35, 270, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			if (s.up_active) {
				s.up_active = false;
			} else {
				s.up_active = true;
				s.down_active = false;
			}
		}
	}

	bool get_activation_state() {
		return s.up_active;
	}
}

class Down : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "symbol_1", 0, 0, x-45, y+135, 90, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			if (s.down_active) {
				s.down_active = false;
			} else {
				s.down_active = true;
				s.up_active = false;
			}
		}
	}

	bool get_activation_state() {
		return s.down_active;
	}
}

class Jump : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "rising", 0, 0, x+50, y+70, 0, 0.6, 0.6, 0xBBFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.jump_active = !s.jump_active;
		}
	}

	bool get_activation_state() {
		return s.jump_active;
	}
}

class Dash : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "dash", 0, 0, x+35, y+70, 0, 0.6, 0.6, 0xBBFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.dash_active = !s.dash_active;
		}
	}

	bool get_activation_state() {
		return s.dash_active;
	}
}

class Light : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "dmgroundstrike2", 0, 0, x+30, y+75, 0, 0.4, 0.4, 0xBBFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.light_active = !s.light_active;
		}
	}

	bool get_activation_state() {
		return s.light_active;
	}
}

class Heavy : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "dmairheavyd", 0, 0, x+35, y+70, 0, 0.3, 0.3, 0xBBFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.heavy_active = !s.heavy_active;
		}
	}

	bool get_activation_state() {
		return s.heavy_active;
	}
}

class Advance : Button {
	void draw_image() {
		x = self.x();
		y = self.y();
		spr.draw_world(16, 19, "stopwatch", 0, 0, x+13, y+12, 0, 0.3, 0.3, 0xBBFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.advance_active = !s.advance_active;
		}
	}

	bool get_activation_state() {
		return s.advance_active;
	}
}