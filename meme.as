/* 
Simple entity animation replacement script made during DLC 2.
Might be a nice reference for a basic implementation of this concept.
http://atlas.dustforce.com/11126/attacky-3
*/

const string EMBED_apple0 = "anim/f1.png";
const string EMBED_apple1 = "anim/f2.png";
const string EMBED_apple2 = "anim/f3.png";
const string EMBED_apple3 = "anim/f4.png";
const string EMBED_apple4 = "anim/f5.png";
const string EMBED_apple5 = "anim/f6.png";
const string EMBED_apple6 = "anim/f7.png";
const string EMBED_apple7 = "anim/f8.png";
const string EMBED_apple8 = "anim/f9.png";
const string EMBED_apple9 = "anim/f10.png";
const string EMBED_apple10 = "anim/f11.png";
const string EMBED_apple11 = "anim/f12.png";
const string EMBED_apple12 = "anim/f13.png";
const string EMBED_apple13 = "anim/f14.png";

class script: callback_base {
    scene@ g;
    [entity] int apple_id;
    entity@ apple;
    sprites@ spr;
	float animation_timer = 0;

    script() {
        @g = get_scene();
        @spr = create_sprites();
    }
    
    void build_sprites(message@ msg) {
        build_spriteset(@msg, "apple", 14, 96);
    }
    
    void build_spriteset(message@ msg, string name, uint len, int offset) {
        for (uint i = 0; i < len; i++) {
            msg.set_string(name + i, name + i);
            msg.set_int(name + i + "|offsetx", offset);
            msg.set_int(name + i + "|offsety", offset);
        }
    }
	
    void on_level_start() {
        //puts("LEVEL START");
        spr.add_sprite_set("script");
        @apple = entity_by_id(apple_id);
        if(@apple != null && apple.type_name() == "hittable_apple")
            apple.set_sprites(spr);
    }
	
    void step(int entities) {
		if(@apple != null) {
			animation_timer = (animation_timer + 0.28) % 14;
		}
	}
	
	
	void draw(float subframe) {
		if(@apple != null) {
			spr.draw_world(18, 8, "apple" + int(animation_timer), 0, 0, apple.x(), apple.y(), 0, 1, 1, 0xFFFFFFFF);
		}
	}
}