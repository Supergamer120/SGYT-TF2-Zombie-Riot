#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"vo/heavy_paincrticialdeath01.mp3",
	"vo/heavy_paincrticialdeath02.mp3",
	"vo/heavy_paincrticialdeath03.mp3",
};

static const char g_HurtSounds[][] = {
	"vo/heavy_painsharp01.mp3",
	"vo/heavy_painsharp02.mp3",
	"vo/heavy_painsharp03.mp3",
	"vo/heavy_painsharp04.mp3",
	"vo/heavy_painsharp05.mp3",
};
static const char g_IdleAlertedSounds[][] = {
	"vo/taunts/heavy_taunts16.mp3",
	"vo/taunts/heavy_taunts18.mp3",
	"vo/taunts/heavy_taunts19.mp3",
};

static const char g_MeleeAttackSounds[][] = {
	"weapons/cleaver_throw.wav",
};
static const char g_HealSound[][] = {
	"items/medshot4.wav",
};



void Sahmir_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds)); i++) { PrecacheSound(g_MeleeAttackSounds[i]); }
	for (int i = 0; i < (sizeof(g_HealSound)); i++) { PrecacheSound(g_HealSound[i]); }

	NPCData data;
	strcopy(data.Name, sizeof(data.Name), "Sahmir");
	strcopy(data.Plugin, sizeof(data.Plugin), "npc_sahmir");
	strcopy(data.Icon, sizeof(data.Icon), "sniper_camper_1");
	data.IconCustom = true;
	data.Flags = 0;
	data.Category = Type_Interitus;
	data.Func = ClotSummon;
	int id = NPC_Add(data);
	Rogue_Paradox_AddWinterNPC(id);
}


static any ClotSummon(int client, float vecPos[3], float vecAng[3], int team)
{
	return Sahmir(vecPos, vecAng, team);
}
methodmap Sahmir < CClotBody
{
	public void PlayIdleAlertSound() 
	{
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
	}
	
	public void PlayHurtSound() 
	{
		if(this.m_flNextHurtSound > GetGameTime(this.index))
			return;
			
		this.m_flNextHurtSound = GetGameTime(this.index) + 0.4;
		
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
		
	}
	
	public void PlayDeathSound() 
	{
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
	}
	
	public void PlayMeleeSound()
	{
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
	}
	public void PlayHealSound() 
	{
		EmitSoundToAll(g_HealSound[GetRandomInt(0, sizeof(g_HealSound) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME - 0.1, 110);

	}
	
	
	public Sahmir(float vecPos[3], float vecAng[3], int ally)
	{
		Sahmir npc = view_as<Sahmir>(CClotBody(vecPos, vecAng, "models/player/heavy.mdl", "1.0", "10000", ally));
		
		i_NpcWeight[npc.index] = 1;
		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		SetVariantInt(2);
		AcceptEntityInput(npc.index, "SetBodyGroup");
		

		func_NPCDeath[npc.index] = view_as<Function>(Sahmir_NPCDeath);
		func_NPCOnTakeDamage[npc.index] = view_as<Function>(Sahmir_OnTakeDamage);
		func_NPCThink[npc.index] = view_as<Function>(Sahmir_ClotThink);
		
		
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;	
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		
		
		
		npc.StartPathing();
		npc.m_flSpeed = 25	0.0;
		Is_a_Medic[npc.index] = true;
		
		
		int skin = (ally==TFTeam_Red&&ZR_Get_Modifier()!=2 ? 0 : 1);
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);
		

		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_knife/c_knife.mdl");
		SetVariantString("1.2");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("head", "models/workshop/player/items/heavy/sbox2014_leftover_trap/sbox2014_leftover_trap.mdl");

		npc.m_iWearable3 = npc.EquipItem("head", "models/workshop/player/items/heavy/sbox2014_trash_man/sbox2014_trash_man.mdl");

		npc.m_iWearable4 = npc.EquipItem("head", "models/workshop/player/items/heavy/hwn2025_poncho/hwn2025_poncho.mdl");
	

		SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable3, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable4, Prop_Send, "m_nSkin", skin);
		return npc;
	}
}

public void Sahmir_ClotThink(int iNPC)
{
	Sahmir npc = view_as<Sahmir>(iNPC);
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	npc.Update();

	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.m_blPlayHurtAnimation = false;
		npc.PlayHurtSound();
	}
	
	if(npc.m_flNextThinkTime > GetGameTime(npc.index))
	{
		return;
	}
	npc.m_flNextThinkTime = GetGameTime(npc.index) + 0.1;

	if(npc.m_iTargetAlly && !IsValidAlly(npc.index, npc.m_iTargetAlly))
		npc.m_iTargetAlly = 0;
	
	if(!npc.m_iTargetAlly || npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		npc.m_iTargetAlly = GetClosestAlly(npc.index);
		if(npc.m_iTargetAlly < 1)
		{
			npc.m_iTargetAlly = GetClosestTarget(npc.index);
		}
		
		if(npc.m_iTargetAlly > 0)
		{
			float vecTarget[3]; WorldSpaceCenter(npc.m_iTargetAlly, vecTarget );
			float VecSelfNpc[3]; WorldSpaceCenter(npc.index, VecSelfNpc);
			float flDistanceToTarget = GetVectorDistance(vecTarget, VecSelfNpc, true);
			
			if(flDistanceToTarget > (100.0*100.0))
			{
				npc.StartPathing();
				if(flDistanceToTarget < npc.GetLeadRadius()) 
				{
					float vPredictedPos[3]; PredictSubjectPosition(npc, npc.m_iTargetAlly,_,_,vPredictedPos );
					npc.SetGoalVector(vPredictedPos);
				}
				else 
				{
					npc.SetGoalEntity(npc.m_iTargetAlly);
				}
			}
			else
			{
				npc.StopPathing();
			}
		}
		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + 1.0;
	}
	SahmirSelfDefense(npc,GetGameTime(npc.index)); 
}

void SahmirSelfDefense(Sahmir npc, float gameTime)
{
	int GetClosestEnemyToAttack;
	//Ranged units will behave differently.
	//Get the closest visible target via distance checks, not via pathing check.
	GetClosestEnemyToAttack = GetClosestTarget(npc.index,_,_,_,_,_,_,true,_,_,true);
	if(!IsValidEnemy(npc.index,GetClosestEnemyToAttack))
	{
		return;
	}
	float vecTarget[3]; WorldSpaceCenter(GetClosestEnemyToAttack, vecTarget);

	float VecSelfNpc[3]; WorldSpaceCenter(npc.index, VecSelfNpc);
	float flDistanceToTarget = GetVectorDistance(vecTarget, VecSelfNpc, true);
	if(flDistanceToTarget < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 30.0))
	{
		if(gameTime > npc.m_flNextMeleeAttack)
		{
			if(flDistanceToTarget < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 30.0))
			{	
				npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE");
				npc.PlayMeleeSound();
				//after we fire, we will have a short delay beteween the actual laser, and when it happens
				//This will predict as its relatively easy to dodge
				float projectile_speed = 2000.0;

				WorldSpaceCenter(GetClosestEnemyToAttack, vecTarget);

				npc.FaceTowards(vecTarget, 20000.0);
				npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 0.75;
				npc.FireArrow(vecTarget, 35.0, projectile_speed);
				ApplyStatusEffect(npc.index, target, "Molecular Collapse", 15.0);
				npc.PlayIdleAlertSound();
			}
		}
	}
}


public Action Sahmir_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	Sahmir npc = view_as<Sahmir>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;
		
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	return Plugin_Changed;
}

public void Sahmir_NPCDeath(int entity)
{
	Sahmir npc = view_as<Sahmir>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
		
	if(IsValidEntity(npc.m_iWearable6))
		RemoveEntity(npc.m_iWearable6);
	if(IsValidEntity(npc.m_iWearable5))
		RemoveEntity(npc.m_iWearable5);
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);

}
