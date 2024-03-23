#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <cromchat>
#include <nvault>

#include <shop>
#include <inventory>

native set_user_colors(id, r, g, b);

#define RAINBOW_PRICE 5000
#define RAINBOW_ID 9002

new g_vault;

new bool:g_bRainbow[33];
new g_iRainbowSpeed = 3;
new g_cRainbowSpeed;

new g_iTaskEnt;

public plugin_init(){
	register_item("Rainbow Hud", "handleRainbow", "shop_hud.amxx", RAINBOW_PRICE, RAINBOW_ID);

	register_clcmd("say /rainbow", "toggle_rainbow");

	g_cRainbowSpeed = register_cvar("rainbow_speed", "5");
	hook_cvar_change(g_cRainbowSpeed, "rainbow_speed_changed");

	CC_SetPrefix("&x04[SHOP]");

	register_forward(FM_Think, "think")
	
	g_iTaskEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))	
	set_pev(g_iTaskEnt, pev_classname, "rainbow_think")
	set_pev(g_iTaskEnt, pev_nextthink, get_gametime() + 1.01)

	g_vault = nvault_open("rainbow");
}

public plugin_end(){
	nvault_close(g_vault);
}

public client_putinserver(id){
	load_rainbow(id);
}

public client_disconnected(id){
	g_bRainbow[id] = false;
}

public think(ent){
	if(ent == g_iTaskEnt) 
	{
		rainbow_task();
		set_pev(ent, pev_nextthink,  get_gametime() + 0.2);
	}
}

public rainbow_speed_changed(pcvar, old_value, new_value){
	g_iRainbowSpeed = get_pcvar_num(g_cRainbowSpeed);
}
// Speed
/*
public rainbow_task()
{
	new Float:vel[3];
	new speed;
	new h, Float:s, colors[3];
	
	for(new id;id<33;id++){
		if(!g_bRainbow[id] || !is_user_alive(id)) continue;

		get_user_velocity(id, vel);
		speed = sqroot(power(floatround(vel[0]), 2) + power(floatround(vel[1]), 2));

		h = ( (speed % 2000) * 360 ) / 2000;

		s = floatclamp(float(speed) / 5000.0 + 0.5, 0.0, 1.0);

		hsv2rgb(h, s, 1, colors);

		set_user_colors(id, colors[0], colors[1], colors[2]);
	}
}
*/
// Time
public rainbow_task()
{
	static hue[33];
	new h, Float:s, colors[3];

	for(new id;id<33;id++){
		if(!g_bRainbow[id] || !is_user_alive(id)) continue;

		h = hue[id];

		hsv2rgb(h, 1.0, 1, colors);

		set_user_colors(id, colors[0], colors[1], colors[2]);

		client_cmd(id, "cl_crosshair_color ^"%d %d %d^"", colors[0], colors[1], colors[2]);

		hue[id]+=g_iRainbowSpeed;
		if(hue[id] >= 360)
			hue[id] = 0;
	}
}


public handleRainbow(id){

	inventory_add(id, RAINBOW_ID);

	new szName[64];
	get_user_name(id, szName, 63);
	CC_SendMessage(0, "&x01Jucatorul &x04%s &x01a cumparat &x07Rainbow Hud &x01din shop pentru &x04%d &x01de credite!", szName, RAINBOW_PRICE);
	CC_SendMessage(id, "&x01Felicitari, acum ai acces la comanda &x04/rainbow!");


	return PLUGIN_CONTINUE;
}

public toggle_rainbow(id){
	if(!inventory_get_item(id, RAINBOW_ID)){
		CC_SendMessage(id, "&x01Nu ai acces la comanda &x04/rainbow!");
		return PLUGIN_HANDLED;
	}
	g_bRainbow[id] = !g_bRainbow[id];

	CC_SendMessage(id, "&x01Ai %s &x04Rainbow Hud!", g_bRainbow[id]?"activat":"dezactivat");

	save_rainbow(id);

	return PLUGIN_HANDLED;
}

public save_rainbow(id){
	new key[32];
	get_user_name(id, key, charsmax(key));

	if(g_bRainbow[id])
		nvault_set(g_vault, key, "1");
	else
		nvault_remove(g_vault, key);
}

public load_rainbow(id){
	new key[32], rainbow[1], timestamp;
	get_user_name(id, key, charsmax(key));

	if(nvault_lookup(g_vault, key, rainbow, charsmax(rainbow), timestamp)){
		g_bRainbow[id] = true;
	}
}

stock hsv2rgb(h, Float:s, v, colors[]){
	new Float:part = float(h) / 60.0;
	new rgbMax = floatround(255.0 * s);

	if( part < 1.0 ){
		colors[0] = rgbMax;
		colors[1] = funcup(part, rgbMax);
		colors[2] = 0;
	}
	else if( part < 2.0 ){
		colors[0] = funcdown(part, rgbMax);
		colors[1] = rgbMax,
		colors[2] = 0;
	}
	else if( part < 3.0 ){
		colors[0] = 0;
		colors[1] = rgbMax,
		colors[2] = funcup(part, rgbMax);
	}
	else if( part < 4.0 ){
		colors[0] = 0;
		colors[1] = funcdown(part, rgbMax),
		colors[2] = rgbMax;
	}
	else if( part < 5.0 ){
		colors[0] = funcup(part, rgbMax);
		colors[1] = 0,
		colors[2] = rgbMax;
	}
	else if( part < 6.0 ){
		colors[0] = rgbMax;
		colors[1] = 0,
		colors[2] = funcdown(part, rgbMax);
	}
}

stock funcdown(Float:value, maxValue){
	value -= floatround(value, floatround_floor);

	return floatround(maxValue - (maxValue * value));
}

stock funcup(Float:value, maxValue){
	value -= floatround(value, floatround_floor);

	return floatround(maxValue * value);
}