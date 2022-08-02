#include <amxmodx>
#include <amxmisc>
#include <cromchat>

#include <shop>
#include <inventory>

#define PREMIUM_KNIFEID 256

public plugin_init(){
	register_item("Premium Knife", "handleKnife", "shopDR_knife.amxx", 50000, PREMIUM_KNIFEID);

	CC_SetPrefix("&x04[LLG]");
}

public handleKnife(id){
	inventory_add(id, PREMIUM_KNIFEID);

	new szName[64];
	get_user_name(id, szName, 63);
	CC_SendMessage(0, "&x01Jucatorul &x04%s &x01a cumparat &x07Premium Knife &x01din shop pentru &x0450.000 &x01de credite!", szName);
	CC_SendMessage(id, "&x01Felicitari, acum ai acces la &x04Premium Knife!", szName);
}