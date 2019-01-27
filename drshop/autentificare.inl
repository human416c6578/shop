#include <amxmodx>
#include <amxmisc>

new gPassword[33][65]
new gHasUserPass[33]
new gLoggedin[33]

public CheckPassword(id)
{
    if(gHasUserPass[id] == 0)
    {
        set_task(10.0,"MSGREGISTER",id)
    }
    else
    {
        new lPassword[65]
	    get_user_info(id,"DEATHRUNPASS",lPassword,64)
        LogInUser(id, lPassword)
    }
}
stock LogInUser(id,givenpass[65])
{
    new userid = get_user_userid(id)  
    if(strcmp(gPassword[id],givenpass) == 0)
    {
        chat_color(id,"!y[!gDR!y]!g Te-ai logat cu succes!")
        gLoggedin[id] = 1
    }
    else
    {
        server_cmd("kick #%d Incorrect Password!",userid)  
    }
}

stock RegisterUser(id, givenpass[65]){
    new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
	format(path,127,"addons/amxmodx/DRSHOP/%s.txt",Name)
    new sData[78]
    format(sData,77,"PAROLA:%s",givenpass)
    write_file(path,sData,4)
    gHasUserPass[id] = 1
    format(gPassword[id],32,"%s",givenpass)
    set_user_info(id,"_dr",gPassword[id])
    return PLUGIN_CONTINUE
}
public MSGREGISTER(id)
{
    chat_color(id,"!y[!gDR!y]!g Pentru o protectie sporita, recomand folosirea comenzi /reg")
}