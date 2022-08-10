/* 
COMMENT HEADER
*/

class script {
	script() {
	}
}

class Protest {
	[text] int layer = 15;
	[text] float rotation = 0;

	script@ s;
	sprites@ spr;
	sprites@ spr2;
	textfield@ tf;
	textfield@ tf2;
	scripttrigger@ self;
	scene@ g;
	bool bg_visible = false;
}

class Kid : Protest, trigger_base {
	uint timer = 0;
	float yoffset = 0;
	float yvelo = -5;

	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@spr = create_sprites();
			spr.add_sprite_set("dustkid");
			@spr2 = create_sprites();
			spr2.add_sprite_set("props1");

			@tf = create_textfield();
			tf.text("#FREEAVENGED");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFF000000);
		}
	}
	
	void step() {
		if (bg_visible) {
			yoffset = yoffset + yvelo;
			yvelo = yvelo+1;
			if(yoffset > 0) {
				yoffset = 0;
				yvelo = -5;
			}
		}
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		if (bg_visible) {
			spr.draw_world(layer, 20, "victory", 7, 0, self.x(), self.y() + yoffset, 0.0, 1.0, 1.0, 0xFFFFFFFF);
			spr2.draw_world(layer, 21, "buildingblocks_8", 0, 0, self.x()-225, self.y()-136 + yoffset, 0.0, 1.5, 0.4, 0xFFFFFFFF);
			tf.draw_world(layer, 22, self.x()-8, self.y()-80 + yoffset, 0.52, 1.0, 0.0);
		}
	}
}

class Worth : Protest, trigger_base {
	uint timer = 0;
	float yoffset = 0;
	float yvelo = -4;

	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@spr = create_sprites();
			spr.add_sprite_set("dustworth");
			@spr2 = create_sprites();
			spr2.add_sprite_set("props1");

			@tf = create_textfield();
			tf.text("GO");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFF000000);

			@tf2 = create_textfield();
			tf2.text("NEON");
			tf2.set_font("ProximaNovaReg", 36);
			tf2.colour(0xFF000000);
		}
	}
	
	void step() {
		if (bg_visible) {
			yoffset = yoffset + yvelo;
			yvelo = yvelo+1;
			if(yoffset > 0) {
				yoffset = 0;
				yvelo = -4;
			}
		}
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		if (bg_visible) {
			spr.draw_world(layer, 20, "idle", 0, 0, self.x(), self.y() + yoffset, 0.0, 1.0, 1.0, 0xFFFFFFFF);
			spr2.draw_world(layer, 20, "buildingblocks_10", 0, 0, self.x()-22, self.y()-80 + yoffset, 180.0, 0.35, 0.35, 0xFFFFFFFF);
			spr2.draw_world(layer, 21, "buildingblocks_8", 0, 0, self.x()-180, self.y()-265 + yoffset, 0.0, 1.1, 0.7, 0xFFFFFFFF);
			tf.draw_world(layer, 22, self.x()-21, self.y()-180 + yoffset, 1.0, 1.0, 0.0);
			tf2.draw_world(layer, 22, self.x()-21, self.y()-150 + yoffset, 1.0, 1.0, 0.0);
		}
	}
}