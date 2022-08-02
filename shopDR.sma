#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta_util>
#include <nvault>
#include <nvault_array>
#include <cromchat>

#include <credits>
#include <inventory>

native reg_is_user_logged(id);
native reg_is_user_registered(id);

#define PLUGIN "Dr Shop"
#define VERSION "0.1"
#define AUTHOR "MrShark45"

enum _: eShopItem
{
	szName[64],
	szCallBackFunction[64],
	szPlugin[64],
	iCost,
	iItemID
}

new Array: g_aItems;

public plugin_init(){
	register_clcmd("say /shop", "shop_menu");

	g_aItems = ArrayCreate( eShopItem );

	CC_SetPrefix("&x04[LLG]") 
}

public plugin_natives(){
	register_library("shop")

	register_native("register_item", "register_item_native");
}
public register_item_native(numParams){
	new item_name[64], item_callbackFunction[64], item_plugin[64];
	get_string(1, item_name, sizeof(item_name));
	get_string(2, item_callbackFunction, sizeof(item_callbackFunction));
	get_string(3, item_plugin, sizeof(item_plugin));
	new item_cost = get_param(4);
	new itemID = get_param(5);

	new item[eShopItem];

	copy( item[ szName ], charsmax( item_name ), item_name );
	copy( item[ szCallBackFunction ], charsmax( item_callbackFunction ), item_callbackFunction );
	copy( item[ szPlugin ], charsmax( item_plugin ), item_plugin );
	item[iCost] = item_cost;
	item[iItemID] = itemID;

	ArrayPushArray(g_aItems, item);
}

public shop_menu(id, page){
	new title[128];
	new credits = get_user_credits(id);
	format(title, sizeof(title), "\y%d \wcredits - \rShop Menu\w!:", credits);
	new menu = menu_create( title, "menu_handler" );

	for(new i;i<ArraySize(g_aItems);i++)
	{
		new shopItem[eShopItem], item[128];
		ArrayGetArray(g_aItems, i, shopItem);

		if(credits >= shopItem[iCost])
			format(item, sizeof(item), "\w%s \y%d\wc", shopItem[szName], shopItem[iCost]);
		else
			format(item, sizeof(item), "\w%s \r%d\wc", shopItem[szName], shopItem[iCost]);
		if(!shopItem[iCost] || inventory_get_item(id, shopItem[iItemID]))
			format(item, sizeof(item), "\y%s", shopItem[szName]);

		menu_additem(menu, item, "");
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	
	menu_display( id, menu, page );

	return PLUGIN_CONTINUE;
}

public menu_handler(id, menu, item){
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;

	if(!reg_is_user_logged(id) || !reg_is_user_registered(id)){
		CC_SendMessage(id, "&x01Trebuie sa fii inregistrat pentru a cumpara din shop!");
		return PLUGIN_CONTINUE;
	}
	
	
	if(item < 0){
		menu_destroy( menu );
		return PLUGIN_CONTINUE;
	}
		
	new shopItem[eShopItem];
	ArrayGetArray(g_aItems, item, shopItem);
	new credits = get_user_credits(id);

	if(inventory_get_item(id, shopItem[iItemID])){
		CC_SendMessage(id, "&x01Deja ai cumparat acest item!");
		return PLUGIN_HANDLED;
	}

	if(credits < shopItem[iCost]){
		CC_SendMessage(id, "&x01Nu ai suficente credite pentru a cumpara acest item!");
		return PLUGIN_HANDLED;
	}

	new call = callfunc_begin(shopItem[szCallBackFunction], shopItem[szPlugin])
	if(call > 0) {
		callfunc_push_int(id);
		new ret = callfunc_end();
		if(!shopItem[iCost] || ret == -1){
			menu_destroy( menu );
			return PLUGIN_HANDLED;
		}
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", shopItem[szName]);
		new newCredits = credits-shopItem[iCost];
		set_user_credits(id, newCredits);
	}
	/*switch(call){
		case -1: client_print(id, print_chat, "Function not found");
		case -2: client_print(id, print_chat, "Plugin not found");
		case 0: client_print(id, print_chat, "Runtime error");
		case 1: client_print(id, print_chat, "Success");
	}*/

	shop_menu(id, item/7);
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

