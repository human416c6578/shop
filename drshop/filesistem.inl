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
	new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
    format(path,127,"%s%s.txt",gPathMaster,Name)
    new sData[128]
    format(sData,127,"CREDITE:%d",Credite[id])
    write_file(path,sData,1)
}
public LoadCredite(id){
	new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
    format(path,127,"%s%s.txt",gPathMaster,Name)
    if(!file_exists(path))
    {
      Credite[id] = 500000
      write_file(path,Name,2)
      write_file(path,"CREDITE:500000",1)
      return PLUGIN_HANDLED
    }
    new f = fopen(path,"r")
    new szLine[128]
    while(!feof(f))
    {
        fgets(f,szLine,charsmax(szLine))
        if(contain(szLine,"CREDITE:") >-1)
        {
            replace_all(szLine,127,"CREDITE:","")
            Credite[id] = str_to_num(szLine)
            break;
        }
    }
    return PLUGIN_HANDLED
}
// Save Knife // Load Knife
Public SaveKnife(id)
{
    new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
    format(path,127,"%s%s.txt",gPathMaster,Name)
    new sData[128]
    format(sData,127,"KNIFECURENT:%d",knife_model[id])
    write_file(path,)
}