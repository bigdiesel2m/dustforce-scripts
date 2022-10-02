/* 
Credits Text Script
*/

class script {
	scene@ g;
	canvas@ c;
	textfield@ text_label;
	
	//FADE STUFF
	int fadein = 0;
	float fade = 0.08;
	uint32 time_cp = 0;
	bool ending = false;
	int ecount = 0;
	
	script() {
		@g = get_scene();
		
		@c = create_canvas(true, 0, 0);
		c.scale_hud(false);
		
		@text_label = @create_textfield();
		text_label.set_font("envy_bold", 20);
		text_label.align_horizontal(-1);
		text_label.align_vertical(1);
		text_label.text("Maybetta + Gameduck");
	}
	
	void draw(float subframe) {
		//FIND CORNER OF SCREEN
		float corner_x = (-1.0*(g.hud_screen_width(false)/2)); 
		float corner_y = (g.hud_screen_height(false)/2);
		
		//LEVEL END FADEOUT HANDLING
		uint32 fade_uint = 0x000000 | (uint(fade * 255) << 24);
		uint32 fade_uint2 = 0xffffff | (uint(fade * 255) << 24);
		
		float label_x = corner_x + 30;
		float label_y = corner_y - 28;
		text_label.colour(fade_uint);
		c.draw_text(text_label, label_x+2, label_y, 1, 1, 0);
		c.draw_text(text_label, label_x-2, label_y, 1, 1, 0);
		c.draw_text(text_label, label_x, label_y+2, 1, 1, 0);
		c.draw_text(text_label, label_x, label_y-2, 1, 1, 0);
		text_label.colour(fade_uint2);
		c.draw_text(text_label, label_x, label_y, 1, 1, 0);
	}

	void step_fixed() {
		//HUD FADE IN ON STARTUP
		if (!ending) {
			fadein++;
			if (fadein < 60) {
				fade = fadein / 60.0;
			} else {
				fade = 1.0;
			}
		}

		if (ending) {
			ecount++;
			fade = min(fade, max(0.0, (120.0 - ecount) / 60.0));
		}
	}
	
	void on_level_end() {
		ending = true;
	}

}