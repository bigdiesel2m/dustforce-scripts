const string EMBED_0 = "ctsprites/0.png";

class script {
	scene@ g;
	camera@ cam;
	sprites@ spr;

	int cam_left;
	int cam_right;
	int cam_top;
	int cam_bottom;

	textfield@ text_test;

	script() {
		@g = get_scene();
		@spr = create_sprites();

		@text_test = @create_textfield();
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}

	void build_sprites(message@ msg) {
		msg.set_string("0", "0");
	}
	
	void draw(float subframe) {
		text_test.text("LEFT: " + cam_left);
		text_test.draw_hud(0, 0, -790, -250, 1, 1, 0);
		text_test.text("RIGHT: " + cam_right);
		text_test.draw_hud(0, 0, -790, -200, 1, 1, 0);
		text_test.text("TOP: " + cam_top);
		text_test.draw_hud(0, 0, -790, -150, 1, 1, 0);
		text_test.text("BOTTOM: " + cam_bottom);
		text_test.draw_hud(0, 0, -790, -100, 1, 1, 0);

		//draw_tiles(cam_left, cam_right, cam_top, cam_bottom);
		spr.draw_world(19, 0, "0", 0, 0, (cam_left+5)*48, (cam_top+5)*48, 0, 0.5, 0.5, 0xFFFFFFFF);

	}

	void draw_tiles(int cam_left, int cam_right, int cam_top, int cam_bottom) {
		for (int i = cam_left; i <= cam_right; i++) {
			for (int j = cam_top; j <= cam_bottom; j++) {
				//
			}
		}
	}

	void step(int entities) {
		cam_check();
	}
	
	void on_level_start() {
		initialize();
	}

	void checkpoint_load() {
		initialize();
	}
	
	void initialize() {
		spr.add_sprite_set("script");
		@cam = get_camera(0);
		cam_check();
	}

	void cam_check() {
		cam_left = int(floor((cam.x() - cam.screen_width()/2)/48));
		cam_right = int(floor((cam.x() + cam.screen_width()/2)/48));
		cam_top = int(floor((cam.y() - cam.screen_height()/2)/48));
		cam_bottom = int(floor((cam.y() + cam.screen_height()/2)/48));
	}
}