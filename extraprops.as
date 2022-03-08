/* 
Simple fake prop script made during DLC 2.
http://atlas.dustforce.com/11114/tire-museum
Use C's sprite reference info for sprite info:
https://github.com/cmann1/PropUtils/tree/master/files/sprite_reference
*/

class script {
	script() {
	}
}

class ExtraProp : trigger_base {
	[text] string sprite_set = "trash_tire";
	[text] string sprite_name = "idle";
	[text] uint32 frame = 0;
	[text] uint32 palette = 0;
	[text] int layer = 15;
	[text|tooltip:"Vanilla props usually use sublayer 19"] int sublayer = 20;
	[text] float rotation = 0;
	[text] float scale_x = 1;
	[text] float scale_y = 1;
	[color] uint32 colour = 0x00FFFFFF;
	[text|tooltip:"From 0 (invisible) to 255 (opaque)"] uint alpha = 255;
	
	script@ s;
	sprites@ spr;
	scripttrigger@ self;
	uint32 colour_adjust;
	
	void init(script@ s, scripttrigger@ self) {
		@spr = create_sprites();
		spr.add_sprite_set(sprite_set);
		@this.s = s;
		@this.self = @self;
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		colour = (colour & 0xFFFFFF) + (alpha << 24); //replaces existing alpha with custom alpha
		spr.draw_world(layer, sublayer, sprite_name, frame, palette, self.x(), self.y(), rotation, scale_x, scale_y, colour);
	}
}