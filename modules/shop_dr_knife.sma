#include <amxmodx>
#include <amxmisc>
#include <cromchat2>

#include <shop>
#include <inventory>

#define PLUGIN "DR Shop"
#define VERSION "1.1"
#define AUTHOR "MrShark45"

#define PREMIUM_KNIFEID 256
#define KATANA_KNIFEID 257

public plugin_init(){
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_item("Premium Knife", "handlePremium", "shop_dr_knife.amxx", 50000, PREMIUM_KNIFEID);
	register_item("Katana", "handleKatana", "shop_dr_knife.amxx", 40000, KATANA_KNIFEID);

	//Chat prefix
	CC_SetPrefix("&x04[SHOP]");
}

public plugin_cfg(){
	register_dictionary("shop_dr_knife.txt");
}

public handlePremium(id){
	inventory_add(id, PREMIUM_KNIFEID);

	new szName[64];
	get_user_name(id, szName, 63);
	CC_SendMessage(0, "%l", "PREMIUM_KNIFE_PURCHASED", szName);
	CC_SendMessage(id, "%L", id, "PREMIUM_KNIFE_GRANTED");
}

public handleKatana(id){
	inventory_add(id, KATANA_KNIFEID);

	new szName[64];
	get_user_name(id, szName, 63);
	CC_SendMessage(0, "%l", "KATANA_KNIFE_PURCHASED", szName);
	CC_SendMessage(id, "%L", id, "KATANA_KNIFE_GRANTED");	
}