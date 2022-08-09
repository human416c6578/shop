#include <amxmodx>
#include <cromchat>
#include <nvault>

#include <inventory>
#include <shop>
#include <credits>

#define SOUNDS_NUM 14

enum _: eSound
{
	iItemID,
	szName[64],
	szPath[128],
	iCost
}

new g_Sounds[SOUNDS_NUM][eSound]={
	{220, "Default",		"", 0},
	{221, "bbNo$",		  "endround/bbnos.mp3", 3000},
	{222, "Batuque",		"endround/batuque.mp3", 3000},
	{223, "Call Me",		"endround/call me.mp3", 3000},
	{224, "Chantaje",	   "endround/chantaje.mp3", 3000},
	{225, "Una Favela",		 "endround/favela.mp3", 3000},
	{226, "Feel Good",	  "endround/feel good.mp3", 3000},
	{227, "Lane Boy",		 "endround/lane boy.mp3", 3000},
	{228, "Industry baby",  "endround/industry baby.mp3", 3000},
	{229, "Lean On",		"endround/lean on.mp3", 3000},
	{230, "Liar",		   "endround/liar.mp3", 3000},
	{231, "Deliric Maine",		  "endround/maine.mp3", 3000},
	{232, "Premium",		"endround/premium.mp3", 3000},
	{233, "Say It Right",   "endround/say it right.mp3", 3000}
};

new g_iVault;

new currentSound[33][128];

public plugin_init(){
	register_item("Sounds", "SoundsMenu", "shopDR_sounds.amxx", 0);

	//Terro WIN
	register_logevent("Event_TWin" , 6, "3=Terrorists_Win", "3=Target_Bombed") 
	//CT WIN
	register_logevent("Event_CTWin", 6, "3=CTs_Win", "3=All_Hostages_Rescued");

	g_iVault = nvault_open("sounds");
}


public plugin_precache(){
	new file[64];
	for(new i=1;i<SOUNDS_NUM;i++){
		format(file, charsmax(file), "sound/%s", g_Sounds[i][szPath]);
		precache_generic(file);
	}
		
}

public client_putinserver(id){
	Load(id);
}

public client_disconnected(id){
	Save(id);
}

public SoundsMenu(id){

	new itemText[128], title[128];
	new credits = get_user_credits(id);
	formatex(title, 127, "\rChoose Sound\w - Credits : \y%d", credits);

	new menu = menu_create( title, "menu_handler" );

	for(new i = 0;i<SOUNDS_NUM;i++){
		if(inventory_get_item(id, g_Sounds[i][iItemID]) || !g_Sounds[i][iCost])
			formatex(itemText, 127, "\y%s", g_Sounds[i][szName])
		else{
			if(credits>=g_Sounds[i][iCost])
				formatex(itemText, 127, "\w%s - \y%d", g_Sounds[i][szName], g_Sounds[i][iCost])
			else
				formatex(itemText, 127, "\w%s - \r%d", g_Sounds[i][szName], g_Sounds[i][iCost])
		}
		
		menu_additem( menu, itemText, "", 0 );
	}
	
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
	
	if(inventory_get_item(id, g_Sounds[item][iItemID])){
		formatex(currentSound[id], 127, "%s", g_Sounds[item][szPath]);
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
	nvault_set( g_iVault , name , currentSound[id]);  

	return PLUGIN_CONTINUE;
}
//loads the current sound
public Load(id){
	new name[64];

	get_user_name( id , name , charsmax( name ) );
	nvault_get( g_iVault , name , currentSound[id] , 127 );  

	return PLUGIN_CONTINUE;
}


public BuySound(id, item){
	new credits = get_user_credits(id);
	if(credits >= g_Sounds[item][iCost]){
		set_user_credits(id, credits - g_Sounds[item][iCost])
		inventory_add(id, g_Sounds[item][iItemID]);
		formatex(currentSound[id], 127, "%s", g_Sounds[item][szPath]);
		CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Sounds[item][szName]);
	}
	else{
		CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest sunet!");
	}
}

public Event_CTWin(){
	new CTs[32],iNum, ct;
	get_players(CTs, iNum, "ae", "CT");
	ct = CTs[0];
	
	if(strlen(currentSound[ct]))
		PlaySound(ct);
	else
		PlaySoundRandom();
}

public Event_TWin(){
	new terrorists[32],iNum, terro;
	get_players(terrorists, iNum, "ae", "TERRORIST");
	terro = terrorists[0];
	
	if(strlen(currentSound[terro]))
		PlaySound(terro);
	else
		PlaySoundRandom();
}

stock PlaySound(id){
	// Emit sound should not work if you precache sounds with precache_generic
	//emit_sound(0, CHAN_AUTO, currentSound[id], 0.5, ATTN_NORM, 0, PITCH_NORM);
	play_sound(0, currentSound[id]);
}

public PlaySoundRandom(){
	new rNum = random_num(1, SOUNDS_NUM-1);
	// Emit sound should not work if you precache sounds with precache_generic
	//emit_sound(0, CHAN_AUTO, g_Sounds[rNum][szPath], 1.0, ATTN_NORM, 0, PITCH_NORM);
	play_sound(0, g_Sounds[rNum][szPath]);
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