/* 
Rainbow trail script I made just for fun.
Might try to incorporate this idea into a larger script, but no guarantees. :P
To do: adjust fog sublayer stuff to change fog triggers on the map, rather than constantly on the camera.
*/

const array <uint32> COLORS = {0xFF750787,0xFF004DFF,0xFF008026,0xFFFFED00,0xFFFF8C00,0xFFE40303};
const array <int> COLORS_L = {17,17,17,17,17,18};
const array <int> COLORS_SL = {20,21,22,23,24,1};

class script {
	scene@ g;
	dustman@ dm;
	sprites@ spr;

	array <State> states(COLORS.length() + 1);

	script() {
		@g = get_scene();
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
				for (uint j=1; j <= draws; j++) {
					spr.draw_world(COLORS_L[i], COLORS_SL[i], states[i+1].anim, states[i+1].frame, 0, (states[i+1].x + states[i+1].xo - j*x_offset), (states[i+1].y + states[i+1].yo - j*y_offset), states[i+1].r, states[i+1].face, 1, 0xFFFFFFFF);
				}
			}
		}
	}
	
	void step_post(int entities) {
		// STATE HANDLING
		State s(spr, dm);
		states.insertLast(s);
		states.removeAt(0);

		// FOG HANDLING
		camera@ cam = get_camera(0);
		fog_setting@ fog = cam.get_fog();
		for (uint i=0; i < COLORS.length(); i++) {
			fog.colour(COLORS_L[i], COLORS_SL[i], COLORS[i]);
			fog.percent(COLORS_L[i], COLORS_SL[i], 1);
		}
		cam.change_fog(fog, 0.0);
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
			State s(spr, dm);
			states[i] = s;
		}
	}
}

class State {
	sprites@ spr;
	dustman@ dm;
	float x;
	float y;
	float r;
	string anim;
	uint frame;
	int face;

	float xo;
	float yo;

	State(sprites@ spr, dustman@ dm) {
		@this.spr = spr;
		@this.dm = dm;
		this.x = dm.x();
		this.y = dm.y();
		this.r = dm.rotation();
		if (dm.attack_state() == 0) {
			this.anim = dm.sprite_index();
			this.frame = uint(max(dm.state_timer(), 0.0)) % spr.get_animation_length(dm.sprite_index());
			this.face = dm.face();
		} else {
			this.anim = dm.attack_sprite_index();
			this.frame = uint(max(dm.attack_timer(), 0.0)) % spr.get_animation_length(dm.attack_sprite_index());
			this.face = dm.attack_face();
		}

		this.xo = dm.draw_offset_x();
		this.yo = dm.draw_offset_y();
	}
	
	State() {
		//
	}
}