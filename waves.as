/* 
"Waves" script made for CMJ 3, which I used in my map "Hollow Elegy".
Thank you to Skyhawk, C, and AvengedRuler for help making the script.
http://atlas.dustforce.com/11175/hollow-elegy
*/

class script {
	scene@ g;
	array <Wave> waves;

	sprites@ s;
	entity@ last_hb;
	int sound = 1;

	textfield@ text_test;

	script() {
		@g = get_scene();

		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void entity_on_add(entity@ e) {
		message@ meta = e.metadata();
		if (meta.has_int("is_wavy")) return; // IF HITBOX IS PART OF THE WAVE, JUST SKIP IT

		// IF WE HAVE A HITBOX TO COMPARE TO AND WE SEE A NEW EFFECT
		if (@last_hb != null && e.type_name() == "effect") { 
			// AND IF THEY'RE CLOSE(ISH) TO EACH OTHER
			if (abs(last_hb.as_hitbox().x() - e.x()) < 150 && abs(last_hb.as_hitbox().y() - e.y()) < 250) {
				sound = 1 + (sound + rand() % 2) % 3; // RANDOMIZES SOUND THE ATTACK PLAYS IF IT HITS AN ENEMY
				Wave w(e, copy_hitbox(last_hb.as_hitbox()), sound);
				waves.insertLast(w);
				@last_hb = null;
			}
		}
		// IF E IS A HITBOX AND FROM A PLAYER THEN SAVE IT
		if (e.type_name() == "hit_box_controller" && e.as_hitbox().owner().team() == 1) {
			@last_hb = e;
		}
	}
	
	void step(int entities) {
		//THIS STEPS EVERY EXISTING WAVE
		for(uint i = 0; i < waves.length(); i++) {
			waves[i].step(@g);
		}
	}
}


class Wave	{
	entity@ e;
	hitbox@ h;
	hitbox@ h_old;
	float x_offset = 0;
	float y_offset = 0;
	float speed = 35;
	int timer = 0;
	int sound = 1 + rand() % 3;
	bool go = true;

	Wave(entity@ e, hitbox@ h, int sound) {
		@this.e = e;
		@this.h = h;
		@this.h_old = h;
		this.sound = sound;
	}

	void step(scene@ g) {
		if (go) {
			speed = speed - 1.4;
			//THIS SWITCH DEFINES THE ANGLES THE WAVES TRAVEL AT
			switch (h.attack_dir()) {
				case 30:
					x_offset = speed * 0.5;
					y_offset = speed * -sqrt(3) / 2;
					break;
				case 85:
					x_offset = speed;
					y_offset = 0;
					break;
				case 150:
				case 151:
					x_offset = speed * 0.5;
					y_offset = speed * sqrt(3) / 2;
					break;
				case -30:
					x_offset = speed * -0.5;
					y_offset = speed * -sqrt(3) / 2;
					break;
				case -85:
					x_offset = -speed;
					y_offset = 0;
					break;
				case -150:
				case -151:
					x_offset = speed * -0.5;
					y_offset = speed * sqrt(3) / 2;
					break;
			}

			// THIS SECTION MOVES THE EFFECT ENTITY
			e.x(e.x() + x_offset);
			e.y(e.y() + y_offset);
			e.time_warp(0.5);

			// THIS SECTION CREATES AND PLACES A NEW HITBOX
			hitbox@ h_out = copy_hitbox(h); // CREATES A HITBOX COPY TO PLACE
			message@ meta = h_out.metadata(); // GETS A HANDLE FOR THE COPY'S METADATA
			meta.set_int("is_wavy", 1); // SETS A METADATA FLAG THAT THIS HITBOX IS PART OF THE WAVE
			h_out.activate_time(0); // MAKES IT ACTIVE ON THE FIRST FRAME
			h_out.x(h_old.x() + x_offset); // SET X TO ADJUSTED VALUE
			h_out.y(h_old.y() + y_offset); // SET Y TO ADJUSTED VALUE
			h_out.attack_ff_strength(0); // SETS FREEZE EFFECT TO ZERO
			g.add_entity(h_out.as_entity()); // PLACES COPY ONTO THE SCENE
			@h_old = h_out; // SAVES THE OLD HITBOX FOR FUTURE REFERENCE

			// THIS SECTION USES PROJECT_TILE_FILTH TO CLEAN FILTH OFF SURFACES
			g.project_tile_filth(h_out.x(), h_out.y(), h_out.base_rectangle().get_width(), h_out.base_rectangle().get_height(), 0, h_out.attack_dir(), 200, 30, true, true, true, true, false, true);

			// THIS SECTION CHECKS TO SEE IF THE HITBOX HIT AN ENEMY AND STOPS IT IF SO
			int col_int = g.get_entity_collision(h_out.y() + h_out.base_rectangle().top(), h_out.y() + h_out.base_rectangle().bottom(), h_out.x() + h_out.base_rectangle().left(), h_out.x() + h_out.base_rectangle().right(), 1);
			for(int i = 0; i < col_int; i++) { // IF WE HIT AN "ENEMY"
				entity@ hit_ent = g.get_entity_collision_index(i); // GET THAT ENTITY'S HANDLE
				// TRY TO CAST THAT ENTITY AS A CONTROLLABLE, AND THEN CHECK IF IT'S ON "TEAM FILTH"
				if (@hit_ent != null && @hit_ent.as_controllable() != null && hit_ent.as_controllable().team() == 0) {
					// IF SO, PLAY A HIT SOUND AND STOP THE WAVE
					switch (h_out.damage()) {
						case 1:
							g.play_sound("sfx_impact_light_" + sound, hit_ent.x(), hit_ent.y(), 1, false, true);
							break;
						case 3:
							g.play_sound("sfx_impact_heavy_" + sound, hit_ent.x(), hit_ent.y(), 1, false, true);
							break;
					}
					go = false;
					break;
				}
			}

			// THIS SECTION CHECKS TO SEE IF THE HITBOX HIT A WALL AND STOPS IT IF SO
			// SOME TRIG TO CREATE A "REASONABLE" RAYCAST THROUGHT THE CENTER OF THE HITBOX
			float mid_x = (h_out.x() + (h_out.base_rectangle().left() + h_out.base_rectangle().right()) / 2);
			float mid_y = (h_out.y() + (h_out.base_rectangle().top() + h_out.base_rectangle().bottom()) / 2);
			float diag = sqrt((h_out.base_rectangle().get_width()*h_out.base_rectangle().get_width()) + (h_out.base_rectangle().get_height()*h_out.base_rectangle().get_height()));
			const float pi = 3.141592653589;
			float start_x = mid_x - sin(h_out.attack_dir() * pi / 180) * diag / 4;
			float start_y = mid_y + cos(h_out.attack_dir() * pi / 180) * diag / 4;
			float end_x = mid_x + sin(h_out.attack_dir() * pi / 180) * diag / 4;
			float end_y = mid_y - cos(h_out.attack_dir() * pi / 180) * diag / 4;
			raycast@ ray = g.ray_cast_tiles(start_x, start_y, end_x, end_y);
			if (ray.hit()) {
				go = false;
			}

			// THIS SECTION INCREMENTS THE TIMER AND STOPS THE HITBOX IF IT TIMES OUT
			timer++;
			if (timer > 20) { 
				go = false;
			}
		}
	}
	
	Wave() {
		//
	}
}

//THIS COPIES THE PROPERTIES OF ONE HITBOX TO ANOTHER
hitbox@ copy_hitbox(hitbox@ hb) {
	hitbox@ hb_new;
	
	@hb_new = create_hitbox(hb.owner(), hb.activate_time(), hb.x(), hb.y(), hb.base_rectangle().top(), hb.base_rectangle().bottom(), hb.base_rectangle().left(), hb.base_rectangle().right());
	hb_new.damage(hb.damage());
	hb_new.filth_type(hb.filth_type());
	hb_new.state_timer(hb.state_timer());
	hb_new.timer_speed(hb.timer_speed());
	hb_new.attack_ff_strength(hb.attack_ff_strength());
	hb_new.parry_ff_strength(hb.parry_ff_strength());
	hb_new.stun_time(hb.stun_time());
	hb_new.can_parry(hb.can_parry());
	hb_new.attack_dir(hb.attack_dir());
	hb_new.attack_strength(hb.attack_strength());
	hb_new.team(hb.team());
	hb_new.attack_effect(hb.attack_effect());
	hb_new.effect_frame_rate(hb.effect_frame_rate());
	return(hb_new);
}