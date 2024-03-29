#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat>

#include <player_skins>
#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 19
#define BAYONET_NUM 3
#define DAGGER_NUM 3
#define KATANA_NUM 3
#define USP_NUM 9
#define CHARS_NUM 5

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
	{100, "Default", "", 0},
	{101, "Knife Iridescent", 		"models/llg/shop/knife/v_def_iridescent.mdl", 	2500},
	{102, "Butcher Iridescent", 	"models/llg/shop/knife/v_but_iridescent.mdl", 	2500},
	{103, "Knife Neo-Noir", 		"models/llg/shop/knife/v_def_neo-noir.mdl", 	2500},
	{104, "Butcher Neo-Noir", 		"models/llg/shop/knife/v_but_neo-noir.mdl", 	2500},
	{105, "Knife Blood", 			"models/llg/shop/knife/v_def_blood.mdl", 		2500},
	{106, "Butcher Carbon", 		"models/llg/shop/knife/v_but_carbon.mdl", 		2500},
	{107, "Knife Nexus", 			"models/llg/shop/knife/v_def_nexus.mdl", 		2500},
	{108, "Butcher Gojo", 			"models/llg/shop/knife/v_but_gojo.mdl", 		2500},
	{109, "Knife Moon", 			"models/llg/shop/knife/v_def_moon.mdl", 		2500},
	{110, "Butcher Hyperbeast", 	"models/llg/shop/knife/v_but_hyperbeast.mdl", 	2500},
	{111, "Knife King", 			"models/llg/shop/knife/v_def_king.mdl", 		2500},
	{112, "Butcher Lion", 			"models/llg/shop/knife/v_but_lion.mdl", 		2500},
	{113, "Knife Lightning", 		"models/llg/shop/knife/v_def_lightning.mdl", 	2500},
	{114, "Butcher Xiao", 			"models/llg/shop/knife/v_but_xiao.mdl", 		2500},
	{115, "Knife Ahegao", 			"models/llg/shop/knife/v_def_ahegao.mdl", 		2500},
	{116, "Knife Sakura", 			"models/llg/shop/knife/v_def_sakura.mdl", 		2500},
	{117, "Knife Grizzly", 			"models/llg/shop/knife/v_def_grizzly.mdl", 		2500},
	{118, "Knife Ghost", 			"models/llg/shop/knife/v_def_ghost.mdl", 		2500}
}

new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth", 	"", 									0},
	{401, "Purple Haze", 	"models/llg/shop/v_vip_purple.mdl", 	2500},
	{402, "Crimson Web", 	"models/llg/shop/v_vip_crimson.mdl", 	2500}
}

new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default", 		"", 										0},
	{501, "Ruby", 			"models/llg/shop/v_premium_red.mdl", 		2500},
	{502, "Purple Vibe", 	"models/llg/shop/v_premium_purple.mdl", 	2500}
}

new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 		"", 									0},
	{601, "Fade", 			"models/llg/shop/v_kat_fade.mdl", 		2500},
	{602, "Sakura", 		"models/llg/shop/v_kat_sakura.mdl", 	2500}
}

new g_Usps[USP_NUM][eSkin]={
	{200, "Default", "", 0},
	{201, "Iridescent", 	"models/llg/shop/usp/v_usp_iridescent.mdl", 	2500},
	{202, "Neo-Noir", 		"models/llg/shop/usp/v_usp_neo-noir.mdl", 		2500},
	{203, "Blue", 			"models/llg/shop/usp/v_usp_blue.mdl", 			2500},
	{204, "Carbon", 		"models/llg/shop/usp/v_usp_carbon.mdl", 		2500},
	{205, "Cortex", 		"models/llg/shop/usp/v_usp_cortex.mdl", 		2500},
	{206, "Night Wolf", 	"models/llg/shop/usp/v_usp_night_wolf.mdl", 	2500},
	{207, "Sakura", 		"models/llg/shop/usp/v_usp_sakura.mdl", 		2500},
	{208, "Xiao", 			"models/llg/shop/usp/v_usp_xiao.mdl", 			2500}
};

new g_Chars[CHARS_NUM][eSkin]={
	{300, "Default", "", 0},
	{301, "Arctic", "arctic2", 2000},
	{302, "Hitman", "hitman", 5000},
	{303, "Ema", "ema", 10000},
	{304, "Agent Ritsuka", "ritsuka", 15000},
}

new g_iMenuId[33];

//Main
public plugin_init(){
	
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins", "SkinsMenu", "shop_skins.amxx", 0);

	CC_SetPrefix("&x04[SHOP]") 

}
//Precaching the skins from the list above
public plugin_precache(){
	for(new i=1;i<KNIFE_NUM;i++)
		precache_model(g_Knives[i][szModel]);
	for(new i=1;i<BAYONET_NUM;i++)
		precache_model(g_Bayonets[i][szModel]);
	for(new i=1;i<DAGGER_NUM;i++)
		precache_model(g_Daggers[i][szModel]);
	for(new i=1;i<KATANA_NUM;i++)
		precache_model(g_Katanas[i][szModel]);
	for(new i=1;i<USP_NUM;i++)
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
	new menu = menu_create( "\rChoose The Weapon You Want!:", "menu_handler1" );

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
	new menu = menu_create( "\rChoose Knife To Set Skin To!:", "menu_handler" );

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
	formatex(title, 127, "\rChoose Knife Skin\w - Credits : \y%d", credits);
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
	formatex(title, 127, "\rChoose Usp Skin\w - Credits : \y%d", credits);

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
	formatex(title, 127, "\rChoose Player Skin\w - Credits : \y%d", credits);
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
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", itemSkin[szName]);

		set_user_weapon_skin(id, itemSkin[szModel]);
	}		
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
	}
	
}

public BuyUspSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Usps[item][iCost]){
		set_user_credits(id, credits - g_Usps[item][iCost])
		inventory_add(id, g_Usps[item][iSkinId]);
		set_user_usp(id, g_Usps[item][szModel]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Usps[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
	}
}

public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iCost]){
		set_user_credits(id, credits - g_Chars[item][iCost])
		inventory_add(id, g_Chars[item][iSkinId]);
		set_user_player_skin(id, g_Chars[item][szModel]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Chars[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
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