#pragma semicolon 1
#pragma newdecls required

static float HealthMulti;
static int HealthBonus;
static int EnemyChance;
static int EnemyBosses;
static int ImmuneNuke;
static int CashBonus;
static float KillBonus;
static float MiniBossChance;
static int IceDebuff;
static int TeslarDebuff;
static int FusionBuff;
static int OceanBuff;
static int CrippleDebuff;
static int CudgelDebuff;
static int PerkMachine;
static int RaidFight;
static float SpeedMult;
static float MeleeMult;
static float RangedMult;
static int ExtraSkulls;
static int SkullTimes;
static bool ExplodingNPC;
static bool IsExplodeWave; // to prevent the message from popping up twice
static int ExplodeNPCDamage;
static int VoidBuff;
static bool VoidAfflictedBuff;
static bool VestaBuff;
static int StrangleDebuff;
static int ProsperityDebuff;
static bool SilenceDebuff;
static float ExtraEnemySize;
static bool CheesyPresence;
static int EloquenceBuff;
static int RampartBuff;
static int EloquenceBuffEnemies;
static int RampartBuffEnemies;
static int FreeplayBuffTimer;
static bool zombiecombine;
static int moremen;
static bool immutable;
static int RandomStats;
static float gay;
static bool friendunit;
static int HurtleBuff;
static int HurtleBuffEnemies;
static bool LoveNahTonic;
static bool Schizophrenia;
static bool DarknessComing;
static int setuptimes;
static float ExtraAttackspeed;
static bool thespewer;
static bool sigmaller;
static bool portalgalore;
static bool refragportal;
static bool XenoLabBuff;
static bool SeaLabBuff;
static int SpecialistDebuff;
static bool SensalTrio;

static int FreeplayModifActive = 0;
static float FM_Health;
static float FM_Damage;

#define INTENSE 1
#define MUSCLE 2
#define SQUEEZER 3
static bool squeezerplus; // soon...

public void Freeplay_Modifier_IntenseTraining()
{
	FreeplayModifActive = INTENSE;
	Modifier_Collect_ChaosIntrusion();
}

public void Freeplay_Modifier_MuscleRefiner()
{
	FreeplayModifActive = MUSCLE;
	Modifier_Collect_SecondaryMercs();
}

public void Freeplay_Modifier_SoulSqueezer()
{
	FreeplayModifActive = SQUEEZER;
	Modifier_Collect_OldTimes();
}

public void Freeplay_RemoveModif()
{
	switch(FreeplayModifActive)
	{
		case INTENSE:
		{
			Modifier_Remove_ChaosIntrusion();
		}
		case MUSCLE:
		{
			Modifier_Remove_SecondaryMercs();
		}
		case SQUEEZER:
		{
			Modifier_Remove_OldTimes();
		}
	}
	FreeplayModifActive = 0;
}

void Freeplay_CharBuffToAdd(char[] data)
{
	switch(FreeplayModifActive)
	{
		case INTENSE:
		{
			FormatEx(data, 6, "♦");
		}
		case MUSCLE:
		{
			FormatEx(data, 6, "♠");
		}
		case SQUEEZER:
		{
			if(squeezerplus)
				FormatEx(data, 6, "☻");
			else
				FormatEx(data, 6, "♣");
		}
	}
}

void Freeplay_OnMapStart()
{
	PrecacheSound("ui/vote_success.wav", true);
	PrecacheSound("ui/mm_medal_silver.wav", true);
	PrecacheSound("ambient/halloween/thunder_01.wav", true);
	PrecacheSound("misc/halloween/spelltick_set.wav", true);
	PrecacheSound("misc/halloween/hwn_bomb_flash.wav", true);
	PrecacheSound("music/mvm_class_select.wav", true);
}

void Freeplay_ResetAll()
{
	HealthMulti = 1.0;
	HealthBonus = 0;
	EnemyChance = 10;
	EnemyBosses = 0;
	ImmuneNuke = 0;
	CashBonus = 0;
	KillBonus = 0.0;
	MiniBossChance = 0.025;
	IceDebuff = 0;
	TeslarDebuff = 0;
	FusionBuff = 0;
	OceanBuff = 0;
	CrippleDebuff = 0;
	CudgelDebuff = 0;
	PerkMachine = 0;
	RaidFight = 0;
	SpeedMult = 1.0;
	MeleeMult = 1.0;
	RangedMult = 1.0;
	ExtraSkulls = -1;
	SkullTimes = 0;
	ExplodeNPCDamage = 0;
	ExplodingNPC = false;
	IsExplodeWave = false;
	VoidBuff = 0;
	VoidAfflictedBuff = false;
	VestaBuff = false;
	StrangleDebuff = 0;
	ProsperityDebuff = 0;
	SilenceDebuff = false;
	ExtraEnemySize = 1.0;
	CheesyPresence = false;
	EloquenceBuff = 0;
	RampartBuff = 0;
	EloquenceBuffEnemies = 0;
	RampartBuffEnemies = 0;
	FreeplayBuffTimer = 0;
	zombiecombine = false;
	moremen = 0;
	RandomStats = 0;
	gay = 0.0;
	friendunit = false;
	HurtleBuff = 0;
	HurtleBuffEnemies = 0;
	LoveNahTonic = false;
	Schizophrenia = false;
	DarknessComing = false;
	setuptimes = 3;
	ExtraAttackspeed = 1.0;
	thespewer = false;
	sigmaller = false;
	portalgalore = false;
	refragportal = false;
	XenoLabBuff = false;
	SeaLabBuff = false;
	SpecialistDebuff = 0;
	SensalTrio = false;
	squeezerplus = false;
	FM_Health = 0.4;
	FM_Damage = 0.65;
}

int Freeplay_EnemyCount()
{
	int amount;
	if(RaidFight)
	{
		amount = 1;
	}
	else
	{
		amount = 5;

		if(zombiecombine)
			amount++;
	
		if(moremen)
			amount++;

		if(Schizophrenia)
			amount++;

		if(DarknessComing)
			amount++;

		if(thespewer)
			amount++;

		if(sigmaller)
			amount++;

		if(portalgalore)
			amount++;

		if(refragportal)
			amount++;

		if(SensalTrio)
			amount++;
	}

	return amount;
}

void Freeplay_OnNPCDeath(int entity)
{
	if(ExplodingNPC)
	{
		float startPosition[3];
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", startPosition); 
		startPosition[2] += 45;
		makeexplosion(entity, startPosition, ExplodeNPCDamage, 150, _, true, true, 6.0);
	}
}

int Freeplay_GetDangerLevelCurrent(int postWaves)
{
	//0.5% chance for danger lvl 0 stuff.
	if(GetRandomFloat(0.0, 1.0) <= 0.005)
	{
		return 0;
	}
	int DangerLevel = 1;

	float DefaultChance = 0.01 * float(EnemyChance);
	DefaultChance += 0.004 * float(postWaves - 41);
	
	if(DefaultChance > 0.45)
	{
		DefaultChance = 0.45;
	}

	for(int LoopMax = 1; LoopMax < 6 ; LoopMax++)
	{
		//theres a default 10% chance to roll higher enemies.
		if(GetRandomFloat(0.0, 1.0) <= (DefaultChance))
		{
			DangerLevel++;
		}
		else
		{
			break;
		}
	}
	return DangerLevel;
}

void Freeplay_AddEnemy(int postWaves, Enemy enemy, int &count, bool alaxios = false)
{
	bool shouldscale = true;
	if(RaidFight || friendunit || zombiecombine || moremen || immutable || Schizophrenia || DarknessComing || thespewer || sigmaller || portalgalore || refragportal || SensalTrio)
	{
		enemy.Is_Boss = 0;
		enemy.WaitingTimeGive = 0.0;
		enemy.ExtraSize = 1.0;
		enemy.Is_Outlined = 0;
		enemy.Is_Health_Scaled = 0;
		enemy.Does_Not_Scale = 0;
		enemy.ignore_max_cap = 0;
		enemy.Is_Immune_To_Nuke = 0;
		enemy.Is_Static = false;
		enemy.Team = 3;
		enemy.Is_Static = false;
		enemy.ExtraMeleeRes = 1.0;
		enemy.ExtraRangedRes = 1.0;
		enemy.ExtraSpeed = 1.0;
		enemy.ExtraDamage = 1.0;
		enemy.ExtraThinkSpeed = 1.0;
	}
	if(RaidFight)
	{
		enemy.Is_Outlined = true;
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Boss = 2;
		enemy.ExtraDamage = 1.0;

		switch(RaidFight)
		{
			case 2:
			{
				enemy.Index = NPC_GetByPlugin("npc_xeno_raidboss_silvester");
				enemy.Health = RoundToFloor((2500000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
				enemy.Data = "wave_40;triple_enemies";
				SensalTrio = true;
			}
			case 3:
			{
				enemy.Index = NPC_GetByPlugin("npc_stella");
				enemy.Health = RoundToFloor((3000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
				enemy.Data = "wave_40;triple_enemies";

				switch(GetRandomInt(1, 4))
				{
					case 1: 
					{
						enemy.Index = NPC_GetByPlugin("npc_ruina_twirl");
						enemy.Health = RoundToFloor((5000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
						enemy.Data = "wave_40;triple_enemies";
					}
					default: 
					{
						enemy.Index = NPC_GetByPlugin("npc_ruina_twirl");
						enemy.Health = RoundToFloor((5000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
						enemy.Data = "wave_40;triple_enemies";
					}
				}
			}
			default:
			{
				enemy.Index = NPC_GetByPlugin("npc_true_fusion_warrior");
				enemy.Health = RoundToFloor((5000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
				enemy.Data = "wave_40";
			}
		}

		// Raid health is lower before w101.
		if(Waves_GetRoundScale() < 101)
			enemy.Health = RoundToCeil(float(enemy.Health) * 0.75);

		enemy.Health = RoundToCeil(float(enemy.Health) * HealthMulti);
		
		//Global HP increaser
		enemy.Health = RoundToCeil(float(enemy.Health) * 0.85);

		// moni
		enemy.Credits += 5000.0;
		enemy.Does_Not_Scale = 1;
		count = 1;
		RaidFight = 0;
		shouldscale = false;
	}
	else if(friendunit)
	{
		enemy.Team = TFTeam_Red;
		count = 1;

		if(enemy.ExtraDamage)
			enemy.ExtraDamage = 25.0;

		enemy.ExtraSpeed = 1.25;
		enemy.ExtraSize = 1.25;

		friendunit = false;
		shouldscale = false;
		char thename[128];
		NPC_GetNameById(enemy.Index, thename, sizeof(thename));
		CPrintToChatAll("{gold}Friendly Unit: {orange}%s", thename);
	}
	else if(DarknessComing)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Index = NPC_GetByPlugin("npc_darkenedheavy");
		enemy.Health = RoundToFloor(((1000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.Credits += 100.0;
		enemy.ExtraMeleeRes = 1.5;
		enemy.Is_Boss = 1;

		count = 4;
		DarknessComing = false;
	}
	else if(zombiecombine)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Index = NPC_GetByPlugin("npc_zombine");
		enemy.Health = RoundToFloor(((150000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.ExtraSpeed = 1.5;
		enemy.ExtraSize = 1.33;
		enemy.Credits += 100.0;
		enemy.ExtraDamage = 2.0;
		enemy.Is_Boss = 0;
		enemy.Is_Health_Scaled = 0;

		count = 20;
		zombiecombine = false;
	}
	else if(moremen)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Index = NPC_GetByPlugin("npc_dweller_heavy");
		enemy.Health = RoundToCeil(((80000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.ExtraSpeed = 1.5;
		enemy.ExtraSize = 1.25;
		enemy.Credits += 100.0;
		enemy.ExtraDamage = 1.25;
		enemy.Is_Boss = 0;
		enemy.Is_Health_Scaled = 0;

		count = 30;
		moremen--;
	}
	else if(immutable)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Boss = 1;
		enemy.Index = NPC_GetByPlugin("npc_immutableheavy");
		enemy.Health = RoundToFloor(((610000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.ExtraMeleeRes = 1.5;
		enemy.ExtraRangedRes = 1.0;
		enemy.ExtraSpeed = 0.9;
		enemy.ExtraDamage = 0.75;
		enemy.ExtraSize = 1.0;
		enemy.Credits += 100.0;

		count = 5;
		immutable = false;
	}
	else if(Schizophrenia)
	{
		enemy.Index = NPC_GetByPlugin("npc_annoying_spirit");
		enemy.Health = RoundToFloor(1000000.0 / 70.0 * float(Waves_GetRoundScale()));
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Outlined = 0;
		enemy.Credits += 100.0;
		count = 1;
		Schizophrenia = false;
	}
	else if(thespewer)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Boss = 1;
		enemy.Index = NPC_GetByPlugin("npc_abyssspewer");
		enemy.Health = RoundToFloor(((1100000.0 + HealthBonus) / 65.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.ExtraMeleeRes = 0.75;
		enemy.ExtraRangedRes = 0.75;
		enemy.ExtraDamage = 5.5;
		enemy.ExtraSpeed = 2.0;
		enemy.ExtraSize = 2.5;
		enemy.ExtraThinkSpeed = 0.75;
		enemy.Credits += 100.0;
		count = 1;
		thespewer = false;
	}
	else if(sigmaller)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Boss = 1;
		enemy.Index = NPC_GetByPlugin("npc_freeplay_sigmaller");
		enemy.Health = RoundToFloor(((750000.0 + HealthBonus) / 65.0 * float(Waves_GetRound())) * HealthMulti);
		enemy.ExtraDamage = 1.0;
		enemy.ExtraSpeed = 1.0;
		enemy.Credits += 100.0;
		count = 1;
		sigmaller = false;
	}
	else if(portalgalore)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Index = NPC_GetByPlugin("npc_void_portal");
		enemy.ExtraSize = 1.5;
		enemy.Credits += 100.0;
		enemy.ExtraDamage = 2.0;
		enemy.Is_Boss = 0;

		count = 13;
		portalgalore = false;
	}
	else if(refragportal)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Index = NPC_GetByPlugin("npc_portal_gate");
		enemy.ExtraSize = 1.5;
		enemy.Credits += 100.0;
		enemy.ExtraDamage = 2.0;
		enemy.Is_Boss = 0;

		count = 5;
		refragportal = false;
	}
	else if(SensalTrio)
	{
		enemy.Is_Immune_To_Nuke = true;
		enemy.Is_Boss = 1;
		enemy.Index = NPC_GetByPlugin("npc_sensal");
		enemy.Health = RoundToFloor((6000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound() * 2) * MultiGlobalHighHealthBoss);
		enemy.Data = "wave_40;triple_enemies";

		// Raid health is lower before w101.
		if(Waves_GetRoundScale() < 101)
			enemy.Health = RoundToCeil(float(enemy.Health) * 0.75);

		enemy.Health = RoundToCeil(float(enemy.Health) * HealthMulti);
		
		//Global HP increaser
		enemy.Health = RoundToCeil(float(enemy.Health) * 0.85);

		// moni
		enemy.Does_Not_Scale = 1;
		count = 1;
		RaidFight = 0;
		shouldscale = false;

		SensalTrio = false;
	}
	else
	{
		float bigchance;
		if(postWaves+1 < 89)
			bigchance = 0.97;
		else
			bigchance = 0.95;

		if(GetRandomFloat(0.0, 1.0) >= bigchance)
		{
			enemy.Is_Boss = 0;
			enemy.WaitingTimeGive = 0.0;
			enemy.ExtraSize = 1.0;
			enemy.Is_Outlined = 0;
			enemy.Is_Health_Scaled = 0;
			enemy.Does_Not_Scale = 0;
			enemy.ignore_max_cap = 0;
			enemy.Is_Immune_To_Nuke = 0;
			enemy.Is_Static = false;
			enemy.Team = 3;
			enemy.Is_Static = false;
			enemy.ExtraMeleeRes = 1.0;
			enemy.ExtraRangedRes = 1.0;
			enemy.ExtraSpeed = 1.0;
			enemy.ExtraDamage = 1.0;

			enemy.Is_Immune_To_Nuke = true;
			int roll = GetRandomInt(1, 14);
			if(roll == 2)
			{
				enemy.Index = NPC_GetByPlugin("npc_dimensionfrag");
				enemy.Health = RoundToFloor(((170000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.25)) * HealthMulti);
				enemy.ExtraDamage = 0.70;
				count = 20;
			}
			else if(roll == 3)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_ltzens");
				enemy.Health = RoundToFloor(((250000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.15)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 15;
			}
			else if(roll == 4)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_refract");
				enemy.Health = RoundToFloor(((200000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.20)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 20;
			}
			else if(roll == 5)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_spuud");
				enemy.Health = RoundToFloor(((300000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.11)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 15;
			}
			else if(roll == 6)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_rouam");
				enemy.Health = RoundToFloor(((500000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
				enemy.ExtraDamage = 2.0;
				count = 5;
			}
			else if(roll == 7)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_keitosis");
				enemy.Health = RoundToFloor(((3000000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
				enemy.ExtraDamage = 1.09;
				enemy.ExtraThinkSpeed = 0.75;
				enemy.Is_Boss = 1;
				count = 1;
			}
			else if(roll == 8)
			{
				enemy.Index = NPC_GetByPlugin("npc_vanishingmatter");
				enemy.Health = RoundToFloor(((350000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
				enemy.ExtraDamage = 0.95;
				count = 10;
			}
			else if(roll == 9)
			{
				enemy.Index = NPC_GetByPlugin("npc_dimensionfrag");
				enemy.Health = RoundToFloor(((170000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.25)) * HealthMulti);
				enemy.ExtraDamage = 0.70;
				count = 20;
			}
			else if(roll == 10)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_ltzens");
				enemy.Health = RoundToFloor(((250000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.15)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 15;
			}
			else if(roll == 11)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_refract");
				enemy.Health = RoundToFloor(((200000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.20)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 20;
			}
			else if(roll == 12)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_spuud");
				enemy.Health = RoundToFloor(((300000.0 + HealthBonus) / 70.0 * (float(Waves_GetRound()) * 1.11)) * HealthMulti);
				enemy.ExtraDamage = 1.25;
				count = 15;
			}
			else if(roll == 13)
			{
				enemy.Index = NPC_GetByPlugin("npc_umbral_rouam");
				enemy.Health = RoundToFloor(((500000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
				enemy.ExtraDamage = 2.0;
				count = 5;
			}
			else
			{
				enemy.Index = NPC_GetByPlugin("npc_vanishingmatter");
				enemy.Health = RoundToFloor(((350000.0 + HealthBonus) / 70.0 * float(Waves_GetRound())) * HealthMulti);
				enemy.ExtraDamage = 0.95;
				count = 10;
			}

			count = RoundToFloor((count * (((postWaves * 1.5) + 80) * 0.009)) * 0.5);
			enemy.Credits += 100.0;

			if(postWaves+1 < 89)
			{
				switch(GetRandomInt(1, 4))
				{
					case 1:
					{
						CPrintToChatAll("{gold}U-uh, that's not supposed to happen....");
					}
					case 2:
					{
						CPrintToChatAll("{gold}Aand this enemy gro- w-wait, what's that!?");	
					}
					case 3:
					{
						CPrintToChatAll("{gold}Erm... seems like something's going wrong...");		
					}
					default:
					{
						CPrintToChatAll("{gold}Oh oh no- BE CAREFUL!!");
					}
				}
			}	
			else
			{	
				switch(GetRandomInt(1, 4))
				{
					case 1:
					{
						CPrintToChatAll("{gold}Aaah crap... here they come again...");
					}
					case 2:
					{
						CPrintToChatAll("{gold}Uh oh, get ready!");	
					}
					case 3:
					{
						CPrintToChatAll("{gold}Damnit... They just keep coming and coming!");		
					}
					default:
					{
						CPrintToChatAll("{gold}Aaaand- oh fudge.");
					}
				}
			}
		}
		else
		{
			if(enemy.Health)
			{
				if(StrContains(enemy.CustomName, "First ") != -1)
				{
					enemy.Health = RoundToCeil((HealthBonus + (enemy.Health * MultiGlobalHealth * HealthMulti * (((postWaves * 3) + 99) * 0.009))) * 0.5);
				}
				else
				{
					enemy.Health = RoundToCeil((enemy.Health * MultiGlobalHealth * HealthMulti * (((postWaves * 3) + 99) * 0.009)) * 0.5);
				}
			}
	
			count = RoundToFloor((count * (((postWaves * 1.5) + 80) * 0.03)) * 0.112);
		}

		if(EnemyBosses && !((enemy.Index + 1) % EnemyBosses))
		{
			enemy.Health = RoundToCeil(enemy.Health * 1.1);
			enemy.ExtraDamage *= 1.25;
			enemy.ExtraMeleeRes *= 0.9;
			enemy.ExtraRangedRes *= 0.9;
			enemy.ExtraSpeed *= 1.1;
		}

		if(ImmuneNuke && !(enemy.Index % ImmuneNuke))
			enemy.Is_Immune_To_Nuke = true;

		if(KillBonus)
			enemy.Credits += KillBonus;

		shouldscale = true;
	}

	if(alaxios)
	{
		enemy.Health = RoundToCeil(enemy.Health * 1.33);
		enemy.ExtraDamage *= 1.15;
	}

	if(shouldscale)
	{
		// count scaling
		float countscale = float(CountPlayersOnRed());
		if(countscale <= 4.0)
		{
			countscale *= 0.07; // below or equal to 4 players, scaling is 0.07 per player, to make low-player freeplay faster
		}
		else if(countscale > 4.0 && countscale <= 8.0) 
		{
			countscale *= 0.125; // above 4 players but below or equal to 8, scaling is 0.125 per player
		}
		else if(countscale > 8.0 && countscale <= 12.0) 
		{
			countscale = 1.0; // above 8 players but below or equal to 12, player scaling should not activate
		}
		else
		{
			countscale *= 0.0782; // above 12 players, scaling should be 0.0782 per player, for a max of +25% enemies at 16 players.
		}

		if(countscale < 0.1)
			countscale = 0.1; // minimum is 90% less enemies

		count = RoundToCeil(float(count) * countscale);
	}

	if(i_WaveHasFreeplay == 2)
	{
		if(count > 30)
			count = 30;
	}

	if(count < 1)
		count = 1;

	if(enemy.Is_Boss == 1)
		enemy.Health = RoundToCeil(float(enemy.Health) * 0.65);

	enemy.Health = RoundToCeil(float(enemy.Health) * FM_Health);

	float ExtraHpAdd;
	ExtraHpAdd = float(postWaves);
	ExtraHpAdd *= 0.075;
	if(ExtraHpAdd <= 1.0)
	{
		ExtraHpAdd = 1.0;
	}
	//Global HP increaser
	enemy.Health = RoundToCeil(float(enemy.Health) * ExtraHpAdd);

	// 2 billion limit, it is necessary to prevent them from going bananas
	if(enemy.Health > 2000000000)
		enemy.Health = 2000000000;

	if(enemy.Team != TFTeam_Red)
	{
		enemy.ExtraThinkSpeed *= ExtraAttackspeed;
		enemy.ExtraSize *= ExtraEnemySize;
	}
}

static Action Freeplay_RouletteMessage(Handle timer)
{
	RaidFight = GetRandomInt(1, 3);
	EmitSoundToAll("misc/halloween/spelltick_set.wav", _, _, _, _, _, GetRandomInt(70, 135));
	switch(RaidFight)
	{
		case 2:
		{
			switch(GetRandomInt(1, 6))
			{
				case 1:
				{
					CPrintToChatAll("{yellow}SILVESTER {white}& {darkblue}WALDCH! {gold}- {red}The better silv duo fight!");
				}
				case 2:
				{
					CPrintToChatAll("{darkblue}WALDCH {white}& {yellow}SILVESTER! {gold}- {red}Enjoy getting sniped from across the map!");
				}
				case 3:
				{
					CPrintToChatAll("{yellow}SILVESTER! {gold}- {red}and waldch, of course!");
				}
				case 4:
				{
					CPrintToChatAll("{darkblue}WALDCH! {gold}- {red}and silvester, of course!");
				}
				case 5:
				{
					CPrintToChatAll("{yellow}SILVESTER {white}& {darkblue}WALDCH! {gold}- {yellow}Hey thanks again for saving me from the Xeno infection, now beat Waldch and me in this simulation.");
				}
				/*case 6:
				{
					CPrintToChatAll("{yellow}SILVESTER {white}& {darkblue}WALDCH! {gold}- {red}Imagine if I added Sensal to this fight. That would be fun.");
				}*/
				default:
				{
					CPrintToChatAll("{yellow}SILVESTER {white}& {darkblue}WALDCH! {gold}- {red}Enjoy eating rocks!");
				}
			}
		}
		case 3:
		{
			switch(GetRandomInt(1, 3))
			{
				case 1:
				{
					CPrintToChatAll("{aqua}STELLA {white}& {crimson}KARLAS! {gold}- {red}Hope you like stella's laser of death!");
				}
				case 2:
				{
					CPrintToChatAll("{crimson}KARLAS {white}& {aqua}STELLA! {gold}- {red}oh hey Karlas, you here to watch. {crimson}*nods head* >:)");
				}
				/*case 3:
				{
					CPrintToChatAll("{aqua}STELLA {white}& {crimson}KARLAS! {gold}- {red}Now lets add one more elf to this, Twirl. Naaa I wont, maybe.");
				}*/
				default:
				{
					CPrintToChatAll("{crimson}KARLAS {white}& {aqua}STELLA! {gold}- {red}Hope you like dealing with all of karlas's swords!");
				}
			}
		}
		default:
		{
			switch(GetRandomInt(1, 2))
			{
				case 1:
				{
					CPrintToChatAll("{yellow}INFECTED SILVESTER! {gold}- {red}Wonder how the Xeno Infection bypassed his shield?");
				}
				default:
				{
					CPrintToChatAll("{yellow}INFECTED SILVESTER! {gold}- {red}An infected menace!");
				}
			}
		}
	}

	return Plugin_Continue;
}	

bool Freeplay_ShouldMiniBoss()
{
	float chance = MiniBossChance;
	int decrease = 10;
	Flagellant_MiniBossChance(decrease);
	if(decrease < 1)
		return true;

	chance *= float(10 / decrease);
	return (chance > GetURandomFloat());
}

void Freeplay_ApplyStatusEffect(int entity, const char[] name, float duration)
{
	float mult = 1.0;
	switch(FreeplayModifActive)
	{
		case INTENSE:
		{
			mult = 1.2;
		}
		case MUSCLE:
		{
			mult = 1.4;
		}
		case SQUEEZER:
		{
			mult = 2.0;
			if(squeezerplus)
				mult = 3.0;
		}
	}
	duration *= mult;
	ApplyStatusEffect(entity, entity, name, duration);
}

void Freeplay_SpawnEnemy(int entity)
{
	if(GetTeam(entity) != TFTeam_Red)
	{
		if(RandomStats)
		{
			if(GetRandomInt(0, 100) < 1) // 1% chance for this to work, it NEEDS to be extra rare.
			{
				SetEntProp(entity, Prop_Data, "m_iHealth", RoundToCeil(float(GetEntProp(entity, Prop_Data, "m_iHealth")) * GetRandomFloat(2.0, 8.0)));
				if(GetEntProp(entity, Prop_Data, "m_iHealth") < 0 || GetEntProp(entity, Prop_Data, "m_iHealth") > 2000000000)
					SetEntProp(entity, Prop_Data, "m_iHealth", 2000000000);
				SetEntProp(entity, Prop_Data, "m_iMaxHealth", GetEntProp(entity, Prop_Data, "m_iHealth"));
				SetEntPropFloat(entity, Prop_Send, "m_flModelScale", GetEntPropFloat(entity, Prop_Send, "m_flModelScale") * GetRandomFloat(0.1, 3.5));
				fl_Extra_MeleeArmor[entity] *= GetRandomFloat(0.1, 2.0);
				fl_Extra_RangedArmor[entity] *= GetRandomFloat(0.1, 2.0);
				fl_Extra_Speed[entity] *= GetRandomFloat(0.1, 3.0);
				fl_Extra_Damage[entity] *= GetRandomFloat(0.5, 6.0);
				f_AttackSpeedNpcIncrease[entity] *= GetRandomFloat(0.4, 1.5);

				// this works if you want to make them stalkers!!!!!!
				if(GetRandomInt(0, 1) == 1)
				{
					b_StaticNPC[entity] = true;
					AddNpcToAliveList(entity, 1);
					b_NoHealthbar[entity] = 1; //Makes it so they never have an outline
					GiveNpcOutLineLastOrBoss(entity, false);
					b_thisNpcHasAnOutline[entity] = true;
				}
	
				switch(GetRandomInt(1, 6))
				{
					case 1:
					{
						CPrintToChatAll("{crimson}HAVE AT THEE!!");
					}
					case 2:
					{
						CPrintToChatAll("{crimson}FACE THIS!!");
					}
					case 3:
					{
						CPrintToChatAll("{crimson}HOW'S THIS FOR A SURPRISE!?");
					}
					case 5:
					{
						CPrintToChatAll("{crimson}BOO!!!!");
					}
					case 6:
					{
						CPrintToChatAll("{crimson}ENGAGE!!!");
					}
					default:
					{
						CPrintToChatAll("{crimson}GET A LOAD OF THIS GUY!!");
					}
				}
	
				RandomStats--;
				EmitSoundToAll("misc/halloween/hwn_bomb_flash.wav", _, _, _, _, _, GetRandomInt(75, 135));
				if(b_thisNpcIsARaid[entity])
				{
					char thename[64];
					NPC_GetNameById(entity, thename, sizeof(thename));
					CPrintToChatAll("{orange}Uh oh... you got a {yellow}%s {orange}with randomized stats.", thename);
					CPrintToChatAll("{orange}Bad luck!");
				}
			}
		}

		if(!b_thisNpcIsARaid[entity])
		{
			fl_Extra_Damage[entity] *= 1.0 + ((float(Waves_GetRoundScale() - 59)) * 0.02);
		}
		else
		{
			fl_Extra_Damage[entity] *= 1.0 + ((float(Waves_GetRoundScale() - 59)) * 0.01);
		}

		fl_Extra_Damage[entity] *= FM_Damage;
	
		//// BUFFS ////

		if(EloquenceBuffEnemies == 1)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Eloquence I", 30.0);

		if(EloquenceBuffEnemies == 2)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Eloquence II", 20.0);	

		if(EloquenceBuffEnemies == 3)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Eloquence III", 10.0);	

		if(RampartBuffEnemies == 1)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Rampart I", 30.0);

		if(RampartBuffEnemies == 2)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Rampart II", 20.0);	

		if(RampartBuffEnemies == 3)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Rampart III", 10.0);

		if(HurtleBuffEnemies == 1)
			Freeplay_ApplyStatusEffect( entity, "Freeplay Hurtle I", 30.0);

		if(HurtleBuffEnemies == 2)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Hurtle II", 20.0);	

		if(HurtleBuffEnemies == 3)
			Freeplay_ApplyStatusEffect(entity, "Freeplay Hurtle III", 10.0);
	
		if(FusionBuff > 1)
			Freeplay_ApplyStatusEffect(entity, "Self Empowerment", 30.0);	
	
		if(FusionBuff > 0)
			Freeplay_ApplyStatusEffect(entity, "Ally Empowerment", 30.0);	
	
		if(OceanBuff > 1)
			Freeplay_ApplyStatusEffect(entity, "Oceanic Scream", 30.0);	
	
		if(OceanBuff > 0)
			Freeplay_ApplyStatusEffect(entity, "Oceanic Singing", 30.0);	
	
		if(VoidBuff > 1)
			Freeplay_ApplyStatusEffect(entity, "Void Strength II", 12.0);
	
		if(VoidBuff > 0)
			Freeplay_ApplyStatusEffect(entity, "Void Strength I", 6.0);
	
		if(VoidAfflictedBuff)
			Freeplay_ApplyStatusEffect(entity, "Void Afflicted", 20.0);

		if(VestaBuff)
			Freeplay_ApplyStatusEffect(entity, "Call To Vesta", 10.0);	

		if(LoveNahTonic)
		{
			Freeplay_ApplyStatusEffect(entity, "Tonic Affliction", 8.0);
			Freeplay_ApplyStatusEffect(entity, "Tonic Affliction Hide", 8.0);
		}

		if(XenoLabBuff)
			Freeplay_ApplyStatusEffect(entity, "Xeno's Territory", 20.0);	

		if(SeaLabBuff)
			Freeplay_ApplyStatusEffect(entity, "Corrupted Godly Power", 20.0);	
	
		//// DEBUFFS ////
	
		if(SilenceDebuff)
			ApplyStatusEffect(entity, entity, "Silenced", 10.0);
	
		if(ProsperityDebuff > 2)
			ApplyStatusEffect(entity, entity, "Prosperity III", 999999.0);	
	
		if(ProsperityDebuff > 1)
			ApplyStatusEffect(entity, entity, "Prosperity II", 999999.0);	
	
		if(ProsperityDebuff > 0)
			ApplyStatusEffect(entity, entity, "Prosperity I", 999999.0);	
	
		if(StrangleDebuff > 2)
			ApplyStatusEffect(entity, entity, "Stranglation III", 999999.0);	
	
		if(StrangleDebuff > 1)
			ApplyStatusEffect(entity, entity, "Stranglation II", 999999.0);	
	
		if(StrangleDebuff > 0)
			ApplyStatusEffect(entity, entity, "Stranglation I", 999999.0);	
	
		if(IceDebuff > 2)
			ApplyStatusEffect(entity, entity, "Near Zero", 999999.0);	
	
		if(IceDebuff > 1)
			ApplyStatusEffect(entity, entity, "Cryo", 999999.0);	
	
		if(IceDebuff > 0)
			ApplyStatusEffect(entity, entity, "Freeze", 999999.0);	
	
		if(TeslarDebuff > 1)
			ApplyStatusEffect(entity, entity, "Teslar Electricution", 999999.0);	
	
		if(TeslarDebuff > 0)
			ApplyStatusEffect(entity, entity, "Teslar Shock", 999999.0);	
	
		if(SpecialistDebuff > 2)
			ApplyStatusEffect(entity, entity, "Molecular Collapse", 999999.0);	
	
		if(SpecialistDebuff > 1)
			ApplyStatusEffect(entity, entity, "Cellular Breakdown", 999999.0);	
	
		if(SpecialistDebuff > 0)
			ApplyStatusEffect(entity, entity, "Hypodermic Toxin Injection", 999999.0);	
	
		if(CrippleDebuff > 0)
		{
			ApplyStatusEffect(entity, entity, "Cripple", 999999.0);	
			CrippleDebuff--;
		}
	
		if(CudgelDebuff > 0)
		{
			ApplyStatusEffect(entity, entity, "Cudgelled", 999999.0);	
			CudgelDebuff--;
		}
	
		// OTHER //
		switch(PerkMachine)
		{
			case 1:
			{
				fl_Extra_MeleeArmor[entity] *= 0.8;
				fl_Extra_RangedArmor[entity] *= 0.8;
				SetEntProp(entity, Prop_Data, "m_iHealth", RoundToCeil(GetEntProp(entity, Prop_Data, "m_iHealth") * 1.15));
			}
			case 2:
			{
				fl_Extra_Damage[entity] *= 1.35;
			}
			case 3:
			{
				fl_Extra_Damage[entity] *= 1.15;
			}
			case 4:
			{
				ApplyStatusEffect(entity, entity, "Fluid Movement", 999999.0);		
			}
		}
		fl_Extra_Speed[entity] *= SpeedMult;
		fl_Extra_MeleeArmor[entity] *= MeleeMult;
		fl_Extra_RangedArmor[entity] *= RangedMult;
	}
}

static Action activatebuffs(Handle timer)
{
	if(FreeplayBuffTimer <= 0)
	{
		FreeplayBuffTimer = 1;
		CreateTimer(2.0, Freeplay_BuffTimer, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

static Action Freeplay_BuffTimer(Handle Freeplay_BuffTimer)
{
	if(FreeplayBuffTimer <= 0)
	{
		return Plugin_Stop;
	}

	for (int client = 1; client <= MaxClients; client++)
	{
		if(IsValidClient(client) && IsPlayerAlive(client))
		{
			if(CheesyPresence)
			{
				ApplyStatusEffect(client, client, "Cheesy Presence", 5.0);
			}
			else
			{
				/*
				if(Items_HasNamedItem(client, "A Block of Cheese"))
					ApplyStatusEffect(client, client, "Cheesy Presence", 5.0);
				*/
			}

			switch(EloquenceBuff)
			{
				case 1:
				{
					ApplyStatusEffect(client, client, "Freeplay Eloquence I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(client, client, "Freeplay Eloquence II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(client, client, "Freeplay Eloquence III", 5.0);
				}
			}

			switch(RampartBuff)
			{
				case 1:
				{
					ApplyStatusEffect(client, client, "Freeplay Rampart I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(client, client, "Freeplay Rampart II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(client, client, "Freeplay Rampart III", 5.0);
				}
			}

			switch(HurtleBuff)
			{
				case 1:
				{
					ApplyStatusEffect(client, client, "Freeplay Hurtle I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(client, client, "Freeplay Hurtle II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(client, client, "Freeplay Hurtle III", 5.0);
				}
			}
		}
	}
	for(int entitycount_again; entitycount_again<i_MaxcountNpcTotal; entitycount_again++)
	{
		int ally = EntRefToEntIndexFast(i_ObjectsNpcsTotal[entitycount_again]);
		if (IsValidEntity(ally) && !b_NpcHasDied[ally] && GetTeam(ally) == TFTeam_Red)
		{
			if(CheesyPresence)
				ApplyStatusEffect(ally, ally, "Cheesy Presence", 5.0);

			switch(EloquenceBuff)
			{
				case 1:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Eloquence I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Eloquence II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Eloquence III", 5.0);
				}
			}

			switch(RampartBuff)
			{
				case 1:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Rampart I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Rampart II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Rampart III", 5.0);
				}
			}

			switch(HurtleBuff)
			{
				case 1:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Hurtle I", 5.0);
				}
				case 2:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Hurtle II", 5.0);
				}
				case 3:
				{
					ApplyStatusEffect(ally, ally, "Freeplay Hurtle III", 5.0);
				}
			}
		}
	}

	return Plugin_Continue;
}

void Freeplay_OnEndWave(int &cash)
{
	switch(FreeplayModifActive)
	{
		case INTENSE:
		{
			FM_Damage *= 1.005;
		}
		case MUSCLE:
		{
			FM_Damage *= 1.0075;
		}
		case SQUEEZER:
		{
			FM_Damage *= 1.01;
			if(squeezerplus)
				FM_Damage *= 1.02;
		}
	}

	switch(FreeplayModifActive)
	{
		case INTENSE:
		{
			FM_Health *= 1.0035;
		}
		case MUSCLE:
		{
			FM_Health *= 1.0075;
		}
		case SQUEEZER:
		{
			FM_Health *= 1.0125;
			if(squeezerplus)
				FM_Health *= 1.02;
		}
	}

	if(ExplodingNPC)
	{
		CPrintToChatAll("{lime}Enemies will no longer explode.");
		ExplodingNPC = false;
		IsExplodeWave = false;
	}
	
	cash += CashBonus;
	int extracash = RoundToCeil(Freeplay_GetRemainingCash());
	if(extracash > 0)
	{
		cash += extracash;
	}

	Freeplay_SetRemainingCash(583.0);
	Freeplay_SetCashTime(GetGameTime() + 20.0);
}

float Freeplay_SetupValues()
{
	return gay;
}
void Freeplay_SetupStart(bool extra = false)
{
	if(i_WaveHasFreeplay != 2)
		return;

	bool guaranteedraid = false;
	if(extra)
	{
		FreeplayBuffTimer = 0;
		CreateTimer(4.0, activatebuffs, _, TIMER_FLAG_NO_MAPCHANGE);

		setuptimes--;
		if(setuptimes <= 0)
		{
			guaranteedraid = true;
			setuptimes = 3;
		}

		if(!guaranteedraid)
		{
			EmitSoundToAll("ui/vote_success.wav");
		}
		
		int skullamount = 1;
		switch(FreeplayModifActive)
		{
			case INTENSE:
			{
				skullamount = 2;
			}
			case MUSCLE:
			{
				skullamount = 3;
			}
			case SQUEEZER:
			{
				skullamount = 4;
				if(squeezerplus)
					skullamount = 6;
			}
		}
		if(ExtraSkulls < 2)
		{
			ExtraSkulls += skullamount;
			CPrintToChatAll("{yellow}Current skull count: {orange}%d", ExtraSkulls+1);
		}
		

		SkullTimes = ExtraSkulls;
	}

	static int RerollTry;

	int rand = 6;
	if((++RerollTry) < 12)
		rand = GetURandomInt() % 73;
	
	if(guaranteedraid)
	{
		EmitSoundToAll("music/mvm_class_select.wav");
		EmitSoundToAll("items/powerup_pickup_king.wav");
		CPrintToChatAll("{strange}--==({gold}RAID ROULETTE!!{strange})==--");
		CPrintToChatAll("{gold}--==({strange}LET THOU FATE BE RANDOMIZED!{gold})==--");
		CPrintToChatAll("{green}-=({lime}Winning this wave will reward you with 5000 extra credits.{green})=-");
		CreateTimer(5.0, Freeplay_RouletteMessage, _, TIMER_FLAG_NO_MAPCHANGE);

		switch(GetRandomInt(1, 12))
		{
			case 1:
			{
				CPrintToChatAll("{gold}Koshi{white}: Ooh, this is gonna be {crimson}funny... {white}Now, you'll fight...");
			}
			case 2:
			{
				CPrintToChatAll("{gold}Koshi{white}: Aah, perfect! {orange}This was gettin' a little boring. {white}I'll send in...");
			}
			case 3:
			{
				CPrintToChatAll("{gold}Koshi{white}: Todaaaay's punching bag will be.... {crimson}hehe...");
			}
			case 4:
			{
				CPrintToChatAll("{gold}Koshi{white}: The {orange}RAID ROULETTE {white}has chosen your fate, {crimson}and rolled...");
			}
			case 5:
			{
				CPrintToChatAll("{lightcyan}Zeina{white}: The enemy you'll be getting is...");
			}
			case 6:
			{
				CPrintToChatAll("{lightcyan}Zeina{white}: The ''raid roulette'' has rolled...");
			}
			case 7:
			{
				CPrintToChatAll("{lightcyan}Zeina{white}: Your next fight will be against...");
			}
			case 8:
			{
				CPrintToChatAll("{lightcyan}Zeina{white}: This next wave you will fight...");
			}
			case 9:
			{
				CPrintToChatAll("{blue}Sensal{white}: The next enemy you will face is...");
			}
			case 10:
			{
				CPrintToChatAll("{yellow}Silvester{white}: Hmm.. The simulation will send...");
			}
			case 11:
			{
				CPrintToChatAll("{lightblue}Nemal{white}: Oooooo. Oh! Oh! Ummm the simulation is about to send...");
			}
			default:
			{
				CPrintToChatAll("{gold}Koshi{white}: Oh, nice! An interesting event...");
			}
		}
		gay = 10.0;
	}
	else
	{
		gay = 0.0;
		char message[128];
		switch(rand)
		{
			/// HEALTH SKULLS ///
			case 0:
			{
				strcopy(message, sizeof(message), "{red}All enemies now have 2500 more health!");
				HealthBonus += 2500;
			}
			case 1:
			{
				strcopy(message, sizeof(message), "{red}All enemies now have 5000 more health!");
				HealthBonus += 5000;
			}
			case 2:
			{
				strcopy(message, sizeof(message), "{red}All enemies now have 5% more health!");
				HealthMulti *= 1.05;
			}
			case 3:
			{
				strcopy(message, sizeof(message), "{red}All enemies now have 10% more health!");
				HealthMulti *= 1.1;
			}
			case 4:
			{
				strcopy(message, sizeof(message), "{green}All enemies now have 5% less health.");
				HealthMulti *= 0.95;
			}
			case 5:
			{
				strcopy(message, sizeof(message), "{green}All enemies now have 2.5% less health.");
				HealthMulti *= 0.975;
			}

			/// BUFF/DEBUFF SKULLS //
			case 6:
			{
				strcopy(message, sizeof(message), "{darkgray}Nothing happend, probably a good thing...");
				/*
				if(EscapeModeForNpc)
				{
					strcopy(message, sizeof(message), "{green}Weaker enemies lose the given extra speed and damage from before.");
					EscapeModeForNpc = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}Weaker enemies now gain extra speed and damage!");
					EscapeModeForNpc = true;
				}
				*/
			}
			case 7:
			{
				if(IceDebuff > 3)
				{
					strcopy(message, sizeof(message), "{red}All enemies have lost the Cryo debuff!");
					IceDebuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies now gain a layer of Cyro debuff.");
					IceDebuff++;
				}
			}
			case 8:
			{
				if(TeslarDebuff > 1)
				{
					strcopy(message, sizeof(message), "{red}All enemies have lost the Teslar debuff!");
					TeslarDebuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies now gain a layer of Teslar debuff.");
					TeslarDebuff++;
				}
	
			}
			case 9:
			{
				if(FusionBuff > 2)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Fusion buff.");
					FusionBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of Fusion buff!");
					FusionBuff++;
				}
				
			}
			case 10:
			{
				if(OceanBuff > 1)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Ocean buff.");
					OceanBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of Ocean buff!");
					OceanBuff++;
				}
			}
			case 11:
			{
				strcopy(message, sizeof(message), "{green}The next 400 enemies will now gain the Crippled debuff.");
				CrippleDebuff += 400;
			}
			case 12:
			{
				strcopy(message, sizeof(message), "{green}The next 400 enemies will now gain the Cudgel debuff.");
				CudgelDebuff += 400;
			}
			case 13:
			{
				RandomStats += GetRandomInt(3, 6);
				strcopy(message, sizeof(message), "{red}A random amount of random enemies will randomly receive randomized stats randomly!");
			}
			case 14:
			{
				if(SpecialistDebuff > 3)
				{
					strcopy(message, sizeof(message), "{red}All enemies have lost the Cellular Breakdown debuff!");
					SpecialistDebuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies now gain a layer of Cellular Breakdown debuff.");
					SpecialistDebuff++;
				}
			}
			case 15:
			{
				if(VoidAfflictedBuff)
				{
					strcopy(message, sizeof(message), "{green}All enemies are now not Void Afflicted, besides the already void afflicted enemies.");
					VoidAfflictedBuff = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now are now Void Afflicted!");
					VoidAfflictedBuff = true;
				}
			}
	
			/// CREDIT SKULLS //
			case 16:
			{
				strcopy(message, sizeof(message), "{green}All enemies now give out 5 extra credits on death.");
				KillBonus += 5;
			}
			case 17:
			{
				if(KillBonus < 1)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}Reduced the credit per enemy kill by 1!");
				KillBonus--;
			}
			case 18:
			{
				if(CashBonus < 50)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}Reduced extra credits gained per wave by 50!");
				CashBonus -= 50;
			}
			case 19:
			{
				strcopy(message, sizeof(message), "{green}You now gain 200 extra credits per wave.");
				CashBonus += 200;
			}
	
			/// PERK SKULLS ///
			case 20:
			{
				if(PerkMachine == 1)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}All enemies are now using the Obsidian Oaf perk, And thus gain +20% resist and +15% HP!");
				PerkMachine = 1;
			}
			case 21:
			{
				if(PerkMachine == 2)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}All enemies are now using the Morning Coffee perk, And thus gain 35% Extra Damage!");
				PerkMachine = 2;
			}
			case 22: // YOUR ATTEMPTS AT DEATH ARE IN, VAIN
			{
				if(PerkMachine == 3)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}All enemies are now using the Marksman Beer perk, and thus gain 15% Extra Damage!");
				PerkMachine = 3;
			}
			case 23:
			{
				if(PerkMachine == 4)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}All enemies are now using the Hasty Hops perk, and thus cannot be slowed!");
				PerkMachine = 4;
			}
			case 24:
			{
				if(PerkMachine == 0)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{green}All enemies are now using the Regene Berry perk, this is useless and removes their previous perk.");
				PerkMachine = 0;
			}
	
			/// MISCELANEOUS SKULLS ///
			case 25:
			{
				if(friendunit)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{green}You will gain a strong, friendly unit.");
				friendunit = true;
			}
			case 26:
			{
				strcopy(message, sizeof(message), "{red}Mini-boss spawn rate has been multiplied by 25%!");
				MiniBossChance *= 1.25;
			}
			case 27:
			{
				if(EnemyBosses == 1)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}Some enemy types now gain extra stats!");
				if(EnemyBosses)
				{
					EnemyBosses--;
				}
				else
				{
					EnemyBosses = 6;
				}
			}
			case 28:
			{
				if(ImmuneNuke == 1)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{red}Some enemy types are now immune to the Nuke Powerup!");
				if(ImmuneNuke)
				{
					ImmuneNuke--;
				}
				else
				{
					ImmuneNuke = 4;
				}
			}
			case 29:
			{
				//if(EnemyChance > 8)
				//{
				//	Freeplay_SetupStart();
				//	return;
				//}
	
				strcopy(message, sizeof(message), "{red}Stronger enemy types are now more likely to appear!");
				EnemyChance++;
			}
			case 30:
			{
				if(EnemyChance < 3)
				{
					Freeplay_SetupStart();
					return;
				}
	
				strcopy(message, sizeof(message), "{green}Stronger enemy types are now less likely to appear.");
				EnemyChance--;
			}
	
			/// SAMU'S SKULLS (new!) ///
			case 31:
			{
				strcopy(message, sizeof(message), "{green}Enemies will now take 15% more melee damage.");
				MeleeMult += 0.15;
			}
			case 32:
			{
				strcopy(message, sizeof(message), "{green}Enemies will now take 20% more melee damage.");
				MeleeMult += 0.2;
			}
			case 33:
			{
				if(MeleeMult < 0.01) // 95% melee res max
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Enemies will now take 10% less melee damage.");
				MeleeMult -= 0.1;
				if(MeleeMult < 0.01)
				{
					MeleeMult = 0.01;
				}
			}
			case 34:
			{
				if(MeleeMult < 0.01)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Enemies will now take 15% less melee damage.");
				MeleeMult -= 0.15;
				if(MeleeMult < 0.01)
				{
					MeleeMult = 0.01;
				}
			}
			case 35:
			{
				strcopy(message, sizeof(message), "{green}Enemies will now take 15% more ranged damage.");
				RangedMult += 0.15;
			}
			case 36:
			{
				strcopy(message, sizeof(message), "{green}Enemies will now take 20% more ranged damage.");
				RangedMult += 0.2;
			}
			case 37:
			{
				strcopy(message, sizeof(message), "{red}Enemy attackspeed has been multiplied by x0.9!");
				ExtraAttackspeed *= 0.9;
			}
			case 38:
			{
				strcopy(message, sizeof(message), "{green}Enemy attackspeed has been reduced by an additional 5%.");
				ExtraAttackspeed += 0.05;
			}
			case 39:
			{
				if(RangedMult < 0.01) // 95% ranged res max
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Enemies will now take 10% less ranged damage.");
				RangedMult -= 0.1;
				if(RangedMult < 0.01)
				{
					RangedMult = 0.01;
				}
			}
			case 40:
			{
				if(RangedMult < 0.01)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Enemies will now take 15% less ranged damage.");
				RangedMult -= 0.15;
				if(RangedMult < 0.01)
				{
					RangedMult = 0.01;
				}
			}
			case 41, 42:
			{
				if(ExplodingNPC)
				{
					Freeplay_SetupStart();
					return;
				}
				ExplodeNPCDamage = GetRandomInt(25, 125);
				strcopy(message, sizeof(message), "{red}Now, enemies will explode on death!");
				ExplodingNPC = true;
				EmitSoundToAll("ui/mm_medal_silver.wav");
			}
			
			case 43:
			{
				if(VoidBuff > 2)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Void buff.");
					VoidBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of the Void buff!");
					VoidBuff++;
				}
			}
			case 44:
			{
				if(VestaBuff)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Call to Vesta buff.");
					VestaBuff = false;
					SpeedMult += 0.15;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain the Call to Vesta buff!");
					VestaBuff = true;
					SpeedMult -= 0.15;
				}
			}
			case 45:
			{
				if(StrangleDebuff > 3)
				{
					strcopy(message, sizeof(message), "{red}All enemies have lost the Stranglation debuff!");
					StrangleDebuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies now gain a layer of the Stranglation debuff.");
					StrangleDebuff++;
				}
			}
			case 46:
			{
				if(ProsperityDebuff > 3)
				{
					strcopy(message, sizeof(message), "{red}All enemies have lost the Prosperity debuff!");
					ProsperityDebuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies now gain a layer of the Prosperity debuff.");
					ProsperityDebuff++;
				}
			}
			case 47:
			{
				if(SilenceDebuff)
				{
					strcopy(message, sizeof(message), "{red}All enemies have been Unsilenced!");
					SilenceDebuff = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All enemies are now silenced for 10 seconds after spawning.");
					SilenceDebuff = true;
				}
			}
			case 48:
			{
				// 25% chance, otherwise retry.
				if(GetRandomFloat(0.0, 1.0) <= 0.25)
				{
					strcopy(message, sizeof(message), "{green}A new special weapon is now available for purchase!");
					Rogue_RareWeapon_Collect();
				}
				else
				{
					Freeplay_SetupStart();
					return;
				}
			}
			case 49:
			{
				if(CheesyPresence)
				{
					strcopy(message, sizeof(message), "{red}You no longer feel a {orange}Cheesy Presence {red}around you.");
					CheesyPresence = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}You start to feel a {orange}Cheesy Presence {green}around you...");
					CheesyPresence = true;
				}
			}
			case 50:
			{
				if(EloquenceBuff > 2)
				{
					strcopy(message, sizeof(message), "{red}Removed the Eloquence buff from everyone!");
					EloquenceBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All players and allied npcs now gain a layer of the Eloquence buff.");
					EloquenceBuff++;
				}
			}
			case 51:
			{
				if(RampartBuff > 2)
				{
					strcopy(message, sizeof(message), "{red}Removed the Rampart buff from everyone!");
					RampartBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All players and allied npcs now gain a layer of the Rampart buff.");
					RampartBuff++;
				}
			}
			case 52:
			{
				if(zombiecombine)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Hey, im thinking of something.... What if, a {gold}combine, {red}and a {gold}zombie, {red}were...");
				zombiecombine = true;
			}
			case 53:
			{
				if(moremen)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}III THINK YOU NEED MORE MEN!!!");
				moremen = 1;
			}
			case 54:
			{
				if(immutable)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{purple}Otherworldly beings approach from a dimensional rip...");
				immutable = true;
			}
			case 55:
			{
				if(EloquenceBuffEnemies > 2)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Eloquence Buff.");
					EloquenceBuffEnemies = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of the Eloquence buff.");
					EloquenceBuffEnemies++;
				}
			}
			case 56:
			{
				if(RampartBuffEnemies > 2)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Rampart Buff.");
					RampartBuffEnemies = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of the Rampart buff!");
					RampartBuffEnemies++;
				}
			}
			case 57:
			{
				if(HurtleBuffEnemies > 2)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Hurtle Buff.");
					HurtleBuffEnemies = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain a layer of the Hurtle buff!");
					HurtleBuffEnemies++;
				}
			}
			case 58:
			{
				if(HurtleBuff > 2)
				{
					strcopy(message, sizeof(message), "{red}Removed the Hurtle buff from everyone!");
					HurtleBuff = 0;
				}
				else
				{
					strcopy(message, sizeof(message), "{green}All players and allied npcs now gain a layer of the Hurtle buff.");
					HurtleBuff++;
				}
			}
			case 59:
			{
				if(LoveNahTonic)
				{
					strcopy(message, sizeof(message), "{green}Ok, that's enough Tonic...");
					LoveNahTonic = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{pink}Love is in the air? {crimson}WRONG! {red}Tonic Affliction in the enemies.");
					LoveNahTonic = true;
				}
			}
			case 60:
			{
				strcopy(message, sizeof(message), "{yellow}Y'know what? I'll throw in another extra skull.");
				ExtraSkulls++;
			}
			case 61:
			{
				strcopy(message, sizeof(message), "{yellow}Y'know what? I'll throw in another extra skull.");
				ExtraSkulls++;
			//	strcopy(message, sizeof(message), "{yellow}Actually, y'know what? Maybe i'll throw in TWO extra skulls even.");
			//	ExtraSkulls += 2;
			}
			case 62:
			{
				strcopy(message, sizeof(message), "{yellow}Y'know what? I'll throw in another extra skull.");
				ExtraSkulls++;
			//	strcopy(message, sizeof(message), "{red}ffffFFFFF-{crimson}FUCK {red}it, THREE EXTRA SKULLS!!!");
			//	ExtraSkulls += 3;
			}
			case 63:
			{
				if(Schizophrenia)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}As you pick this skull, you begin to hear voices in your head...");
				Schizophrenia = true;
			}
			case 64:
			{
				if(DarknessComing)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}THE DARKNESS IS COMING! {crimson}YOU NEED TO RUN!!");
				DarknessComing = true;
			}
			case 65:
			{
				if(thespewer)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Your final challenge.... a {crimson}Nourished Spewer!");
				thespewer = true;
			}
			case 66:
			{
				if(friendunit)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{green}You will gain a strong, friendly unit.");
				friendunit = true;
			}
			case 67:
			{
				if(portalgalore)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Here's a gift from {purple}Unspeakable{red}. {purple}Five Hundred Void Portals!!");
				portalgalore = true;
			}
			case 68:
			{
				if(refragportal)
				{
					Freeplay_SetupStart();
					return;
				}
				strcopy(message, sizeof(message), "{red}Here's a gift from {darkblue}C.H.I.M.E.R.A.{red}. {darkblue}Five Hundred Portal Gate!");
				refragportal = true;
			}
			case 69:
			{
				if(XenoLabBuff)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Xeno's Territory buff.");
					XenoLabBuff = false;
					SpeedMult += 0.15;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain the Xeno's Territory buff!");
					XenoLabBuff = true;
					SpeedMult -= 0.15;
				}
			}
			case 71:
			{
				if(SeaLabBuff)
				{
					strcopy(message, sizeof(message), "{green}All enemies have lost the Corrupted Godly Power buff.");
					SeaLabBuff = false;
				}
				else
				{
					strcopy(message, sizeof(message), "{red}All enemies now gain the Corrupted Godly Power buff!");
					SeaLabBuff = true;
				}
			}
			case 72:
			{
				if(VoidAfflictedBuff)
				{
					strcopy(message, sizeof(message), "{green}All enemies are now not Void Afflicted, besides the already void afflicted enemies.");
					VoidAfflictedBuff = false;
				}
				else
				{
					Freeplay_SetupStart();
					return;
				}
			}
			//case 72:
			//{
				//if(sigmaller)
				//{
					//Freeplay_SetupStart();
					//return;
				//}
				//strcopy(message, sizeof(message), "{red}Holy smokes, it's him. {crimson}The SIGMALLER!");
				//sigmaller = true;
			//}
			default:
			{
				strcopy(message, sizeof(message), "{yellow}Nothing!");
				// If this shows up, FIX YOUR CODE :)
			}	
		}

		RerollTry = 0;
		CPrintToChatAll("{orange}New Skull{default}: %s", message);

		if(ExplodingNPC && !IsExplodeWave)
		{
			CPrintToChatAll("{yellow}The exploding enemy skull lasts 1 wave. | Current Base damage: %d", ExplodeNPCDamage);
			IsExplodeWave = true;
		}
		if(SkullTimes > 0)
		{
			SkullTimes--;
			Freeplay_SetupStart();
		}
	}
}
