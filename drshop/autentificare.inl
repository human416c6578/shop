#include <amxmodx>
#include <amxmisc>

new gPassword[33][65]
new gHasUserPass[33]
new gLoggedin[33]

public CheckPassword(id)
{
    new data[65]
    if(strcmp(gPassword[id],"",1) == 0)
    {
        gHasUserPass[id] = 0
    }
    else{
        gHasUserPass[id] = 1
    }
    if(gHasUserPass[id] == 0)
    {
        if(!is_user_admin(id))
            set_task(10.0,"MSGREGISTER",id)
    }
    else
    {
        get_user_info(id, "_dr", data, 64)
        trim(data)
        remove_quotes(data)
        if (!data[0]){
            set_task(3.0,"MSGLOGIN",id)
            set_task(15.0,"kick",id)
        }
        else
            LogInUser(id, data)
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
            chat_color(id,"!y[!gDR!y]!g Te-ai logat cu succes!")
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

public kick(id){
    if(gLoggedin[id] == 1){
       return PLUGIN_CONTINUE
    }
    else{
        new userid = get_user_userid(id) 
	    server_cmd("kick #%d Nu esti logat!",userid)
    }
    return PLUGIN_CONTINUE
}