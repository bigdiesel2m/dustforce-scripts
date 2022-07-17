/* 
"Neon" script made for DLC 3
Thank you to msg555 and Alexspeedy for their help making the script.
*/

class script {
	script() {
	}
}

class Neon {
	[text] int layer = 20;
	[text] float rotation = 0;
	[text] float scale_x = 1;
	[text] float scale_y = 1;

	script@ s;
	sprites@ spr;
	sprites@ spr2;
	textfield@ tf;
	textfield@ tf2;
	scripttrigger@ self;
	scene@ g;
	bool bg_visible = false;
 
	void draw_neon(sprites@ spr, int layer, int sub_layer, string spriteName, uint32 frame, uint32 palette, float x, float y, float rotation, float scale_x, float scale_y) {
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+(1*scale_x), y+(1*scale_y), rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+(1*scale_x), y-(1*scale_y), rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-(1*scale_x), y-(1*scale_y), rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-(1*scale_x), y+(1*scale_y), rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer+1, spriteName, frame, palette, x, y, rotation, scale_x, scale_y, 0xFF000000);
	}

	void neon_text(textfield@ tf, int layer, int sub_layer, float x, float y, float scale_x, float scale_y, float rotation) {
		tf.draw_world(layer, sub_layer, x+(1*scale_x), y+(1*scale_y), scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x+(1*scale_x), y-(1*scale_y), scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x-(1*scale_x), y-(1*scale_y), scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x-(1*scale_x), y+(1*scale_y), scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer+1, x, y, scale_x, scale_y, rotation);
	}
}

class ManSwipe : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustman");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 50) {
				SL1 = 20;
				SL2 = 22;
			} else if (timer == 100) {
				SL1 = 22;
				SL2 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "groundstrike1", 2, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL1, "dmgroundstrike1", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL2, "groundstrike2", 2, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL2, "dmgroundstrike2", 1, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class KidDash : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	int SL3 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustkid");
			@spr2 = create_sprites();
			spr2.add_sprite_set("backdrops");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 35) {
				SL1 = 20;
				SL2 = 22;
				SL3 = 20;
			} else if (timer == 70) {
				SL1 = 20;
				SL2 = 20;
				SL3 = 22;
			} else if (timer == 105) {
				SL1 = 22;
				SL2 = 20;
				SL3 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "dash", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL1, "dkdash", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL2, "dash", 1, 0, self.x()+(50*scale_x), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL3, "dash", 2, 0, self.x()+(100*scale_x), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class WorthHeavy : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("dustworth");     
			
			@tf = create_textfield();
			tf.text("BOOM!");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 60) {
				SL2 = 22;
			} else if (timer == 120) {
				SL2 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "groundstraight", 4, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL2, "doheavyf", 0, 0, self.x()+(25*scale_x), self.y()+(6*scale_y), rotation, scale_x, scale_y);
			neon_text(tf, layer, SL2, self.x()+(90*scale_x), self.y()-(120*scale_y), scale_x, scale_y, -20);
		}
	}
}

class LeafNod : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	int SL3 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("leafsprite");
		}
	}
	
	void step() {
		if (bg_visible) {
		timer = (timer + 1);
			if (timer == 25) {
				SL1 = 20;
				SL2 = 22;
				SL3 = 20;
			} else if (timer == 50) {
				SL1 = 20;
				SL2 = 20;
				SL3 = 22;
			} else if (timer == 75) {
				SL1 = 20;
				SL2 = 22;
				SL3 = 20;
			} else if (timer == 100) {
				SL1 = 22;
				SL2 = 20;
				SL3 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "idle", 4, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL2, "idle", 6, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL3, "idle", 8, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class BearSleep : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	int SL3 = 20;
	int SL4 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("bear");
			
			@tf = create_textfield();
			tf.text("Z");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 40) {
				SL2 = 22;
				SL3 = 20;
				SL4 = 20;
			} else if (timer == 80) {
				SL2 = 22;
				SL3 = 22;
				SL4 = 20;
			} else if (timer == 120) {
				SL2 = 22;
				SL3 = 22;
				SL4 = 22;
			} else if (timer == 160) {
				SL2 = 20;
				SL3 = 20;
				SL4 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "cthanks1", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			neon_text(tf, layer, SL2, self.x()+(60*scale_x), self.y()-(100*scale_y), scale_x, scale_y, 30);
			neon_text(tf, layer, SL3, self.x()+(70*scale_x), self.y()-(140*scale_y), scale_x, scale_y, -10);
			neon_text(tf, layer, SL4, self.x()+(65*scale_x), self.y()-(180*scale_y), scale_x, scale_y, 20);
		}
	}
}

class DustDustDust : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	int SL2 = 20;
	int SL3 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@tf = create_textfield();
			tf.text("DUST");
			tf.set_font("ProximaNovaReg", 72);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 30) {
				SL1 = 22;
			} else if (timer == 60) {
				SL2 = 22;
			} else if (timer == 90) {
				SL3 = 22;
			} else if (timer == 120) {
				SL1 = 20;
				SL2 = 20;
				SL3 = 20;
				timer = 0;
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
			neon_text(tf, layer, SL1, self.x(), self.y(), scale_x, scale_y, 0);
			neon_text(tf, layer, SL2, self.x(), self.y()+(75*scale_y), scale_x, scale_y, 0);
			neon_text(tf, layer, SL3, self.x(), self.y()+(150*scale_y), scale_x, scale_y, 0);
		}
	}
}

class MaidsRule : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("maid");
			
			@tf = create_textfield();
			tf.text("MAIDS");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFFFFFFFF);

			@tf2 = create_textfield();
			tf2.text("RULE");
			tf2.set_font("ProximaNovaReg", 36);
			tf2.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 45) {
				SL1 = 20;
			} else if (timer == 90) {
				SL1 = 22;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "cidle", 0, 0, self.x(), self.y(), rotation, -scale_x, scale_y);
			neon_text(tf, layer, SL2, self.x(), self.y()-(120*scale_y), scale_x, scale_y, 0);
			neon_text(tf2, layer, SL2, self.x(), self.y()+(20*scale_y), scale_x, scale_y, 0);
		}
	}
}

class LetsDust : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@tf = create_textfield();
			tf.text("LET'S");
			tf.set_font("ProximaNovaReg", 72);
			tf.colour(0xFFFFFFFF);

			@tf2 = create_textfield();
			tf2.text("DUST!");
			tf2.set_font("ProximaNovaReg", 72);
			tf2.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 30) {
				SL1 = 22;
			} else if (timer == 60) {
				SL2 = 22;
			} else if (timer == 100) {
				SL1 = 20;
				SL2 = 20;
				timer = 0;
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
			neon_text(tf, layer, SL1, self.x(), self.y(), scale_x, scale_y, 0);
			neon_text(tf2, layer, SL2, self.x()+(200*scale_x), self.y(), scale_x, scale_y, 0);
		}
	}
}

class ManTaunt : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustman");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 15) {
				SL1 = 22;
			} else if (timer == 75) {
				SL1 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "victory", 7, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class GirlTaunt : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustgirl");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 20) {
				SL1 = 22;
			} else if (timer == 70) {
				SL1 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "victory", 7, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class KidTaunt : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustkid");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 15) {
				SL1 = 22;
			} else if (timer == 75) {
				SL1 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "victory", 7, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class WorthTaunt : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("dustworth");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 20) {
				SL1 = 22;
			} else if (timer == 100) {
				SL1 = 20;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "victory", 3, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class GoGoGoGo : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@tf = create_textfield();
			tf.text("GO");
			tf.set_font("ProximaNovaReg", 100);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 33) {
				SL1 = 22;
			} else if (timer == 66) {
				SL1 = 20;
				timer = 0;
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
			neon_text(tf, layer, SL1, self.x(), self.y(), scale_x, scale_y, 0);
			neon_text(tf, layer, SL1, self.x()+(150*scale_x), self.y(), scale_x, scale_y, 0);
			neon_text(tf, layer, SL1, self.x()+(300*scale_x), self.y(), scale_x, scale_y, 0);
			neon_text(tf, layer, SL1, self.x()+(450*scale_x), self.y(), scale_x, scale_y, 0);
		}
	}
}

class DustU : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("props2");     
			
			@tf = create_textfield();
			tf.text("Dust U");
			tf.set_font("ProximaNovaReg", 58);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 42) {
				SL2 = 22;
			} else if (timer == 84) {
				SL2 = 20;
				timer = 0;
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
			neon_text(tf, layer, SL1, self.x(), self.y()-(120*scale_y), scale_x, scale_y, 0);
			draw_neon(spr, layer, SL2, "boulders_14", 0, 0, self.x()+(90*scale_x), self.y()-(5*scale_y), 25, scale_x*1.2, scale_y*1.2);
			draw_neon(spr, layer, SL2, "boulders_15", 0, 0, self.x()-(10*scale_x), self.y()+(80*scale_y), 65, scale_x*1.2, scale_y*1.2);
		}
	}
}

class CleanTech : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("props2");
			
			@tf = create_textfield();
			tf.text("CLEAN");
			tf.set_font("ProximaNovaReg", 36);
			tf.colour(0xFFFFFFFF);

			@tf2 = create_textfield();
			tf2.text("TECH");
			tf2.set_font("ProximaNovaReg", 36);
			tf2.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 32) {
				SL1 = 20;
			} else if (timer == 64) {
				SL1 = 22;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "boulders_13", 0, 0, self.x()-(10*scale_x), self.y(), rotation, -scale_x, scale_y);
			neon_text(tf, layer, SL1, self.x(), self.y()-(50*scale_y), scale_x, scale_y, 0);
			neon_text(tf2, layer, SL1, self.x(), self.y()-(18*scale_y), scale_x, scale_y, 0);
		}
	}
}

class AppleStatic : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;
			@spr = create_sprites();
			spr.add_sprite_set("props2");
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 80) {
				SL1 = 20;
			} else if (timer == 90) {
				SL1 = 22;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "foliage_25", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		}
	}
}

class BigTree : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@spr = create_sprites();
			spr.add_sprite_set("props2");
			@this.s = s;
			@this.self = @self;
		}
	}
	
	void step() {
		if (bg_visible) {
			timer = (timer + 1);
			if (timer == 90) {
				SL1 = 20;
			} else if (timer == 105) {
				SL1 = 22;
				timer = 0;
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
			draw_neon(spr, layer, SL1, "trunks_6", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
			draw_neon(spr, layer, SL1, "leaves_6", 0, 0, self.x(), self.y()+(70*scale_y), rotation, scale_x, scale_y);
		}
	}
}

class AppleCorp : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@g = get_scene();
		bg_visible = g.layer_visible(3);
		if (bg_visible) {
			@this.s = s;
			@this.self = @self;

			@tf = create_textfield();
			tf.text("AppleCorp");
			tf.set_font("ProximaNovaReg", 58);
			tf.colour(0xFFFFFFFF);
		}
	}
	
	void step() {
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		if (bg_visible) {
			neon_text(tf, layer, SL1, self.x(), self.y(), scale_x, scale_y, 0);
		}
	}
}