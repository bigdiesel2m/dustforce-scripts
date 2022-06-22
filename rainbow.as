/* 
COMMENT HEADER
*/
const array <int> COLORS = {16,17,20,21,22,23};

class script {
	scene@ g;
	dustman@ dm;
	sprites@ spr;

	array <State> states(COLORS.length() + 1);

	textfield@ text_test;

	script() {
		@g = get_scene();
		
		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void draw(float subframe) {
		for (uint i=0; i < COLORS.length(); i++) {
			float x_dif = states[i+1].x - states[i].x;
			float y_dif = states[i+1].y - states[i].y;
			float x_offset = 0;
			float y_offset = 0;

			uint draws = (abs(x_dif) > abs(y_dif) ? abs(int(x_dif/2)) : abs(int(y_dif/2)));
			if (draws != 0) {
				if (abs(x_dif) > abs(y_dif)) {
					x_offset = 2;
					y_offset = 2*int(y_dif/2) / float(draws);
				} else {
					y_offset = 2;
					x_offset = 2*int(x_dif/2) / float(draws);
				}
				for (uint j=0; j <= draws; j++) {
					spr.draw_world(17, COLORS[i], states[i+1].anim, states[i+1].frame, 0, (states[i].x + j*x_offset), (states[i].y + j*y_offset), states[i+1].r, states[i+1].face, 1, 0xFFFFFFFF);
				}
			}
		}
		//text_test.text("Anim: " + states[6].anim + " - " + states[6].frame);
		//text_test.draw_hud(0, 0, -790, -350, 1, 1, 0);
	}
	
	void step_post(int entities) {
		State s(dm.x(), dm.y(), dm.rotation(), dm.face(), dm.sprite_index(), uint(max(dm.state_timer(), 0.0)) % spr.get_animation_length(dm.sprite_index()));
		states.insertLast(s);
		states.removeAt(0);
	}

	void on_level_start() {
		initialize();
	}
	
	void checkpoint_load() {
		initialize();
	}
	
	void initialize() {
		@dm = controller_controllable(0).as_dustman();
		@spr = dm.get_sprites();
		for (uint i=0; i < states.length(); i++) {
			State s(dm.x(), dm.y(), dm.rotation(), dm.face(), dm.sprite_index(), uint(max(dm.state_timer(), 0.0)) % spr.get_animation_length(dm.sprite_index()));
			states[i] = s;
		}
	}
}

class State {
	float x;
	float y;
	float r;
	int face;
	string anim;
	uint frame;

	State(float x, float y, float r, int face, string anim, uint frame) {
		this.x = x;
		this.y = y;
		this.r = r;
		this.face = face;
		this.anim = anim;
		this.frame = frame;
	}
	
	State() {
		//
	}
}