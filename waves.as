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
			text_test.text(players[0].attack_state() + " - " + hb.x() + " - " + hb.y() + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
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
	float x;
	float y;
	int timer = 0;

	Wave(entity@ e, hitbox@ h) {
		@this.e = e;
		@this.h = h;
		this.x = h.x();
		this.y = h.y();
	}

	void step(scene@ g) {
		if (timer < 20) {
			x = x + 20;

			//THIS SECTION CHECKS IF THE LAST HITBOX HIT SOMETHING
			if (@h_old != null) {
				puts("" + h_old.hit_outcome());
			}

			//THIS SECTION MOVES THE EFFECT ENTITY
			e.x(x);

			//THIS SECTION CREATES AND PLACES A NEW HITBOX
			hitbox@ h_out = copy_hitbox(h); // CREATES A HITBOX COPY TO PLACE
			message@ meta = h_out.metadata(); // GETS A HANDLE FOR THE COPY'S METADATA
			meta.set_int("is_wavy", 1); // SETS A METADATA FLAG THAT THIS HITBOX IS PART OF THE WAVE
			h_out.activate_time(0); // MAKES IT ACTIVE ON THE FIRST FRAME
			h_out.x(x); // SET X TO ADJUSTED VALUE
			h_out.y(y); // SET Y TO ADJUSTED VALUE
			h_out.attack_ff_strength(0); //
			g.add_entity(h_out.as_entity()); // PLACES COPY ONTO THE SCENE

			//THIS SECTION INCREMENTS THE TIMER AND SAVES THIS HITBOX FOR FUTURE REFERENCE
			@h_old = h_out;
			timer++;
		}
	}
	
	Wave() {
		//
	}
}

//THIS COPIES THE PROPERTIES OF ONE HITBOX TO ANOTHER (I HOPE)
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