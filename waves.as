/* 
TEST SCRIPT
*/

class script {
    scene@ g;
	canvas@ c;

    array <dustman@> players(4, null);

	sprites@ s;
	hitbox@ hb;
	hitbox@ hb_new;
	rectangle@ rect;

	//TESTING STUFF
	bool go = false;
	textfield@ text_test;
	string test_string;
    int test_int = 0;

	script() {
		@g = get_scene();

		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

    void entity_on_add(entity@ e) {
        if (e.type_name() == "hit_box_controller") {
            @hb = e.as_hitbox();
            @hb_new = create_hitbox(hb.owner(), 0, hb.x(), hb.y(), hb.base_rectangle().top(), hb.base_rectangle().bottom(), hb.base_rectangle().left(), hb.base_rectangle().right());
            go = true;
            puts(e.type_name());
            test_int++;
        }
    }
	
    void step(int entities) {
        if (go) {
            g.add_entity(hb_new.as_entity());
        }
	}
	
    void draw(float subframe) {
		//TEST
		if (go) {
			//text_test.text(old_state_timer + " - " + hb.state_timer() + " - " + test_string);
			//text_test.text(hb.y() + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
			text_test.text(test_int + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
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
