#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat2>

#include <player_skins>
#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 2
#define BAYONET_NUM 3
#define DAGGER_NUM 3
#define KATANA_NUM 4
#define USP_NUM 1
#define CHARS_NUM 7

enum eSkin
{
	iSkinId,
	szName[64],
	szModel[128],
	iCost
}

enum eMenu
{
	iKnives = 0,
	iButchers,
	iBayonets,
	iDaggers,
	iKatanas,
	iUsps,
	iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Default", 						"models/v_knife.mdl", 0},
	{101, "Default Butcher", 				"models/knife-mod/v_butcher.mdl", 0}
}

new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth", 	"models/llg/shop/v_vip_tigertooth.mdl", 				0},
	{401, "Purple Haze", 	"models/llg/shop/v_vip_purple.mdl", 	2500},
	{402, "Crimson Web", 	"models/llg/shop/v_vip_crimson.mdl", 	2500}
}

new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default", 				"models/llg/v_premium.mdl",	0},
	{501, "Ruby", 					"models/llg/shop/v_premium_red.mdl", 2500},
	{502, "Purple Vibe", 			"models/llg/shop/v_premium_purple.mdl",	2500}
}

new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 				"models/llg/v_katana.mdl",	0},
	{601, "Christmas", 				"models/llg/v_katana_xmas.mdl",	0},
	{602, "Fade", 					"models/llg/v_kat_fade.mdl", 2500},
	{603, "Sakura", 				"models/llg/v_kat_sakura.mdl",	2500}
}

new g_Usps[USP_NUM][eSkin]={
	{200, "Default", 				"models/v_usp.mdl", 0},
};

new g_Chars[CHARS_NUM][eSkin]={
	{300, "Default", "", 				0},
	{301, "Arctic", "arctic2", 			2000},
	{302, "Hitman", "hitman", 			5000},
	{303, "Ema", "ema", 				10000},
	{304, "Agent Ritsuka", "ritsuka", 	15000},
	{305, "Sub-zero", "sub-zero", 		5000},
	{306, "Scorpion", "scorpion", 		5000},
}

new g_iMenuId[33];

//Main
public plugin_init(){
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins", "SkinsMenu", "shop_skins.amxx", 0);
	
	//Chat prefix
	CC_SetPrefix("&x04[SHOP]") 

}

public plugin_cfg(){
	register_dictionary("shop_skins.txt");
}

//Precaching the skins from the list above
public plugin_precache(){
	for(new i=0;i<KNIFE_NUM;i++)
		precache_model(g_Knives[i][szModel]);
	for(new i=0;i<BAYONET_NUM;i++)
		precache_model(g_Bayonets[i][szModel]);
	for(new i=0;i<DAGGER_NUM;i++)
		precache_model(g_Daggers[i][szModel]);
	for(new i=0;i<KATANA_NUM;i++)
		precache_model(g_Katanas[i][szModel]);
	for(new i=0;i<USP_NUM;i++)
		precache_model(g_Usps[i][szModel]);
	
	new mdl[128];
	for(new i=1;i<CHARS_NUM;i++){
		format(mdl, charsmax(mdl), "models/player/%s/%s.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		precache_generic(mdl);
		format(mdl, charsmax(mdl), "models/player/%s/%sT.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		if(file_exists(mdl))
			precache_generic(mdl);
	}
}

//Menu to choose the menu you want
public SkinsMenu(id){
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
			//UspMenu(id);
			g_iMenuId[id] = iUsps;
			KnifeSkinMenu(id, g_Usps, USP_NUM);
		}
		case 2:
		{
			//CharSkinMenu(id);
			g_iMenuId[id] = iCharacters;
			KnifeSkinMenu(id, g_Chars, CHARS_NUM);
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
			g_iMenuId[id] = iBayonets;
			KnifeSkinMenu(id, g_Bayonets, BAYONET_NUM);
		}
		case 3:
		{
			g_iMenuId[id] = iDaggers;
			KnifeSkinMenu(id, g_Daggers, DAGGER_NUM);
		}
		case 4:
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
			skinItem = g_Knives[item];
		case iBayonets:
			skinItem = g_Bayonets[item];
		case iDaggers:
			skinItem = g_Daggers[item];
		case iKatanas:
			skinItem = g_Katanas[item];
		case iUsps:
			skinItem = g_Usps[item];
		case iCharacters:
			skinItem = g_Chars[item];
	}
	
	if(inventory_get_item(id, skinItem[iSkinId])){
		set_user_weapon_skin(id, skinItem[szModel]);

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
		set_user_usp(id, g_Usps[item][szModel]);
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
		if(inventory_get_item(id, g_Chars[i][iSkinId]) || !g_Chars[i][iCost])
			formatex(itemText, 127, "\y%s", g_Chars[i][szName]);
		else{
			if(credits>=g_Chars[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Chars[i][szName], g_Chars[i][iCost]);
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Chars[i][szName], g_Chars[i][iCost]);
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
	
	if(inventory_get_item(id, g_Chars[item][iSkinId])){
		set_user_player_skin(id, g_Chars[item][szModel]);
		
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
		set_user_credits(id, credits - itemSkin[iCost])
		inventory_add(id, itemSkin[iSkinId]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", itemSkin[szName]);

		set_user_weapon_skin(id, itemSkin[szModel]);
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
		set_user_usp(id, g_Usps[item][szModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Usps[item][szName]);
	}
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iCost]){
		set_user_credits(id, credits - g_Chars[item][iCost])
		inventory_add(id, g_Chars[item][iSkinId]);
		set_user_player_skin(id, g_Chars[item][szModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Chars[item][szName]);
	}
	else{
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public set_user_weapon_skin(id, model[]) {
	switch(g_iMenuId[id]) {
		case iKnives:
			set_user_knife(id, model);
		case iButchers:
			set_user_butcher(id, model);
		case iBayonets:
			set_user_bayonet(id, model);
		case iDaggers:
			set_user_dagger(id, model);
		case iKatanas:
			set_user_katana(id, model);
		case iUsps:
			set_user_usp(id, model);
		case iCharacters:
			set_user_player_skin(id, model);
	}
}