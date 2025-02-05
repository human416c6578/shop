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

#define KNIFE_NUM 11
#define BUTCHER_NUM 11
#define BAYONET_NUM 3
#define DAGGER_NUM 3
#define KATANA_NUM 4
#define USP_NUM 11
#define CHARS_NUM 7

enum eSkin
{
	iSkinId,
	szName[64],
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
	iBayonets,
	iDaggers,
	iKatanas,
	iUsps,
	iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "Default", 					0, 0},
	{101, "Knife Iridescent", 		 	5,	2500},
	{102, "Knife Neo-Noir", 		 	9,	2500},
	{103, "Knife Blood", 			 	2,	2500},
	{104, "Knife Nexus", 			 	10,	2500},
	{105, "Knife Moon", 			 	8,	2500},
	{106, "Knife King", 			 	6,	2500},
	{107, "Knife Lightning", 		 	7,	2500},
	{108, "Knife Ahegao", 			 	1,	2500},
	{109, "Knife Grizzly", 			 	4,	2500},
	{110, "Knife Ghost", 			 	3,	2500}
}

new g_Butchers[BUTCHER_NUM][eSkin] = {
	{150, "Default", 				0, 	0},
	{151, "Butcher Iridescent", 	6,	2500},
	{152, "Butcher Neo-Noir", 		8, 	2500},
	{153, "Butcher Blood", 			1,	2500},
	{154, "Butcher Carbon", 		2,	2500},
	{155, "Butcher Fade", 			3,	2500},
	{156, "Butcher Gojo", 			4,	2500},
	{157, "Butcher Hyperbeast", 	5,	2500},
	{158, "Butcher Lion", 			7,	2500},
	{159, "Butcher Nezuko", 		9,	2500},
	{160, "Butcher Xiao", 			10,	2500}
}

new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "Tiger Tooth", 			0,	0},
	{401, "Purple Haze", 			2, 	2500},
	{402, "Crimson Web", 		 	1,	2500}
}

new g_Daggers[DAGGER_NUM][eSkin] = {
	{500, "Default", 				0,	0},
	{501, "Ruby", 					1, 	2500},
	{502, "Purple Vibe", 			2,	2500}
}

new g_Katanas[KATANA_NUM][eSkin] = {
	{600, "Default", 				0,	0},
	{601, "Christmas", 				3,	0},
	{602, "Fade", 					1, 	2500},
	{603, "Sakura", 				2,	2500}
}

new g_Usps[USP_NUM][eSkin]={
	{200, "Default", 				0, 	0},
	{201, "Iridescent", 			6,	2500},
	{202, "Neo-Noir", 				7,	2500},
	{203, "Blood", 					1,	2500},
	{204, "Blue", 					2,	2500},
	{205, "Carbon", 				3,	2500},
	{206, "Cortex", 				4,	2500},
	{207, "Fade", 					5,	2500},
	{208, "Night Wolf", 			9,	2500},
	{209, "Sakura", 				8,	2500},
	{210, "Xiao", 					10,	2500}
};

new g_Chars[CHARS_NUM][ePlayerSkin]={
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

	register_item("Skins", "SkinsMenu", "shop_skins_submodels.amxx", 0);

	CC_SetPrefix("&x04[SHOP]") 

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
			KnifeSkinMenu(id, g_Butchers, KNIFE_NUM);
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
			skinItem = g_Butchers[item];
		case iBayonets:
			skinItem = g_Bayonets[item];
		case iDaggers:
			skinItem = g_Daggers[item];
		case iKatanas:
			skinItem = g_Katanas[item];
		case iUsps:
			skinItem = g_Usps[item];
	}
	
	if(inventory_get_item(id, skinItem[iSkinId])){
		set_user_weapon_skin(id, skinItem[iSubModel]);

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
		set_user_usp(id, g_Usps[item][iSubModel]);
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
}

public BuySkin(id, itemSkin[eSkin]){
	new credits = get_user_credits(id);
	if(credits >= itemSkin[iCost]){
		set_user_credits(id, credits - itemSkin[iCost])
		inventory_add(id, itemSkin[iSkinId]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", itemSkin[szName]);
		//CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", itemSkin[szName]);

		set_user_weapon_skin(id, itemSkin[iSubModel]);
	}		
	else{
		//CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");

	}
	
}

public BuyUspSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Usps[item][iCost]){
		set_user_credits(id, credits - g_Usps[item][iCost])
		inventory_add(id, g_Usps[item][iSkinId]);
		set_user_usp(id, g_Usps[item][iSubModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Usps[item][szName]);
		//CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Usps[item][szName]);
	}
	else{
		//CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public BuyPlayerSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Chars[item][iPlayerCost]){
		set_user_credits(id, credits - g_Chars[item][iPlayerCost])
		inventory_add(id, g_Chars[item][iPlayerSkinId]);
		set_user_player_skin(id, g_Chars[item][szPlayerModel]);
		CC_SendMessage(id, "%L", id, "SKIN_PURCHASED", g_Chars[item][szPlayerName]);
		//CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Chars[item][szPlayerName]);
	}
	else{
		//CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
		CC_SendMessage(id, "%L", id, "NOT_ENOUGH_CREDITS_SKIN");
	}
}

public set_user_weapon_skin(id, submodel) {
	switch(g_iMenuId[id]) {
		case iKnives:
			set_user_knife(id, submodel);
		case iButchers:
			set_user_butcher(id, submodel);
		case iBayonets:
			set_user_bayonet(id, submodel);
		case iDaggers:
			set_user_dagger(id, submodel);
		case iKatanas:
			set_user_katana(id, submodel);
		case iUsps:
			set_user_usp(id, submodel);
	}
}