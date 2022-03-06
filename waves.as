/* 
TEST SCRIPT
*/

class script {
	scene@ g;
	canvas@ c;

	array <dustman@> players(4, null);
	array <Wave> waves;

	sprites@ s;
	hitbox@ hb;

	entity@ old_e;


	//TESTING STUFF
	bool go = false;
	textfield@ text_test;
	string test_string;
	int test_int = 0;
	entity@ test_ent;

	script() {
		@g = get_scene();

		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void entity_on_add(entity@ e) {
		message@ meta = e.metadata();
		if (meta.has_int("is_wavy")) return; // IF HITBOX IS PART OF THE WAVE, JUST SKIP IT
		if (@old_e != null) {
			// THIS DETECTS WHEN A PLAYER ATTACKS, AND GETS BOTH THE EFFECT ENTITY AND THE HITBOX ENTITY
			if (old_e.type_name() == "hit_box_controller" && e.type_name() == "effect") {
				if (old_e.as_hitbox().owner().team() == 1) { // IF THIS IS A PLAYER ATTACK
					Wave w(e, copy_hitbox(old_e.as_hitbox()));
					waves.insertLast(w);
				}
			}
		}
		@old_e = e;
	}

	// void entity_on_add(entity@ e) {
	// 	if (e.type_name() == "hit_box_controller") {
	// 		@hb = e.as_hitbox();
	// 		@hb_new = create_hitbox(hb.owner(), 0, hb.x(), hb.y(), hb.base_rectangle().top(), hb.base_rectangle().bottom(), hb.base_rectangle().left(), hb.base_rectangle().right());
	// 		go = true;
	// 		puts(e.type_name());
	// 		test_int++;
	// 	}
	// }
	
	void step(int entities) {
		if (@players[0].hitbox() != null) {
			@hb = @players[0].hitbox();
			go = true;
		}

		//THIS STEPS EVERY EXISTING WAVE
		for(uint i = 0; i < waves.length(); i++) {
			waves[i].step(@g);
		}
	}
	
	void draw(float subframe) {
		//TEST
		if (go) {
			//text_test.text(old_state_timer + " - " + hb.state_timer() + " - " + test_string);
			//text_test.text(hb.y() + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
			//text_test.text(hb.state_timer() + " - " + hb.activate_time() + " - " + hb.triggered());
			//text_test.text(players[0].attack_state() + " - " + hb.x() + " - " + hb.y() + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
			text_test.text(hb.attack_dir() + "");
			c.draw_text(text_test, 0, 250, 1, 1, 0);
		}

	}
	
	void on_level_start() {
		initialize();
	}
	
	void checkpoint_load() {
		initialize();
	}
	
	void initialize() {
		@c = create_canvas(true, 0, 0);

		//CREATE ARRAY OF PLAYERS
		for(uint i=0; i < players.length(); i++) {
			if (@controller_controllable(i) != null) {
				@players[i] = controller_controllable(i).as_dustman();
			}
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
	bool go = true;

	Wave(entity@ e, hitbox@ h) {
		@this.e = e;
		@this.h = h;
		@this.h_old = h;
	}

	void step(scene@ g) {
		if (go) {
			speed = speed - 1.5;
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
			if (col_int > 0) {
				go = false;
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
			//puts(h_out.x() + " - " + start_x + " - " + end_x);

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