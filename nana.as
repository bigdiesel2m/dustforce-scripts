const int MAX_PLAYERS = 4;

class script {
    scene@ g;
    array <dustman@> players(MAX_PLAYERS, null);
	bool singleplayer = true;
    entity@ nana = null;
	dustman@ popo;
	
	//ARRAY STUFF
	int arraycount = 0;
	array <int> x_array(7, 0);
	array <int> y_array(7, 0);
	array <int> taunt_array(7, 0);
	array <int> heavy_array(7, 0);
	array <int> light_array(7, 0);
	array <int> dash_array(7, 0);
	array <int> jump_array(7, 0);
	array <int> fall_array(7, 0);
	
	//COMBO STUFF
	int oldcombo_popo = 0;
	
	//DEATH STUFF
	canvas@ c;
	bool dying = false;
	int dying_step = 0;
	float dead_x;
	float dead_y;
	sprites@ poofsprites;
	int poof_frame = 0;
	bool olddead_nana = false;

    script() {
        @g = get_scene();
		
		@c = create_canvas(false, 18, 14);
		
		@poofsprites = create_sprites();
		poofsprites.add_sprite_set("editor");
    }
	
    void step(int entities) {
		//ONLY NEED TO DO FUN STUFF IF PLAYING SOLO
		if (singleplayer) {
			//INTENT HANDLING BELOW
			//SET NANA'S INTENTS
			nana.as_controllable().x_intent(x_array[0]);
			nana.as_controllable().y_intent(y_array[0]);
			nana.as_controllable().taunt_intent(taunt_array[0]);
			nana.as_controllable().heavy_intent(heavy_array[0]);
			nana.as_controllable().light_intent(light_array[0]);
			nana.as_controllable().dash_intent(dash_array[0]);
			nana.as_controllable().jump_intent(jump_array[0]);
			nana.as_controllable().fall_intent(fall_array[0]);
			//REMOVE OLDEST INTENTS
			x_array.removeAt(0);
			y_array.removeAt(0);
			taunt_array.removeAt(0);
			heavy_array.removeAt(0);
			light_array.removeAt(0);
			dash_array.removeAt(0);
			jump_array.removeAt(0);
			fall_array.removeAt(0);
			//ADD NEW INTENTS AT END OF ARRAY
			x_array.insertLast(popo.x_intent());
			y_array.insertLast(popo.y_intent());
			taunt_array.insertLast(popo.taunt_intent());
			heavy_array.insertLast(popo.heavy_intent());
			dash_array.insertLast(popo.dash_intent());
			light_array.insertLast(popo.light_intent());
			jump_array.insertLast(popo.jump_intent());
			fall_array.insertLast(popo.fall_intent());
			
			//COMBO HANDLING BELOW
			//WHEN EITHER GAINS COMBO, SET COMBO TIMERS TO 1
			if (nana.as_dustman().combo_count() > 0 || popo.combo_count() > oldcombo_popo) {
				popo.combo_timer(1);
				nana.as_dustman().combo_timer(1);
			}
			//WHEN NANA HITS SOMETHING, ADJUST DISPLAYED COMBO AND SPECIAL PROGRESSION TO MATCH
			if (nana.as_dustman().combo_count() > 0) {
				popo.combo_count(popo.combo_count() + nana.as_dustman().combo_count());
				popo.skill_combo(popo.skill_combo() + nana.as_dustman().combo_count());
				if (popo.skill_combo() > 99) {
					popo.skill_combo(120);
				}
				nana.as_dustman().combo_count(0);
			}
			//TIE NANA'S SPECIAL PROGRESS TO POPO'S
			nana.as_dustman().skill_combo(popo.skill_combo());
			//REMEMBER OLD COMBO COUNT FOR FUTURE COMPARISON
			oldcombo_popo = popo.combo_count();
			
			//DEATH HANDLING BELOW
			//WHEN NANA DIES, START DYING SEQUENCE
			if (nana.as_dustman().dead() && not olddead_nana) {
				dying = true;
				dead_x = nana.x();
				dead_y = nana.y();
				dying_step = 0;
				g.remove_entity(nana);
			}
			//WHILE DYING, ADJUST POOF FRAMES
			if (dying) {
				poof_frame = floor(dying_step / 4.0);
				dying_step++;
				if (dying_step > 63) {
					dying = false;
					dying_step = 0;
				}
			}
			//REMEMBER IF SHE IS DEAD FOR FUTURE COMPARISON
			olddead_nana = nana.as_dustman().dead();
		}
	}
	
	//WHENEVER AN ENEMY GETS CLEANED, GIVE BOTH PLAYERS AN AIR CHARGE
	void entity_on_remove(entity@ e) {
		if (@e.as_controllable() != null) {
			if (e.as_controllable().team() == 0) {
				popo.dash(1);
				nana.as_dustman().dash(1);
			}
		}
	}
	
    void draw(float subframe) {
		if (singleplayer) {
			if (dying) {
				c.draw_sprite(poofsprites, "respawnteam2", poof_frame, 0, dead_x, dead_y, 0, 1, 1, 0xffffffff);
			}
		}
	}
	
	void on_level_start() {
		initialize();
	}
    
    void checkpoint_load() {
		initialize();
    }
	
	void initialize() {
		//CREATE ARRAY OF PLAYERS
		for(uint i=0; i < players.length(); i++) {
			if (@controller_controllable(i) != null) {
				@players[i] = controller_controllable(i).as_dustman();
			}
		}
		//FORCE CHARACTER SELECTION
		if (@players[0] != null) {
			players[0].character("dustman");
		}
		if (@players[1] != null) {
			singleplayer = false;
			players[1].character("dustgirl");
		}
		if (@players[2] != null) {
			players[2].character("dustman");
		}
		if (@players[3] != null) {
			players[3].character("dustgirl");
		}
		//IF SINGLEPLAYER, CREATE NANA
		if (singleplayer) {
			@popo = players[0];
			@nana = create_entity("dust_girl");
	
			nana.x(players[0].x() - 10);
			nana.y(players[0].y());
			
			nana.as_controllable().team(1);
			nana.as_dustman().ai_disabled(true);
			nana.as_dustman().auto_respawn(false);
			g.add_entity(nana, false);
		}
	}
}