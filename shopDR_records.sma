#include <amxmodx>
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
    iItemID,
    szName[64],
    szPath[128],
    iCost
}

enum _: eType
{
    szSR[128],
    szLocal[128],
}

new g_Sounds[SOUNDS_NUM][eSound]={
    {320, "Default",        "", 0},
    {321, "Lane Boy",         "endround/lane boy.mp3", 3000},
    {322, "Deliric Maine",          "endround/maine.mp3", 3000},
    {323, "Premium",        "endround/premium.mp3", 3000},
    {324, "Enemy",        "endround/enemy.mp3", 3000},
    {325, "Bones",        "endround/bones.mp3", 3000},
    {326, "Live Another Day",        "endround/liveanotherday.mp3", 3000},
    {327, "Where are you now",        "endround/whereareyounow.mp3", 3000},
    {328, "I Ain't Worried",        "endround/worried.mp3", 3000},
    {329, "Alors On Danse",        "endround/alors.mp3", 3000}

};

new g_iVault;

new currentType[33];
new currentSound[33][eType];

public plugin_init(){
    register_item("Record Sounds", "ChooseMenu", "shopDR_records.amxx", 0);

    g_iVault = nvault_open("recordsounds");
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


public BuySound(id, item){
    new credits = get_user_credits(id);
    if(credits >= g_Sounds[item][iCost]){
        set_user_credits(id, credits - g_Sounds[item][iCost])
        inventory_add(id, g_Sounds[item][iItemID]);
        formatex(currentSound[id][currentType[id]], 127, "%s", g_Sounds[item][szPath]);
        CC_SendMessage(id, "&x01Ai cumparat &x04%s &x01!", g_Sounds[item][szName]);
    }
    else{
        CC_SendMessage(id, "&x01Nu ai suficiente credite pentru a cumpara acest sunet!");
    }
}

public timer_player_record(id){
    currentType[id] = szLocal;
    if(currentSound[id][currentType[id]])
        PlaySound(id);
    else
        PlaySoundRandom();
}

public timer_player_world_record(id){
    currentType[id] = szSR;
    if(currentSound[id][currentType[id]])
        PlaySound(id);
    else
        PlaySoundRandom();
}

public ChooseMenu(id){
    new itemText[128], title[128];
    new credits = get_user_credits(id);
    formatex(title, 127, "\rChoose Category\w - Credits : \y%d", credits);

    new menu = menu_create( title, "choosemenu_handler" );

    formatex(itemText, 127, "\wLocal Record")
    menu_additem( menu, itemText, "", 0 );

    formatex(itemText, 127, "\wServer Record")
    menu_additem( menu, itemText, "", 0 );
    
    
    menu_setprop( menu, MPROP_EXIT, MEXIT_ALL );
    menu_display( id, menu, 0 );

    return PLUGIN_CONTINUE;
}

public choosemenu_handler( id, menu, item ){
    if ( item == MENU_EXIT ){
        menu_destroy( menu );
        return PLUGIN_HANDLED;
    }
    currentType[id] = item;
    switch(item){
        case 0:
            RecordsMenu(id);
        case 1:
            RecordsMenu(id);
    }
    return PLUGIN_HANDLED;
}

public RecordsMenu(id){

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

public menu_handler( id, menu, item ){
    if ( item == MENU_EXIT ){
        menu_destroy( menu );
        return PLUGIN_HANDLED;
    }
    
    if(inventory_get_item(id, g_Sounds[item][iItemID])){
        formatex(currentSound[id][currentType[id]], 127, "%s", g_Sounds[item][szPath]);
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
    formatex(name, charsmax(name), "%sLocal", name);
    nvault_set( g_iVault , name , currentSound[id][szLocal]);
    formatex(name, charsmax(name), "%sWR", name);
    nvault_set( g_iVault , name , currentSound[id][szSR]);

    return PLUGIN_CONTINUE;
}
//loads the current sound
public Load(id){
    new name[64];

    get_user_name( id , name , charsmax( name ) );

    formatex(name, charsmax(name), "%sLocal", name);
    nvault_get( g_iVault , name , currentSound[id][szLocal] , 127 );
    formatex(name, charsmax(name), "%sWR", name);
    nvault_get( g_iVault , name , currentSound[id][szSR] , 127 );

    return PLUGIN_CONTINUE;
}

stock PlaySound(id){
    // Emit sound should not work if you precache sounds with precache_generic
    //emit_sound(0, CHAN_AUTO, currentSound[id], 0.5, ATTN_NORM, 0, PITCH_NORM);
    play_sound(0, currentSound[id][currentType[id]]);
}

public PlaySoundRandom(){
    new rNum = random_num(1, SOUNDS_NUM - 1);
    // Emit sound should not work if you precache sounds with precache_generic
    //emit_sound(0, CHAN_AUTO, g_Sounds[rNum][szPath], 1.0, ATTN_NORM, 0, PITCH_NORM);
    play_sound(0, g_Sounds[rNum][szPath]);
    //Play Random Christmas Song
    //play_sound(0, g_ChristmasSounds[rNum][szPath]);
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