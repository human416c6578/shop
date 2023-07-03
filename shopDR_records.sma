#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <hamsandwich>
#include <cromchat>
#include <nvault>

#include <inventory>
#include <shop>
#include <credits>
#include <timer>

#define SOUNDS_NUM 10

enum _: eSound
{
	iID,
	szName[64],
	szPath[128],
	iCost
}

// new g_Sounds[SOUNDS_NUM][eSound]={
//	 {320, "Default",		"", 0},
//	 {321, "Lane Boy",		 "endround/lane boy.mp3", 3000},
//	 {322, "Deliric Maine",		  "endround/maine.mp3", 3000},
//	 {323, "Premium",		"endround/premium.mp3", 3000},
//	 {324, "Enemy",		"endround/enemy.mp3", 3000},
//	 {325, "Bones",		"endround/bones.mp3", 3000},
//	 {326, "Live Another Day",		"endround/liveanotherday.mp3", 3000},
//	 {327, "Where are you now",		"endround/whereareyounow.mp3", 3000},
//	 {328, "I Ain't Worried",		"endround/worried.mp3", 3000},
//	 {329, "Alors On Danse",		"endround/alors.mp3", 3000}

// };

new Array:g_aSounds;

new g_iVault;

new currentSound[33];

public plugin_init(){
	register_item("Record Sounds", "RecordsMenu", "shopDR_records.amxx", 0);

	g_iVault = nvault_open("recordsounds");
	
}

public plugin_precache(){
	g_aSounds = ArrayCreate(eSound);
	LoadSongs();
	new eItem[eSound];
	new file[64];
	for(new i=1;i<ArraySize(g_aSounds);i++){
		ArrayGetArray(g_aSounds, i, eItem);
		format(file, charsmax(file), "sound/%s", eItem[szPath]);
		precache_generic(file);
	}
		
}

public plugin_end(){
	ArrayDestroy(g_aSounds);
}

public client_putinserver(id){
	Load(id);
}

public client_disconnected(id){
	Save(id);
}


public LoadSongs(){
	new szFilename[256]
	get_configsdir(szFilename, charsmax(szFilename))
	add(szFilename, charsmax(szFilename), "/songs.cfg")
	new iFilePointer = fopen(szFilename, "rt");
	new szData[256], eItem[eSound];
	new szID[16];
	new szCost[16];

	if(iFilePointer){
		while(!feof(iFilePointer))
		{
			fgets(iFilePointer, szData, charsmax(szData))
			trim(szData)

			switch(szData[0])
			{
				case EOS, '#', ';', '/': continue
			}

			parse(szData, szID, charsmax(szID), eItem[szName], charsmax(eItem[szName]), eItem[szPath], charsmax(eItem[szPath]), szCost, charsmax(szCost));
			eItem[iID] = str_to_num(szID);
			eItem[iCost] = str_to_num(szCost);
			ArrayPushArray(g_aSounds, eItem);
			server_print("%d %s %s %d", eItem[iID], eItem[szName], eItem[szPath], eItem[iCost]);
		}
	}
}

public BuySound(id, item){
	new credits = get_user_credits(id);
	new eItem[eSound];
	ArrayGetArray(g_aSounds, item, eItem);
	if(credits >= eItem[iCost]){
		set_user_credits(id, credits - eItem[iCost])
		inventory_add(id, eItem[iID]);
		formatex(currentSound[id], 127, "%s", eItem[szPath]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", eItem[szName]);
	}
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest sunet!");
	}
}

public timer_player_record(id){
	if(currentSound[id])
		PlaySound(id);
	else
		PlaySoundRandom();
}

public timer_player_world_record(id){
	PlaySoundRandom();
}

public RecordsMenu(id){
	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\rChoose Sound\w - Credits : \y%d", credits);

	new menu = menu_create( title, "menu_handler" );
	new eItem[eSound];
	for(new i = 0;i<ArraySize(g_aSounds);i++){
		ArrayGetArray(g_aSounds, i, eItem);
		if(inventory_get_item(id, eItem[iID]) || !eItem[iCost])
			formatex(itemText, 127, "\y%s", eItem[szName])
		else{
			if(credits>=eItem[iCost])
				formatex(itemText, 127, "\w%s - \y%d", eItem[szName], eItem[iCost])
			else
				formatex(itemText, 127, "\w%s - \r%d", eItem[szName], eItem[iCost])
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
	menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, menu, 0 );

	return PLUGIN_CONTINUE;
}

public menu_handler( id, menu, item ){
	if ( item == MENU_EXIT ){
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	new eItem[eSound];
	ArrayGetArray(g_aSounds, item, eItem);
	if(inventory_get_item(id, eItem[iID])){
		formatex(currentSound[id], 127, "%s", eItem[szPath]);
		Save(id);
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	BuySound(id, item);
	return PLUGIN_HANDLED;
}

//save the current sound
public Save(id){
	new name[64];

	get_user_name( id , name , charsmax( name ) );
	formatex(name, charsmax(name), "%s", name);
	nvault_set( g_iVault , name , currentSound[id]);

	return PLUGIN_CONTINUE;
}
//loads the current sound
public Load(id){
	new name[64];

	get_user_name( id , name , charsmax( name ) );

	formatex(name, charsmax(name), "%s", name);
	nvault_get( g_iVault , name , currentSound[id] , 127 );

	return PLUGIN_CONTINUE;
}

stock PlaySound(id){
	// Emit sound should not work if you precache sounds with precache_generic
	//emit_sound(0, CHAN_AUTO, currentSound[id], 0.5, ATTN_NORM, 0, PITCH_NORM);
	play_sound(0, currentSound[id]);
}

public PlaySoundRandom(){
	new rNum = random_num(1, ArraySize(g_aSounds) - 1);
	// Emit sound should not work if you precache sounds with precache_generic
	//emit_sound(0, CHAN_AUTO, g_Sounds[rNum][szPath], 1.0, ATTN_NORM, 0, PITCH_NORM);
	new eItem[eSound];
	ArrayGetArray(g_aSounds, rNum, eItem);
	play_sound(0, eItem[szPath]);
}

play_sound(id, sound[])
{
	new audio_track[128];
	format(audio_track, 127, "%s", sound);
	if(containi(sound, "sound/") == -1)
		format(audio_track, 127, "sound/%s", sound);

	new len = strlen(audio_track);
	if(equali(audio_track[len - 3], "wav")) {
		send_audio(id, audio_track, PITCH_NORM);
	} else if(equali(audio_track[len - 3], "mp3")) {
		client_cmd(id, "mp3 play ^"%s^"", audio_track);
	}
}

stock send_audio(id, audio[], pitch)
{
	static msg_send_audio;
	
	if(!msg_send_audio) {
		msg_send_audio = get_user_msgid("SendAudio");
	}

	message_begin( id ? MSG_ONE_UNRELIABLE : MSG_BROADCAST, msg_send_audio, _, id);
	write_byte(id);
	write_string(audio);
	write_short(pitch);
	message_end();
}