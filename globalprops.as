/* 
Variant of extraprops.as designed to work better with background props unloading
Use C's sprite reference info for sprite info:
https://github.com/cmann1/PropUtils/tree/master/files/sprite_reference
*/

class script {
	[text] array<ExtraProp> props;

	script() {
	}
	
	void editor_draw(float f) {
		draw_it();
	}

	void draw(float subframe) {
		draw_it();
	}

	void draw_it() {
		for(uint i = 0; i < props.length; i++) {
			props[i].draw_prop();
		}
	}
}

class ExtraProp {
	[text] string sprite_set = "dustworth";
	[text] string sprite_name = "doheavyd";
	[text] uint32 frame = 0;
	[text] uint32 palette = 0;
	[text] int layer = 3;
	[text|tooltip:"Vanilla props usually use sublayer 19"] int sublayer = 20;
	[position,mode:world,layer:=layer.=sublayer,y:Y1] float X1;
	[hidden] float Y1;
	[text] float rotation = 0;
	[text] float scale_x = 1;
	[text] float scale_y = 1;
	[color] uint32 colour = 0x00FFFFFF;
	[text|tooltip:"From 0 (invisible) to 255 (opaque)"] uint alpha = 255;
	
	sprites@ spr;
	
	ExtraProp() {
		@spr = create_sprites();
		spr.add_sprite_set(sprite_set);
	}

	void draw_prop() {
		colour = (colour & 0xFFFFFF) + (alpha << 24); //replaces existing alpha with custom alpha
		spr.draw_world(layer, sublayer, sprite_name, frame, palette, X1, Y1, rotation, scale_x, scale_y, colour);
	}
}