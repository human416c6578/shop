#include <amxmodx>
#include <file>
#include <amxmisc>

// PATHS
new gPathMaster[32] = "addons/amxmodx/DRSHOP/"
new gPathCredite[32] = "addons/amxmodx/DRSHOP/Credite/"
new gPathTrail[32] = "addons/amxmodx/DRSHOP/Trail/"
new gPathKnife[32] = "addons/amxmodx/DRSHOP/Knife/"
// Check File
public CheckFiles()
{
    // Verificam path-ul master
    if(!dir_exists(gPathMaster))
    {
        mkdir(gPathMaster)
    }
    // acum verificam toate path-urile
    if(!dir_exists(gPathCredite))
    {
        mkdir(gPathCredite)
    }
    if(!dir_exists(gPathTrail))
    {
        mkdir(gPathTrail)
    }
    if(!dir_exists(gPathKnife))
    {
        mkdir(gPathKnife)
    }
}
// Save credite / Load credite
public Save(id){
	new Name[33]
	get_user_name(id,Name, charsmax(Name))
	new vaultkey[64], vaultdata[64]
	format(vaultkey, 63, "^"%s^"", Name)
	format(vaultdata,63, "%d", Credite[id])
	
	log_to_file(SVLOG,"DATE : %d Am salvat %s credite pentru %s", get_systime(0), vaultdata, vaultkey );
}

public Load(id){
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	new vaultkey[64], vaultdata[64]
	format(vaultkey, 63, "%s", Name)
	format(vaultdata,63, "%s", GetCredits(vaultkey))
	Credite[id] = str_to_num(vaultdata)
	log_to_file(LOADLOG,"DATE : %d Am incarcat %s credite pentru %s", get_systime(0), vaultdata, vaultkey );
}