#include <amxmodx>
#include <amxmisc>

new Invited[33] = -1

// CMDS
public CmdClanCreate(id, ClanName[65])
{
    if(CreateClan[id] == 0)
    {
        chat_color(id,"!y[!gCLAN!y]!g Nu ai posibilitatea de creere a unui !teamclan!")
        return PLUGIN_HANDLED
    }
    if(strcmp(ClanID[id],"") != 0)
    {
        chat_color(id,"!y[!gCLAN!y]!g Nu ai posibilitatea de creare a unui !teamclan!")
        return PLUGIN_HANDLED
    }
    new path[256], sData[128]
    format(path,255,"%s%s.txt",gPathClan,ClanName)
    if(file_exists(path) == 1)
    {
        chat_color(id,"!y[!gCLAN!y]!g Acest !teamClan !gexista deja!")
        return PLUGIN_HANDLED
    }
    new Name[33]
    get_user_name(id,Name,32)
    format(sData,127,"CLANN:%s",ClanName)
    write_file(path,sData,0)
    format(sData,127,"LEADER:%s",Name)
    write_file(path,sData,-1)
    CreateClan[id] = 0
    chat_color(id,"!y[!gCLAN!y]!g Ai creat clanul !team%s !gcu succes!",ClanName)
    chat_color(0,"!y[!gCLAN!y]!g Jucatorul !team%s !ga infintat clanul cu numele !team%s",Name, ClanName)
    format(path,255,"%s%s.txt",gPathMaster,Name)
    format(sData,127,"CLANID:%s",ClanName)
    write_file(path,sData,5)
    write_file(path,"CREATEC:0",6)
    return PLUGIN_HANDLED
}
public ClanInvite(id,invitedid)
{
    CheckIfLeader(id)
    if(ClanLeader[id] == 0)
    {
        chat_color(id,"!y[!gCLAN!y]!g Nu esti un lider!")
        return PLUGIN_HANDLED
    }
    new sData[65]
    format(sData,64,"%s",ClanID[invitedid])
    if(sData[0])
    {
        chat_color(id,"!y[!gCLAN!y]!g Acest jucator este deja membrul unui clan!")
        return PLUGIN_HANDLED
    }
    new Title[128]
    format(Title,127,"AI FOST INIVITAT IN CLANUL %s", ClanID[id])
    Invited[invitedid] = id
    new IMenu = menu_create(Title,"InviteMenu")
    menu_additem(IMenu,"DA / YES", "", 0)
    menu_additem(IMenu,"Nu / NO","", 0)
    menu_setprop(IMenu, MPROP_EXIT, MEXIT_ALL );
	menu_display(invitedid, IMenu, 0 ); 
    return PLUGIN_HANDLED
}
// MENUS
public InviteMenu(id, IMenu, item)
{
    new Name[33]
    get_user_name(id, Name, charsmax(Name))
    switch(item)
    {
        case MENU_EXIT:
        {
            chat_color(0,"!y[!gCLAN!y]!g Jucatorul !team%s !ga ales sa nu adere la !team%s!",Name,ClanID[Invited[id]])
        }
        case 0:
        {
            chat_color(0,"!y[!gCLAN!y]!g Jucatorul !team%s !ga ales sa adere la !team%s!",Name,ClanID[Invited[id]])
            new path[256], sData[128]
            format(path,255,"%s%s.txt",gPathClan,ClanID[Invited[id]])
            format(sData,127,"MEMBER:%s",Name)
            write_file(path,sData,-1)
            format(path,127,"%s%s.txt",gPathMaster,Name)
            format(sData,127,"CLANID:%s",ClanID[Invited[id]])
            write_file(path,sData,5)
        }
        case 1:
        {
             chat_color(0,"!y[!gCLAN!y]!g Jucatorul !team%s !ga ales sa nu adere la !team%s!",Name,ClanID[Invited[id]])
        }
    }
    menu_destroy(IMenu)
    return PLUGIN_HANDLED
}
// HELP
public CmdClanHelp(id)
{
    chat_color(id,"!teamToate datele importante despre clanuri au fost scrise in consola ta!")
    chat_color(id,"!teamDeschide !gCONSOLA!")
    console_print(id,"========== CLAN SYSTEM ==========")
    console_print(id,">>> 1. Un chat special (/c)")
    console_print(id,">>> 2. War-uri pentru diferite harti")
    console_print(id,">>> 3. Seif cu credite")
    console_print(id,">>> 4. Mai multe chestii vor urma!")
    console_print(id,"========== CLAN SYSTEM ==========")
}
public CmdClanCreateHelp(id)
{
    chat_color(id,"!y[!gCLAN!y]!g Toate datele importante despre crearea clanurilor au fost scrise in consola ta!")
    chat_color(id,"!y[!gCLAN!y]!g Deschide !gCONSOLA!")
    console_print(id,"========== CLAN SYSTEM ==========")
    console_print(id,">>> 1. Cumpara un clan din /shop!")
    console_print(id,">>> 2. Foloseste comanda /createclan")
    console_print(id,">>> 3. Inainte de a da ^"ENTER^" comenzii /createclan scrie numele clanului")
    console_print(id,">>> 4. Exemplu: /createclan TUDOR")
    console_print(id,"========== CLAN SYSTEM ==========")
}

// LOADING
public CheckIfLeader(id)
{
    new Name[33]
    get_user_name(id, Name, 32)
    new path[256]
    format(path,255,"%s%s.txt",gPathClan,ClanID[id])
    log_to_file("CLANDEBUG.txt","Nume: %s || ClanID: %s",Name, ClanID[id])
    if(file_exists(path) == 0)
    {
        ClanLeader[id] = 0
    }
    new f = fopen(path,"r")
    new szLine[128]
    while(!feof(f))
    {
        fgets(f,szLine,charsmax(szLine))
        if(contain(szLine,"LEADER:") >-1)
        {
            replace_all(szLine,127,"LEADER:","")
            trim(szLine)
            remove_quotes(szLine)
            if(strcmp(Name,szLine) == 0)
            {
                ClanLeader[id] = 1
                chat_color(id,"!y[!gCLAN!y]!g Esti liderul clanului !team%s!g!",ClanID[id])
            }
        }
    }
    return PLUGIN_HANDLED
}