/* 
HUD replacement script I developed while working on sideways.as
Includes options to hide individual parts of the HUD such as the Combo, Special Meter, or Time
*/
class script {
	scene@ g;
	camera@ cam;
	canvas@ c;
	canvas@ ct;
	dustman@ d;
	
	textfield@ text_time;
	textfield@ text_test;
	textfield@ text_label;
	textfield@ text_combo;
	textfield@ text_falling;
	
	sprites@ supersprites;
	
	//MISC STUFF
	bool checkpointed = false;
	bool hidetext = false;
	
	//HUD OPTIONS
	[boolean|tooltip:"COMBO text"]
	bool HUD_COMBO_LABEL = true;
	[boolean|tooltip:"Combo number"]
	bool HUD_COMBO_NUM = true;
	[boolean|tooltip:"Special meter"]
	bool HUD_METER = true;
	[boolean|tooltip:"Time"]
	bool HUD_TIME = true;
	
	//FADE STUFF
	int fadein = 0;
	bool running = true;
	float fade = 0.08;
	uint32 time_cp = 0;
	bool ending = false;
	int ecount = 0;
	
	//COMBO STUFF
	float combo_x;
	float combo_y;
	float combo_scale = 0.2;
	float combo_scale_base = 0.2;
	float combo_scale_bonus = 0;
	float combo_angle = 0;
	int combo_int = 0;
	float fade_combo = 1.0;
	
	bool blink = true;
	int blink_count = 0;
	
	bool falling = false;
	float falling_x;
	float falling_y;
	float falling_scale;
	float falling_angle = 0;
	float falling_velox = 0;
	float falling_veloy = 0;
	float falling_velor = 0;
	int falling_count = 0;
	
	bool shaking = false;
	float shake_angle = 0;
	float shake_magnitude = 0;
	float shake_x = 0;
	float shake_y = 0;
	int shake_step = 0;
	
	//SUPER METER STUFF
	bool superboom = false;
	bool superpulse = false;
	int superboom_frame = 0;
	int superpulse_frame = 0;
	
	float meter_visual = 0;
	float meter_actual = 0;
	
	float superpos = -122;
	string charcode;
	
	int pulse_step = 0;
	int super_step = 0;
	
	script() {
		@g = get_scene();
		@cam = get_camera(0);
		
		@c = create_canvas(true, 0, 0);
		@ct = create_canvas(true, 0, 0);
		c.scale_hud(false);
		ct.scale_hud(false);
		
		@supersprites = create_sprites();
		supersprites.add_sprite_set("editor");
		
		@text_time = @create_textfield();
		text_time.set_font("Caracteres", 26);
		text_time.align_horizontal(-1);
		text_time.align_vertical(1);
		text_time.text("0:00.000");
		
		@text_test = @create_textfield();
		text_test.set_font("Caracteres", 26);
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
		
		@text_label = @create_textfield();
		text_label.set_font("Caracteres", 26);
		text_label.align_horizontal(-1);
		text_label.align_vertical(1);
		text_label.text("COMBO");
		
		@text_combo = @create_textfield();
		text_combo.set_font("Caracteres", 92);
		text_combo.align_horizontal(0);
		text_combo.align_vertical(0);
		
		@text_falling = @create_textfield();
		text_falling.set_font("Caracteres", 92);
		text_falling.align_horizontal(0);
		text_falling.align_vertical(0);
	}
	
	void draw(float subframe) {
		//FIND CORNER OF SCREEN
		float corner_x = (-1.0*(g.hud_screen_width(false)/2)); 
		float corner_y = (g.hud_screen_height(false)/2);
		
		//LEVEL END FADEOUT HANDLING		
		uint32 fade_uint = 0xffffff | (uint(fade * 255) << 24);
		uint32 combo_uint = 0xffffff | (uint(fade_combo * 255) << 24);
		
		
		if (not hidetext) {
			//TIME
			if (HUD_TIME) {
				float time_x = corner_x + 285;
				float time_y = corner_y - 15;
				text_time.colour(fade_uint);
				if (d.dead() || (get_time_us() - time_cp) < 500000) { //PUSHES TIMER TO HIGHER LAYER WHEN DEAD AND RESPAWNING
					ct.layer(5);
				} else {
					ct.layer(0);
				}
				ct.draw_text(text_time, time_x, time_y, 1, 1, 0);
			}
			
			//COMBO LABEL
			if (HUD_COMBO_LABEL) {
				float label_x = corner_x + 15;
				float label_y = corner_y - 110.5;
				text_label.colour(fade_uint);
				c.draw_text(text_label, label_x, label_y, 1, 1, -15);
			}
		}
		
		//SUPERBAR - REGULAR
		float superbar_x = corner_x + 136;
		float superbar_y = corner_y - 35;
		if (HUD_METER) {
			c.draw_sprite(supersprites, "specialmeterback", 0, 0, superbar_x, superbar_y, 0, 1, 1, fade_uint);

			if (superpos > -122) {
				c.draw_rectangle(superbar_x - 116, superbar_y + 17, superbar_x + superpos + 6, superbar_y - 15, 0, fade_uint);
				string superend = charcode + "special";
				c.draw_sprite(supersprites, superend, 0, 0, superbar_x + superpos, superbar_y, 0, 1, 1, fade_uint);
			}
			
			c.draw_sprite(supersprites, "specialmeterborder", 0, 0, superbar_x, superbar_y, 0, 1, 1, fade_uint);
			
			if (superpulse) {
				c.draw_sprite(supersprites, "specialmeterfull" + charcode, superpulse_frame, 0, superbar_x, superbar_y, 0, 1, 1, fade_uint);
			}
		}
		
		//COMBO NUMBER
		combo_x = corner_x + 120 + shake_x;
		combo_y = corner_y - 88.5 + shake_y;
		text_combo.colour(combo_uint);
		if (HUD_COMBO_NUM) {
			if (combo_int > 0 && blink && not hidetext) {
				c.draw_text(text_combo, combo_x, combo_y, combo_scale, combo_scale, combo_angle);
			}
		}
		
		//SUPERBAR - SPECIAL
		if (HUD_METER) {
			if (superboom) {
				c.draw_sprite(supersprites, charcode + "specialspend", superboom_frame, 0, superbar_x, superbar_y, 0, 1, 1, fade_uint);
			}
		}
		
		//LOSING COMBO
		if (HUD_COMBO_NUM) {
			if (falling) {
				text_falling.colour(fade_uint);
				c.draw_text(text_falling, falling_x, falling_y, falling_scale, falling_scale, falling_angle);
			}
		}
	}

	void step_post(int entities) {
		//HUD TIMER, IN STEP POST TO AVOID OFF-BY-ONE ERRORS
		int timer = g.time_in_level();
		int minute = floor(timer / 1000 / 60.0);
		int sec = timer / 1000 % 60;
		int mil = timer % 1000;
		string secs = ""+sec;
		string mils = ""+mil;
		if (sec < 10) {
			secs = "0"+secs;
		}
		if (mil < 100) {
			mils = "0"+mils;
			if (mil < 10) {
				mils = "0"+mils;
			}
		}
		text_time.text(minute+":"+secs+"."+mils);
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

		//HUD COMBO BREAKING, WHICH CONTINUES TO FALL ON LEVEL END
		if (falling) {
			falling_x = falling_x + falling_velox;
			falling_y = falling_y + falling_veloy;
			falling_angle = falling_angle + falling_velor;
			falling_veloy = falling_veloy + 0.35;
			falling_count++;
			if (falling_count < 30) {
				fade_combo = 0.0;
			} else {
				fade_combo = min(1.0,sqrt(falling_count - 29) / 7.75);
			}
		}
		
		//COMBO NUMBER CHARACTERISTICS, FREEZE ON LEVEL END
		if (running) { 
			if (not d.dead()) {
				//WHEN WE DETECT COMBO LOSS, START NUMBER FALL ANIMATION
				if (d.combo_count() == 0 && combo_int > 0) {
					falling_initialize();
				}
				
				//COMBO SCALE CHANGES
				combo_scale_base = 0.2 + min(1.0,(d.combo_count() / 200.0)) * 0.6;
				combo_scale_bonus = d.combo_timer() / 5.0;
				combo_scale = combo_scale_base + combo_scale_bonus;
				
				if (d.combo_count() > combo_int) { //WHEN COMBO GOES UP, RANDOMIZE ANGLE, START SHAKE
					combo_angle = min(1.0,(d.combo_count() / 200.0)) * ((rand() % 201) - 100.0) / 12.5;
					shake_initialize();
				}
				
				if (shaking) {
					shake_step++;
					switch(shake_step) {
						case 2:
							shake_x = shake_magnitude * cos(shake_angle);
							shake_y = shake_magnitude * sin(shake_angle);
							break;
						case 4:
						case 6:
							shake_x = shake_x / -2.0;
							shake_y = shake_y / -2.0;
							break;
						case 8:
							shake_x = 0;
							shake_y = 0;
							shaking = false;
					}
				}
			
				//COMBO DISPLAY INCREMENTER, ALSO USED TO CHECK WHEN COMBO STARTS TO FALL
				combo_int = d.combo_count();
				text_combo.text(""+combo_int);
			}
			
			
			//HUD SUPERBAR
			if (d.attack_state() != 3) {
				if (d.skill_combo() < 100) {
					meter_actual = d.skill_combo();
				
					float dif = meter_actual - meter_visual;
					
					//THE FOLLOWING MATH STOLEN FROM THE GAME CODE
					if (dif > 0) {
						dif = int(max(dif/10,1));
					} else {
						dif = int(min(dif/10,-1));
					}
					meter_visual += dif;
					if (dif < 0) {
						meter_visual = meter_actual;
					}
				}
				
				if (d.skill_combo() >= 100) {
					superpulse = true;
				}
			}
		}
		
		if (d.dead() && not checkpointed) {
			hidetext = true;
		}
		
		//THIS ADJUSTS THE FRAME OF THE SUPER BAR PULSING
		if (superpulse) {
			switch(pulse_step) {
				case 0: 
				case 1:
				case 2:
					superpulse_frame = 0;
					break;
				case 3:
				case 4:
					superpulse_frame = 1;
			}
			pulse_step = (pulse_step + 1) % 5;
		}
		
		//ON SUPER USAGE, RESETS BAR, STOPS PULSING, AND STARTS BAR EXPLOSION PROCESS
		if (d.attack_state() == 3) {
			meter_visual = 0;
			meter_actual = 0;
			superpulse = false;
			superboom = true;
		}
		
		//BAR EXPLOSION PROCESS
		if (superboom) {
			superboom_frame = floor(super_step / 4); //THIS ISN'T PERFECT BUT IT'S CLOSE
			super_step = (super_step + 1) % 80;
			if (super_step == 0 && d.attack_state() != 3) { //IF WE'VE LOOPED AROUND AND THE SUPER IS OVER, STOP PROCESS
				superboom = false;
			}
		}
		
		//DETERMINES METER LOCATION WITHIN BAR
		superpos = 228.0*meter_visual/100 - 122;
		
		//HUD COMBO BLINKING
			if (d.combo_timer() < .295 && d.combo_count() != 0) {
				blink_count++;
				if (blink_count == 5) {
					blink = !blink;
					blink_count = 0;
				}
			} else {
				blink = true;
			}

		if (ending) {
			ecount++;
			fade = min(fade, max(0.0, (120.0 - ecount) / 60.0));
			fade_combo = min(fade, max(0.0, (120.0 - ecount) / 60.0));
		}
	}

	void on_level_start() {
		initialize();
	}
	
	void checkpoint_save() {
		checkpointed = true;
	}

	void checkpoint_load() {
		initialize();
		
		//TIME GRAB FOR LAYER STUFF
		time_cp = get_time_us();
		
		//SUPERBAR ADJUSTMENT
		if (d.skill_combo() < 100) {
			superpulse = false;
			meter_actual = d.skill_combo();
			meter_visual = meter_actual;
			superpos = 228.0*meter_visual/100 - 122;
		}
		if (d.skill_combo() >= 100) {
			superpulse = true;
		}
	}
	
	void on_level_end() {
		running = false;
		ending = true;
	}
	
	void falling_initialize() {
		falling = true;
		text_falling.text(""+combo_int);
		falling_x = combo_x - 9;
		falling_y = combo_y - 10;
		falling_scale = combo_scale;
		falling_angle = combo_angle;
		falling_veloy = -4.0;
		falling_velox = ((rand() % 9) / 10.0) - 0.4;
		falling_velor = ((rand() % 21) / 10.0) - 1.0;
		falling_count = 0;
		fade_combo = 0;
	}
	
	void shake_initialize() {
		shake_angle = (rand() % 360) * 3.14159 / 180.0;
		shake_magnitude = min(1.0,(d.combo_count() / 200.0)) * 8.0;
		shake_step = 0;
		shaking = true;
	}
	
	void initialize() {
		g.disable_score_overlay(true);
		
		//COMBO NUMBER RESETTING
		shake_x = 0;
		shake_y = 0;
		shake_step = 0;
		shaking = false;
		blink = true;
		blink_count = 0;
		
		//CREATE DICTIONARY TO GET PROPER SPRITE NAMES
		@d = @controller_controllable(0).as_dustman();
		dictionary characterCodes = {
			{'dustman', 'dm'},
			{'dustgirl', 'dg'},
			{'dustkid', 'dk'},
			{'dustworth', 'do'},
			{'vdustman', 'dm'},
			{'vdustgirl', 'dg'},
			{'vdustkid', 'dk'},
			{'vdustworth', 'do'}
		};
		charcode = string(characterCodes[d.character()]);
	}
}