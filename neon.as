/* 
COMMENT HEADER
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
	textfield@ tf;
	scripttrigger@ self;

	void draw_neon(sprites@ spr, int layer, int sub_layer, string spriteName, uint32 frame, uint32 palette, float x, float y, float rotation, float scale_x, float scale_y) {
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+1, y+1, rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+1, y-1, rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-1, y-1, rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-1, y+1, rotation, scale_x, scale_y, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer+1, spriteName, frame, palette, x, y, rotation, scale_x, scale_y, 0xFF000000);
	}

	void neon_text(textfield@ tf, int layer, int sub_layer, float x, float y, float scale_x, float scale_y, float rotation) {
		tf.draw_world(layer, sub_layer, x+1, y+1, scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x+1, y-1, scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x-1, y-1, scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer, x-1, y+1, scale_x, scale_y, rotation);
		tf.draw_world(layer, sub_layer+1, x, y, scale_x, scale_y, rotation);
	}
}

class ManSwipe : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@spr = create_sprites();
		spr.add_sprite_set("dustman");
		@this.s = s;
		@this.self = @self;
	}
	
	void step() {
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
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		draw_neon(spr, layer, SL1, "groundstrike1", 2, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL1, "dmgroundstrike1", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL2, "groundstrike2", 2, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL2, "dmgroundstrike2", 1, 0, self.x(), self.y(), rotation, scale_x, scale_y);
	}
}

class KidDash : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	int SL3 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@spr = create_sprites();
		spr.add_sprite_set("dustkid");
		@this.s = s;
		@this.self = @self;
	}
	
	void step() {
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
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		draw_neon(spr, layer, SL1, "dash", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL1, "dkdash", 0, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL2, "dash", 1, 0, self.x()+50, self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL3, "dash", 2, 0, self.x()+100, self.y(), rotation, scale_x, scale_y);
	}
}

class WorthHeavy : Neon, trigger_base {
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	
	void init(script@ s, scripttrigger@ self) {
		@this.s = s;
		@this.self = @self;
		@spr = create_sprites();
		spr.add_sprite_set("dustworth");     
		
		@tf = create_textfield();
		tf.text("BOOM!");
		tf.set_font("ProximaNovaReg", 36);
		tf.colour(0xFFFFFFFF);
	}
	
	void step() {
		timer = (timer + 1);
		if (timer == 60) {
			SL2 = 22;
		} else if (timer == 120) {
			SL2 = 20;
			timer = 0;
		}
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		draw_neon(spr, layer, SL1, "groundstraight", 4, 0, self.x(), self.y(), rotation, scale_x, scale_y);
		draw_neon(spr, layer, SL2, "doheavyf", 0, 0, self.x()+25, self.y()+6, rotation, scale_x, scale_y);
		neon_text(tf, layer, SL2, self.x()+90, self.y()-120, scale_x, scale_y, -20);
	}
}