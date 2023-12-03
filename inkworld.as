// On Hit Test
class script : callback_base {
    scene@ g;
	
	controllable@ me;
	controllable@ enemy;
	
	hitbox@ attackbox;
	
	float midx;
	float midy;
	int hitdir;
	
    script() {
        @g = get_scene();
    }
	
    void on_level_start() {
		@me = controller_controllable(0);
		me.on_hit_callback(this,"on_player_hit", 0);
    }
	
	void on_player_hit(controllable@ attacker, controllable@ attacked, hitbox@ attack_hitbox, int arg) {
		@enemy = attacked;
		@attackbox = attack_hitbox;
		rectangle@ hurtbox = attacked.hurt_rect();
		
		midx = attacked.x() + hurtbox.left() + hurtbox.get_width() * 0.5;
		midy = attacked.y() + hurtbox.top() + hurtbox.get_height() * 0.5;
		hitdir = attack_hitbox.attack_dir();
	}
	
	void draw(float sub_frame) {
		if(@enemy != null) {
			g.draw_line_world(20, 20, midx, midy + 10, midx, midy - 10, 3, 4294967295);
			g.draw_line_world(20, 20, midx + 10, midy, midx - 10, midy, 3, 4294967295);
			if(@attackbox != null) {
				rectangle@ attackrec = attackbox.base_rectangle();
				switch(hitdir) {
					case -151:
					case -150:
						g.draw_rectangle_world(20, 20, midx, midy, midx - attackrec.get_width(), midy + attackrec.get_height(), 0, 0xFFFFFFFF);
						break;
					case -85:
						g.draw_rectangle_world(20, 20, midx, midy - attackrec.get_height() * 0.5, midx - attackrec.get_width(), midy + attackrec.get_height() * 0.5, 0, 0xFFFFFFFF);
						break;
					case -30:
						g.draw_rectangle_world(20, 20, midx, midy, midx - attackrec.get_width(), midy - attackrec.get_height(), 0, 0xFFFFFFFF);
						break;
					case 30:
						g.draw_rectangle_world(20, 20, midx, midy, midx + attackrec.get_width(), midy - attackrec.get_height(), 0, 0xFFFFFFFF);
						break;
					case 85:
						g.draw_rectangle_world(20, 20, midx, midy - attackrec.get_height() * 0.5, midx + attackrec.get_width(), midy + attackrec.get_height() * 0.5, 0, 0xFFFFFFFF);
						break;
					case 150:
					case 151:
						g.draw_rectangle_world(20, 20, midx, midy, midx + attackrec.get_width(), midy + attackrec.get_height(), 0, 0xFFFFFFFF);
						break;
				}	
				//g.draw_rectangle_world(20, 20, attackbox.x() + attackrec.left(), attackbox.y() + attackrec.top(), attackbox.x() + attackrec.right(), attackbox.y() + attackrec.bottom(), 0, 4294967295);
			}
		}
	}
	
	/* void step(int entities) {	
        rand = rand + 17;
		if(rand > 360) {
			rand = rand - 360;
		}
	} */
}