/* 
Credits Text Script for Cyber Complex 4, based on my previous HUD replacement scripts.
Uses script triggers in each section to add mapmaker names in the superbar.
Thanks to Zaik for helping me figure out how to get script triggers to work.
http://atlas.dustforce.com/11677/cyber-complex-4
*/

class script {
	scene@ g;
	canvas@ c;

	string name;
	textfield@ text_label;
	
	//FADE STUFF
	int fadein = 0;
	float fade = 0.08;
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
		name = "";
	}
	
	void draw(float subframe) {
		//FIND CORNER OF SCREEN
		float corner_x = (-1.0*(g.hud_screen_width(false)/2)); 
		float corner_y = (g.hud_screen_height(false)/2);

		float label_x = corner_x + 30;
		float label_y = corner_y - 28;
		
		//ADJUST TEXT TRANSPARENCY BASED ON FADE IN/OUT
		uint32 fade_uint = 0x000000 | (uint(fade * 255) << 24);
		uint32 fade_uint2 = 0xffffff | (uint(fade * 255) << 24);
		
		//DRAW BORDERED TEXT IN SUPERBAR
		text_label.text(name);
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

		//HUD FADE OUT ON ENDING
		if (ending) {
			ecount++;
			fade = min(fade, max(0.0, (120.0 - ecount) / 60.0));
		}
	}
	
	void on_level_end() {
		ending = true;
	}

}

class Credits : trigger_base {
	script@ s;
	[text] string name = "";

	void init(script@ s, scripttrigger@ self) {
		@this.s = s;
    }

	//WHEN PLAYER HITS TRIGGER, SEND NAME FROM THE TRIGGER TO THE MAIN SCRIPT
	void activate(controllable@ e) {
		if (@e.as_dustman() != null) {
			s.name = name;
		}
	}
}