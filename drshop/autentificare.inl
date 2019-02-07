#include <amxmodx>
#include <amxmisc>

new gPassword[33][65]
new gHasUserPass[33]
new gLoggedin[33]

public CheckPassword(id)
{
    trim(gPassword[id])
    if(!gPassword[id][0])
    {
        gHasUserPass[id] = 0
    }
    else
    {
        gHasUserPass[id] = 1
    }
    if(gHasUserPass[id] == 0)
    {
        set_task(10.0,"MSGREGISTER",id)
    }
    else
    {
        set_task(10.0,"MSGLOGIN",id)
    }
}
stock LogInUser(id,givenpass[65])
{
    if(gLoggedin[id] == 0){
        new userid = get_user_userid(id)  
        trim(givenpass)
        trim(gPassword[id])
        if(strcmp(gPassword[id],givenpass,0) == 0)
        {
            new Name[33]
            get_user_name(id,Name,charsmax(Name))
            //chat_color(id,"!y[!gDR!y]!g Te-ai logat cu succes!")
            chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gs-a logat cu succes!",Name)
            gLoggedin[id] = 1
        }
        else{
            server_cmd("kick #%d parola incorecta!",userid)
        }
    }
    else{
        chat_color(id,"!y[!gDR!y]!g Esti deja logat!")
        return PLUGIN_CONTINUE
    }
    return PLUGIN_CONTINUE
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

public MSGREGISTER(id){
    chat_color(id,"!y[!gDR!y]!g Foloseste comanda !y[/reg parola] !gpentru a te inregistra!")
}

public MSGLOGIN(id){
    chat_color(id,"!y[!gDR!y]!g Foloseste comanda !y[/login parola] !gpentru a te loga!")
}
