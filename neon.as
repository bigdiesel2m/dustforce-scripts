/* 
COMMENT HEADER
*/

const array <string> MAN = {"groundstrike1","vdmgroundstrike1","groundstrike2","vdmgroundstrike2","vdustman"};

class script {
	script() {
	}
}

class Neon : trigger_base {
	[text] int layer = 15;
	[text] float rotation = 0;
	[text] float scale_x = 1;
	[text] float scale_y = 1;

	script@ s;
	sprites@ spr;
	scripttrigger@ self;

	uint32 colour = 0xFFFFFFFF;
	uint timer = 0;
	int SL1 = 22;
	int SL2 = 20;
	int SL3 = 22;
	
	void init(script@ s, scripttrigger@ self) {
		@spr = create_sprites();
		spr.add_sprite_set(MAN[4]);
		@this.s = s;
		@this.self = @self;
	}
	
	void step() {
		timer = timer + 1;
		if (timer == 60) {
			SL1 = SL2;
			SL2 = SL3;
			SL3 = SL1;
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
		spr.draw_world(layer, SL1, MAN[0], 2, 0, self.x(), self.y(), rotation, scale_x, scale_y, colour);
		spr.draw_world(layer, SL1, MAN[1], 0, 0, self.x(), self.y(), rotation, scale_x, scale_y, colour);
		spr.draw_world(layer, SL2, MAN[2], 2, 0, self.x(), self.y(), rotation, scale_x, scale_y, colour);
		spr.draw_world(layer, SL2, MAN[3], 1, 0, self.x(), self.y(), rotation, scale_x, scale_y, colour);
	}
}