#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat2>

#include <player_skins_submodels>
#include <shop>
#include <credits>
#include <inventory>
#include <vip>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 32
//#define BUTCHER_NUM 9
#define BAYONET_NUM 3
//#define DAGGER_NUM 3
//#define KATANA_NUM 4
#define USP_NUM 24
#define CHARS_NUM 16

enum eSkin
{
	iSkinId,
	szName[64],
	szModel[64],
	iSubModel,
	iCost
}

enum ePlayerSkin
{
	iPlayerSkinId,
	szPlayerName[64],
	szPlayerModel[128],
	iSubmodel,
	iPlayerCost
}

enum eMenu
{
	iKnives = 0,
	iButchers,
	iBayonets,
	//iDaggers,
	//iKatanas,
	iUsps,
	iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Knife Default",          "models/fwo20251/v_def_free_and_vip.mdl", 0, 0},
	{101, "Butcher Default",        "models/fwo20251/v_but_free_and_vip.mdl", 0, 0},

	{133, "Knife Ahegao",       "models/fwo20251/v_def_free_and_vip.mdl", 26, 1000},
	{134, "Knife Black",        "models/fwo20251/v_def_free_and_vip.mdl", 41, 1000},
	{135, "Knife Black-Orange", "models/fwo20251/v_def_free_and_vip.mdl", 37, 1000},
	{136, "Knife Blood",        "models/fwo20251/v_def_free_and_vip.mdl", 20, 1000},
	{137, "Knife Fire",         "models/fwo20251/v_def_free_and_vip.mdl", 21, 1000},
	{138, "Knife Fire Flower",  "models/fwo20251/v_def_free_and_vip.mdl", 22, 1000},
	{139, "Knife Galaxy",       "models/fwo20251/v_def_free_and_vip.mdl", 30, 1000},
	{140, "Knife Goku",         "models/fwo20251/v_def_free_and_vip.mdl", 31, 1000},
	{141, "Knife Gold",         "models/fwo20251/v_def_free_and_vip.mdl", 32, 1000},
	{142, "Knife Grizzly",      "models/fwo20251/v_def_free_and_vip.mdl", 23, 1000},
	{143, "Knife Howl",         "models/fwo20251/v_def_free_and_vip.mdl", 24, 1000},
	{144, "Knife Icephoenix",   "models/fwo20251/v_def_free_and_vip.mdl", 25, 1000},
	{145, "Knife Iridescent",   "models/fwo20251/v_def_free_and_vip.mdl", 27, 1000},
	{146, "Knife Joker",        "models/fwo20251/v_def_free_and_vip.mdl", 33, 1000},
	{147, "Knife King",         "models/fwo20251/v_def_free_and_vip.mdl", 42, 1000},
	{148, "Knife Moon",         "models/fwo20251/v_def_free_and_vip.mdl", 28, 1000},
	{149, "Knife Neo-Noir",     "models/fwo20251/v_def_free_and_vip.mdl", 29, 1000},
	{150, "Knife Purple",       "models/fwo20251/v_def_free_and_vip.mdl", 40, 1000},
	{151, "Knife Sakura",       "models/fwo20251/v_def_free_and_vip.mdl", 39, 1000},
	{152, "Knife Shred",        "models/fwo20251/v_def_free_and_vip.mdl", 34, 1000},
	{153, "Knife Storm",        "models/fwo20251/v_def_free_and_vip.mdl", 35, 1000},
	{154, "Knife Venom",        "models/fwo20251/v_def_free_and_vip.mdl", 36, 1000},
	{156, "Butcher Blood Khalifa", "models/fwo20251/v_but_free_and_vip.mdl", 11, 1000},
	{157, "Butcher Boris",       	"models/fwo20251/v_but_free_and_vip.mdl", 12, 1000},
	{158, "Butcher Gojo",        	"models/fwo20251/v_but_free_and_vip.mdl", 13, 1000},
	{159, "Butcher Hyperbeast",  	"models/fwo20251/v_but_free_and_vip.mdl", 14, 1000},
	{160, "Butcher Iridescent",  	"models/fwo20251/v_but_free_and_vip.mdl", 10, 1000},
	{161, "Butcher Lion blade",  	"models/fwo20251/v_but_free_and_vip.mdl", 15, 1000},
	{162, "Butcher Neo-Noir",    	"models/fwo20251/v_but_free_and_vip.mdl", 16, 1000},
	{163, "Butcher Xiao",        	"models/fwo20251/v_but_free_and_vip.mdl", 17, 1000}
}

new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth",         "models/llg3/v_vip.mdl", 0, 0},
	{401, "Purple Haze",         "models/llg3/v_vip.mdl", 2, 1000},
	{402, "Crimson Web",         "models/llg3/v_vip.mdl", 1, 1000}
}

/*new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default", 				0,	0},
	{501, "Ruby", 					1, 	2500},
	{502, "Purple Vibe", 			2,	2500}
}*/

/*new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 				0,	0},
	{601, "Christmas", 				3,	0},
	{602, "Fade", 					1, 	2500},
	{603, "Sakura", 				2,	2500}
}*/

new g_Usps[USP_NUM][eSkin] = {
	{200, "Default",             "models/fwo20251/v_usp_free_and_vip.mdl", 0, 0},
	{223, "Abstract Blue",       "models/fwo20251/v_usp_free_and_vip.mdl", 23, 1000},
	{224, "Black",               "models/fwo20251/v_usp_free_and_vip.mdl", 24, 1000},
	{225, "Blue",                "models/fwo20251/v_usp_free_and_vip.mdl", 25, 1000},
	{226, "Bright",              "models/fwo20251/v_usp_free_and_vip.mdl", 26, 1000},
	{227, "Caiman",              "models/fwo20251/v_usp_free_and_vip.mdl", 27, 1000},
	{228, "Cardinal Crystal",    "models/fwo20251/v_usp_free_and_vip.mdl", 28, 1000},
	{229, "Cortex",              "models/fwo20251/v_usp_free_and_vip.mdl", 29, 1000},
	{230, "Electra",             "models/fwo20251/v_usp_free_and_vip.mdl", 30, 1000},
	{231, "Fire Flower",         "models/fwo20251/v_usp_free_and_vip.mdl", 31, 1000},
	{232, "Flashback",           "models/fwo20251/v_usp_free_and_vip.mdl", 32, 1000},
	{233, "Green Fire",          "models/fwo20251/v_usp_free_and_vip.mdl", 33, 1000},
	{234, "Green Realist",       "models/fwo20251/v_usp_free_and_vip.mdl", 34, 1000},
	{235, "Iridescent",          "models/fwo20251/v_usp_free_and_vip.mdl", 35, 1000},
	{236, "Lightning Monster",   "models/fwo20251/v_usp_free_and_vip.mdl", 36, 1000},
	{237, "Neo-Noir",            "models/fwo20251/v_usp_free_and_vip.mdl", 37, 1000},
	{238, "Night Wolf",          "models/fwo20251/v_usp_free_and_vip.mdl", 38, 1000},
	{239, "Oil Filter",          "models/fwo20251/v_usp_free_and_vip.mdl", 39, 1000},
	{240, "Purity",              "models/fwo20251/v_usp_free_and_vip.mdl", 40, 1000},
	{241, "Sakura",              "models/fwo20251/v_usp_free_and_vip.mdl", 41, 1000},
	{242, "Shaker",              "models/fwo20251/v_usp_free_and_vip.mdl", 42, 1000},
	{243, "Ticket to Hell",      "models/fwo20251/v_usp_free_and_vip.mdl", 43, 1000},
	{244, "Xiao",                "models/fwo20251/v_usp_free_and_vip.mdl", 44, 1000},
	{245, "Xtreme",              "models/fwo20251/v_usp_free_and_vip.mdl", 45, 1000}
};

new g_Chars[CHARS_NUM][ePlayerSkin]={
	{300,	"Default",			"gign", 0, 0},
	{301,	"Admin Gign",		"fwo_player_teste", 0, 5000},
	{302,	"Agent Ritsuka",	"fwo_ritsuka_teste", 0, 15000},
	{303,	"Arctic",			"fwo_arctic_teste", 0, 2000},
	{304,	"Banana",			"fwo_player_teste", 6, 5000},
	{305,	"Ema",				"fwo_ema_teste", 0, 10000},
	{306,	"GTA Homeless",		"fwo_player_teste", 1, 5000},
	{307,	"Hitman",			"fwo_player_teste", 2, 5000},
	{308,	"Itachi",			"fwo_player_teste", 3, 5000},
	{309,	"Mila",				"fwo_mila_teste", 0, 15000},
	{310,	"Neo",				"fwo_player_teste", 7, 5000},
	{311,	"Phillip",			"fwo_player_teste", 4, 5000},
	{312,	"Pink Panther",		"fwo_panther_teste", 0, 7000},
	{313,	"Scorpion",			"fwo_scorpion_teste", 0, 5000},
	{314,	"Sponge Bob",		"fwo_player_teste", 5, 5000},
	{315,	"Sub-zero",			"fwo_sub-zero_teste", 0, 5000}
}

new eMenu:g_iMenuId[33];

//Main
public plugin_init(){
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins(VIP)", "SkinsMenu", "shop_skins_submodels_vip.amxx", 0);

	//Chat prefix
	CC_SetPrefix("&x04[SHOP]");
}

public plugin_cfg(){

	register_dictionary("shop_skins.txt");

}

//Precaching the skins from the list above
public plugin_precache(){
	new mdl[128];
	for(new i=1;i<CHARS_NUM;i++){
		format(mdl, charsmax(mdl), "models/player/%s/%s.mdl", g_Chars[i][szPlayerModel], g_Chars[i][szPlayerModel]);
		precache_generic(mdl);
		format(mdl, charsmax(mdl), "models/player/%s/%sT.mdl", g_Chars[i][szPlayerModel], g_Chars[i][szPlayerModel]);
		if(file_exists(mdl))
			precache_generic(mdl);
	}
	precache_model(g_Knives[0][szModel]);
	precache_model(g_Knives[1][szModel]);
	precache_model(g_Bayonets[0][szModel]);
	precache_model(g_Usps[0][szModel]);
}

//Menu to choose the menu you want
public SkinsMenu(id){
	
	if(!isPlayerVip(id)){
		CC_SendMessage(id, "%L", id, "VIP_REQUIRED");
		return PLUGIN_HANDLED;
	}
	
	new menu = menu_create( "\r[SHOP] \d- \wChoose your item:", "menu_handler1" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );
	menu_additem( menu, "\wPlayer Skins", "", 0);

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}

public menu_handler1( id, menu, item ){
	
	switch( item )
	{
		case 0:
		{
			KnifeMenu(id);
		}
		case 1:
		{
			UspMenu(id);
		}
		case 2:
		{
			CharSkinMenu(id);
		}
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Menu to choose a custom knife skin
public KnifeMenu(id){
	new menu = menu_create( "\r[SHOP] \d- \wChoose the type of knife:", "menu_handler" );

	menu_additem( menu, "\wDefault Knife", 	"", 0 );
	menu_additem( menu, "\wButcher Knife", 	"", 0 );
	menu_additem( menu, "\wVip Knife", 		"", 0 );
	//menu_additem( menu, "\wPremium Knife", 	"", 0 );
	//menu_additem( menu, "\wKatana Knife", 	"", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}

//Handler for the knife skin menu
public menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}

	switch( item )
	{
		case 0:
		{
			g_iMenuId[id] = iKnives;
			KnifeSkinMenu(id, g_Knives, KNIFE_NUM);
			
		}
		case 1:
		{
			g_iMenuId[id] = iButchers;
			KnifeSkinMenu(id, g_Knives, KNIFE_NUM);
		}
		case 2:
		{
			g_iMenuId[id] = iBayonets;
			KnifeSkinMenu(id, g_Bayonets, BAYONET_NUM);
		}
		/*case 3:
		{
			g_iMenuId[id] = iDaggers;
			KnifeSkinMenu(id, g_Daggers, DAGGER_NUM);
		}
		case 4:
		{
			g_iMenuId[id] = iKatanas;
			KnifeSkinMenu(id, g_Katanas, KATANA_NUM);
		}*/
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Second Menu
public KnifeSkinMenu(id, items[][eSkin], num_items){
	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[SHOP] \d- \wKnife Skins^n\wCredits: \y%d\d", credits);
	new menu = menu_create( title, "knife_skin_handler" );
	
	for(new i = 0;i<num_items;i++){
		if(inventory_get_item(id, items[i][iSkinId]) || !items[i][iCost])
			formatex(itemText, 127, "\y%s", items[i][szName]);
		else{
			formatex(itemText, 127, "\w%s - %s%d", items[i][szName], credits>=items[i][iCost]?"\y":"\s", items[i][iCost]);	
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public knife_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		KnifeMenu(id);
		return PLUGIN_HANDLED;
	}

	new skinItem[eSkin];
	switch(g_iMenuId[id]) {
		case iKnives, iButchers: 
			skinItem = g_Knives[item];
		case iBayonets:
			skinItem = g_Bayonets[item];
		/*case iDaggers:
			skinItem = g_Daggers[item];
		case iKatanas:
			skinItem = g_Katanas[item];*/
		case iUsps:
			skinItem = g_Usps[item];
	}
	
	if(inventory_get_item(id, skinItem[iSkinId])){
		set_user_weapon_skin(id, skinItem[szModel], skinItem[iSubModel]);

		menu_destroy( menu );
		KnifeMenu(id);
		return PLUGIN_HANDLED;
	}

	menu_destroy( menu );
	BuySkin(id, skinItem);
	KnifeMenu(id);
	return PLUGIN_HANDLED;
}

//Menu to choose a custom knife skin
public UspMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[SHOP] \d- \wUsp Skins^n\wCredits: \y%d\d", credits);

	new menu = menu_create( title, "usp_menu_handler" );

	for(new i = 0;i<USP_NUM;i++){
		if(inventory_get_item(id, g_Usps[i][iSkinId]) || !g_Usps[i][iCost])
			formatex(itemText, 127, "\y%s", g_Usps[i][szName])
		else{
			if(credits>=g_Usps[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Usps[i][szName], g_Usps[i][iCost])
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Usps[i][szName], g_Usps[i][iCost])
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}

//Handler for the knife skin menu
public usp_menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Usps[item][iSkinId])){
		set_user_usp(id, g_Usps[item][szModel], g_Usps[item][iSubModel]);
		menu_destroy( menu );
		UspMenu(id);
		return PLUGIN_HANDLED;
	}

	menu_destroy( menu );
	BuyUspSkin(id, item);
	UspMenu(id);
	return PLUGIN_HANDLED;
}

public CharSkinMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\r[SHOP] \d- \wPlayer Skins^n\wCredits: \y%d", credits);
	new menu = menu_create( title, "player_skin_handler" );
	
	for(new i = 0;i<CHARS_NUM;i++){
		if(inventory_get_item(id, g_Chars[i][iPlayerSkinId]) || !g_Chars[i][iPlayerCost])
			formatex(itemText, 127, "\y%s", g_Chars[i][szPlayerName]);
		else{
			if(credits>=g_Chars[i][iPlayerCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Chars[i][szPlayerName], g_Chars[i][iPlayerCost]);
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Chars[i][szPlayerName], g_Chars[i][iPlayerCost]);
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_setprop(menu, MPROP_EXITNAME, "Back");
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public player_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		SkinsMenu(id);
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Chars[item][iPlayerSkinId])){
		set_user_player_skin(id, g_Chars[item][szPlayerModel], g_Chars[item][iSubmodel]);
		
		menu_destroy( menu );
		CharSkinMenu(id);
		return PLUGIN_HANDLED;

	}
	menu_destroy( menu );
	BuyPlayerSkin(id, item);
	CharSkinMenu(id);
	return PLUGIN_HANDLED;
}

public BuySkin(id, itemSkin[eSkin]){
	new credits = get_user_credits(id);
	if(credits >= itemSkin[iCost]){
		set_user_credits(id, credits - itemSkin[iCost]);
		inventory_add(id, itemSkin[iSkinId]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", itemSkin[szName]);
		set_user_weapon_skin(id, itemSkin[szModel], itemSkin[iSubModel]);
	}		
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public BuyUspSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Usps[item][iCost]){
		set_user_credits(id, credits - g_Usps[item][iCost])
		inventory_add(id, g_Usps[item][iSkinId]);
		set_user_usp(id, g_Usps[item][szModel], g_Usps[item][iSubModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Usps[item][szName]);
	}
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iPlayerCost]){
		set_user_credits(id, credits - g_Chars[item][iPlayerCost])
		inventory_add(id, g_Chars[item][iPlayerSkinId]);
		set_user_player_skin(id, g_Chars[item][szPlayerModel], g_Chars[item][iSubmodel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Chars[item][szPlayerName]);
	}
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public set_user_weapon_skin(id, model[], submodel) {
	switch(g_iMenuId[id]) {
		case iKnives:
			set_user_knife(id, model, submodel);
		case iButchers:
			set_user_butcher(id, model, submodel);
		case iBayonets:
			set_user_bayonet(id, model, submodel);
		/*case iDaggers:
			set_user_dagger(id, submodel);
		case iKatanas:
			set_user_katana(id, submodel);*/
		case iUsps:
			set_user_usp(id, model, submodel);
	}
}