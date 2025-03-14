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

#define KNIFE_NUM 23
#define BUTCHER_NUM 9
#define BAYONET_NUM 3
//#define DAGGER_NUM 3
//#define KATANA_NUM 4
#define USP_NUM 24
#define CHARS_NUM 7

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
	iBayonets,
	//iDaggers,
	//iKatanas,
	iUsps,
	iCharacters
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{100, "models/fwo2025/v_def_free_and_vip.mdl", "Default",            	0, 0},
    {123, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Ahegao",       	26, 1000},
    {124, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Black",        	41, 1000},
    {125, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Black-Orange",  	37, 1000},
    {126, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Blood",        	20, 1000},
    {127, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Fire",         	21, 1000},
    {128, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Fire Flower",  	22, 1000},
    {129, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Galaxy",       	30, 1000},
    {130, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Goku",         	31, 1000},
    {131, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Gold",         	32, 1000},
    {132, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Grizzly",      	23, 1000},
	{133, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Howl",         	24, 1000},
    {134, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Icephoenix",   	25, 1000},
    {135, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Iridescent",   	27, 1000},
    {136, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Joker",        	33, 1000},
    {137, "models/fwo2025/v_def_free_and_vip.mdl", "Knife King",         	42, 1000},
    {138, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Moon",         	28, 1000},
    {139, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Neo-Noir",     	29, 1000},
    {140, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Purple",      	40, 1000},
    {141, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Sakura",       	39, 1000},
    {142, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Shred",        	34, 1000},
    {143, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Storm",        	35, 1000},
    {144, "models/fwo2025/v_def_free_and_vip.mdl", "Knife Venom",        	36, 1000}
}

new g_Butchers[BUTCHER_NUM][eSkin] = {
    {150, "models/fwo2025/v_but_free_and_vip.mdl", "Default",           		0, 0,},
    {160, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Blood Khalifa", 	11, 1000},
    {161, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Boris",      	12, 1000},
    {162, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Gojo",       	13, 1000},
    {163, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Hyperbeast", 	14, 1000},
    {164, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Iridescent", 	10, 1000},
    {165, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Lion blade", 	15, 1000},
    {166, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Neo-Noir",   	16, 1000},
    {167, "models/fwo2025/v_but_free_and_vip.mdl", "Butcher Xiao",       	17, 1000}
}


new g_Bayonets[BAYONET_NUM][eSkin] = {
	{400, "models/llg3/v_vip.mdl", "Tiger Tooth", 			0,	0},
	{401, "models/llg3/v_vip.mdl", "Purple Haze", 			2, 	1000},
	{402, "models/llg3/v_vip.mdl", "Crimson Web", 		 	1,	1000}
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
	{200, "models/fwo2025/v_usp_vip", "Default",             0, 0},
	{223, "models/fwo2025/v_usp_vip", "Abstract Blue",       23, 1000},
	{224, "models/fwo2025/v_usp_vip", "Black",               24, 1000},
	{225, "models/fwo2025/v_usp_vip", "Blue",                25, 1000},
	{226, "models/fwo2025/v_usp_vip", "Bright",              26, 1000},
	{227, "models/fwo2025/v_usp_vip", "Caiman",              27, 1000},
	{228, "models/fwo2025/v_usp_vip", "Cardinal Crystal",    28, 1000},
	{229, "models/fwo2025/v_usp_vip", "Cortex",              29, 1000},
	{230, "models/fwo2025/v_usp_vip", "Electra",             30, 1000},
	{231, "models/fwo2025/v_usp_vip", "Fire Flower",         31, 1000},
	{232, "models/fwo2025/v_usp_vip", "Flashback",           32, 1000},
	{233, "models/fwo2025/v_usp_vip", "Green Fire",          33, 1000},
	{234, "models/fwo2025/v_usp_vip", "Green Realist",       34, 1000},
	{235, "models/fwo2025/v_usp_vip", "Iridescent",          35, 1000},
	{236, "models/fwo2025/v_usp_vip", "Lightning Monster",   36, 1000},
	{237, "models/fwo2025/v_usp_vip", "Neo-Noir",            37, 1000},
	{238, "models/fwo2025/v_usp_vip", "Night Wolf",          38, 1000},
	{239, "models/fwo2025/v_usp_vip", "Oil Filter",          39, 1000},
	{240, "models/fwo2025/v_usp_vip", "Purity",              40, 1000},
	{241, "models/fwo2025/v_usp_vip", "Sakura",              41, 1000},
	{242, "models/fwo2025/v_usp_vip", "Shaker",              42, 1000},
	{243, "models/fwo2025/v_usp_vip", "Ticket to Hell",      43, 1000},
	{244, "models/fwo2025/v_usp_vip", "Xiao",                44, 1000},
	{245, "models/fwo2025/v_usp_vip", "Xtreme",              45, 1000}
};

new g_Chars[CHARS_NUM][ePlayerSkin]={
	{300, "Default", "", 				0},
	{301, "Arctic", "arctic2", 			2000},
	{302, "Hitman", "hitman", 			5000},
	{303, "Ema", "ema", 				10000},
	{304, "Agent Ritsuka", "ritsuka", 	15000},
	{305, "Sub-zero", "sub-zero", 		5000},
	{306, "Scorpion", "scorpion", 		5000}
}

new g_iMenuId[33];

//Main
public plugin_init(){
	register_plugin(PLUGIN,VERSION,AUTHOR);

	register_item("Skins(VIP)", "SkinsMenu", "shop_skins_submodels_vip.amxx", 0);

	//Chat prefix
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
			KnifeSkinMenu(id, g_Butchers, KNIFE_NUM);
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
	skinItem = g_Knives[item];
	switch(g_iMenuId[id]) {
		case iKnives:
			skinItem = g_Knives[item];
		case iButchers:
			skinItem = g_Butchers[item];
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
		set_user_player_skin(id, g_Chars[item][szPlayerModel]);
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