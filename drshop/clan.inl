#include <amxmodx>
#include <amxmisc>


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