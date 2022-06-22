class script {
	scene@ g;
	dustman@ dm;

	string anim = "";
	int face = 1;
	int frame = 0;
	sprites@ spr;

    array <int> old_x(6, 0);
    array <int> old_y(6, 0);

	textfield@ text_test;

	script() {
		@g = get_scene();
		
		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void draw(float subframe) {
		text_test.text("Anim: " + anim + " - " + frame + " - " + dm.x());
		text_test.draw_hud(0, 0, -790, -350, 1, 1, 0);

		spr.draw_world(17, 23, anim, frame, 0, dm.x()-2, dm.y(), dm.rotation(), face*1, 1, 0xFFFFFFFF);
	}
	
	void step_post(int entities) {
		anim = dm.sprite_index();
		face = dm.face();
		frame = uint(max(dm.state_timer(), 0.0));
		frame = frame % spr.get_animation_length(anim);
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
	}
}
