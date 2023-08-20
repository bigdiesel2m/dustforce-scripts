/* 
Avant-garde script
*/

class script {
    scene@ g;
    array <dustman@> players(4, null);
    entity@ man = null;
	dustman@ king;

	bool left_active = false;
	bool right_active = false;
	bool up_active = false;
	bool down_active = false;


    script() {
        @g = get_scene();
    }
	
	void step(int entities) {
		
	}

	/*
	void input() {
		man.as_controllable().x_intent(x_status);
		man.as_controllable().y_intent(y_status);
		man.as_controllable().heavy_intent(heavy_status);
		man.as_controllable().light_intent(light_status);
		man.as_controllable().dash_intent(dash_status);
		man.as_controllable().jump_intent(jump_status);
		man.as_controllable().fall_intent(fall_status);
	}
	*/
	
    void draw(float subframe) {
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
		@man = create_entity("dust_man");
	}
}

[hidden]
class Button : trigger_base {
	script@ s;
	scripttrigger@ self;
	scene@ g;

	sprites@ spr;
	sprites@ spr2;
	
	float x;
	float y;
	uint32 bg = 0xFFAAAAAA;
	uint32 color = 0xFF777700;

	void init(script@ s, scripttrigger@ self) {
		@this.s = s;
		@this.self = @self;
        @g = get_scene();
		
		@spr = create_sprites();
		@spr2 = create_sprites();
		spr.add_sprite_set("dustman");
		spr2.add_sprite_set("props5");
	}
	
	bool hitcheck() {
		int hits = g.get_entity_collision(y+20, y+80, x+20, x+80, 8);
        for (int i = 0; i < hits; i++) {
            hitbox@ hb = g.get_entity_collision_index(i).as_hitbox();
            if (hb.triggered() && hb.state_timer() == hb.activate_time()) {
				return true;
			}
		}
		return false;
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
			color = 0xFFDDDD00;
		} else {
			color = 0xFF777700;
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
		spr2.draw_world(16, 19, "symbol_1", 0, 0, x-36, y-48, 180, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.left_active = !s.left_active;
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
		spr2.draw_world(16, 19, "symbol_1", 0, 0, x+135, y+145, 0, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.right_active = !s.right_active;
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
		spr2.draw_world(16, 19, "symbol_1", 0, 0, x+145, y-35, 270, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.up_active = !s.up_active;
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
		spr2.draw_world(16, 19, "symbol_1", 0, 0, x-45, y+135, 90, 1, 1, 0xFFFFFFFF);
	}

	void step() {
		if (hitcheck()) {
			s.down_active = !s.down_active;
		}
	}

	bool get_activation_state() {
		return s.down_active;
	}
}