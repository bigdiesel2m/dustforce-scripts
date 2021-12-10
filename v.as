const string EMBED_tile1 = "vsprites/tile1.png";
const string EMBED_tile2 = "vsprites/tile2.png";
const string EMBED_tile3 = "vsprites/tile3.png";
const string EMBED_tile4 = "vsprites/tile4.png";
const string EMBED_tile5 = "vsprites/tile5.png";
const string EMBED_door = "vsprites/door.png";

const string EMBED_excla = "vfont/!.png";
const string EMBED_pound = "vfont/#.png";
const string EMBED_money = "vfont/$.png";
const string EMBED_percent = "vfont/%.png";
const string EMBED_amp = "vfont/&.png";
const string EMBED_opar = "vfont/(.png";
const string EMBED_cpar = "vfont/).png";
const string EMBED_comma = "vfont/,.png";
const string EMBED_apos = "vfont/'.png";
const string EMBED_dash = "vfont/-.png";
const string EMBED_semi = "vfont/;.png";
const string EMBED_at = "vfont/@.png";
const string EMBED_obrace = "vfont/[.png";
const string EMBED_cbrace = "vfont/].png";
const string EMBED_under = "vfont/_.png";
const string EMBED_grave = "vfont/`.png";
const string EMBED_plus = "vfont/+.png";
const string EMBED_equals = "vfont/=.png";
const string EMBED_ast = "vfont/ast.png";
const string EMBED_chevl = "vfont/chevl.png";
const string EMBED_chevr = "vfont/chevr.png";
const string EMBED_colon = "vfont/colon.png";
const string EMBED_period = "vfont/period.png";
const string EMBED_quest = "vfont/quest.png";
const string EMBED_slash = "vfont/slash.png";
const string EMBED_space = "vfont/space.png";

const string EMBED_bslash = "vfont/bslash.png";

const string EMBED_0 = "vfont/0.png";
const string EMBED_1 = "vfont/1.png";
const string EMBED_2 = "vfont/2.png";
const string EMBED_3 = "vfont/3.png";
const string EMBED_4 = "vfont/4.png";
const string EMBED_5 = "vfont/5.png";
const string EMBED_6 = "vfont/6.png";
const string EMBED_7 = "vfont/7.png";
const string EMBED_8 = "vfont/8.png";
const string EMBED_9 = "vfont/9.png";

const string EMBED_A = "vfont/A.png";
const string EMBED_B = "vfont/B.png";
const string EMBED_C = "vfont/C.png";
const string EMBED_D = "vfont/D.png";
const string EMBED_E = "vfont/E.png";
const string EMBED_F = "vfont/F.png";
const string EMBED_G = "vfont/G.png";
const string EMBED_H = "vfont/H.png";
const string EMBED_I = "vfont/I.png";
const string EMBED_J = "vfont/J.png";
const string EMBED_K = "vfont/K.png";
const string EMBED_L = "vfont/L.png";
const string EMBED_M = "vfont/M.png";
const string EMBED_N = "vfont/N.png";
const string EMBED_O = "vfont/O.png";
const string EMBED_P = "vfont/P.png";
const string EMBED_Q = "vfont/Q.png";
const string EMBED_R = "vfont/R.png";
const string EMBED_S = "vfont/S.png";
const string EMBED_T = "vfont/T.png";
const string EMBED_U = "vfont/U.png";
const string EMBED_V = "vfont/V.png";
const string EMBED_W = "vfont/W.png";
const string EMBED_X = "vfont/X.png";
const string EMBED_Y = "vfont/Y.png";
const string EMBED_Z = "vfont/Z.png";

const string EMBED_a2 = "vfont/a2.png";
const string EMBED_b2 = "vfont/b2.png";
const string EMBED_c2 = "vfont/c2.png";
const string EMBED_d2 = "vfont/d2.png";
const string EMBED_e2 = "vfont/e2.png";
const string EMBED_f2 = "vfont/f2.png";
const string EMBED_g2 = "vfont/g2.png";
const string EMBED_h2 = "vfont/h2.png";
const string EMBED_i2 = "vfont/i2.png";
const string EMBED_j2 = "vfont/j2.png";
const string EMBED_k2 = "vfont/k2.png";
const string EMBED_l2 = "vfont/l2.png";
const string EMBED_m2 = "vfont/m2.png";
const string EMBED_n2 = "vfont/n2.png";
const string EMBED_o2 = "vfont/o2.png";
const string EMBED_p2 = "vfont/p2.png";
const string EMBED_q2 = "vfont/q2.png";
const string EMBED_r2 = "vfont/r2.png";
const string EMBED_s2 = "vfont/s2.png";
const string EMBED_t2 = "vfont/t2.png";
const string EMBED_u2 = "vfont/u2.png";
const string EMBED_v2 = "vfont/v2.png";
const string EMBED_w2 = "vfont/w2.png";
const string EMBED_x2 = "vfont/x2.png";
const string EMBED_y2 = "vfont/y2.png";
const string EMBED_z2 = "vfont/z2.png";

const float cam_height = 1152;
const float cam_width = 1536;
const float y_buffer = 192;

const int min_grid_x = -1;
const int max_grid_x = 1;
const int min_grid_y = -3;
const int max_grid_y = 4;

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
		msg.set_string("door", "door");

		msg.set_string("!", "excla");
		msg.set_string("#", "pound");
		msg.set_string("$", "money");
		msg.set_string("%", "percent");
		msg.set_string("&", "amp");
		msg.set_string("(", "opar");
		msg.set_string(")", "cpar");
		msg.set_string(",", "comma");
		msg.set_string("'", "apos");
		msg.set_string("-", "dash");
		msg.set_string(";", "semi");
		msg.set_string("@", "at");
		msg.set_string("[", "obrace");
		msg.set_string("]", "cbrace");
		msg.set_string("_", "under");
		msg.set_string("`", "grave");
		msg.set_string("+", "plus");
		msg.set_string("=", "equals");
		msg.set_string("*", "ast");
		msg.set_string("<", "chevl");
		msg.set_string(">", "chevr");
		msg.set_string(":", "colon");
		msg.set_string(".", "period");
		msg.set_string("?", "quest");
		msg.set_string("/", "slash");
		msg.set_string(" ", "space");
		
		msg.set_string("\\", "bslash");

		msg.set_string("0", "0");
		msg.set_string("1", "1");
		msg.set_string("2", "2");
		msg.set_string("3", "3");
		msg.set_string("4", "4");
		msg.set_string("5", "5");
		msg.set_string("6", "6");
		msg.set_string("7", "7");
		msg.set_string("8", "8");
		msg.set_string("9", "9");

		msg.set_string("A", "A");
		msg.set_string("B", "B");
		msg.set_string("C", "C");
		msg.set_string("D", "D");
		msg.set_string("E", "E");
		msg.set_string("F", "F");
		msg.set_string("G", "G");
		msg.set_string("H", "H");
		msg.set_string("I", "I");
		msg.set_string("J", "J");
		msg.set_string("K", "K");
		msg.set_string("L", "L");
		msg.set_string("M", "M");
		msg.set_string("N", "N");
		msg.set_string("O", "O");
		msg.set_string("P", "P");
		msg.set_string("Q", "Q");
		msg.set_string("R", "R");
		msg.set_string("S", "S");
		msg.set_string("T", "T");
		msg.set_string("U", "U");
		msg.set_string("V", "V");
		msg.set_string("W", "W");
		msg.set_string("X", "X");
		msg.set_string("Y", "Y");
		msg.set_string("Z", "Z");

		msg.set_string("a", "a2");
		msg.set_string("b", "b2");
		msg.set_string("c", "c2");
		msg.set_string("d", "d2");
		msg.set_string("e", "e2");
		msg.set_string("f", "f2");
		msg.set_string("g", "g2");
		msg.set_string("h", "h2");
		msg.set_string("i", "i2");
		msg.set_string("j", "j2");
		msg.set_string("k", "k2");
		msg.set_string("l", "l2");
		msg.set_string("m", "m2");
		msg.set_string("n", "n2");
		msg.set_string("o", "o2");
		msg.set_string("p", "p2");
		msg.set_string("q", "q2");
		msg.set_string("r", "r2");
		msg.set_string("s", "s2");
		msg.set_string("t", "t2");
		msg.set_string("u", "u2");
		msg.set_string("v", "v2");
		msg.set_string("w", "w2");
		msg.set_string("x", "x2");
		msg.set_string("y", "y2");
		msg.set_string("z", "z2");
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
		
		int current_room = int(floor(((max_grid_y - min_grid_y + 1)*(grid_x - min_grid_x) + (grid_y - min_grid_y))/2));
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
		int current_room = int(floor(((max_grid_y - min_grid_y + 1)*(grid_x - min_grid_x) + (grid_y - min_grid_y))/2));
		room_tiles[current_room].draw(@g, @c, @spr, flipped);
		
		//TEST STUFF
		//text_test.text(cam.x() + " - " + (cam.x() - (48 + cam_width / 2)) + " - " + particles_far[step_far].x);
		//text_test.text(30 + " - " + hsv_to_rgb(30, 1, 1));
		//c.draw_text(text_test, 0, 250, 1, 1, 0);
	}
	
	void on_level_start() {
		initialize();
		
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
	}
	
	void gridcheck() {
		int old_grid_x = grid_x;
		int old_grid_y = grid_y;
		grid_x = int(floor((dm.x() + (cam_width/2)) / cam_width));
		grid_y = int(floor((dm.y() + grid_height/2) / grid_height));
		if (old_grid_x != grid_x || old_grid_y != grid_y) {
			camera_update();
		}
        
        //SKYHAWK'S CODE TO FIX RESIZING ISSUES
        float _, height;
        cam.get_layer_draw_rect(0, 19, _, _, _, height);
        if(not closeTo(height, cam_height, 0.001)) {
            cam.script_camera(false);
            cam.screen_height(cam_height);
            camera_update();
        }
        else if(not cam.script_camera()){
            cam.script_camera(true);
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
				float x1 =  gx * cam_width - (cam_width/2);
				float x2 =  gx * cam_width + (cam_width/2);
				float y1 =  gy * grid_height - (grid_height/2);
				float y2 =  gy * grid_height + (grid_height/2);
				float y3 =  gy * grid_height - (cam_height/2);
				float y4 =  gy * grid_height + (cam_height/2);

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
		int room_width = int(cam_width/48);
		int room_height = int(grid_height/48);
		
		room_tiles.resize(0);
		for(int gx = min_grid_x; gx <= max_grid_x; gx++) {
			for(int gy = min_grid_y + 1; gy <= max_grid_y; gy+=2) {
				room = Room();
				//TILE DETECTION AND STORAGE
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
				//DOOR DETECTION AND STORAGE
				int entint = g.get_entity_collision(gy * grid_height - (3*grid_height/2), gy * grid_height + (grid_height/2), gx * cam_width - cam_width/2, gx * cam_width + cam_width/2, 16);
				for(int j=0; j < entint; j++) {
					entity@ CurrentEntity = g.get_entity_collision_index(j);
					if (CurrentEntity.type_name() == "level_door") {
						if (CurrentEntity.y() > gy * grid_height - grid_height/2) {
							Pos p = Pos(int(6*round(CurrentEntity.x()/6)),int(6*round(CurrentEntity.y()/6)), 0);
							room.doors.insertLast(p);
						} else {
							Pos p = Pos(int(6*round(CurrentEntity.x()/6)),int(6*round((2*(gy * grid_height - grid_height/2) - CurrentEntity.y())/6)), 1);
							room.doors.insertLast(p);
						}
					}
				}

				room.y_coord = gy;
				room_tiles.insertLast(room);
			}
		}
	}
}

class Room {
	[hidden] int y_coord = 0;
	[text|tooltip:"Hue angle, from 0 to 359"] int hue = 30;
	[option,1:1,2:2,3:3,4:4,5:5] int pattern = 3;
	[option,1:1,2:2,3:3,4:4,5:5] int bg_pattern = 5;
	[text] string name = "";
	[hidden] array<Pos> tiles;
	[hidden] array<Pos> bg_tiles;
	[hidden] array<Pos> doors;
	
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
	
	void draw(scene@ g, canvas@ c, sprites@ spr, bool flipped) {
		draw_tile_pattern(@g, @spr, tiles, pattern, get_tile_rgb(), get_edge_rgb(), 19, flipped);
		draw_tile_pattern(@g, @spr, bg_tiles, bg_pattern, get_bg_tile_rgb(), get_bg_edge_rgb(), 15, flipped);
		draw_door_sprites(@g, @spr, doors, 18, flipped);
		draw_text_sprites(@c, @spr, name);
	}
	
	void draw_tile_pattern(scene@ g, sprites@ spr, array<Pos> tiles, int pattern, uint32 c_pattern, uint32 c_edge, int layer, bool flipped) {
		//FIND TILE Y VALUE MIDWAY BETWEEN FLIPPED AND NONFLIPPED VERSIONS OF THE ROOM
		int room_ht = (cam_height + y_buffer) / 48;
		int midy = (y_coord * room_ht) - room_ht/2;
		for(uint i = 0; i < tiles.length; i++) {
			//PATTERN DRAWING
			if (!flipped) {
				spr.draw_world(layer, 19, "tile"+pattern, 0, 0, 48*tiles[i].x - 1, 48*tiles[i].y, 0, 0.50, 0.50, c_pattern);
			} else {
				spr.draw_world(layer, 19, "tile"+pattern, 0, 0, 48*tiles[i].x - 1, 48*(2*midy - tiles[i].y), 0, 0.50, -0.50, c_pattern);
			}
			
			//EDGE DRAWING
			int horizontal_left = 48*tiles[i].x;
			int horizontal_right = 48*tiles[i].x + 48;
			if (!flipped) {
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
			} else {
				if (tiles[i].e & 2 > 0) { //LEFT
					g.draw_rectangle_world(layer, 20, 48*tiles[i].x - 1, 48*(2*midy - tiles[i].y) - 49, 48*tiles[i].x + 12, 48*(2*midy - tiles[i].y) + 1, 0, c_edge);
				} else {
					horizontal_left = horizontal_left - 12;
				}
				if (tiles[i].e & 1 > 0) { //RIGHT
					g.draw_rectangle_world(layer, 20, 48*tiles[i].x + 49, 48*(2*midy - tiles[i].y) - 49, 48*tiles[i].x + 36, 48*(2*midy - tiles[i].y) + 1, 0, c_edge);
				} else {
					horizontal_right = horizontal_right + 12;
				}
				if (tiles[i].e & 8 > 0) {
					g.draw_rectangle_world(layer, 20, horizontal_left, 48*(2*midy - tiles[i].y) - 12, horizontal_right, 48*(2*midy - tiles[i].y) + 1, 0, c_edge);
				}
				if (tiles[i].e & 4 > 0) {
					g.draw_rectangle_world(layer, 20, horizontal_left, 48*(2*midy - tiles[i].y) - 36, horizontal_right, 48*(2*midy - tiles[i].y) - 49, 0, c_edge);
				}
			}
		}
	}

	void draw_door_sprites(scene@ g, sprites@ spr, array<Pos> doors, int layer, bool flipped) {
		int room_ht = cam_height + y_buffer;
		int midy = (y_coord * room_ht) - room_ht/2;
		for(uint i = 0; i < doors.length; i++) {
			if (!flipped) {
				if (doors[i].e == 0) {
					spr.draw_world(layer, 0, "door", 0, 0, doors[i].x - 36, doors[i].y - 97, 0, 1, 1, 0xFFFFFFFF);
				} else {
					spr.draw_world(layer, 0, "door", 0, 0, doors[i].x - 36, doors[i].y + 97, 0, 1, -1, 0xFFFFFFFF);
				}
			} else {
				if (doors[i].e == 0) {
					spr.draw_world(layer, 0, "door", 0, 0, doors[i].x - 36, 2*midy - doors[i].y + 97, 0, 1, -1, 0xFFFFFFFF);
				} else {
					spr.draw_world(layer, 0, "door", 0, 0, doors[i].x - 36, 2*midy - doors[i].y - 97, 0, 1, 1, 0xFFFFFFFF);
				}
			}
		}
	}

	void draw_text_sprites(canvas@ c, sprites@ spr, string name) {
		if (name != "") {
			c.draw_rectangle(-805,410,805,500,0,0xFF000000);
			int start = -16 * name.length();
			for(uint i = 0; i < name.length(); i++) {
				spr.draw_hud(20, 20, name.substr(i,1), 0, 0, start + i*32, 415, 0, 0.5, 0.5, 0xFFC4C4E3);
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
	int hi = int(floor(hs));
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
	int r = int(round((rp+m)*255));
	int g = int(round((gp+m)*255));
	int b = int(round((bp+m)*255));
	uint32 rgb = 0xFF000000 + (r << 16) + (g << 8) + b;
	return 0xFF000000 + (r << 16) + (g << 8) + b;
}