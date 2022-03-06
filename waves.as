/* 
TEST SCRIPT
*/

class script {
    scene@ g;
	canvas@ c;

    array <dustman@> players(4, null);

	sprites@ s;
	hitbox@ hb;
	rectangle@ rect;

	//TESTING STUFF
	bool go = false;
	textfield@ text_test;
	string test_string;

	float old_state_timer;

	script() {
		@g = get_scene();

		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}
	
    void step(int entities) {
		if (@players[0].hitbox() != null) {
			@hb = players[0].hitbox();
			go = true;
		}

		// if (go) {
		// 	if (hb.state_timer() > old_state_timer) {
		// 		test_string = "INCREMENTING";
		// 		hb.x(hb.x() + 10);
		// 	} else {
		// 		test_string = "STOPPED";
		// 	}

		// 	old_state_timer = hb.state_timer();
		// }

	}
	
    void draw(float subframe) {
		//TEST
		if (go) {
			//text_test.text(old_state_timer + " - " + hb.state_timer() + " - " + test_string);
			text_test.text(hb.y() + " - " + hb.base_rectangle().bottom() + " - " + hb.base_rectangle().top());
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
