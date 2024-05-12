/* 
Reflection script
*/

class script: callback_base {
	[text] array<mirror> rectangles;
	array <effect@> effects;
	scene@ g;

	textfield@ tf;
	

	script() {
		@g = get_scene();
	}

	void entity_on_add(entity@ e) {
		if(e.type_name() == "effect") {
			effects.insertLast(e.as_effect());
		}
	}

	void entity_on_remove(entity@ e) {
		if(e.type_name() == "effect") {
			for (uint i=0; i<effects.size(); ++i) {
				if (effects[i].is_same(e)) {
					effects.removeAt(i);
				}
			}
		}
	}

	void step(int entities) {
		// for(uint i = 0; i < effects.length(); i++) {
		// 	puts(effects[i].sprite_set());
		// }
	}

	void draw(float subframe) {
		for (uint i=0; i<rectangles.size(); ++i) {
			rectangles[i].draw(g);
		}

		for(uint i = 0; i < effects.length(); i++) {
			tf.text(effects[i].sprite_set() + " - " + effects[i].state_timer() + " - " + effects[i].total_frames() + " - " + effects[i].destroyed());
			tf.draw_hud(20, 22, -780, i*50, 1.0, 1.0, 0.0);
		}
	}

	void editor_draw(float subframe) {
		for (uint i=0; i<rectangles.size(); ++i) {
			rectangles[i].editor_draw(g);
		}
	}
	
	void on_level_start() {
		initialize();
	}
	void checkpoint_load() {
		initialize();
	}
	void initialize() {
		for (uint i=0; i<rectangles.size(); ++i) {
			rectangles[i].init(g);
		}

		@tf = create_textfield();
		tf.text("");
		tf.set_font("ProximaNovaReg", 36);
		tf.colour(0xFF000000);
		tf.align_horizontal(-1);
		tf.align_vertical(1);
	}
}

class mirror {
	[text] int layer = 17;
	[text] int sublayer = 20;
	[position,mode:world,y:y1] float x1;
	[hidden] float y1;
	[position,mode:world,y:y2] float x2;
	[hidden] float y2;
	[boolean] bool blur = true;
	[boolean] bool debug = false;

	textfield@ tf;

	void init(scene@ g) {
		if (debug) {
			@tf = create_textfield();
			tf.text("");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFF000000);
			tf.align_horizontal(1);
			tf.align_vertical(-1);
		}
	}

	void draw(scene@ g) {
		if (blur) {
			g.draw_glass_world(layer, sublayer, x1, y1, x2, y2, 0, 0);
		}
		if (debug) {
			tf.text("enemy - " + g.get_entity_collision(y1, y2, x1, x2, 1));
			tf.draw_world(layer, 22, x1, y1, 1.0, 1.0, 0.0);
			tf.text("particle - " + g.get_entity_collision(y1, y2, x1, x2, 3));
			tf.draw_world(layer, 22, x1, y1+50, 1.0, 1.0, 0.0);
			tf.text("prop - " + g.get_entity_collision(y1, y2, x1, x2, 4));
			tf.draw_world(layer, 22, x1, y1+100, 1.0, 1.0, 0.0);
			tf.text("player - " + g.get_entity_collision(y1, y2, x1, x2, 5));
			tf.draw_world(layer, 22, x1, y1+150, 1.0, 1.0, 0.0);
			tf.text("cleansed - " + g.get_entity_collision(y1, y2, x1, x2, 14));
			tf.draw_world(layer, 22, x1, y1+200, 1.0, 1.0, 0.0);
		}
	}

	void editor_draw(scene@ g) {
		if (blur) {
			g.draw_glass_world(layer, sublayer, x1, y1, x2, y2, 0, 0);
		}
	}
}