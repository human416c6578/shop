#include <amxmodx>
#include <amxmisc>

new gPassword[33][65]
new gHasUserPass[33]

public CheckPassword(id)
{
    if(gHasUserPass[id] == 0)
    {
        return PLUGIN_HANDLED
    }
}
stock LogInUser(id,givenpass)
{
    
}