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

#define KNIFE_NUM 33
#define DAGGER_NUM 3
#define KATANA_NUM 4
#define USP_NUM 23

enum eSkin
{
	iSkinId,
	szName[64],
	szModel[64],
	iSubModel,
	iCost
}

enum eMenu
{
	iKnives = 0,
	iButchers,
	iDaggers,
	iKatanas,
	iUsps
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Knife Default",          "models/llg2025/v_def_knife.mdl", 0, 0},
	{101, "Butcher Default",        "models/llg2025/v_but_knife.mdl", 0, 0},
	{102, "Knife Abstract",         "models/llg2025/v_def_knife.mdl", 1, 2500},
	{103, "Knife Among Us",         "models/llg2025/v_def_knife.mdl", 43, 2500},
	{104, "Butcher Black Wolf",     "models/llg2025/v_but_knife.mdl", 1, 2500},
	{105, "Butcher Blood",          "models/llg2025/v_but_knife.mdl", 2, 2500},
	{106, "Butcher Carbon",         "models/llg2025/v_but_knife.mdl", 3, 2500},
	{107, "Knife Cold Cerf",        "models/llg2025/v_def_knife.mdl", 15, 2500},
	{108, "Knife Color",            "models/llg2025/v_def_knife.mdl", 2, 2500},
	{109, "Knife Cosmic Ohmy",      "models/llg2025/v_def_knife.mdl", 16, 2500},
	{110, "Knife Fade",             "models/llg2025/v_def_knife.mdl", 3, 2500},
	{111, "Butcher Fade",           "models/llg2025/v_but_knife.mdl", 4, 2500},
	{112, "Knife Fekete",           "models/llg2025/v_def_knife.mdl", 4, 2500},
	{113, "Knife Frozen",           "models/llg2025/v_def_knife.mdl", 5, 2500},
	{114, "Knife Ghost Blue",       "models/llg2025/v_def_knife.mdl", 6, 2500},
	{115, "Knife Ghost Red",        "models/llg2025/v_def_knife.mdl", 7, 2500},
	{116, "Knife Ghost Pink",       "models/llg2025/v_def_knife.mdl", 14, 2500},
	{117, "Knife Lightning",        "models/llg2025/v_def_knife.mdl", 8, 2500},
	{118, "Knife Linkin Park",      "models/llg2025/v_def_knife.mdl", 9, 2500},
	{119, "Butcher Lion",           "models/llg2025/v_but_knife.mdl", 5, 2500},
	{120, "Knife Nexus",            "models/llg2025/v_def_knife.mdl", 10, 2500},
	{121, "Butcher Nezuko",         "models/llg2025/v_but_knife.mdl", 6, 2500},
	{122, "Knife Night",            "models/llg2025/v_def_knife.mdl", 13, 2500},
	{123, "Knife Nightraid",        "models/llg2025/v_def_knife.mdl", 38, 2500},
	{124, "Butcher Rainbow",        "models/llg2025/v_but_knife.mdl", 7, 2500},
	{125, "Butcher Red Ghost",      "models/llg2025/v_but_knife.mdl", 8, 2500},
	{126, "Butcher Rias",           "models/llg2025/v_but_knife.mdl", 9, 2500},
	{127, "Knife Space Ohmy",       "models/llg2025/v_def_knife.mdl", 17, 2500},
	{128, "Knife Sponge Bob",       "models/llg2025/v_def_knife.mdl", 18, 2500},
	{129, "Knife Steel",            "models/llg2025/v_def_knife.mdl", 11, 2500},
	{130, "Knife Thug Cat",         "models/llg2025/v_def_knife.mdl", 12, 2500},
	{131, "Knife White Duck",       "models/llg2025/v_def_knife.mdl", 19, 2500},
	{132, "Knife Yum",              "models/llg2025/v_def_knife.mdl", 44, 2500}
};

new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default",        "models/llg2025/v_premium.mdl", 0, 0},
	{501, "Ruby",           "models/llg2025/v_premium.mdl", 1, 2500},
	{502, "Purple Vibe",    "models/llg2025/v_premium.mdl", 2, 2500}
}

new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 	"models/llg2025/v_katana.mdl", 0, 0},
	{601, "Christmas", 	"models/llg2025/v_katana.mdl", 3, 0},
	{602, "Fade", 		"models/llg2025/v_katana.mdl", 1, 2500},
	{603, "Sakura", 	"models/llg2025/v_katana.mdl", 2, 2500}
}

new g_Usps[USP_NUM][eSkin]={
	{200, "Default",               "models/llg2025/v_usp.mdl", 0, 0},
	{201, "Abstract",              "models/llg2025/v_usp.mdl", 1, 2500},
	{202, "Blood Thirst",          "models/llg2025/v_usp.mdl", 2, 2500},
	{203, "Blue Print",            "models/llg2025/v_usp.mdl", 3, 2500},
	{204, "Carbon",                "models/llg2025/v_usp.mdl", 4, 2500},
	{205, "Cherry Blossom",        "models/llg2025/v_usp.mdl", 5, 2500},
	{206, "Dark Flower",           "models/llg2025/v_usp.mdl", 6, 2500},
	{207, "Dark Red",              "models/llg2025/v_usp.mdl", 7, 2500},
	{208, "Dogon",                 "models/llg2025/v_usp.mdl", 8, 2500},
	{209, "Dolomit",               "models/llg2025/v_usp.mdl", 9, 2500},
	{210, "Fade",                  "models/llg2025/v_usp.mdl", 10, 2500},
	{211, "Fire",                  "models/llg2025/v_usp.mdl", 11, 2500},
	{212, "Iced",                  "models/llg2025/v_usp.mdl", 12, 2500},
	{213, "Night Wolf Green",      "models/llg2025/v_usp.mdl", 13, 2500},
	{214, "Nightfire",             "models/llg2025/v_usp.mdl", 14, 2500},
	{215, "Nightraid",             "models/llg2025/v_usp.mdl", 15, 2500},
	{216, "Orion",                 "models/llg2025/v_usp.mdl", 16, 2500},
	{217, "Pac-Man",               "models/llg2025/v_usp.mdl", 17, 2500},
	{218, "Stained",               "models/llg2025/v_usp.mdl", 18, 2500},
	{219, "Strong Blue",           "models/llg2025/v_usp.mdl", 19, 2500},
	{220, "Torque",                "models/llg2025/v_usp.mdl", 20, 2500},
	{221, "Water",                 "models/llg2025/v_usp.mdl", 21, 2500},
	{222, "Zebra",                 "models/llg2025/v_usp.mdl", 22, 2500}
};

new eMenu:g_iMenuId[33];

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
	precache_model(g_Knives[0][szModel]); // Knife Default
	precache_model(g_Knives[1][szModel]); // Knife Butcher
	precache_model(g_Daggers[0][szModel]);
	precache_model(g_Katanas[0][szModel]);
	precache_model(g_Usps[0][szModel]);
}

//Menu to choose the menu you want
public SkinsMenu(id){
	new menu = menu_create( "\r[SHOP] \d- \wChoose your item:", "menu_handler1" );

	menu_additem( menu, "\wKnife Skins", "", 0 );
	menu_additem( menu, "\wUsp Skins", "", 0 );

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
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

//Menu to choose a custom knife skin
public KnifeMenu(id){
	new menu = menu_create( "\r[SHOP] \d- \wChoose the type of knife:", "menu_handler" );

	menu_additem( menu, "\wDefault Knife", 	"", 0 );
	menu_additem( menu, "\wButcher Knife", 	"", 0 );
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
			KnifeSkinMenu(id, g_Knives, KNIFE_NUM);
		}
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
	switch(g_iMenuId[id]) {
		case iKnives, iButchers: 
		skinItem = g_Knives[item];
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

public set_user_weapon_skin(id, model[], submodel) {
	switch(g_iMenuId[id]) {
		case iKnives:
			set_user_knife(id, model, submodel);
		case iButchers:
			set_user_butcher(id, model, submodel);
		case iDaggers:
			set_user_dagger(id, model, submodel);
		case iKatanas:
			set_user_katana(id, model, submodel);
		case iUsps:
			set_user_usp(id, model, submodel);
	}
}