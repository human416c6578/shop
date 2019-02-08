#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <nvault>
#include <fun>
#include <hamsandwich>
#include <fakemeta>
#include <engine>
#include <dhudmessage>

//#include "drshop/db.inl"

#pragma tabsize 0

#define PLUGIN "LLG SHOP SYSTEM"
#define VERSION "Final 1.0"
#define AUTHOR "ATudor | MrShark45"
#define TASKID        	1000
#define TASKID2		2000
#define TASKID3		3000
#define TASKID4		4000
#define TASKID5		5000
#define TASKID6		6000
#define TASKID7		7000
#define TASKID8		8000
#define ACCES_FLAG  ADMIN_RESERVATION
#define MAXPLAYERS 32
#define TASK_INTERVAL 4.0
#define MAX_HEALTH 255
#define m_pLastItem 375
#define m_pLastKnifeItem 370
#define NRBW 	18
#define NRSW	7
//#define UpdateInViitor
//#define DEBUGSHOP "SHOP"
#define ST
//#define TestBB
//#define SBDEBUG

// Mesaje
new CurrentMSG = 0

// SB
new SBNR[33]
new SBBET[33]
new SBPlayed[33]
new SBDisconnectIP[33][32]
new SBDisconnectPlayed[33] = 0
// IDK
new GTotal = 0
new AllowGamble = 1
new GMin = 0
// GAMBLE
new Gamble[33]
new GambleNR = 0
new isGamble[33]
new isExtraction = 0
new idExtraction[33]
// GLOBAL //
new HealthBought[33] = 0
new BigGunsId[NRBW][] =
{
	"weapon_scout",
	"weapon_xm1014",
	"weapon_mac10",
	"weapon_aug",
	"weapon_ump45",
	"weapon_sg550",
	"weapon_galil",
	"weapon_famas",
	"weapon_awp",
	"weapon_mp5navy",
	"weapon_m249",
	"weapon_m4a1",
	"weapon_m3",
	"weapon_tmp",
	"weapon_g3sg1",
	"weapon_sg552",
	"weapon_ak47",
	"weapon_p90"
}
new BigGunsAmmo[NRBW][] =
{
	"ammo_762nato",
	"ammo_buckshot",
	"ammo_45acp",
	"ammo_556nato",
	"ammo_45acp",
	"ammo_556nato",
	"ammo_556nato",
	"ammo_556nato",
	"ammo_338magnum",
	"ammo_9mm",
	"ammo_556natobox",
	"ammo_556nato",
	"ammo_buckshot",
	"ammo_9mm",
	"ammo_762nato",
	"ammo_556nato",
	"ammo_762nato",
	"ammo_57mm"
}
new SmallGunsId[NRSW][] =
{
	"weapon_p228",
	"weapon_fiveseven",
	"weapon_elite",
	"weapon_deagle",
	"weapon_glock18",
	"weapon_usp",
	"nothing"
}
new SmallGunsAmmo[NRSW][] =
{
	"ammo_357sig",
	"ammo_57mm",
	"ammo_9mm",
	"ammo_50ae",
	"ammo_9mm",
	"ammo_45acp",
	"nothing"
}

new Countdown = 6
new IsCountDown = 0
new GiveArg = 0
new SVFile[64]
new SVLOG[64]
new LOADLOG[64]
new Credite[33] = 0
new Weapon[33] = 0
new Survival[33] = 0
new Invizibilitate[33] = 0
new reducerex
new MBPlayed[33] = 0
new MBPlayedD[33] = 0
new MBPlayedND[33][32]
// TRANSFER
new TransferAllow[33] = 0
new TransferCool[33] = 0
new DisconnectIP[33][32]
new DisconnectCool[33] = 0
// Knife
new g_Menu
new CVAR_HEALTH_ADD
new CVAR_HEALTH_MAX
new CVAR_DAMAGE 
// Custom Include
#include "drshop/inventar.inl"
#include "drshop/knife.inl"
#include "drshop/autentificare.inl"
#include "drshop/filesistem.inl"
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	// DB
	CheckFiles()
	// ADMIN CMD 
	register_concmd("amx_give","GiveCredite",ADMIN_LEVEL_G,"-Da credite") // <jucator> <credite>
	register_concmd("amx_setcredite","SetCredite",ADMIN_LEVEL_G,"-Seteaza credite") // Jucator credite
	register_concmd("amx_allcool","CmdCool")
	register_concmd("aminventarma","CmdAInventar")
	register_concmd("amx_delete_inventar","CmdDeleteInventar",ADMIN_LEVEL_G,"-Stergi inventarul cuiva")
	// USER CMD
	register_clcmd("say /credits", "ShowCredite")
	register_clcmd("say /drshop", "Shop")
	register_clcmd("say /shop", "Shop")
	register_clcmd("say /allcredits","ShowAll")
	register_clcmd("say /inventar","CmdInventar")
	register_clcmd("say /skin","CmdSetSkin")
	register_clcmd("say /testsound","CmdTestSound")
	register_clcmd("say /sound","CmdSetSound")
	register_clcmd("say","TalkEvent")
	register_clcmd("say /glow","CmdGlow")
	// EVENT 
	register_event("DeathMsg", "KillEvent", "a")
	RegisterHam(Ham_Spawn, "player", "SpawnEvent", 1)  
	register_forward( FM_CmdStart, "forward_cmdstart" );
	register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged") 
	register_event("CurWeapon","EventCurWeapon","be","1=1") 
	register_event( "Damage", "event_damage", "be" )
	// CVARS
	reducerex = register_cvar("shop_reducere_x", "1.0")
	// OTHER
	format(SVFile,63,"Credite.txt")
	format(SVLOG,63,"SAVE.log")
	if(!dir_exists("addons/amxmodx/logs/SHOP/"))
	{
		mkdir("addons/amxmodx/logs/SHOP/")
	}
	format(LOADLOG,63,"addons/amxmodx/logs/SHOP/LOAD.log")
	IVault = nvault_open("INVENTARYDB")
	set_task(30.0,"MesajeID",0,_,_,"b")
	// KNIFE
	g_Menu = register_menuid("Knife Mod")
	register_menucmd(g_Menu, 1023, "knifemenu")
	register_clcmd("say /knife", "display_knife")
	CVAR_HEALTH_ADD = register_cvar("km_addhealth", "3")
	CVAR_HEALTH_MAX = register_cvar("km_maxhealth", "75")
	CVAR_DAMAGE = register_cvar("km_damage", "2")
	set_task(480.0, "kmodmsg", 0, _, _, "b")
}
public client_disconnect(id)
{
	if(is_user_bot(id))
	{
		return PLUGIN_HANDLED
	}
	if(HasSound[id] == 1)
	{
		new iPlayer[32],iNum
		get_players(iPlayer,iNum)
		for(new i = 0; i <= iNum; i++)
		{
			if(gAllowSound[iPlayer[i]] == 1)
			{
				PlaySound(iPlayer[i],id)
			}
		}
		
	}
	gHasUserPass[id] = 0
	gLoggedin[id] = 0
	gPassword[id] = ""
	gAllowSound[id] = 1
	new ip[33]
	get_user_ip(id,ip,32,1)
	new Name[33]
	get_user_name(id, Name, 32)
	SaveData(id)
	SaveInventar(id)
	log_to_file("LogSave.txt","Am salvat %d credite pentru %s [%s]", Credite[id], Name, ip)
	removetasks(id)
	remove_task(id)
	if(TransferCool[id] > 0)
	{
		for(new i = 1; i <= 32; i++)
		{
			if(strcmp(DisconnectIP[i],"NOTHING"))
			{
				format(DisconnectIP[i],31,"%s",ip)
				DisconnectCool[i] = TransferCool[id]
				i = 33
			}
		}
	}
	if(MBPlayed[id] == 2)
	{
		for(new i = 1; i <= 32; i++)
		{
			if(strcmp(MBPlayedND[i],"NOTHING"))
			{
				format(MBPlayedND[i],31,"%s",ip)
				MBPlayedD[i] = MBPlayed[id]
				i = 33
			}
		}
	}
	if(SBPlayed[id] > 0)
	{
		for(new i = 1; i <= 32; i++)
		{
			if(strcmp(SBDisconnectIP[i],"NOTHING"))
			{
				format(SBDisconnectIP[i],31,"%s",ip)
				SBDisconnectPlayed[i] = SBPlayed[id]
				i = 33
			}
		}
	}
	SBBET[id] = 0
	SBNR[id] = 0
	SBPlayed[id] = 0
	MBPlayed[id] = 0
	TransferAllow[id] = 0
	TransferCool[id] = 0
	
	return PLUGIN_CONTINUE
}
public plugin_end()
{
	new Name[33]
	new players[32],inum
	get_players(players,inum)
	for(new i = 0; i <= inum; i++)
	{
		if(!is_user_bot(players[i]))
		{
			get_user_name(players[i],Name,32)
			SaveData(players[i])
			SaveInventar(players[i])
			removetasks(players[i])
		}
		
	}
	nvault_close(IVault)
}
public client_putinserver(id)
{
	if(is_user_bot(id))
	{
		return PLUGIN_HANDLED
	}
	set_task(3.0,"MSGLOGIN",id)
	new Name[64]
	get_user_name(id, Name, charsmax(Name))
	LoadData(id)
	LoadInventar(id)
	gAllowSound[id] = 1
	set_task(300.0, "CrediteTask", id + TASKID2, _, _, "b")
	set_task(62.0, "TransferTask", id + TASKID)
	new ip[33]
	get_user_ip(id,ip,32,1)
	
	log_to_file("LogLoad.txt","Am incarcat %d credite pentru %s [%s]", Credite[id], Name, ip)
	for(new i = 0; i < 32; i++)
	{
		if(strcmp(ip,DisconnectIP[i]) == 0)
		{
			format(DisconnectIP[i],31,"NOTHING")
			TransferCool[id] = DisconnectCool[i]
			set_task(60.0,"RemoveCool",id + TASKID4,_,_,"b")
		}
		if(strcmp(ip,MBPlayedND[i]) == 0)
		{
			format(MBPlayedND[i],31,"NOTHING")
			MBPlayed[id] = MBPlayedD[i]
		}
		if(strcmp(ip,SBDisconnectIP[i]) == 0)
		{
			format(SBDisconnectIP[i],31,"NOTHING")
			SBPlayed[id] = SBDisconnectPlayed[i]
		}
	}
	
	return PLUGIN_CONTINUE
}
public plugin_precache() { 
	// KNIFE
	precache_model("models/knife-mod/v_butcher.mdl") 
	precache_model("models/knife-mod/p_butcher.mdl") 
	precache_model("models/knife-mod/v_machete.mdl")
	precache_model("models/knife-mod/p_machete.mdl")
	precache_model("models/knife-mod/v_bak.mdl")
	precache_model("models/knife-mod/p_bak.mdl")
	precache_model("models/knife-mod/v_pocket.mdl")
	precache_model("models/knife-mod/p_pocket.mdl")
	precache_model("models/v_knife.mdl") 
	precache_model("models/p_knife.mdl")
	precache_model("models/knife-mod/v_knifeadminV2.mdl")
	precache_model("models/knife-mod/v_super.mdl")
	precache_model("models/knife-mod/p_super.mdl")
	// Inventar
	precache_model("models/player/buzzlightyear/buzzlightyear.mdl")
	precache_model("models/player/Jill/Jill.mdl")
	precache_model("models/player/Trump/Trump.mdl")
	precache_model("models/player/Hitler/Hitler.mdl")
	precache_model("models/player/alice/alice.mdl")
	precache_model("models/player/Pepsiman/Pepsiman.mdl")
	precache_model("models/player/Flash/Flash.mdl")
	precache_model("models/player/Horsemask/Horsemask.mdl")
	precache_model("models/player/Sonic/Sonic.mdl")
	precache_model("models/player/DrunkSanta/DrunkSanta.mdl")
	precache_model("models/player/deadpool/deadpool.mdl")
	precache_model("models/player/subzero/subzero.mdl")
	precache_model("models/player/xiah/xiah.mdl")
	// INVENTAR SOUNDS
	for(new i = 0; i < SoundNR; i++)
	{
		precache_sound(SoundNamesID[i])
	}
} 
public SpawnEvent(id)
{
	set_task(3.0, "GiveItems", id)
	if(is_user_alive(id))
	{
		if(cs_get_user_team(id) == CS_TEAM_CT)
		{
			if(!is_user_bot(id))
			{
				if(HasModel[id] == 1)
				{
					cs_reset_user_model(id)
					cs_set_user_model(id,ModelID[id])
				}
			}
		}
	}
	//set_task(1.0,"UpdateStats",id + TASKID8)
	HealthBought[id] = 0
}

public KillEvent()
{
	new atacator = read_data(1)
	new victima = read_data(2)
	new hs = read_data(3)
	new Name[33]
	get_user_name(victima, Name, 32)
	if (hs == 1)
	{
		if (is_user_connected(atacator) && !is_user_bot(atacator))
		{
			if (cs_get_user_team(atacator) == CS_TEAM_CT)
			{
				if (!is_user_admin(victima))
				{
					Credite[atacator] += 800
					if (is_user_alive(atacator))
					{
						chat_color(atacator, "!y[!gDR!y]!g Ai primit !team800 !gcredite pentru uciderea lui !team%s!g!", Name)
						if(HasSound[atacator] == 1)
						{
							new iPlayer[32],iNum
							get_players(iPlayer,iNum)
							for(new i = 0; i <= iNum; i++)
							{
								if(gAllowSound[iPlayer[i]] == 1)
								{
									PlaySound(iPlayer[i],atacator)
								}
							}
						}
					}
				}
				else
				{
						Credite[atacator] += 1600
						if (is_user_alive(atacator))
						{
							chat_color(atacator, "!y[!gDR!y]!g Ai primit !team1600 !gcredite pentru uciderea lui !team%s!g!", Name)
							if(HasSound[atacator] == 1)
							{
								new iPlayer[32],iNum
								get_players(iPlayer,iNum)
								for(new i = 0; i <= iNum; i++)
								{
									if(gAllowSound[iPlayer[i]] == 1)
									{
										PlaySound(iPlayer[i],atacator)
									}
								}
							}
						}
				}
			}
			else if (cs_get_user_team(atacator) == CS_TEAM_T)
			{
					if (!is_user_admin(victima))
					{
						Credite[atacator] += 150
							if (is_user_alive(atacator))
							{
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team150 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
							
					}
					else
					{
						Credite[atacator] += 300
							if (is_user_alive(atacator))
							{
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team300 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
					}
				}
			}

		}
		else
		{
			if (is_user_connected(atacator) && !is_user_bot(atacator))
			{
				if (cs_get_user_team(atacator) == CS_TEAM_CT)
				{
					if (!is_user_admin(victima))
					{
						Credite[atacator] += 200
							if (is_user_alive(atacator))
							{
								if(HasSound[atacator] == 1)
								{
									new iPlayer[32],iNum
									get_players(iPlayer,iNum)
									for(new i = 0; i <= iNum; i++)
									{
										if(gAllowSound[iPlayer[i]] == 1)
										{
											PlaySound(iPlayer[i],atacator)
										}
									}
								}
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team200 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
					}
					else
					{
						Credite[atacator] += 400
							if (is_user_alive(atacator))
							{
								if(HasSound[atacator] == 1)
								{
									new iPlayer[32],iNum
									get_players(iPlayer,iNum)
									for(new i = 0; i <= iNum; i++)
									{
										if(gAllowSound[iPlayer[i]] == 1)
										{
											PlaySound(iPlayer[i],atacator)
										}
									}
								}
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team400 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
				}
				
			}
				else if (cs_get_user_team(atacator) == CS_TEAM_T)
				{
					if (!is_user_admin(victima))
					{
						Credite[atacator] += 50
							if (is_user_alive(atacator))
							{
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team50 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
					}
					else
					{
						Credite[atacator] += 100
							if (is_user_alive(atacator))
							{
								chat_color(atacator, "!y[!gDR!y]!g Ai primit !team100 !gcredite pentru uciderea lui !team%s!g!", Name)
							}
					}
				}
			}
		}
}
public ClientUserInfoChanged(id) 
{
	new newname[64],oldname[64]
	get_user_info(id, "name", newname,63)
	get_user_name(id,oldname,63)
	if(!is_user_connected(id) || is_user_bot(id))
	{
		return PLUGIN_CONTINUE
	}
	if(!equali(newname, oldname))
	{
		set_user_info(id,"name",oldname)
		chat_color(id,"!y[!gDR!y]!g Daca iti schimbi numele, iti poti pierde creditele!")
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE
}



// ADMIN CMDS //
public CmdCool(id)
{
	if(!is_user_admin(id))
	{
		return PLUGIN_HANDLED
	}
	new Name[33]
	new iPlayer[32],iNum
	get_players(iPlayer,iNum)
	for(new i = 0; i <= iNum; i++)
	{
		get_user_name(iPlayer[i],Name,charsmax(Name))
		console_print(id,"%s - %d",Name,TransferCool[iPlayer[i]])
	}
	return PLUGIN_CONTINUE
}
public SetCredite(id, level, cid)
{
	if(!cmd_access(id, level, cid,0))
	{
		console_print(id, "Nu ai acces la aceasta comanda!")
		return PLUGIN_CONTINUE
	}
	new Arg1[33]
	new Arg2[33]
	read_argv(1, Arg1, charsmax(Arg1))
	read_argv(2, Arg2, charsmax(Arg2))
	if(strcmp(Arg1,"@ALL") == 0)
	{
		new AName[33]
		get_user_name(id, AName, 32)
		new players[32],inum
		get_players(players,inum)
		new targ = str_to_num(Arg2)
		for(new i = 0; i <= inum; i++)
		{
			Credite[players[i]] = targ
		}
		chat_color(0, "!y[!gDR!y]!g Adminul !team%s !ga setat !teamtuturor !gcredite in valoare de !team%d", AName, targ)
		return PLUGIN_HANDLED
	}
	new tinta = cmd_target(id,Arg1,2)
	if(!tinta)
	{
		console_print(id,"Jucatorul nu e conectat!")
		return PLUGIN_CONTINUE
	}
	new targ = str_to_num(Arg2)
	Credite[tinta] = targ
	new AName[33], UName[33]
	get_user_name(id, AName, 32)
	get_user_name(tinta, UName, 32)
	chat_color(0, "!y[!gDR!y]!g Adminul !team%s !ga setat !team%d !gcredite pentru !team%s", AName, targ, UName)
	log_to_file(SVFile,"%s i-a setat lui %s: %d credite", AName, UName, targ)
	return PLUGIN_CONTINUE
}
public GiveCredite(id, level, cid)
{
	if(!cmd_access(id, level, cid,0))
	{
		console_print(id, "Nu ai acces la aceasta comanda!")
		return PLUGIN_CONTINUE
	}
	new Arg1[33]
	new Arg2[33]
	read_argv(1, Arg1, charsmax(Arg1))
	read_argv(2, Arg2, charsmax(Arg2))
	if(strcmp(Arg1,"@ALLGIVE") == 0)
	{
		new AName[33]
		get_user_name(id, AName, 32)
		new players[32],inum
		get_players(players,inum)
		new targ = str_to_num(Arg2)
		for(new i = 0; i <= inum; i++)
		{
			Credite[players[i]] += targ
			
		}
		chat_color(0, "!y[!gDR!y]!g Adminul !team%s !gle-a dat !teamtuturor !gcredite in valoare de !team%d", AName, targ)
	}
	else if(strcmp(Arg1,"@RANDOM") == 0)
	{
		if(IsCountDown == 0)
		{
			set_task(1.0,"StartCountDown",9594,_,_,"b")
			chat_color(0,"!y[!gDR!y]!g A inceput loteria pentru !teamCredite!g!")
			IsCountDown = 1
			GiveArg = str_to_num(Arg2)
		}
	}
	else
	{
		new tinta = cmd_target(id,Arg1,2)
		if(!tinta)
		{
			console_print(id,"Jucatorul nu e conectat!")
			return PLUGIN_CONTINUE
		}
		new targ = str_to_num(Arg2)
		Credite[tinta] += targ
		new AName[33], UName[33]
		get_user_name(id, AName, 32)
		get_user_name(tinta, UName, 32)
		if(tinta != id)
		{
			chat_color(0, "!y[!gDR!y]!g Adminul !team%s !gi-a dat lui !team%s !gcredite in valoare de !team%d", AName, UName, targ)
		}
		log_to_file(SVFile,"%s i-a dat lui %s: %d credite", AName, UName, targ)
		
	}
	return PLUGIN_CONTINUE
}
// CLIENT CMDS //

public ShowCredite(id)
{
	if(gLoggedin[id] == 0 && !is_user_admin(id))
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
		return PLUGIN_HANDLED
	}
	chat_color(id,"!y[!gDR!y]!g Ai !team%d !gcredite!", Credite[id])
	return PLUGIN_HANDLED
}
public Shop(id)
{
	if(gLoggedin[id] == 0 && !is_user_admin(id))
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
		return PLUGIN_HANDLED
	}
	#if defined DEBUGSHOP
		if(!is_user_admin(id)) 
		{
			chat_color(id,"!y[!gSHOP!y]!team Shop-ul !geste in mentenanta momentan. Intreaba un owner pentru a afla motivele.")
			return PLUGIN_HANDLED
		}
	#endif
	new title[128]
	format(title,127,"DR LLG SHOP [%d CREDITS]",Credite[id])
	new Menu = menu_create(title,"SMenu")
	new itemText[128]
	#if defined TestBB
		format(itemText,127,"Big Box [Skins / Sounds] - Gratis")
	#else
		format(itemText,127,"Big Box [Skins / Sounds] - 600000 Credite")
	#endif
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Mistery Box [0-75k credite] - %d Credite",8000)
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"M4A1 + 90 Gloante si Deagle + 16 Gloante - %d Credite [1 Runda]",40000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"255 HP - %d Credite [1 Runda]",100000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"M4A1 + 90 Gloante si Deagle + 16 Gloante - %d Credite",200000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"50% Invizibilitate - %d Credite",500000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Arme Random + Munitie - %d Credite [1 Runda]",500000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Pachet supravietuitor - %d Credite",700000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Knife Special - %d Credite [Permanent] ",1000000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Trail - %d Credite [Permanent] ",1000000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	format(itemText,127,"Tag Personalizat - %d Credite [Permanent] ",5000000 / get_pcvar_num(reducerex))
	menu_additem(Menu,itemText,"",0)
	menu_setprop( Menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, Menu, 0 ); 
	return PLUGIN_CONTINUE
}
public SMenu(id, Menu, item)
{
	new Name[33]
	new vaultKey[64]
	get_user_name(id, Name, charsmax(Name))
	switch(item)
	{
		case 0:
		{
			if(Credite[id] >= 6000000)
			{
				#if defined TestBB
				chat_color(id,"!y[!gSHOP!y]!g Ai posibilitatea de a incerca !team'BIG BOX'!")
				#else
					Credite[id] -= 6000000 / get_pcvar_num(reducerex)
				#endif
				new nr1 = random_num(0,100)
				if(nr1 >= 0 && nr1 <= 50)
				{
					new nr2 = random_num(0,SoundNR - 1)
					if(SoundID[id][nr2] == 1)
					{
						chat_color(id,"!y[!gDR!y]!g Ai deja acest sunet, vei primii creditele inapoi!")
						#if defined TestBB
							chat_color(id,"!y[!gDR!y]!g Dar, din pacate, aceasta este doar versiunea de test.!")
						#else
							Credite[id] += 6000000
						#endif
					}
					else
					{
						chat_color(id,"!y[!gBIG BOX!y]!g Ai castigat sunetul: !team%s !gFELICITARI!",SoundNames[nr2])
						#if defined TestBB
							chat_color(id,"!y[!gDR!y]!g Dar din pacate este versiunea de testare!")
						#else
							chat_color(0,"!y[!gBIG BOX!y]!g Jucatorul !team%s !ga castigat Sunetul: !team%s !g!",Name,SoundNames[nr2])
							SoundID[id][nr2] = 1
						#endif
					}
				}
				else if(nr1 >= 46 && nr1 <= 100)
				{
					new nr2 = random_num(0,SkinNR - 1)
					if(SkinID[id][nr2] == 1)
					{
						chat_color(id,"!y[!gDR!y]!g Ai deja acest skin, vei primii creditele inapoi!")
						#if defined TestBB
							chat_color(id,"!y[!gDR!y]!g Dar, din pacate, aceasta este doar versiunea de test.!")
						#else
							Credite[id] += 600000
						#endif
					}
					else
					{
						chat_color(id,"!y[!gBIG BOX!y]!g Ai castigat skin-ul: !team%s !gFELICITARI!",SkinNames[nr2])
						#if defined TestBB
							chat_color(id,"!y[!gDR!y]!g Dar din pacate este versiunea de testare!")
						#else
							chat_color(0,"!y[!gBIG BOX!y]!g Jucatorul !team%s !ga castigat SKIN-UL: !team%s !g!",Name,SkinNames[nr2])
							SkinID[id][nr2] = 1
						#endif
					}
				}
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
			
		}
		case 1:
		{
			if(Credite[id] >= 8000)
			{
				if(MBPlayed[id] < 2)
				{
					Credite[id] -= 8000
					MBPlayed[id] += 1
					new xCredite = Credite[id]
					new Nr1 = random_num(0,100)
					new nr2
					if(Nr1 <= 5)
					{
						nr2 = random_num(50000,75000)
						Credite[id] += nr2
						if(HasSound[id] == 1)
						{
							new iPlayer[32],iNum
							get_players(iPlayer,iNum)
							for(new i = 0; i <= iNum; i++)
							{
								if(gAllowSound[iPlayer[i]] == 1)
								{
									//client_cmd( iPlayer[i], "spk ^"%s^"", HSoundID[id] );
									PlaySound(iPlayer[i],id)
								}
							}
						}
					}
					else if(Nr1 >= 6 && Nr1 <= 15)
					{
						nr2 = random_num(25000,50000)
						Credite[id] += nr2
					}
					else if(Nr1 >= 16 && Nr1 <= 30)
					{
						nr2 = random_num(10000,24000)
						Credite[id] += nr2
					}
					else if(Nr1 >= 31 && Nr1 <= 50)
					{
						nr2 = random_num(1000,9000)
						Credite[id] += nr2
					}
					else if(Nr1 >= 51 && Nr1 <= 70)
					{
						nr2 = random_num(100,1000)
						Credite[id] += nr2
					}
					else
					{
						nr2 = random_num(5,100)
						Credite[id] += nr2
					}
					log_to_file("MisteryBox.txt","Jucatorul %s a scos %d credite din mistery box [Credite Inainte %d] [Credite Dupa %d]",Name,nr2,xCredite,Credite[id])
					chat_color(0,"!y[!gSHOP!y]!g Jucatorul !team%s !ga castigat !team%d !gcredite la !teamMistery Box!g!",Name,nr2)
				}
				else
				{
					chat_color(id,"!y[!gDR!y]!g Nu mai poti juca !teamMistery Box !gpe aceasta harta!")
				}
				
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 2:
		{
			if(Credite[id] >= 40000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 40000 / get_pcvar_num(reducerex)
				give_item(id,"ammo_50ae")
				give_item(id,"ammo_50ae")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_m4a1")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				//chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gsi-a cumparat pachetul de arme pentru o runda!", Name)
				chat_color(id,"!y[!gDR!y]!g Ti-ai cumparat !teamPachetul de arme pentru o runda!g!")
				menu_destroy( Menu );
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}	
		}
		case 3:
		{
			if(Credite[id] >= 100000 / get_pcvar_num(reducerex))
			{
				if(HealthBought[id] == 1)
				{
					chat_color(id,"!y[!gDR!y]!g Deja ai cumparat viata in aceasta runda!")
					return PLUGIN_HANDLED
				}
				Credite[id] -= 100000 / get_pcvar_num(reducerex)
				chat_color(id,"!y[!gDR!y]!g Ti-ai cumparat !team255 HP!g!")
				if(get_user_health(id) <= 255)
				{
					set_user_health(id,255)
				}
				else
				{
					chat_color(id,"!y[!gDR!y]!g Maximul de HP pe care poti sa il ai este de !team255!g!")
				}
				HealthBought[id] = 1
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 4:
		{
			if(Credite[id] >= 200000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 200000 / get_pcvar_num(reducerex)
				give_item(id,"ammo_50ae")
				give_item(id,"ammo_50ae")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_m4a1")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gsi-a cumparat pachetul de arme!", Name)
				Weapon[id] = 1
				menu_destroy( Menu );
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 5:
		{
			if(Credite[id] >= 500000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 500000 / get_pcvar_num(reducerex)
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !ga cumparat !team50 !gla suta !teaminvizibilitate!g!",Name)
				set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderTransAlpha,100)
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}	
		}
		case 6:
		{
			if(Credite[id] >= 500000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 500000  / get_pcvar_num(reducerex)
				new nr = random_num(0,NRBW - 2)
				new nr2 = random_num(0,NRSW - 2)
				give_item(id,BigGunsId[nr])
				give_item(id,BigGunsAmmo[nr])
				give_item(id,BigGunsAmmo[nr])
				give_item(id,SmallGunsId[nr2])
				give_item(id,SmallGunsAmmo[nr2])
				give_item(id,SmallGunsAmmo[nr2])
				//chat_color(0,"!y[!gSHOP!y]!g Jucatorul !team%s !ga primit !team%s !gsi !team%s",Name, BigGunsName[nr], SmallGunsName[nr])
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 7:
		{
			
			if(Credite[id] >= 700000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 700000 / get_pcvar_num(reducerex)
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gsi-a cumparat !teampachetul de supravietuitor!g!",Name)
				set_user_health(id,255)
				cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM)
				give_item(id,"ammo_50ae")
				give_item(id,"ammo_50ae")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_m4a1")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				give_item(id,"ammo_556nato")
				Survival[id] = 1
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 8:
		{
			if(Credite[id] >= 1000000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 1000000 / get_pcvar_num(reducerex)
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gsi-a cumparat !teamKnife Special!", Name)
				SetKnife(id,4)
				allowKnife[id] = 1
				new path[128]
				format(path,127,"addons/amxmodx/DRSHOP/%s.txt",Name)
				write_file(path,"CUMPARATKNIFE:1",2)
				log_to_file(SVFile,"%s si-a cumparat KNIFE Special", Name)
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		
		
		case 9:
		{
			if(Credite[id] >= 1000000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 1000000 / get_pcvar_num(reducerex)
				
				
				format(vaultKey, 63, "%s", Name)
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !gsi-a cumparat !teamTrail Permanent!", Name)
				chat_color(id,"!y[!gSHOP!y]!g Reintra pe server pentru a-ti putea activa trail-ul!")
				new path[128]
				format(path,127,"addons/amxmodx/DRSHOP/%s.txt",Name)
				write_file(path,"TRAIL:1",4)
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
		case 10:
		{
			if(Credite[id] >= 5000000 / get_pcvar_num(reducerex))
			{
				Credite[id] -= 5000000 / get_pcvar_num(reducerex)
				new Name[33],idv
				idv = random_num(0,10000)
				get_user_name(id, Name, charsmax(Name))
				chat_color(0,"!y[!gDR!y] !gJucatorul !team%s !gsi-a cumparat un nou !teamtag!g!",Name)
				chat_color(id,"!y[!gDR!y] !gDepune o cerere pe forum pentru !teamTAG !gin care sa precizezi !teamTAG!y-!teamUL !gdorit!")
				chat_color(id,"!y[!gDR!y] !gSau anunta un !teamOWNER !gonline!")
				chat_color(id,"!y[!gDR!y] !gID VERIFICARE !team%d!g!",idv)
				log_to_file("TAGFILE","%s si-a cumparat TAG, [ID VERIFICARE %d]",Name,idv)
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Nu ai destule !teamcredite!g!")
			}
		}
	}
	return PLUGIN_HANDLED
}
public ShowAll(id)
{
	if(gLoggedin[id] == 0 && !is_user_admin(id))
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
		return PLUGIN_HANDLED
	}
	console_print(id,"================ CREDITE DR LLG ===============")
	new players[32],inum, Name[33]
	get_players(players,inum)
	for(new i = 0; i <= inum; i++)
	{
		if(!is_user_bot(players[i]) && is_user_connected(players[i]))
		{
			get_user_name(players[i],Name,charsmax(Name))
			console_print(id,"%s - %d Credite",Name,Credite[players[i]])
		}
	}
	console_print(id,"================ CREDITE DR LLG ===============")
	client_cmd(id,"toggleconsole")
	return PLUGIN_CONTINUE
}
public CmdTransfer(id,Tinta,Credits)
{
	if(gLoggedin[id] == 0)
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
		return PLUGIN_HANDLED
	}
	#if defined ST 
		chat_color(id,"!y[!gDR!y]!g Sistemul de !teamtransfer !geste in !teammentenanta!g!")
		return PLUGIN_HANDLED
	#endif
	if(TransferAllow[id] == 0)
	{
		chat_color(id,"!y[!gCREDITE!y]!g Nu poti sa transferi inca credite!")
		return PLUGIN_HANDLED
	}
	if(TransferCool[id] > 0)
	{
		chat_color(id,"!y[!gDR!y]!g Mai trebuie sa astepti !team%d !gminute!",TransferCool[id])
		return PLUGIN_HANDLED
	}
	if(Credits > 10000)
	{
		if(!is_user_admin(id))
		{
			Credits = 10000
		}
	}
	if(Credits <= 0)
	{
		return PLUGIN_HANDLED
	}
	if(!Tinta)
	{
		chat_color(id,"!y[!gCREDITE!y]!g Jucatorul !teamtinta !gnu este conectat!")
		return PLUGIN_HANDLED
	}
	if(id == Tinta)
	{
		chat_color(id,"!y[!gTRANSFER!y]!g Nu poti sa iti transferi tie insusi.")
		return PLUGIN_HANDLED
	}
	new Name[33], sName[33]
	get_user_name(id, sName,charsmax(sName))
	get_user_name(Tinta,Name,charsmax(Name))
	if(Credite[id] >= Credits)
	{
		Credite[Tinta] += Credits
		Credite[id] -= Credits
		chat_color(0,"!y[!gCREDITE!y] !gJucatorul !team%s !gi-a transferat lui !team%s !gun numar de !team%d !gcredite!",sName,Name,Credits)
		if(!is_user_admin(id))
		{
			TransferCool[id] = 3
			set_task(60.0,"RemoveCool",id + TASKID4,_,_,"b")
		}
		else if(get_user_flags(id) & ADMIN_LEVEL_A)
		{
			if(get_user_flags(id) & ADMIN_LEVEL_H)
			{
				TransferCool[id] = 0
			}
			else
			{
				TransferCool[id] = 2
				set_task(60.0,"RemoveCool",id + TASKID4,_,_,"b")
			}
		}
	}
	return PLUGIN_CONTINUE
}
public CmdGlow(id)
{
	if(gLoggedin[id] == 0)
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
		return PLUGIN_HANDLED
	}
	if(get_user_flags(id) & ADMIN_LEVEL_H)
	{
		if(!is_user_alive(id))
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti !teamviu!")
			return PLUGIN_HANDLED
		}
		if(!is_user_connected(id))
		{
			return PLUGIN_HANDLED
		}
		new GlowMenu = menu_create("LALEAGANE GLOW","GlowMenuChoice")
      
		//Albastru^n 7.  Alb^n 8.  Random^n^n 9.  Opreste glow-ul^n^n 0.  Exit.") 
		menu_additem(GlowMenu,"Opreste glow-ul [TURN OFF]")
		menu_additem(GlowMenu,"Rosu [RED]")
		menu_additem(GlowMenu,"Portocaliu [ORANGE]")
		menu_additem(GlowMenu,"Galben [YELLOW]")
		menu_additem(GlowMenu,"Verde [GREEN]")
		menu_additem(GlowMenu,"Roz [PINK]")
		menu_additem(GlowMenu,"Albastru [BLUE]")
		menu_additem(GlowMenu,"Alb [WHITE]")
		menu_additem(GlowMenu,"Random")
		menu_setprop(GlowMenu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id,GlowMenu,0)
	}
	else
	{
		chat_color(id,"!y[!gDR!y]!g Nu esti !teamVIP!g!")
		return PLUGIN_HANDLED
	}
	return PLUGIN_CONTINUE
}
public GlowMenuChoice(id,GlowMenu,key) 
{ 
	new Client[21] 
	get_user_name(id,Client,20)    

	switch(key) 
	{ 
		case 0: 
		{
			set_hudmessage(0,255,0, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderNormal,35)
		} 
		case 1: 
		{
			set_hudmessage(255,0,0, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,255,0,0,kRenderNormal,35)
		}
		case 2: 
		{
			set_hudmessage(255,140,0, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,255,140,0,kRenderNormal,35)
		}
		case 3: 
		{
			set_hudmessage(255,255,0, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,255,255,0,kRenderNormal,35)
		}
		case 4:
		{
			set_hudmessage(0,255,0, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,0,255,0,kRenderNormal,35)
		} 
		case 5: 
		{
			set_hudmessage(255,20,147, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,255,20,147,kRenderNormal,35)
		} 
		case 6: 
		{ 
			set_hudmessage(0,0,255, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4)  
			set_user_rendering(id,kRenderFxGlowShell,0,0,255,kRenderNormal,35)
		}
		case 7: 
		{
			set_hudmessage(192,192,192, 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,192,192,192,kRenderNormal,35)
		}
		case 8: 
		{
			new culoare[3]
			for(new i = 0; i < 3; i++)
			{
				culoare[i] = random_num(0,255)
			}
			set_hudmessage(culoare[0],culoare[1],culoare[2], 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,culoare[0],culoare[1],culoare[2],kRenderNormal,35)
			chat_color(id,"!y[!gDR!y]!g Daca vrei sa ti minte rgb-ul pentru acest glow: %d %d %d",culoare[0],culoare[1],culoare[2])
		}
		case 9: 
		{
			return PLUGIN_CONTINUE
		} 
	}
	return PLUGIN_HANDLED 
}

public TalkEvent(id)
{
	new msg[256]
	read_args(msg,charsmax(msg))
	remove_quotes(msg)
	new Arg0[15], Arg1[65],Arg2[33], Arg3[33]
	parse(msg,Arg0,14,Arg1,32,Arg2,32,Arg3,32)
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	if(strcmp(Arg0,"/gamble",1) == 0)
	{
		if(gLoggedin[id] == 0)
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
			return PLUGIN_HANDLED
		}
		new Creditex = str_to_num(Arg1)
		if(AllowGamble == 0)
		{
			chat_color(id,"!y[!gGAMBLE!y]!g Inca nu poti paria!")
			return PLUGIN_HANDLED
		}
		if(Creditex > Credite[id])
		{
			chat_color(id,"!y[!gGAMBLE!y]!g Nu ai atatea !teamcredite!g!")
			return PLUGIN_HANDLED
		}
		if(Creditex < 1)
		{
			chat_color(id,"!y[!gGAMBLE!y]!g Suma este prea mica!")
			return PLUGIN_HANDLED
		}
		if(Creditex < GMin)
		{
			chat_color(id,"!y[!gGAMBLE!y]!g Suma ta este mai mica decat suma minima !y[!g%d!y]",GMin)
			return PLUGIN_HANDLED
		}
		if(Creditex > 5000)
		{
			Creditex = 5000
			chat_color(id,"!y[!GAMBLE!y]!g Suma este prea mare!")
		}
		if(GambleNR < 3)
		{
			if(Creditex > 1000)
			{
				chat_color(id,"!y[!gGAMBLE!y]!g Suma este prea mare")
				Creditex =  1000
			}
		}
		if(GambleNR == 1)
		{
			GMin = Creditex
		}
		if(Gamble[id] + Creditex > 5000 && isGamble[id] == 0)
		{
			chat_color(id,"!y[!gGAMBLE!y]!g Ai depasit limita de credite!")
			return PLUGIN_HANDLED
		}
		else
		{
			Gamble[id] += Creditex
			Credite[id] -= Creditex
		}
		if(isGamble[id] == 0)
		{
			GambleNR += 1
			isGamble[id] = 1
			idExtraction[GambleNR] = id
		}
		GTotal += Creditex
		chat_color(0,"!y[!gGAMBLE!y]!g Jucatorul !team%s !ga pus in joc !team%d !gcredite !y[!gTOTAl!y:!team%d!g]",Name,Creditex,GTotal)
		chat_color(0,"!y[!gGAMBLE!y]!g Momentan !team%d !gpersoane participa in aceasta runda de !teamgamble!g!",GambleNR)
		if(GambleNR < 5)
		{
			new NeedToBeIn = 5
			NeedToBeIn -= GambleNR
			chat_color(0,"!y[!gGAMBLE!y]!g Pentru a incepe extragerea, mai trebuie sa intre !team%d !gpersoane",NeedToBeIn)
		}
		else
		{
			if(isExtraction == 0)
			{
				set_task(60.0,"PickGambleWinner")
				chat_color(0,"!y[!gGAMBLE!y]!g Extragerea va incepe peste un minut!")
				isExtraction = 1
			}
		}
		if(GTotal < 0)
		{
			GTotal = 10000
		}
	}
	else if(strcmp(Arg0,"/sb",1) == 0)
	{
		if(gLoggedin[id] == 0)
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
			return PLUGIN_HANDLED
		}
		new Creditex = str_to_num(Arg1)
		#if defined SBDEBUG
			new name[33]
			get_user_name(id,name,charsmax(name))
			if(strcmp(name,"ATudor",1) != 0)
			{
				chat_color(id,"!y[!gDR!y]!g Acest sistem este in lucru. Doar !teamATudor !gare acces!")
				return PLUGIN_HANDLED
			}
		#endif
		if(SBPlayed[id] >= 4)
		{
			chat_color(id,"!y[!gDR!y]!g Nu mai poti sa mai joci pe aceasta harta!")
			return PLUGIN_HANDLED
		}
		if(Creditex <= 0)
		{
			chat_color(id,"!y[!gDR!y]!g Suma este interzisa!")
			return PLUGIN_HANDLED
		}
		if(Creditex > Credite[id])
		{
			chat_color(id,"!y[!gSB!y]!g Nu ai destule credite!")
			return PLUGIN_HANDLED
		}
		if(Creditex > 5000)
		{
			Creditex = 5000
			chat_color(id,"!y[!gSB!y]!g Suma maxima este de !team5000")
		}
		SBBET[id] = Creditex
		new Title[128]
		SBNR[id] = random_num(1,14)
		format(Title,127,"[LALEAGANE] NUMARUL ESTE: %d [1-14]",SBNR[id])
		new Menu = menu_create(Title,"SBMenu")
		menu_additem(Menu,"Mai mare","",0)
		menu_additem(Menu,"Mai mic","",0)
		menu_additem(Menu,"Egal","",0)
		menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id,Menu,0)
	}
	else if(strcmp(Arg0,"/transfer",1) == 0)
	{
		if(gLoggedin[id] == 0)
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
			return PLUGIN_HANDLED
		}
		new Tintax = cmd_target(id,Arg1,CMDTARGET_NO_BOTS)
		new Creditex = str_to_num(Arg2)
		CmdTransfer(id,Tintax,Creditex)
	}
	else if(strcmp(Arg0,"/inventar",1) == 0)
	{
		if(gLoggedin[id] == 0)
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
			return PLUGIN_HANDLED
		}
		new tinta = cmd_target(id,Arg1,CMDTARGET_NO_BOTS)
		if(!tinta)
		{
			chat_color(id,"!y[!gDR!y]!g Nu poti sa ii vizualizezi inventarul lui !team%s!",Arg1)
			return PLUGIN_HANDLED
		}
		CmdInventar(id,tinta)
	}
	else if(strcmp(Arg0,"/cglow",1) == 0 || strcmp(Arg0,"/customglow",1) == 0)
	{
		if(gLoggedin[id] == 0)
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti logat sau inregistrat!")
			return PLUGIN_HANDLED
		}
		if(get_user_flags(id) & ADMIN_LEVEL_H)
		{
			new culoare[3]
			culoare[0] = str_to_num(Arg1)
			culoare[1] = str_to_num(Arg2)
			culoare[2] = str_to_num(Arg3)
			set_hudmessage(culoare[0],culoare[1],culoare[2], 0.02, 0.73, 0, 6.0, 8.0, 0.1, 0.2, 4) 
			set_user_rendering(id,kRenderFxGlowShell,culoare[0],culoare[1],culoare[2],kRenderNormal,35)
		}
		else
		{
			chat_color(id,"!y[!gDR!y]!g Nu esti !teamVIP!g!")
		}
	}
	else if(strcmp(Arg0,"/reg",1) == 0 || strcmp(Arg0,"/register",1) == 0)
	{
		remove_quotes(Arg1)
		if(gHasUserPass[id] == 1)
		{
			if(gLoggedin[id] == 1)
			{
				trim(Arg1)
				RegisterUser(id,Arg1)
				chat_color(id,"!y[!gDR!y]!g Ti-ai schimbat parola cu succes.")
				chat_color(id,"!y[!gDR!y]!g Parola noua: !team%s",Arg1)
				gLoggedin[id] = 0
			}
			else
			{
				chat_color(id,"!y[!gDR!y]!g Esti deja inregistrat!")
				return PLUGIN_HANDLED
			}
		}
		else{
			if (!Arg1[0]){
				chat_color(id,"!y[!gDR!y]!g Parola Invalida!")
			}
			else
			{
				trim(Arg1)
				RegisterUser(id,Arg1)
				new Name[33]
				get_user_name(id,Name,charsmax(Name))
				chat_color(id,"!y[!gDR!y]!g Ai fost inregistrat, parola ta e: !team%s!",Arg1)
				chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !ga fost inregistrat cu succes!",Name)
			}
		}
		return PLUGIN_HANDLED
	}
	else if(strcmp(Arg0,"/login",1) == 0)
	{
		remove_quotes(Arg1)
		trim(Arg1)
		if (!Arg1[0]){
			chat_color(id,"!y[!gDR!y]!g Parola Invalida!")
		}
		if(gHasUserPass[id] == 1 && gLoggedin[id] == 0)
		{
			LogInUser(id,Arg1)
		}
		else
		{
			trim(Arg1)
			RegisterUser(id,Arg1)
			new Name[33]
			get_user_name(id,Name,charsmax(Name))
			chat_color(id,"!y[!gDR!y]!g Ai fost inregistrat, parola ta e: !team%s!",Arg1)
			chat_color(0,"!y[!gDR!y]!g Jucatorul !team%s !ga fost inregistrat cu succes!",Name)
			return PLUGIN_HANDLED
		}
		return PLUGIN_HANDLED
	}
	else if(strcmp(Arg0,"/sunet",1) == 0)
	{
		if(gAllowSound[id] == 0)
		{
			gAllowSound[id] = 1
			chat_color(id,"!y[!gDR!y]!g Ti-ai activat sunetul cu succes!")
		}
		else
		{
			gAllowSound[id] = 0
			chat_color(id,"!y[!gDR!y]!g Ti-ai dezactivat sunetul cu succes!")
		}
	}
	return PLUGIN_CONTINUE
}
public SBMenu(id, Menu, item)
{
	new Name[33]
	get_user_name(id, Name,charsmax(Name))
	new NRX = random_num(1,14)
	new winorlose = random_num(0,6)
	switch(item)
	{
		case 0:
		{
			if(winorlose == 2)
			{
				if(SBNR[id] > 4)
				{
					NRX = random_num(1,4)
				}
				else
				{
					NRX = 1
				}
				
			}
			if(NRX > SBNR[id])
			{
				SBNR[id] = 0
				new Castig = SBBET[id] + SBBET[id]
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga castigat !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,Castig/2)
				Credite[id] += Castig
				SBBET[id] = 0
			}
			else
			{
				Credite[id] -= SBBET[id]
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga pierdut !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,SBBET[id])
			}
			chat_color(id,"!y[!gSB!y]!g Numarul a fost !team%d",NRX)
			SBPlayed[id] += 1
			menu_destroy(Menu)
		}
		case 1:
		{
			if(winorlose == 2)
			{
				if(SBNR[id] < 12)
				{
					NRX = random_num(12,14)
				}
				else
				{
					NRX = 14
				}
				
			}
			if(NRX < SBNR[id])
			{
				SBNR[id] = 0
				new Castig = SBBET[id] + SBBET[id]
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga castigat !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,Castig/2)
				Credite[id] += Castig
				SBBET[id] = 0
			}
			else
			{
				Credite[id] -= SBBET[id]
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga pierdut !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,SBBET[id])
			}
			chat_color(id,"!y[!gSB!y]!g Numarul a fost !team%d",NRX)
			SBPlayed[id] += 1
			menu_destroy(Menu)
		}
		case 2:
		{
			if(winorlose == 2)
			{
				if(SBNR[id] < 12)
				{
					NRX = random_num(12,14)
				}
				else
				{
					NRX = random_num(1,7)
				}
				
			}
			if(NRX == SBNR[id])
			{
				SBNR[id] = 0
				new Castig = SBBET[id] * 5
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga castigat !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,Castig - SBBET[id])
				Credite[id] += Castig
				SBBET[id] = 0
			}
			else
			{
				Credite[id] -= SBBET[id]
				chat_color(id,"!y[!gSB!y]!g Numarul a fost !team%d",NRX)
				chat_color(0,"!y[!gSB!y]!g Jucatorul !team%s !ga pierdut !team%d !gla !teamSMALLER!g-!teamBIGGER",Name,SBBET[id])
			}
			SBPlayed[id] += 1
			menu_destroy(Menu)
		}
	}
}

public PickGambleWinner()
{
	if(GambleNR < 2)
	{
		chat_color(0,"!y[!gGAMBLE!y]!g Nu exista suficienti participanti!")
		return PLUGIN_HANDLED
	}
	new castigator = random_num(1,GambleNR)
	if(is_user_bot(idExtraction[castigator]))
	{
		PickGambleWinner
	}
	new Name[33]
	get_user_name(idExtraction[castigator],Name,charsmax(Name))
	Credite[idExtraction[castigator]] += GTotal
	chat_color(0,"!y[!gGAMBLE!y]!g Jucatorul !team%s !ga castiagt !teamextrgaerea !y[!team%d !gcredite!y]!g!",Name,GTotal)
	isExtraction = 0
	GTotal = 0
	GambleNR = 0
	AllowGamble = 0
	new iPlayer[32], iNum
	get_players(iPlayer,iNum)
	for(new i = 0; i < iNum; i++)
	{
		new id = iPlayer[i]
		isGamble[id] = 0
	}
	GMin = 0
	chat_color(0,"!y[!gDR!y]!g A inceput !teamcooldown-ul !gpentru gamble !team[2 Minute]!")
	set_task(120.0,"ToggleGamble")
	return PLUGIN_HANDLED
}




public ToggleGamble()
{
	AllowGamble = 1
	chat_color(0,"!y[!gDR!y]!g Puteti paria din nou !y[!team/Gamble!y]!g")
}
public RemoveCool(taskid)
{
	new id = taskid - TASKID4
	if(TransferCool[id] >= 1)
	{
		TransferCool[id] -= 1
		chat_color(id,"!y[!gDR!y]!g Mai ai de asteptat !team%d !gminute pentru a !teamtransfera!",TransferCool[id])
	}
	else
	{
		chat_color(id,"!y[!gDR!y]!g Poti !teamtransfera !gcredite!")
		remove_task(taskid)
	}
}
public TransferTask(taskid)
{
	new id = taskid - TASKID
	TransferAllow[id] = 1
	chat_color(id,"!y[!gCREDITS!y] !gAcum poti sa transfer!")
}

public StartCountDown()
{
	if(Countdown >= 1)
	{
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(0, "Extragerea in %d secunde", Countdown)
		Countdown -= 1
	}
	else
	{
		IsCountDown = 0
		new players[32],inum
		get_players(players,inum)
		new castigator = players[random(inum)]
		if(is_user_bot(castigator))
		{
			StartCountDown
			return PLUGIN_CONTINUE
		}
		else if(get_user_flags(castigator) & ADMIN_LEVEL_G)
		{
			StartCountDown
			return PLUGIN_CONTINUE
		}
		else if(!is_user_connected(castigator))
		{
			StartCountDown
			return PLUGIN_CONTINUE
		}
		new CName[33]
		new targ = GiveArg
		get_user_name(castigator,CName,charsmax(CName))
		chat_color(0,"!y[!gDR!y]!g Castigatorul este: !team%s !gel a castigat !team%d !gcredite!",CName, targ)
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(0, "Castigatorul a %d Credite este %s", targ, CName)
		Credite[castigator] += targ
		remove_task(9594)
		Countdown = 6
	}
	return PLUGIN_HANDLED
}
public CrediteTask(taskid)
{
	new id = taskid - TASKID2
	chat_color(id,"!y[!gDR!y]!g Ai primit !team100 credite !gpentru activitatea pe server!")
	Credite[id] += 100
}
public removetasks(id)
{
	if(task_exists(id + TASKID))
	{
		remove_task(id + TASKID)
	}
	if(task_exists(id + TASKID2))
	{
		remove_task(id + TASKID2)
	}
	if(task_exists(id + TASKID3))
	{
		remove_task(id + TASKID3)
	}
	if(task_exists(id + TASKID4))
	{
		remove_task(id + TASKID4)
	}
	if(task_exists(id + TASKID5))
	{
		remove_task(id + TASKID5)
	}
	if(task_exists(id + TASKID6))
	{
		remove_task(id + TASKID6)
	}
	if(task_exists(id + TASKID7))
	{
		remove_task(id + TASKID7)
	}
}
public GiveItems(id)
{
	if(is_user_alive(id))
	{
		if(Weapon[id] == 1)
		{
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id, "weapon_deagle")
			give_item(id, "weapon_m4a1")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
		}
		if(Survival[id] == 1)
		{
			set_user_health(id,255)
			set_user_armor(id,200)
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id, "weapon_deagle")
			give_item(id, "weapon_m4a1")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
		}
		if(Invizibilitate[id] == 1)
		{
			set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderTransAlpha,100)
		}
	}
}

public MesajeID()
{
	switch(CurrentMSG)
	{
		case 0:
		{
			chat_color(0,"!y[!gDR!y]!g Pentru a transfera credite scrie !team/transfer!g. !teamSintaxa!g:!team /transfer Jucator Credite!g!")
		}
		case 1:
		{
			chat_color(0,"!y[!gBIG BOX!y]!g Pentru a !teamtesta !gsunetele pe care le poti castiga in !teamBIG BOX !gscrie !team/testsound")
		}
		case 2:
		{
			chat_color(0,"!y[!gDR!y]!g Pentru a vedea inventarul cuiva, scrie !team/inventar NUME")
		}
		case 3:
		{
			chat_color(0,"!y[!gDR!y]!g Pentru a stralucii scrie !team/glow. !gPentru o stralucire custom, scrie !team/cglow [0-255] [0-255] [0-255],")
			chat_color(0,"!team[0-255] inseamna un numar de la 0 la 255")
		}
		case 4:
		{
			chat_color(0,"!y[!gDR!y]!g Pentru a-ti schimba parola, logheaza-te, iar dupa aceea scrie !team/reg !gsi o parola noua!")
		}
		case 5:
		{
			chat_color(0,"!y[!gDR!y]!g Pentru a nu mai auzi sunetul de kill, scrie !y[!team/sunet!y]")
		}
	}
	if(CurrentMSG == 5)
	{
		CurrentMSG = 0
	}
	else
	{
		CurrentMSG += 1
	}
}

stock log_kill(killer, victim, weapon[],headshot) {
	user_silentkill( victim );
	
	message_begin( MSG_ALL, get_user_msgid( "DeathMsg" ), {0,0,0}, 0 );
	write_byte( killer );
	write_byte( victim );
	write_byte( headshot );
	write_string( weapon );
	message_end();
	
	new kfrags = get_user_frags( killer );
	set_user_frags( killer, kfrags++ );
	new vfrags = get_user_frags( victim );
	set_user_frags( victim, vfrags++ );
	
	return  PLUGIN_CONTINUE
} 
stock chat_color(const id, const input[], any:...)
{
 new count = 1, players[32]
 static msg[191]
 vformat(msg, 190, input, 3)
 
 replace_all(msg, 190, "!g", "^4")
 replace_all(msg, 190, "!y", "^1")
 replace_all(msg, 190, "!team", "^3")
 
 if (id) players[0] = id; else get_players(players, count, "ch")
 {
  for (new i = 0; i < count; i++)
  {
   if (is_user_connected(players[i]))
   {
    message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
    write_byte(players[i]);
    write_string(msg);
    message_end();
   }
  }
 }
}
