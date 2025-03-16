#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat2>

#include <player_skins_submodels>
#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 23
#define BUTCHER_NUM 10
//#define BAYONET_NUM 3
#define DAGGER_NUM 3
#define KATANA_NUM 4
#define USP_NUM 23
//#define CHARS_NUM 7

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
	iPlayerCost
}

enum eMenu
{
	iKnives = 0,
	iButchers,
	//iBayonets,
	iDaggers,
	iKatanas,
	iUsps,
	//iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Default",                "models/fwo20251/v_def_free_and_vip.mdl", 0, 0},
	{101, "Knife Abstract",         "models/fwo20251/v_def_free_and_vip.mdl", 1, 2500},
	{102, "Knife Among Us",         "models/fwo20251/v_def_free_and_vip.mdl", 3, 2500},
	{103, "Knife Cold Cerf", 		"models/fwo20251/v_def_free_and_vip.mdl", 15, 2500},
	{104, "Knife Color", 			"models/fwo20251/v_def_free_and_vip.mdl", 2, 2500},
	{105, "Knife Cosmic Ohmy", 		"models/fwo20251/v_def_free_and_vip.mdl", 16, 2500},
	{106, "Knife Fade",		 		"models/fwo20251/v_def_free_and_vip.mdl", 3, 2500},
	{107, "Knife Fekete", 			"models/fwo20251/v_def_free_and_vip.mdl", 4, 2500},
	{108, "Knife Frozen", 			"models/fwo20251/v_def_free_and_vip.mdl", 5, 2500},
	{109, "Knife Ghost Blue", 		"models/fwo20251/v_def_free_and_vip.mdl", 6, 2500},
	{110, "Knife Ghost Red", 		"models/fwo20251/v_def_free_and_vip.mdl", 7, 2500},
	{111, "Knife Ghost Pink", 		"models/fwo20251/v_def_free_and_vip.mdl", 14, 2500},
	{112, "Knife Lightning", 		"models/fwo20251/v_def_free_and_vip.mdl", 8, 2500},
	{113, "Knife Linkin Park", 		"models/fwo20251/v_def_free_and_vip.mdl", 9, 2500},
	{114, "Knife Nexus", 			"models/fwo20251/v_def_free_and_vip.mdl", 10, 2500},
	{115, "Knife Night", 		 	"models/fwo20251/v_def_free_and_vip.mdl", 13, 2500},
	{116, "Knife Nightraid", 		"models/fwo20251/v_def_free_and_vip.mdl", 38, 2500},
	{117, "Knife Space Ohmy", 		"models/fwo20251/v_def_free_and_vip.mdl", 17, 2500},
	{118, "Knife Sponge Bob", 		"models/fwo20251/v_def_free_and_vip.mdl", 18, 2500},
	{119, "Knife Steel", 		 	"models/fwo20251/v_def_free_and_vip.mdl", 11, 2500},
	{120, "Knife Thug Cat", 		"models/fwo20251/v_def_free_and_vip.mdl", 12, 2500},
	{121, "Knife White Duck", 		"models/fwo20251/v_def_free_and_vip.mdl", 19, 2500},
	{122, "Knife Yum", 			 	"models/fwo20251/v_def_free_and_vip.mdl", 44, 2500}
}

new g_Butchers[BUTCHER_NUM][eSkin] = {
	{150, "Default", 				"models/fwo20251/v_but_free_and_vip.mdl", 0, 0},
	{151, "Butcher Black Wolf", 	"models/fwo20251/v_but_free_and_vip.mdl", 1, 2500},
	{152, "Butcher Blood", 			"models/fwo20251/v_but_free_and_vip.mdl", 2, 2500},
	{153, "Butcher Carbon", 		"models/fwo20251/v_but_free_and_vip.mdl", 3, 2500},
	{154, "Butcher Fade",			"models/fwo20251/v_but_free_and_vip.mdl", 4, 2500},
	{155, "Butcher Lion",			"models/fwo20251/v_but_free_and_vip.mdl", 5, 2500},
	{156, "Butcher Nezuko",			"models/fwo20251/v_but_free_and_vip.mdl", 6, 2500},
	{157, "Butcher Rainbow", 		"models/fwo20251/v_but_free_and_vip.mdl", 7, 2500},
	{158, "Butcher Red Ghost", 		"models/fwo20251/v_but_free_and_vip.mdl", 8, 2500},
	{159, "Butcher Rias", 			"models/fwo20251/v_but_free_and_vip.mdl", 9, 2500}
}

/*new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth", 			0,	0},
	{401, "Purple Haze", 			2, 	2500},
	{402, "Crimson Web", 		 	1,	2500}
}*/

new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default",        "models/llg3/v_premium.mdl", 0, 0},
	{501, "Ruby",           "models/llg3/v_premium.mdl", 1, 2500},
	{502, "Purple Vibe",    "models/llg3/v_premium.mdl", 2, 2500}
}

new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 	"models/fwo20251/v_katana.mdl", 0, 0},
	{601, "Christmas", 	"models/fwo20251/v_katana.mdl", 3, 0},
	{602, "Fade", 		"models/fwo20251/v_katana.mdl", 1, 2500},
	{603, "Sakura", 	"models/fwo20251/v_katana.mdl", 2, 2500}
}

new g_Usps[USP_NUM][eSkin]={
	{200, "Default", 				"models/fwo20251/v_usp_free_and_vip.mdl", 0, 0},
	{201, "Abstract", 				"models/fwo20251/v_usp_free_and_vip.mdl", 1, 2500},
	{202, "Blood Thirst", 			"models/fwo20251/v_usp_free_and_vip.mdl", 2, 2500},
	{203, "Blue Print", 			"models/fwo20251/v_usp_free_and_vip.mdl", 3, 2500},
	{204, "Carbon", 				"models/fwo20251/v_usp_free_and_vip.mdl", 4, 2500},
	{205, "Cherry Blossom", 		"models/fwo20251/v_usp_free_and_vip.mdl", 5, 2500},
	{206, "Dark Flower", 			"models/fwo20251/v_usp_free_and_vip.mdl", 6, 2500},
	{207, "Dark Red", 				"models/fwo20251/v_usp_free_and_vip.mdl", 7, 2500},
	{208, "Dogon", 					"models/fwo20251/v_usp_free_and_vip.mdl", 8, 2500},
	{209, "Dolomit", 				"models/fwo20251/v_usp_free_and_vip.mdl", 9, 2500},
	{210, "Fade", 					"models/fwo20251/v_usp_free_and_vip.mdl", 10, 2500},
	{211, "Fire", 					"models/fwo20251/v_usp_free_and_vip.mdl", 11, 2500},
	{212, "Iced", 					"models/fwo20251/v_usp_free_and_vip.mdl", 12, 2500},
	{213, "Night Wolf Green", 		"models/fwo20251/v_usp_free_and_vip.mdl", 13, 2500},
	{214, "Nightfire", 				"models/fwo20251/v_usp_free_and_vip.mdl", 14, 2500},
	{215, "Nightraid", 				"models/fwo20251/v_usp_free_and_vip.mdl", 15, 2500},
	{216, "Orion", 					"models/fwo20251/v_usp_free_and_vip.mdl", 16, 2500},
	{217, "Pac-Man", 				"models/fwo20251/v_usp_free_and_vip.mdl", 17, 2500},
	{218, "Stained", 				"models/fwo20251/v_usp_free_and_vip.mdl", 18, 2500},
	{219, "Strong Blue", 			"models/fwo20251/v_usp_free_and_vip.mdl", 19, 2500},
	{220, "Torque", 				"models/fwo20251/v_usp_free_and_vip.mdl", 20, 2500},
	{221, "Water", 					"models/fwo20251/v_usp_free_and_vip.mdl", 21, 2500},
	{222, "Zebra", 					"models/fwo20251/v_usp_free_and_vip.mdl", 22, 2500}
};

/*new g_Chars[CHARS_NUM][ePlayerSkin]={
	{300, "Default", "", 				0},
	{301, "Arctic", "arctic2", 			2000},
	{302, "Hitman", "hitman", 			5000},
	{303, "Ema", "ema", 				10000},
	{304, "Agent Ritsuka", "ritsuka", 	15000},
	{305, "Sub-zero", "sub-zero", 		5000},
	{306, "Scorpion", "scorpion", 		5000}
}*/

new g_iMenuId[33];

//Main
public plugin_init(){
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins", "SkinsMenu", "shop_skins_submodels.amxx", 0);

	//Chat prefix
	CC_SetPrefix("&x04[SHOP]");
}

public plugin_cfg(){

	register_dictionary("shop_skins.txt");

}

//Precaching the skins from the list above
public plugin_precache(){
	precache_model(g_Knives[0][szModel]);
	precache_model(g_Butchers[0][szModel]);
	precache_model(g_Daggers[0][szModel]);
	precache_model(g_Katanas[0][szModel]);
	precache_model(g_Usps[0][szModel]);

	/*new mdl[128];
	for(new i=1;i<CHARS_NUM;i++){
		format(mdl, charsmax(mdl), "models/player/%s/%s.mdl", g_Chars[i][szPlayerModel], g_Chars[i][szPlayerModel]);
		precache_generic(mdl);
		format(mdl, charsmax(mdl), "models/player/%s/%sT.mdl", g_Chars[i][szPlayerModel], g_Chars[i][szPlayerModel]);
		if(file_exists(mdl))
			precache_generic(mdl);
	}*/
}

//Menu to choose the menu you want
public SkinsMenu(id){
	new menu = menu_create( "\r[SHOP] \d- \wChoose your item:", "menu_handler1" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );
	//menu_additem( menu, "\wPlayer Skins", "", 0);

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
		/*case 2:
		{
			CharSkinMenu(id);
		}*/
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Menu to choose a custom knife skin
public KnifeMenu(id){
	new menu = menu_create( "\r[SHOP] \d- \wChoose the type of knife:", "menu_handler" );

	menu_additem( menu, "\wDefault Knife", 	"", 0 );
	menu_additem( menu, "\wButcher Knife", 	"", 0 );
	//menu_additem( menu, "\wVip Knife", 		"", 0 );
	menu_additem( menu, "\wPremium Knife", 	"", 0 );
	menu_additem( menu, "\wKatana Knife", 	"", 0 );

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
			KnifeSkinMenu(id, g_Butchers, KNIFE_NUM);
		}
		/*case 2:
		{
			g_iMenuId[id] = iBayonets;
			KnifeSkinMenu(id, g_Bayonets, BAYONET_NUM);
		}*/
		case 2:
		{
			g_iMenuId[id] = iDaggers;
			KnifeSkinMenu(id, g_Daggers, DAGGER_NUM);
		}
		case 3:
		{
			g_iMenuId[id] = iKatanas;
			KnifeSkinMenu(id, g_Katanas, KATANA_NUM);
		}
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
	skinItem = g_Knives[item];
	switch(g_iMenuId[id]) {
		case iKnives:
			skinItem = g_Knives[item];
		case iButchers:
			skinItem = g_Butchers[item];
		/*case iBayonets:
			skinItem = g_Bayonets[item];*/
		case iDaggers:
			skinItem = g_Daggers[item];
		case iKatanas:
			skinItem = g_Katanas[item];
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

/*public CharSkinMenu(id){

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
		set_user_player_skin(id, g_Chars[item][szPlayerModel]);
		
		menu_destroy( menu );
		CharSkinMenu(id);
		return PLUGIN_HANDLED;

	}
	menu_destroy( menu );
	BuyPlayerSkin(id, item);
	CharSkinMenu(id);
	return PLUGIN_HANDLED;
}*/

public BuySkin(id, itemSkin[eSkin]){
	new credits = get_user_credits(id);
	if(credits >= itemSkin[iCost]){
		set_user_credits(id, credits - itemSkin[iCost])
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

/*public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iPlayerCost]){
		set_user_credits(id, credits - g_Chars[item][iPlayerCost])
		inventory_add(id, g_Chars[item][iPlayerSkinId]);
		set_user_player_skin(id, g_Chars[item][szPlayerModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Chars[item][szPlayerName]);
	}
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}*/

public set_user_weapon_skin(id, model[], submodel) {
	switch(g_iMenuId[id]) {
		case iKnives:
			set_user_knife(id, model, submodel);
		case iButchers:
			set_user_butcher(id, model, submodel);
		/*case iBayonets:
			set_user_bayonet(id, model, submodel);*/
		case iDaggers:
			set_user_dagger(id, model, submodel);
		case iKatanas:
			set_user_katana(id, model, submodel);
		case iUsps:
			set_user_usp(id, model, submodel);
	}
}