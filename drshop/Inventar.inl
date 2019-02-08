#include <amxmodx>
#include <amxmisc>
#include <nvault>
#include <cstrike>
#include <fakemeta>

#define SkinNR 13
#define SoundNR 42
// GLOBAL
new SkinID[33][SkinNR]
new SoundID[33][SoundNR]
new SkinUsed[33]
new SoundUsed[33]
new IVault
new gAllowSound[33] = 1
new SkinNames[SkinNR][] =
{
	"Buzz Lightyear",
	"Jill Valentine",
	"Trump",
	"Hitler",
	"Pepsi Man",
	"Alice",
	"Flash",
	"Horse Mask",
	"Sonic",
	"Drunk Santa Klaus",
	"DeadPool",
	"Sub-Zero",
	"Xiah"
}
new SkinNamesID[SkinNR][] =
{
	"buzzlightyear",
	"Jill",
	"Trump",
	"Hitler",
	"Pepsiman",
	"alice",
	"Flash",
	"Horsemask",
	"Sonic",
	"DrunkSanta",
	"deadpool",
	"subzero",
	"xiah"
}
new SoundNames[SoundNR][] =
{
	"Yes",
	"May The Force Be With You",
	"Helloo Babee",
	"The One and Only",
	"YMCA",
	"Filty Animal",
	"Rap God",
	"You shall not pass",
	"Taraf",
	"Electronica #1",
	"Dubstep #1",
	"Every Thing",
	"Let the bodies hit the floor",
	"Beast",
	"Some Day We will Rise",
	"Rock #1",
	"E V E",
	"Adderal",
	"Babylon",
	"ColorBlind",
	"Do you love me?",
	"Droppin da bomb",
	"Drug Addicts",
	"LEH",
	"Twerk it like Miley",
	"Lock My Hips",
	"Mi Cama",
	"Score Suite",
	"Shisha",
	"Shooting Stars",
	"Still Cold",
	"TBC",
	"You Don't Owe Me",
	"Zooted",
	"All This Love", // NOU
	"Gasoline",
	"Happier",
	"Manele Manele",
	"Psycho",
	"Say My Name",
	"Sweet But Psycho",
	"Sunflower"
}
new SoundNamesID[SoundNR][] =
{
	"misc/yes.wav",
	"misc/FORCE.WAV",
	"misc/HIBABE.WAV",
	"misc/THEONE.WAV",
	"misc/YMCA.WAV",
	"misc/anger.wav",
	"misc/rapgod.wav",
	"misc/shallnotpass.wav",
	"misc/Taraf.wav",
	"misc/Electronica1.wav",
	"misc/Dubstep1.wav",
	"misc/avril.wav",
	"misc/bodies.wav",
	"misc/beast.wav",
	"misc/rise.wav",
	"misc/rock.wav",
	"misc/eve.wav",
	"misc/adderal.mp3",
	"misc/Babylon.mp3",
	"misc/colorblind.mp3",
	"misc/doyouloveme.mp3",
	"misc/dropndabomb.mp3",
	"misc/drugaddicts.mp3",
	"misc/leh.mp3",
	"misc/likemiley.mp3",
	"misc/LockMyHips.mp3",
	"misc/micama.mp3",
	"misc/scoresuite.mp3",
	"misc/shisha.mp3",
	"misc/shootingstars.mp3",
	"misc/StillCold.mp3",
	"misc/tbc.mp3",
	"misc/youdontoweme.mp3",
	"misc/zooted.mp3",
	"misc/allthislove.mp3",
	"misc/gasolinev2.mp3",
	"misc/happier.mp3",
	"misc/manele.mp3",
	"misc/psycho.mp3",
	"misc/saymyname.mp3",
	"misc/sweetbutpsychov2.mp3",
	"misc/sunflower.mp3"
}
new HasModel[33]
new ModelID[33][32]
// Sound/
new HasSound[33]
new HSoundID[33][32]
// USER CMDS
public CmdInventar(id,target)
{
	if(!is_user_connected(target))
	{
		return PLUGIN_HANDLED
	}
	new Name[33],TName[33]
	get_user_name(id,Name,charsmax(Name))
	get_user_name(target,TName,charsmax(TName))
	console_print(id,"===============INVENTAR===============")
	for(new i = 0; i < SkinNR; i++)
	{
		if(SkinID[target][i] == 1)
		{
			console_print(id,"%s",SkinNames[i])
		}
	}
	for(new i = 0; i < SoundNR; i++)
	{
		if(SoundID[target][i] == 1)
		{
			console_print(id,"%s",SoundNames[i])
		}
	}
	console_print(id,"===============INVENTAR===============")
	chat_color(0,"!y[!gINVENTAR!y]!g Jucatorul !team%s !gii inspecteaza inventarul lui !team%s!",Name,TName) 
	client_cmd(id,"toggleconsole")
	return PLUGIN_HANDLED
}
// SKIN
public CmdSetSkin(id)
{
	new Menu = menu_create("LALEAGANE SKIN SELECTOR","SkinMenu")
	for(new i = 0; i < SkinNR; i++)
	{
		if(SkinID[id][i] == 1)
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - IN INVENTAR", SkinNames[i])
			menu_additem(Menu,txt,"",0)
		}
		else
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - NU DETII", SkinNames[i])
			menu_additem(Menu,txt,"",0)
		}
	}
	menu_setprop( Menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, Menu, 0 );
}
public SkinMenu(id, Menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(Menu)
		return PLUGIN_HANDLED;
	}  
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	if(SkinID[id][item] == 1)
	{
		chat_color(id,"!y[!gSKINS!y]!g Ai ales !team%s !gskinul va fi aplicat!",SkinNames[item])
		cs_reset_user_model(id)
		cs_set_user_model(id,SkinNamesID[item])
		format(ModelID[id],31,SkinNamesID[item])
		HasModel[id] = 1
		chat_color(0,"!y[!gSKINS!y]!g Jucatorul !team%s !ga ales skin-ul !team%s!g!",Name,SkinNames[item])
		SkinUsed[id] = item
		//set_task(1.0,"UpdateStats",id + TASKID8)
	}
	else
	{
		chat_color(id,"!y[!gSKINS!y]!g Nu detii acest skin!")
	}
	log_to_file("DEBUGINVENTAR","%d",item)
	menu_destroy(Menu)
	return PLUGIN_HANDLED
}
// SOUND
public CmdSetSound(id)
{
	new Menu = menu_create("LALEAGANE SOUND SELECTOR","SoundMenu")
	for(new i = 0; i < SoundNR; i++)
	{
		if(SoundID[id][i] == 1)
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - IN INVENTAR", SoundNames[i])
			menu_additem(Menu,txt,"",0)
		}
		else
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - NU DETII", SoundNames[i])
			menu_additem(Menu,txt,"",0)
		}
	}
	menu_setprop( Menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, Menu, 0 );
}
public SoundMenu(id, Menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(Menu)
		return PLUGIN_HANDLED;
	} 
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	if(SoundID[id][item] == 1)
	{
		chat_color(id,"!y[!gSOUNDS!y]!g Ai ales !team%s !gsunetul va fi aplicat!",SoundNames[item])
		if(contain(SoundNamesID[item],".mp3") >= 0)
		{
			new newString[128]
			format(newString,127,"sound/%s",SoundNamesID[item])
			client_cmd(id,"mp3 play ^"%s^"",newString)
		}
		else
		{
			client_cmd( id, "spk ^"%s^"", SoundNamesID[item] );
		}
		HasSound[id] = 1
		format(HSoundID[id],31,"%s",SoundNamesID[item])
		chat_color(0,"!y[!gSOUNDs!y]!g Jucatorul !team%s !ga ales sunetul !team%s!g!",Name,SoundNames[item])
		SoundUsed[id] = item
		//set_task(1.0,"UpdateStats",id + TASKID8)
	}
	log_to_file("DEBUGINVENTAR","%d",item)
	menu_destroy(Menu)
	return PLUGIN_HANDLED
}
public CmdTestSound(id)
{
	new Menu = menu_create("LALEAGANE SOUND TESTER","SoundMenuTest")
	for(new i = 0; i < SoundNR; i++)
	{
		if(SoundID[id][i] == 1)
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - IN INVENTAR", SoundNames[i])
			menu_additem(Menu,txt,"",0)
		}
		else
		{
			new txt[128]
			format(txt,charsmax(txt),"%s - NU DETII", SoundNames[i])
			menu_additem(Menu,txt,"",0)
		}
	}
	menu_setprop( Menu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, Menu, 0 );
}
public SoundMenuTest(id, Menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(Menu)
		return PLUGIN_HANDLED;
	}  
	new Name[33]
	get_user_name(id,Name,charsmax(Name))
	chat_color(id,"!y[!gSOUNDS!y]!g Testezi sunteul !team%s!g!",SoundNames[item])
	if(contain(SoundNamesID[item],".mp3") >= 0)
	{
		new newString[128]
		format(newString,127,"sound/%s",SoundNamesID[item])
		client_cmd(id,"mp3 play ^"%s^"",newString)
	}
	else
	{
		client_cmd( id, "spk ^"%s^"", SoundNamesID[item] );
	}
	log_to_file("DEBUGINVENTAR","%d",item)
	menu_destroy(Menu)
	return PLUGIN_HANDLED
}
// ADMIN CMDS
public CmdAInventar(id, level, cid)
{
	if(!cmd_access(id, level, cid,0))
	{
		console_print(id, "Nu ai acces la aceasta comanda!")
		return PLUGIN_CONTINUE
	}
	for(new i = 0; i < SkinNR; i++)
	{
		SkinID[id][i] = 1
	}
	for(new i = 0; i < SoundNR; i++)
	{
		SoundID[id][i] = 1
	}
	new Name[33]
	get_user_name(id, Name,charsmax(Name))
	log_to_file("Inventar_Cmd.txt","Jucatorul %s a folosit comanda de debug!",Name)
	return PLUGIN_CONTINUE
}
public CmdDeleteInventar(id,level,cid)
{
	if(!cmd_access(id,level,cid,0))
	{
		return PLUGIN_HANDLED
	}
	new Arg0[33]
	read_argv(1,Arg0,charsmax(Arg0))
	remove_quotes(Arg0)
	trim(Arg0)
	new tinta = cmd_target(id,Arg0,2)
	if(!tinta)
	{
		console_print(id,"%s nu e conectat!",Arg0)
		return PLUGIN_HANDLED
	}
	for(new i = 0; i < SkinNR; i++)
	{
		SkinID[tinta][i] = 0
	}
	for(new i = 0; i < SoundNR; i++)
	{
		SoundID[tinta][i] = 0
	}
	ModelID[id] = ""
	HSoundID[id] = ""
	SaveInventar(id)
	new Name[33]
	get_user_name(tinta,Name,32)
	console_print(id,"%s - inventar resetat",Name)
	return PLUGIN_HANDLED
}
// SRV CMDS
public PlaySound(ToID,FromID)
{
	//client_cmd( iPlayer[i], "spk ^"%s^"", HSoundID[id] );
	if(contain(HSoundID[FromID],".mp3") >= 0)
	{
		new newString[128]
		format(newString,127,"sound/%s",HSoundID[FromID])
		client_cmd(ToID,"mp3 play ^"%s^"",newString)
	}
	else
	{
		client_cmd( ToID, "spk ^"%s^"", FromID );
	}
}
public LoadInventar(id)
{
	new vaultkey[128], vaultdata[128]
	new Name[33]
	get_user_name(id, Name,charsmax(Name))
	for(new i = 0; i <SkinNR; i++)
	{
		format(vaultkey,127,"^"%sskinid%d^"",Name,i)
		nvault_get(IVault,vaultkey,vaultdata,charsmax(vaultdata))
		SkinID[id][i] = str_to_num(vaultdata)
	}
	for(new i = 0; i < SoundNR; i++)
	{
		format(vaultkey,127,"^"%ssoundid%d^"",Name,i)
		nvault_get(IVault,vaultkey,vaultdata,charsmax(vaultdata))
		SoundID[id][i] = str_to_num(vaultdata)
	}
	format(vaultkey,127,"^"skin%s^"",Name)
	nvault_get(IVault,vaultkey,vaultdata,charsmax(vaultdata))
	if(strcmp(vaultdata,"") == 0)
	{
		// do nothing
	}
	else
	{
		cs_reset_user_model(id)
		cs_set_user_model(id,vaultdata)
		format(ModelID[id],31,vaultdata)
		HasModel[id] = 1
		for(new i = 0; i < SkinNR; i++)
		{
			if(strcmp(vaultdata,SkinNamesID[i]) == 0)
			{
				SkinUsed[id] = i
			}
		}
	}
	format(vaultkey,127,"^"sound%s^"",Name)
	nvault_get(IVault,vaultkey,vaultdata,charsmax(vaultdata))
	if(strcmp(vaultdata,"") == 0)
	{
		// do nothing
	}
	else
	{
		client_cmd( id, "spk ^"%s^"", vaultdata );
		HasSound[id] = 1
		format(HSoundID[id],31,"%s",vaultdata)
		for(new i = 0; i < SkinNR; i++)
		{
			if(strcmp(vaultdata,SoundNamesID[i]) == 0)
			{
				SoundUsed[id] = i
			}
		}
	}

	return PLUGIN_HANDLED
}
public SaveInventar(id)
{
	
	new vaultkey[128], vaultdata[128]
	new Name[33]
	get_user_name(id, Name,charsmax(Name))
	for(new i = 0; i < SkinNR; i++)
	{
		format(vaultkey,127,"^"%sskinid%d^"",Name,i)
		format(vaultdata,127,"%d",SkinID[id][i])
		nvault_set(IVault,vaultkey,vaultdata)
	}
	for(new i = 0; i < SoundNR; i++)
	{
		format(vaultkey,127,"^"%ssoundid%d^"",Name,i)
		format(vaultdata,127,"%d",SoundID[id][i])
		nvault_set(IVault,vaultkey,vaultdata)
	}
	format(vaultkey,127,"^"skin%s^"",Name)
	format(vaultdata,127,"%s",ModelID[id])
	nvault_set(IVault,vaultkey,vaultdata)
	format(vaultkey,127,"^"sound%s^"",Name)
	format(vaultdata,127,"%s",HSoundID[id])

}