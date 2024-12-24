#include <amxmodx>
#include <cstrike>
#include <cromchat>
#include <fakemeta_util>
#include <credits>
#include <shop>
#include <deathrun>

new g_iTero[MAX_PLAYERS];
new g_iHP[MAX_PLAYERS];

public plugin_init(){
	register_event("HLTV", "eventNewRound", "a", "1=0", "2=0");

	registerItems();
	
	CC_SetPrefix("&x04[DR]") 
}

public client_putinserver(id){
	g_iTero[id] = 0;
	g_iHP[id] = 0;
}

public eventNewRound(){
	for(new i;i<MAX_PLAYERS;i++)
		g_iHP[i] = 0;
}

registerItems(){
	register_item("Terorist Runda Urmatoare", "handleBuyTerro", "shop_dr_weapons.amxx", 100);
	register_item("50 HP", "handleHealth50", "shop_dr_weapons.amxx", 100);
	register_item("50 Armura", "handleArmor50", "shop_dr_weapons.amxx", 50);
	register_item("Desert Eagle", "handleDeagle", "shop_dr_weapons.amxx", 50);
	register_item("M4a1", "handleM4a1", "shop_dr_weapons.amxx", 100);
	register_item("Ak47", "handleAk47", "shop_dr_weapons.amxx", 100);
	register_item("AWP", "handleAwp", "shop_dr_weapons.amxx", 150);
}

public handleBuyTerro(id){
	new terro = get_next_terrorist();
	new szName[64];
	if(g_iTero[id] >= 3){
		CC_SendMessage(id, "Ai atins limita maxima a acestui item.");
		return -1;
	}
	if(terro){
		get_user_name(terro, szName, sizeof(szName));
		CC_SendMessage(id, "&x04%s &x01a ales deja sa fie terrorist urmatoare runda!", szName);
		return -1;
	}
	else{
		set_next_terrorist(id);
		get_user_name(id, szName, 63);
		CC_SendMessage(0, "&x04%s &x01a ales sa fie &x03terorist runda urmatoare!", szName);
		g_iTero[id]++;
	}
}
//Doar pentru tero
public handleHealth50(id){
	if(cs_get_user_team(id) != CS_TEAM_T){
		CC_SendMessage(id, "&x01Optiunea aceasta este doar pentru terorist!");
		return -1;
	}
	if(g_iHP[id] >= 5){
		CC_SendMessage(id, "Ai atins limita maxima a acestui item.");
		return -1;
	}

	new health = get_user_health(id)+50;

	fm_set_user_health(id, health);

	g_iHP[id]++;
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
