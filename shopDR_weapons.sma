#include <amxmodx>
#include <cstrike>
#include <cromchat>
#include <fakemeta_util>

#include <credits>
#include <shop>
#include <deathrun>


public plugin_init(){
	registerItems();
	
	CC_SetPrefix("&x04[STRIX]") 
}

registerItems(){
	register_item("Terorist Runda Urmatoare", "handleBuyTerro", "shopDR_weapons.amxx", 50);
	register_item("50 HP", "handleHealth50", "shopDR_weapons.amxx", 100);
	register_item("50 Armura", "handleArmor50", "shopDR_weapons.amxx", 50);
	register_item("Desert Eagle", "handleDeagle", "shopDR_weapons.amxx", 50);
	register_item("M4a1", "handleM4a1", "shopDR_weapons.amxx", 100);
	register_item("Ak47", "handleAk47", "shopDR_weapons.amxx", 100);
	register_item("AWP", "handleAwp", "shopDR_weapons.amxx", 150);
}

public handleBuyTerro(id){
	new terro = set_next_terrorist(id);
	new szName[64];
	if(terro){
		get_user_name(terro, szName, sizeof(szName));
		CC_SendMessage(id, "&x04%s &x01a ales deja sa fie terrorist urmatoare runda!", szName);
		return -1;
	}
	else{
		get_user_name(id, szName, 63);
		CC_SendMessage(0, "&x04%s &x01a ales sa fie &x03terorist runda urmatoare!", szName);
	}
}
//Doar pentru tero
public handleHealth50(id){
	if(cs_get_user_team(id) != CS_TEAM_T){
		CC_SendMessage(id, "&x01Optiunea aceasta este doar pentru terorist!");
		set_user_credits(id, get_user_credits(id) + 100)
		return -1;
	}

	fm_set_user_health(id, get_user_health(id)+50);
}

public handleArmor50(id){
	if(cs_get_user_team(id) != CS_TEAM_T){
		CC_SendMessage(id, "&x01Optiunea aceasta este doar pentru terorist!");
		set_user_credits(id, get_user_credits(id) + 50)
		return - 1;
	}
	fm_set_user_armor(id, get_user_armor(id)+50);
}

public handleDeagle(id){
	fm_give_item(id, "weapon_deagle");
	fm_give_item(id, "ammo_deagle");
	fm_give_item(id, "ammo_deagle");
}

public handleM4a1(id){
	fm_give_item(id, "weapon_m4a1");
	fm_give_item(id, "ammo_m4a1");
	fm_give_item(id, "ammo_m4a1");
}

public handleAk47(id){
	fm_give_item(id, "weapon_ak47");
	fm_give_item(id, "ammo_ak47");
	fm_give_item(id, "ammo_ak47");
}

public handleAwp(id){
	fm_give_item(id, "weapon_awp");
	fm_give_item(id, "ammo_awp");
	fm_give_item(id, "ammo_awp");
}
