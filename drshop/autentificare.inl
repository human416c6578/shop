#include <amxmodx>
#include <amxmisc>

new gPassword[33][65]
new gHasUserPass[33]

public CheckPassword(id, givenpass)
{
    gPassword[id] = GetUserPassword(id)

    if(gHasUserPass[id] == 0)
    {
        RegisterUser()
        return PLUGIN_HANDLED
    }
    else
        LogInUser(id, givenpass)
}
stock LogInUser(id,givenpass)
{
    new userid = get_user_userid(id)  
    if(gPassword == givenpass)
        //ok
    else
        server_cmd("kick #%d Incorrect Password!",userid)  
}

stock RegisterUser(id, givenpass){
    
}

GetUserPassword(id){
    new data[64]
    
    
    
    return data
}