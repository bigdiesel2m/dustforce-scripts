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
	[text] float scale = 1;

	script@ s;
	sprites@ spr;
	scripttrigger@ self;

	void draw_neon(sprites@ spr, int layer, int sub_layer, string spriteName, uint32 frame, uint32 palette, float x, float y, float rotation, float scale) {
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+1, y+1, rotation, scale, scale, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x+1, y-1, rotation, scale, scale, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-1, y-1, rotation, scale, scale, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer, spriteName, frame, palette, x-1, y+1, rotation, scale, scale, 0xFFFFFFFF);
		spr.draw_world(layer, sub_layer+1, spriteName, frame, palette, x, y, rotation, scale, scale, 0xFF000000);
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
		if (timer == 60) {
			SL1 = 20;
			SL2 = 22;
		} else if (timer == 120) {
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
		draw_neon(spr, layer, SL1, "groundstrike1", 2, 0, self.x(), self.y(), rotation, scale);
		draw_neon(spr, layer, SL1, "dmgroundstrike1", 0, 0, self.x(), self.y(), rotation, scale);
		draw_neon(spr, layer, SL2, "groundstrike2", 2, 0, self.x(), self.y(), rotation, scale);
		draw_neon(spr, layer, SL2, "dmgroundstrike2", 1, 0, self.x(), self.y(), rotation, scale);
	}
}