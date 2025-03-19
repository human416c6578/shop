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
#define BAYONET_NUM 3
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
	iUsps,
	iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Knife Default",          "models/llg2025/v_def_knife.mdl", 0, 0},
	{101, "Butcher Default",        "models/llg2025/v_but_knife.mdl", 0, 0},
	{133, "Knife Ahegao",           "models/llg2025/v_def_knife.mdl", 26, 1000},
	{134, "Knife Black",            "models/llg2025/v_def_knife.mdl", 41, 1000},
	{135, "Knife Black-Orange",     "models/llg2025/v_def_knife.mdl", 37, 1000},
	{136, "Butcher Blood Khalifa",  "models/llg2025/v_but_knife.mdl", 11, 1000},
	{137, "Knife Blood",            "models/llg2025/v_def_knife.mdl", 20, 1000},
	{138, "Butcher Boris",          "models/llg2025/v_but_knife.mdl", 12, 1000},
	{139, "Knife Fire",             "models/llg2025/v_def_knife.mdl", 21, 1000},
	{140, "Knife Fire Flower",      "models/llg2025/v_def_knife.mdl", 22, 1000},
	{141, "Knife Galaxy",           "models/llg2025/v_def_knife.mdl", 30, 1000},
	{142, "Butcher Gojo",           "models/llg2025/v_but_knife.mdl", 13, 1000},
	{143, "Knife Goku",             "models/llg2025/v_def_knife.mdl", 31, 1000},
	{144, "Knife Gold",             "models/llg2025/v_def_knife.mdl", 32, 1000},
	{145, "Knife Grizzly",          "models/llg2025/v_def_knife.mdl", 23, 1000},
	{146, "Knife Howl",             "models/llg2025/v_def_knife.mdl", 24, 1000},
	{147, "Butcher Hyperbeast",     "models/llg2025/v_but_knife.mdl", 14, 1000},
	{148, "Knife Icephoenix",       "models/llg2025/v_def_knife.mdl", 25, 1000},
	{149, "Knife Iridescent",       "models/llg2025/v_def_knife.mdl", 27, 1000},
	{150, "Butcher Iridescent",     "models/llg2025/v_but_knife.mdl", 10, 1000},
	{151, "Knife Joker",            "models/llg2025/v_def_knife.mdl", 33, 1000},
	{152, "Knife King",             "models/llg2025/v_def_knife.mdl", 42, 1000},
	{153, "Butcher Lion blade",     "models/llg2025/v_but_knife.mdl", 15, 1000},
	{154, "Knife Moon",             "models/llg2025/v_def_knife.mdl", 28, 1000},
	{155, "Knife Neo-Noir",         "models/llg2025/v_def_knife.mdl", 29, 1000},
	{156, "Butcher Neo-Noir",       "models/llg2025/v_but_knife.mdl", 16, 1000},
	{157, "Knife Purple",           "models/llg2025/v_def_knife.mdl", 40, 1000},
	{158, "Knife Sakura",           "models/llg2025/v_def_knife.mdl", 39, 1000},
	{159, "Knife Shred",            "models/llg2025/v_def_knife.mdl", 34, 1000},
	{160, "Knife Storm",            "models/llg2025/v_def_knife.mdl", 35, 1000},
	{161, "Knife Venom",            "models/llg2025/v_def_knife.mdl", 36, 1000},
	{162, "Butcher Xiao",           "models/llg2025/v_but_knife.mdl", 17, 1000}
};

new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth",         "models/llg2025/v_vip.mdl", 0, 0},
	{401, "Purple Haze",         "models/llg2025/v_vip.mdl", 2, 1000},
	{402, "Crimson Web",         "models/llg2025/v_vip.mdl", 1, 1000}
}

new g_Usps[USP_NUM][eSkin] = {
	{200, "Default",             "models/llg2025/v_usp.mdl", 0, 0},
	{223, "Abstract Blue",       "models/llg2025/v_usp.mdl", 23, 1000},
	{224, "Black",               "models/llg2025/v_usp.mdl", 24, 1000},
	{225, "Blue",                "models/llg2025/v_usp.mdl", 25, 1000},
	{226, "Bright",              "models/llg2025/v_usp.mdl", 26, 1000},
	{227, "Caiman",              "models/llg2025/v_usp.mdl", 27, 1000},
	{228, "Cardinal Crystal",    "models/llg2025/v_usp.mdl", 28, 1000},
	{229, "Cortex",              "models/llg2025/v_usp.mdl", 29, 1000},
	{230, "Electra",             "models/llg2025/v_usp.mdl", 30, 1000},
	{231, "Fire Flower",         "models/llg2025/v_usp.mdl", 31, 1000},
	{232, "Flashback",           "models/llg2025/v_usp.mdl", 32, 1000},
	{233, "Green Fire",          "models/llg2025/v_usp.mdl", 33, 1000},
	{234, "Green Realist",       "models/llg2025/v_usp.mdl", 34, 1000},
	{235, "Iridescent",          "models/llg2025/v_usp.mdl", 35, 1000},
	{236, "Lightning Monster",   "models/llg2025/v_usp.mdl", 36, 1000},
	{237, "Neo-Noir",            "models/llg2025/v_usp.mdl", 37, 1000},
	{238, "Night Wolf",          "models/llg2025/v_usp.mdl", 38, 1000},
	{239, "Oil Filter",          "models/llg2025/v_usp.mdl", 39, 1000},
	{240, "Purity",              "models/llg2025/v_usp.mdl", 40, 1000},
	{241, "Sakura",              "models/llg2025/v_usp.mdl", 41, 1000},
	{242, "Shaker",              "models/llg2025/v_usp.mdl", 42, 1000},
	{243, "Ticket to Hell",      "models/llg2025/v_usp.mdl", 43, 1000},
	{244, "Xiao",                "models/llg2025/v_usp.mdl", 44, 1000},
	{245, "Xtreme",              "models/llg2025/v_usp.mdl", 45, 1000}
};

new g_Chars[CHARS_NUM][ePlayerSkin]={
	{300,	"Default",          "gign", 0, 0},
	{301,	"Admin Gign",       "llg_player_compiled", 0, 5000},
	{302,	"Agent Ritsuka",    "llg2025_ritsuka", 0, 15000},
	{303,	"Arctic",           "llg2025_arctic", 0, 2000},
	{304,	"Banana",           "llg_player_compiled", 6, 5000},
	{305,	"Ema",              "llg2025_ema", 0, 10000},
	{306,	"GTA Homeless",     "llg_player_compiled", 1, 5000},
	{307,	"Hitman",           "llg_player_compiled", 2, 5000},
	{308,	"Itachi",           "llg_player_compiled", 3, 5000},
	{309,	"Mila",             "llg2025_mila", 0, 15000},
	{310,	"Neo",              "llg_player_compiled", 7, 5000},
	{311,	"Phillip",          "llg_player_compiled", 4, 5000},
	{312,	"Pink Panther",     "llg2025_panther", 0, 7000},
	{313,	"Scorpion",         "llg2025_scorpion", 0, 5000},
	{314,	"Sponge Bob",       "llg_player_compiled", 5, 5000},
	{315,	"Sub-zero",         "llg2025_sub-zero", 0, 5000}
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
	precache_model(g_Knives[0][szModel]); // Knife Default
	precache_model(g_Knives[1][szModel]); // Knife Butcher
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
		case iUsps:
			set_user_usp(id, model, submodel);
	}
}