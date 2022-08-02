#include <amxmodx>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <cromchat>

#include <shop>
#include <credits>
#include <inventory>

#define PLUGIN "Shop Skins"	
#define VERSION "1.0"
#define AUTHOR "MrShark45"

#pragma tabsize 0

#define KNIFE_NUM 5
#define USP_NUM 3
#define CHARS_NUM 5

enum _: eSkin
{
	iSkinId,
	szName[64],
	szModel[128],
	iCost
}

new g_Knives[KNIFE_NUM][eSkin] = {
	{201, "Default", "", 0},
	{202, "Default Iridescent", "models/player/clan/clanT2.mdl", 12500},
	{203, "Butcher Iridescent", "models/player/sonic/sonicT2.mdl", 12500},
	{204, "Default Neo-Noir", "models/player/robi/robiT.mdl", 25000},
	{205, "Butcher Neo-Noir", "models/player/tokyo/tokyoT.mdl", 25000}
}


new g_Usps[USP_NUM][eSkin]={
	{120, "Default", "", 0},
	{121, "Iridescent", "models/player/boruto/borT.mdl", 12500},
	{122, "Neo-Noir", "models/player/spider/spidermanT.mdl", 25000}
};

new g_Chars[CHARS_NUM][eSkin]={
	{250, "Default", "", 0},
	{260, "Arctic", "arctic2", 2000},
	{261, "Hitman", "hitman", 5000},
	{262, "Ema", "ema", 10000},
	{263, "Agent Ritsuka", "ritsuka", 15000},
}

new currentKnife[33][2][128];
new currentUsp[33][128];
new currentPlayer[33][128];

new knifeId[33];

new g_iVault;

//Main
public plugin_init(){
	
	register_plugin(PLUGIN,VERSION,AUTHOR);

	//register_clcmd( "say /skins","SkinsMenu" );

	register_event("CurWeapon","Changeweapon_Hook","be","1=1");

	register_event("ResetHUD", "ResetModel_Hook", "b");

	g_iVault = nvault_open( "skins" );

	register_item("Skins", "SkinsMenu", "shopDR_skins.amxx", 0);

	CC_SetPrefix("&x04[LLG]") 

}
//Precaching the skins from the list above
public plugin_precache(){
	for(new i=1;i<KNIFE_NUM;i++)
		precache_model(g_Knives[i][szModel]);
	for(new i=1;i<USP_NUM;i++)
		precache_model(g_Usps[i][szModel]);
	
	new mdl[128];
	for(new i=1;i<CHARS_NUM;i++){
		format(mdl, charsmax(mdl), "models/player/%s/%s.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		precache_model(mdl);
		format(mdl, charsmax(mdl), "models/player/%s/%sT.mdl", g_Chars[i][szModel], g_Chars[i][szModel]);
		if(file_exists(mdl))
			precache_model(mdl);
	}
		

}
//Event Connect Player
public client_putinserver(id){
	Load(id);
}

//Checking the weapon the player switched to and if he's a vip it'll set a skin on that weapon if it's on the weapons list above
public Changeweapon_Hook(id){
	
	new model[32];

	pev(id,pev_viewmodel2, model, 31);
	new wpn_id = get_user_weapon(id);

	if(wpn_id == CSW_USP && strlen(currentUsp[id]))
		set_pev(id,pev_viewmodel2, currentUsp[id]);
	if(equali(model,"models/llg/v_knife.mdl") && strlen(currentKnife[id][0]))
		set_pev(id,pev_viewmodel2,currentKnife[id][0]);
	if(equali(model,"models/llg/v_butcher.mdl") && strlen(currentKnife[id][1]))
		set_pev(id,pev_viewmodel2,currentKnife[id][1]);
	
	return PLUGIN_HANDLED;
}

public ResetModel_Hook(id, level, cid){
	if(currentPlayer[id][0]){
		cs_set_user_model(id, currentPlayer[id]);
		server_print(currentPlayer[id]);
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
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
//menu handler for the vip menu /vmenu
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

	menu_additem( menu, "\wDefault Knife", "", 0 );
	menu_additem( menu, "\wGravity Knife", "", 0 );

	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the knife skin menu
public menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	switch( item )
	{
		case 0:
		{
			KnifeSkinMenu(id);
			knifeId[id] = 0;
		}
		case 1:
		{
			KnifeSkinMenu(id);
			knifeId[id] = 1;
		}
	}
	menu_destroy( menu );
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
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}
//Handler for the knife skin menu
public usp_menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Usps[item][iSkinId])){
		formatex(currentUsp[id], 127, "%s", g_Usps[item][szModel]);
		Save(id);
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	BuyUspSkin(id, item);
	return PLUGIN_HANDLED;
}
//Second Menu
public KnifeSkinMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\rChoose Knife Skin\w - Credits : \y%d", credits);
	new menu = menu_create( title, "knife_skin_handler" );
	
	for(new i = 0;i<KNIFE_NUM;i++){
		if(inventory_get_item(id, g_Knives[i][iSkinId]) || !g_Knives[i][iCost])
			formatex(itemText, 127, "\y%s", g_Knives[i][szName]);
		else{
			if(credits>=g_Knives[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Knives[i][szName], g_Knives[i][iCost]);
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Knives[i][szName], g_Knives[i][iCost]);
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public knife_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Knives[item][iSkinId])){
		formatex(currentKnife[id][knifeId[id]], 127, "%s", g_Knives[item][szModel]);
		Save(id);
		menu_destroy( menu );
		return PLUGIN_HANDLED;

	}

	BuyKnifeSkin(id, item);
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
	menu_display( id, menu, 0 );
}

//Second Handler for the second menu
public player_skin_handler( id, menu, item){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	
	if(inventory_get_item(id, g_Chars[item][iSkinId])){
		formatex(currentPlayer[id], 127, "%s", g_Chars[item][szModel]);
		Save(id);
		menu_destroy( menu );
		return PLUGIN_HANDLED;

	}

	BuyPlayerSkin(id, item);
	return PLUGIN_HANDLED;
}

public BuyKnifeSkin(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Knives[item][iCost]){
		set_user_credits(id, credits - g_Knives[item][iCost])
		inventory_add(id, g_Knives[item][iSkinId]);
		formatex(currentKnife[id][knifeId[id]], 127, "%s", g_Knives[item][szModel]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Knives[item][szName]);
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
		formatex(currentUsp[id], 127, "%s", g_Usps[item][szModel]);
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
		formatex(currentPlayer[id], 127, "%s", g_Chars[item][szModel]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Chars[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest skin!");
	}
}

//save the skins 
public Save(id){
	new name[30];
	new key1[30];
	new key2[30];
	new key3[30];
	new key4[30];


	get_user_name( id , name , charsmax( name ) );

	formatex(key1, charsmax(key1), "%s", name);
	formatex(key2, charsmax(key2), "%s+1", name);
	formatex(key3, charsmax(key2), "%s+3", name);
	formatex(key4, charsmax(key2), "%s+5", name);
	
	nvault_set( g_iVault , key1 , currentKnife[id][0]);
	nvault_set( g_iVault , key2 , currentKnife[id][1]);
	nvault_set( g_iVault , key3 , currentUsp[id]);
	nvault_set( g_iVault , key4 , currentPlayer[id]);

	cs_set_user_model(id, currentPlayer[id]);
}
//loads the skins
public Load(id){

	new name[30];
	new key1[30];
	new key2[30];
	new key3[30];
	new key4[30];

	get_user_name( id , name , charsmax( name ) );

	formatex(key1, charsmax(key1), "%s", name);
	formatex(key2, charsmax(key2), "%s+1", name);
	formatex(key3, charsmax(key2), "%s+3", name);
	formatex(key4, charsmax(key2), "%s+5", name);

	nvault_get( g_iVault , key1 , currentKnife[id][0] , 127 );  
	nvault_get( g_iVault , key2 , currentKnife[id][1] , 127 );
	nvault_get( g_iVault , key3 , currentUsp[id] , 127 );
	nvault_get( g_iVault , key4 , currentPlayer[id] , 127 );
}