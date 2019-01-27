#include <amxmodx>
#include <file>
#include <amxmisc>

// PATHS
new gPathMaster[32] = "addons/amxmodx/DRSHOP/"
// Check File
public CheckFiles()
{
    // Verificam path-ul master
    if(!dir_exists(gPathMaster))
    {
        mkdir(gPathMaster)
    }
}
// Save credite / Load credite
public SaveCredite(id){
	
}

public LoadCredite(id){
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	new vaultkey[64], vaultdata[64]
	format(vaultkey, 63, "%s", Name)
	format(vaultdata,63, "%s", GetCredits(vaultkey))
	Credite[id] = str_to_num(vaultdata)
	log_to_file(LOADLOG,"DATE : %d Am incarcat %s credite pentru %s", get_systime(0), vaultdata, vaultkey );
}