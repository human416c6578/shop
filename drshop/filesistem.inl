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
public SaveData(id){
    if(is_user_bot(id))
    {
        return PLUGIN_HANDLED
    }
	new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
    format(path,127,"%s%s.txt",gPathMaster,Name)
    new sData[128]
    format(sData,127,"CREDITE:%d",Credite[id])
    write_file(path,sData,0)
    format(sData,127,"KNIFECURENT:%d",knife_model[id])
    write_file(path,sData,1)
    return PLUGIN_HANDLED
}
public LoadData(id){
    if(is_user_bot(id))
    {
        return PLUGIN_HANDLED
    }
	new Name[33]
    get_user_name(id,Name,charsmax(Name))
    new path[128]
    format(path,127,"%s%s.txt",gPathMaster,Name)
    if(!file_exists(path))
    {
      Credite[id] = 500000
      knife_model[id] = 3
      allowKnife[id] = 0
      write_file(path,"CREDITE:500000",0)
      write_file(path,"KNIFECURENT:0",1)
      write_file(path,"CUMPARATKNIFE:0",2)
      write_file(path,"TRAIL:0",3)
      write_file(path,"PAROLA:",4)
      SetKnife(id,3)
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
        }
        else if(contain(szLine,"KNIFECURENT:") >-1 )
        {
            replace_all(szLine,127,"KNIFECURENT:","")
            knife_model[id] = str_to_num(szLine)
            SetKnife(id,knife_model[id])
        }
        else if(contain(szLine,"CUMPARATKNIFE:") >-1 )
        {
            replace_all(szLine,127,"CUMPARATKNIFE:","")
            allowKnife[id] = str_to_num(szLine)
        }
        else if(contain(szLine,"PAROLA:") >-1 )
        {
            replace_all(szLine,127,"PAROLA:","")
            
        }
    }
    if(Credite[id] == 0)
    {
        Credite[id] = 500000
    }
    fclose(f)
    return PLUGIN_HANDLED
}