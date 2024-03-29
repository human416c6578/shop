#include <amxmodx>
#include <fakemeta>
#include <cromchat>

#include <shop>
#include <inventory>

#define PLUGIN_NAME "Trail Menu"
#define PLUGIN_VERSION "1.3"
#define PLUGIN_AUTHOR "Glaster"

#define TIME_POSITION_CHECK 5.0
#define TIME_POSITION_TASK 3.0
#define INDEX_POSITION_TASK 129910

#define MAX_SPRITES 32

#define TRAIL_ID 9001
#define TRAIL_PRICE 10000

new g_iDataSprites[][][] = {
	// Format: {Path_To_Sprite, id}
	{"sprites/new/bio.spr", "1"},
	{"sprites/new/chain.spr", "2"},
	{"sprites/new/Half-Life.spr", "4"},
	{"sprites/new/lighting.spr", "5"},
	{"sprites/new/love.spr", "6"},
	{"sprites/new/minecraft.spr", "7"},
	{"sprites/new/snow_white.spr", "8"},
	{"sprites/new/tok.spr", "9"},
	{"sprites/new/tok1.spr", "10"},
	{"sprites/new1/blue-green.spr", "11"},
	{"sprites/new1/blue-pink.spr", "13"},
	{"sprites/new1/Dota2.spr", "14"},
	{"sprites/new1/icecream.spr", "15"},
	{"sprites/new1/pink-jacket.spr", "16"},
	{"sprites/new1/yellow-green.spr", "17"},
};

new g_iDataColors[][][] = {
	//Format: {ColorName, R, G, B}
	{"Red", "255", "0", "0"},
	{"Green", "0", "255", "0"},
	{"Blue", "0", "0", "255"},
	{"White", "255", "255", "255"},
	{"Orange", "255", "165", "0"},
	{"Yellow", "255", "255", "0"},
	{"Green", "0", "255", "0"},
	{"Purple", "128", "0", "128"},
	{"BSoD","0","0","170"}   
	

};

new g_iSprites[MAX_SPRITES + 1], g_iUserType[33], g_iUserColor[33];
		   
public plugin_precache() {
	for(new i; i < sizeof(g_iDataSprites); i++)
		if(i <= MAX_SPRITES)
			g_iSprites[i] = engfunc(EngFunc_PrecacheModel, g_iDataSprites[i][0]);
}

public plugin_init() {
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
	
	register_menucmd(register_menuid("Show_TrailMenu"), (1<<0|1<<1|1<<9), "Handle_TrailMenu");
	
	register_concmd("say /trail", "Show_TrailMenu");
	register_concmd("say_team /trail", "Show_TrailMenu");

	register_item("Trail", "handleTrail", "shop_trail.amxx", TRAIL_PRICE, TRAIL_ID);
}

public handleTrail(id){
	inventory_add(id, TRAIL_ID);

	new szName[64];
	get_user_name(id, szName, 63);
	CC_SendMessage(0, "&x01Jucatorul &x04%s &x01a cumparat &x07Trail &x01din shop pentru &x04%d &x01de credite!", szName, TRAIL_PRICE);
	CC_SendMessage(id, "&x01Felicitari, acum ai acces la &x04Trail!", szName);

	return PLUGIN_CONTINUE;
}

public client_putinserver(id) {
	g_iUserColor[id] = 0;
	g_iUserType[id] = -1;
}

public Show_TrailMenu(id) {
	if(!inventory_get_item(id, TRAIL_ID)){
		CC_SendMessage(id, "&x01Nu ai acces la comanda &x04/trail!");
		return PLUGIN_HANDLED;
	}
	new szMenu[512], iLen = formatex(szMenu, charsmax(szMenu), "\wTrail MEnu^n^n");
	
	if(g_iUserType[id] == -1) {
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y[1] \wStyle \r[OFF]^n");
	}
	else {
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y[1] \wStyle \r[%s]^n", g_iDataSprites[g_iUserType[id]][1]);
	}
	
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y[2] \wColor \r[%s]^n^n", g_iDataColors[g_iUserColor[id]][0]);
	
	formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\y[0] \wExit");
	return show_menu(id, (1<<0|1<<1|1<<9), szMenu, -1, "Show_TrailMenu");
}

public Handle_TrailMenu(id, iKey) {
	switch(iKey) {
		case 0: {
			if((sizeof(g_iDataSprites) - 1) <= g_iUserType[id]) {
				g_iUserType[id] = -1;
			}
			else {
				g_iUserType[id]++;
			}
		}
		case 1:{ 
			if((sizeof(g_iDataColors) - 1) <= g_iUserColor[id]) {
				g_iUserColor[id] = 0;
			}
			else {
				g_iUserColor[id]++;
			}
		}
		case 9: return PLUGIN_HANDLED;
	}
	
	remove_task(INDEX_POSITION_TASK + id);
	remove_trail(id);
	
	set_task(TIME_POSITION_TASK, "check_potision", INDEX_POSITION_TASK + id, _, _, "b");
	create_trail(id);
	
	return Show_TrailMenu(id);
}

public create_trail(id) {
	if(!is_user_alive(id) || g_iUserType[id] == -1) {
		return false;
	}
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(22);
	write_short(id);											//id
	write_short(g_iSprites[g_iUserType[id]]);				//sprite
	write_byte(2 * 10);										//life
	write_byte(5);											//size
	write_byte(str_to_num(g_iDataColors[g_iUserColor[id]][1]));								//r
	write_byte(str_to_num(g_iDataColors[g_iUserColor[id]][2]));											//g
	write_byte(str_to_num(g_iDataColors[g_iUserColor[id]][3]));											//b
	write_byte(255);										//brightness
	message_end();
	
	return true;
}

public check_potision(id) {
	id = id - INDEX_POSITION_TASK;
	
	static Float:fTime[33], Float:fOrigin[33][3];
	
	if(fTime[id] + TIME_POSITION_CHECK < get_gametime()) {
		pev(id, pev_origin, fOrigin[id]);
		fTime[id] = get_gametime();
	}
	
	new Float:fOriginTwo[3];
	pev(id, pev_origin, fOriginTwo);
	
	if(fOrigin[id][0] == fOriginTwo[0] && fOrigin[id][1] == fOriginTwo[1] && fOrigin[id][2] == fOriginTwo[2]) {
		remove_trail(id);
		create_trail(id);
	}
}

public remove_trail(id) {
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(99);
	write_short(id);
	message_end();
}
