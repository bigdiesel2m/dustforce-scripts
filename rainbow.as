/* 
COMMENT HEADER
*/
const array <int> COLORS = {16,17,20,21,22,23};

class script {
	scene@ g;
	dustman@ dm;

	string anim = "";
	int face = 1;
	int frame = 0;
	sprites@ spr;

    array <float> x_array(COLORS.length() + 1, 0);
    array <float> y_array(COLORS.length() + 1, 0);
    array <float> r_array(COLORS.length() + 1, 0);
    array <float> face_array(COLORS.length() + 1, 0);
    array <float> anim_array(COLORS.length() + 1, 0);
    array <float> frame_array(COLORS.length() + 1, 0);

	textfield@ text_test;

	script() {
		@g = get_scene();
		
		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void draw(float subframe) {
		for (uint i=5; i < COLORS.length(); i++) {
			float x_dif = x_array[i+1] - x_array[i];
			float y_dif = y_array[i+1] - y_array[i];
			float x_offset = 0;
			float y_offset = 0;
			uint draws = 0;

			if (abs(x_dif) > abs(y_dif)) {
				draws = abs(int(x_dif/2));
				x_offset = 2;
				if (draws != 0) {
					y_offset = 2*int(y_dif/2) / float(draws);
				} else {y_offset = 0;}
			} else {
				draws = abs(int(y_dif/2));
				y_offset = 2;
				if (draws != 0) {
					x_offset = 2*int(x_dif/2) / float(draws);
				} else {x_offset = 0;}
			}
			for (uint j=0; j <= draws; j++) {
				puts(i*x_offset + " - " + i*y_offset);
				spr.draw_world(17, COLORS[i], anim, frame, 0, (x_array[i] + j*x_offset), (y_array[i] + j*y_offset), r_array[i+1], face_array[i+1], 1, 0xFFFFFFFF);
			}
		}
		text_test.text("Anim: " + anim + " - " + dm.rotation() + " - " + (dm.x() - x_array[5]));
		text_test.draw_hud(0, 0, -790, -350, 1, 1, 0);
	}
	
	void step_post(int entities) {
		anim = dm.sprite_index();
		face = dm.face();
		frame = uint(max(dm.state_timer(), 0.0));
		frame = frame % spr.get_animation_length(anim);

		// POSITION SAVING STUFF
		x_array.insertLast(dm.x());
		y_array.insertLast(dm.y());
		r_array.insertLast(dm.rotation());
		x_array.removeAt(0);
		y_array.removeAt(0);
		r_array.removeAt(0);
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
		for (uint i=0; i < x_array.length(); i++) {
			x_array[i] = dm.x();
			y_array[i] = dm.y();
		}
	}
}