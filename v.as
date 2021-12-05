const string EMBED_tile1 = "vsprites/tile1.png";
const string EMBED_tile2 = "vsprites/tile2.png";
const string EMBED_tile3 = "vsprites/tile3.png";
const string EMBED_tile4 = "vsprites/tile4.png";
const string EMBED_tile5 = "vsprites/tile5.png";

const float cam_height = 1152;
const float cam_width = 1536;
const float y_buffer = 192;

class script {
	scene@ g;
	dustman@ dm;
	camera@ cam;
	canvas@ c;
	fog_setting@ fog;
	
	//TEST STUFF
	textfield@ text_test;
	int test_int = 0;
	
	//CAMERA STUFF
	float grid_height = cam_height + y_buffer;		
	int grid_x = 0;
	int grid_y = 0;
	bool flipped = false;
	
	//TILE STUFF
	[text] array<Room> room_tiles;
	[boolean] bool detect_tiles = false;
	int min_grid_x = -1;
	int max_grid_x = 1;
	int min_grid_y = -1;
	int max_grid_y = 2;
	sprites@ spr;
	
	//PARTICLE STUFF
	array<Particle> particles_far(25);
	array<Particle> particles_mid(25);
	array<Particle> particles_near(15);
	int step_far = 0;
	int step_mid = 0;
	int step_near = 0;
	
	script() {
		@g = get_scene();
		@c = create_canvas(true, 0, 0);
	
		//TILE STUFF
		@spr = create_sprites();
		
		//TEST STUFF
		@text_test = @create_textfield();
		text_test.set_font("Caracteres", 26);
		text_test.align_horizontal(-1);
		text_test.align_vertical(1);
	}
	
	void build_sprites(message@ msg) {
		msg.set_string("tile1", "tile1");
		msg.set_string("tile2", "tile2");
		msg.set_string("tile3", "tile3");
		msg.set_string("tile4", "tile4");
		msg.set_string("tile5", "tile5");
	}
	
	
	void step(int entities) {
		//Y TELEPORTING
		if (dm.y() > cam.y() + cam_height/2 + 48) {
			if (!flipped) {
				dm.y(dm.y() + (cam_height + 2*y_buffer));
			} else {
				dm.y(dm.y() - (3*cam_height + 2*y_buffer));
			}
		} else if (dm.y() < cam.y() - cam_height/2 + 48) {
			if (!flipped) {
				dm.y(dm.y() - (cam_height + 2*y_buffer));
			} else {
				dm.y(dm.y() + (3*cam_height + 2*y_buffer));
			}
		}
		
		//FLIP HANDLING
		if (dm.jump_intent() != 0) {
			if (dm.ground()) {
				float y_offset = dm.y() - cam.y();
				if(!flipped) {
					dm.y(cam.y()- grid_height - y_offset + 48);
				} else {
					dm.y(cam.y() + grid_height - y_offset + 48);
				}
				dm.set_speed_xy(dm.x_speed(), 840);
			}
			dm.jump_intent(0);
		}
		
		//PARTICLE STUFF
		for(uint i = 0; i < particles_far.length; i++) {
			particles_far[i].step();
		}
		for(uint i = 0; i < particles_mid.length; i++) {
			particles_mid[i].step();
		}
		for(uint i = 0; i < particles_near.length; i++) {
			particles_near[i].step();
		}
		if ((rand() % 5) == 0) {
			if (particles_far[step_far].x < cam_width / -2 - 96) {
				particles_far[step_far].restart();
				step_far = (step_far + 1) % particles_far.length;
			}
		}
		if ((rand() % 5) == 0) {
			if (particles_mid[step_mid].x < cam_width / -2 - 96) {
				particles_mid[step_mid].restart();
				step_mid = (step_mid + 1) % particles_mid.length;
			}
		}
		if ((rand() % 5) == 0) {
			if (particles_near[step_near].x < cam_width / -2 - 96) {
				particles_near[step_near].restart();
				step_near = (step_near + 1) % particles_near.length;
			}
		}
		
		/*
		//CONTROL STUFF
		if(flipped) {
			dm.y_intent(-dm.y_intent());
		}
		*/
		
		//CAMERA STUFF
		gridcheck();
		
		int current_room = ((max_grid_y - min_grid_y + 1)*(grid_x - min_grid_x) + (grid_y - min_grid_y));
		room_tiles[current_room].step(@cam, @fog);
	}
	
	void draw(float subframe) {
		c.draw_rectangle(-805,455,-600,-455,0,0xFF000000);
		c.draw_rectangle(805,455,600,-455,0,0xFF000000);
		//THIS THIRD RECTANGLE JUST SO I CAN READ FPS
		c.draw_rectangle(805,-350,350,-455,0,0xFF000000);
		
		//PARTICLE STUFF
		for(uint i = 0; i < particles_far.length; i++) {
			particles_far[i].draw(@g, cam.x(), cam.y(), flipped);
		}
		for(uint i = 0; i < particles_mid.length; i++) {
			particles_mid[i].draw(@g, cam.x(), cam.y(), flipped);
		}
		for(uint i = 0; i < particles_near.length; i++) {
			particles_near[i].draw(@g, cam.x(), cam.y(), flipped);
		}
		
		//TILE PATTERN STUFF
		int current_room = ((max_grid_y - min_grid_y + 1)*(grid_x - min_grid_x) + (grid_y - min_grid_y));
		room_tiles[current_room].draw(@g, @spr, flipped);
		
		//TEST STUFF
		//text_test.text(cam.x() + " - " + (cam.x() - (48 + cam_width / 2)) + " - " + particles_far[step_far].x);
		//text_test.text(30 + " - " + hsv_to_rgb(30, 1, 1));
		//c.draw_text(text_test, 0, 250, 1, 1, 0);
	}
	
	void on_level_start() {
		initialize();
	}
	
	void checkpoint_load() {
		initialize();
	}
	
	void initialize() {
		spr.add_sprite_set("script");
		//Not relevant for a nexus, but if I want to make a custom level with this script I'll make a custom HUD as well that doesn't get split by the black bar on the left
		g.disable_score_overlay(true);
		//Swaps the entity layer behind layer 17 so we can use layer 17 as fake opaqueness for layer 19
		g.reset_layer_order();
		g.swap_layer_order(17, 18);
		
		@dm = controller_entity(0).as_dustman();
		@cam = get_camera(0);
		@fog = cam.get_fog();
		cam.script_camera(true);
		cam.screen_height(cam_height);
		gridcheck();
		camera_update();
		
		for(uint i = 0; i < particles_far.length; i++) {
			particles_far[i].init(0);
		}
		for(uint i = 0; i < particles_mid.length; i++) {
			particles_mid[i].init(1);
		}
		for(uint i = 0; i < particles_near.length; i++) {
			particles_near[i].init(2);
		}
	}
	
	void gridcheck() {
		int old_grid_x = grid_x;
		int old_grid_y = grid_y;
		grid_x = floor((dm.x() + (cam_width/2)) / cam_width);
		grid_y = floor((dm.y() + grid_height/2) / grid_height);
		if (old_grid_x != grid_x || old_grid_y != grid_y) {
			camera_update();
		}
	}
	
	void camera_update() {
		cam.prev_x(grid_x * cam_width);
		cam.x(grid_x * cam_width);
		cam.prev_y(grid_y * grid_height);
		cam.y(grid_y * grid_height);
		if (grid_y %2 == 0) {
			flipped = false;
			cam.prev_scale_y(1);
			cam.scale_y(1);
		} else {
			flipped = true;
			cam.prev_scale_y(-1);
			cam.scale_y(-1);
		}
	}
	
	void editor_step() {
		if(detect_tiles) {
			run_tile_detection();
			detect_tiles = false;
			editor_sync_vars_menu();
		}
	}

	void editor_draw(float sub_frame) {
		for(int gx = min_grid_x; gx <= max_grid_x; gx++) {
			for(int gy = min_grid_y; gy <= max_grid_y; gy++) {
				int x1 =  gx * cam_width - (cam_width/2);
				int x2 =  gx * cam_width + (cam_width/2);
				int y1 =  gy * grid_height - (grid_height/2);
				int y2 =  gy * grid_height + (grid_height/2);
				int y3 =  gy * grid_height - (cam_height/2);
				int y4 =  gy * grid_height + (cam_height/2);

				g.draw_line_world(20, 20, x1, y1, x2, y1, 5, 0xFFFFFFFF);
				g.draw_line_world(20, 20, x1, y2, x2, y2, 5, 0xFFFFFFFF);
				g.draw_line_world(20, 20, x1, y3, x2, y3, 5, 0xFFFFFFFF);
				g.draw_line_world(20, 20, x1, y4, x2, y4, 5, 0xFFFFFFFF);
				g.draw_line_world(20, 20, x1, y1, x1, y2, 5, 0xFFFFFFFF);
				g.draw_line_world(20, 20, x2, y1, x2, y2, 5, 0xFFFFFFFF);
			}
		}
	}
	
	void run_tile_detection() {
		Room room;
		tileinfo@ t;
		tileinfo@ tb;
		
		//TURNING EXISTING VARIABLES INTO INTS
		int room_width = cam_width/48;
		int room_height = grid_height/48;
		
		room_tiles.resize(0);
		for(int gx = min_grid_x; gx <= max_grid_x; gx++) {
			for(int gy = min_grid_y; gy <= max_grid_y; gy++) {
				room = Room();
				for(int tx = 0; tx < room_width; tx++) {
					for(int ty = 0; ty < room_height; ty++) {
						int tile_x = gx * room_width - (room_width/2) + tx;
						int tile_y = gy * room_height - (room_height/2) + ty;
						@t = g.get_tile(tile_x, tile_y, 19);
						@tb = g.get_tile(tile_x, tile_y, 15);
						if(t.solid()) {
							int tile_edges = (t.edge_top() & 8) + (t.edge_bottom() & 8)/2 + (t.edge_left() & 8)/4 + (t.edge_right() & 8)/8;
							Pos p = Pos(tile_x, tile_y, tile_edges);
							room.tiles.insertLast(p);
						}
						if(tb.solid()) {
							int tile_edges = (tb.edge_top() & 8) + (tb.edge_bottom() & 8)/2 + (tb.edge_left() & 8)/4 + (tb.edge_right() & 8)/8;
							Pos p = Pos(tile_x, tile_y, tile_edges);
							room.bg_tiles.insertLast(p);
						}
					}
				}
				room_tiles.insertLast(room);
			}
		}
	}
}

class Room {
	[text] int hue = 30;
	[text] string pattern = "tile3";
	[text] string bg_pattern = "tile5";
	[hidden] array<Pos> tiles;
	[hidden] array<Pos> bg_tiles;
	
	uint32 tile_rgb = 0;
	uint32 edge_rgb = 0;
	uint32 body_rgb = 0;
	uint32 bg_tile_rgb = 0;
	uint32 bg_edge_rgb = 0;
	
	uint32 get_tile_rgb() {
		if(tile_rgb == 0) {
			tile_rgb = hsv_to_rgb(hue, .50, .70);
		}
		return tile_rgb;
	}
	
	uint32 get_edge_rgb() {
		if(edge_rgb == 0) {
			edge_rgb = hsv_to_rgb(hue, .40, .90);
		}
		return edge_rgb;
	}
	
	uint32 get_body_rgb() {
		if(body_rgb == 0) {
			body_rgb = hsv_to_rgb(hue, .50, .50);
		}
		return body_rgb;
	}
	
	uint32 get_bg_tile_rgb() {
		if(bg_tile_rgb == 0) {
			bg_tile_rgb = hsv_to_rgb(hue, .47, .13);
		}
		return bg_tile_rgb;
	}
	
	uint32 get_bg_edge_rgb() {
		if(bg_edge_rgb == 0) {
			bg_edge_rgb = hsv_to_rgb(hue, .52, .27);
		}
		return bg_edge_rgb;
	}
	
	void step(camera@ cam, fog_setting@ fog) {
		fog.colour(19, 10, body_rgb);
		fog.percent(19, 10, 1);
		cam.change_fog(@fog, 0);
	}
	
	void draw(scene@ g, sprites@ spr, bool flipped) {
		draw_tile_pattern(@g, @spr, tiles, pattern, get_tile_rgb(), get_edge_rgb(), 19, flipped);
		draw_tile_pattern(@g, @spr, bg_tiles, bg_pattern, get_bg_tile_rgb(), get_bg_edge_rgb(), 15, flipped);
	}
	
	void draw_tile_pattern(scene@ g, sprites@ spr, array<Pos> tiles, string pattern, uint32 c_pattern, uint32 c_edge, int layer, bool flipped) {
		for(uint i = 0; i < tiles.length; i++) {
			if (!flipped) {
				spr.draw_world(layer, 19, pattern, 0, 0, 48*tiles[i].x - 1, 48*tiles[i].y, 0, 0.50, 0.50, c_pattern);
			} else {
				spr.draw_world(layer, 19, pattern, 0, 0, 48*tiles[i].x - 1, 48*tiles[i].y + 48, 0, 0.50, -0.50, c_pattern);
			}
				
			int horizontal_left = 48*tiles[i].x;
			int horizontal_right = 48*tiles[i].x + 48;
			
			if (tiles[i].e & 2 > 0) { //LEFT
				g.draw_rectangle_world(layer, 20, 48*tiles[i].x - 1, 48*tiles[i].y - 1, 48*tiles[i].x + 12, 48*tiles[i].y + 49, 0, c_edge);
			} else {
				horizontal_left = horizontal_left - 12;
			}
			if (tiles[i].e & 1 > 0) { //RIGHT
				g.draw_rectangle_world(layer, 20, 48*tiles[i].x + 49, 48*tiles[i].y - 1, 48*tiles[i].x + 36, 48*tiles[i].y + 49, 0, c_edge);
			} else {
				horizontal_right = horizontal_right + 12;
			}
			if (tiles[i].e & 8 > 0) {
				g.draw_rectangle_world(layer, 20, horizontal_left, 48*tiles[i].y -1, horizontal_right, 48*tiles[i].y + 12, 0, c_edge);
			}
			if (tiles[i].e & 4 > 0) {
				g.draw_rectangle_world(layer, 20, horizontal_left, 48*tiles[i].y + 49, horizontal_right, 48*tiles[i].y + 36, 0, c_edge);
			}
		}
	}
	
	Room () {
		//
	}
}

class Pos {
	[text] int x;
	[text] int y;
	[text] int e;

	Pos(int x, int y, int e) {
		this.x = x;
		this.y = y;
		this.e = e;
	}
	
	Pos() {
		//
	}
}

class Particle {
	[hidden] float x;
	[hidden] float y;
	[hidden] int l;
	
	
	Particle() {
		//
	}
	
	void init(int layer) {
		x = (rand() % (480 + cam_width)) - (480 + cam_width)/2;
		y = (rand() % cam_height) - cam_height/2;
		l = layer;
	}
	
	void step() {
		switch(l) {
			case 0:
				x = x - (cam_width / 140);
				break;
			case 1:
				x = x - (cam_width / 110);
				break;
			case 2:
				x = x - (cam_width / 80);
				break;
		}
	}
	
	void draw(scene@ g, float cam_x, float cam_y, bool flipped) {
		switch(l) {
			case 0:
			case 1:
				if (!flipped) {
					g.draw_rectangle_world(14, 20, cam_x + x, cam_y + y, cam_x + x + 12, cam_y + y + 12, 0, 0xFF222222);
				} else {
					g.draw_rectangle_world(14, 20, cam_x + x, cam_y - y, cam_x + x + 12, cam_y - y - 12, 0, 0xFF222222);
				}
				break;
			case 2:
				if (!flipped) {
					g.draw_rectangle_world(14, 20, cam_x + x, cam_y + y, cam_x + x + 12, cam_y + y + 12, 0, 0xFF555555);
				} else {
					g.draw_rectangle_world(14, 20, cam_x + x, cam_y - y, cam_x + x + 12, cam_y - y - 12, 0, 0xFF555555);
				}
				break;
		}
	}
	
	void restart() {
		x = cam_width / 2 + 96;
		y = (rand() % cam_height) - cam_height/2;
	}
}

uint32 hsv_to_rgb(float hue, float sat, float val) {
	float c = val * sat;
	float h = hue % 360;
	float hs = (h / 60.0);
	float x = c * (1 - abs((hs % 2) - 1));
	float m = val - c;
	float rp = 0;
	float gp = 0;
	float bp = 0;
	int hi = floor(hs);
	switch(hi) {
		case 0:
			rp = c;
			gp = x;
			break;
		case 1:
			rp = x;
			gp = c;
			break;
		case 2:
			gp = c;
			bp = x;
			break;
		case 3:
			gp = x;
			bp = c;
			break;
		case 4:
			rp = x;
			bp = c;
			break;
		case 5:
			rp = c;
			bp = x;
			break;
	}
	int r = floor((rp+m)*255 + 0.5);
	int g = floor((gp+m)*255 + 0.5);
	int b = floor((bp+m)*255 + 0.5);
	uint32 rgb = 0xFF000000 + (r << 16) + (g << 8) + b;
	return rgb;
}