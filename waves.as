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
	varstruct@ vars;

	int old_attack_state = 0;
	string old_type_name;

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
		if (@old_e != null) {
			//puts(e.type_name() + " - " + old_e.type_name());
			if (old_e.type_name() == "hit_box_controller" && e.type_name() == "effect") {
				puts("detected");
				Wave w(e, copy_hitbox(old_e.as_hitbox()));
				waves.insertLast(w);
				puts("" + waves.length());
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

		if (old_attack_state < players[0].attack_state()) {
			//g.project_tile_filth(hb.x(), hb.y(), hb.base_rectangle().get_width(), hb.base_rectangle().get_height(), 4, hb.attack_dir(), 96, 0, true, true, true, true, false, true);
			//g.project_tile_filth(hb.x(), hb.y(), 5, hb.base_rectangle().get_height(), 4, hb.attack_dir(), 480, 30, true, true, true, true, false, true);
			
		}
		old_attack_state = players[0].attack_state();

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
	int x;
	int y;

	Wave(entity@ e, hitbox@ h) {
		@this.e = e;
		@this.h = h;
		this.x = h.x();
		this.y = h.y();
	}

	void step(scene@ g) {
		
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