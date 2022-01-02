const string EMBED_0 = "ctsprites/0.png";

class script {
	scene@ g;
	camera@ cam;
	sprites@ spr;
	tileinfo@ tile;

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
		for (int i = cam_left; i <= cam_right; i++) {
			for (int j = cam_top; j <= cam_bottom; j++) {
				@tile = g.get_tile(i, j, 19);
				draw_tile(i*48, j*48, int(tile.type()), 19);
			}
		}
	}

	void draw_tile(int x, int y, int type, int layer) {
		if (tile.solid() && !tile.is_dustblock() && !(tile.sprite_tile() == 0)) {
			if (type == 0) {
				spr.draw_world(layer, 0, "0", 0, 0, x, y, 0, 0.5, 0.5, 0xFFFFFFFF);
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