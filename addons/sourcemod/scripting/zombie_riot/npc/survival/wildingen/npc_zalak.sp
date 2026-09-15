#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] =
{
	"npc/headcrab/die1.wav",
	"npc/headcrab/die2.wav"
};

static const char g_HurtSounds[][] =
{
	"npc/headcrab/pain1.wav",
	"npc/headcrab/pain2.wav",
	"npc/headcrab/pain3.wav"
};

static const char g_IdleAlertedSounds[][] =
{
	"npc/headcrab/alert1.wav",
	"npc/headcrab/idle3.wav"
};


static const char g_MeleeHitSounds[][] =
{
	"weapons/cleaver_hit_02.wav",
	"weapons/cleaver_hit_03.wav",
	"weapons/cleaver_hit_05.wav",
	"weapons/cleaver_hit_06.wav",
	"weapons/cleaver_hit_07.wav",
};

static const char g_MeleeAttackSounds[][] =
{
	"weapons/machete_swing.wav",
};

void ZalakOnMapStart()
{
	NPCData data;
	strcopy(data.Name, sizeof(data.Name), "Zalak");
	strcopy(data.Plugin, sizeof(data.Plugin), "npc_zalak");
	strcopy(data.Icon, sizeof(data.Icon), "scout_bat");
	data.IconCustom = false;
	data.Flags = 0;
	data.Category = Type_Interitus;
	data.Func = ClotSummon;
	NPC_Add(data);
}

static any ClotSummon(int client, float vecPos[3], float vecAng[3], int team)
{
	return Zalak(vecPos, vecAng, team);
}

methodmap Zalak < CClotBody
{
	public void PlayIdleSound()
	{
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
	}
	public void PlayHurtSound()
	{
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
	}
	public void PlayDeathSound() 
	{
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME);
	}
	public void PlayMeleeSound()
 	{
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_AUTO, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, _);
	}
	public void PlayMeleeHitSound()
	{
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_AUTO, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, _);	
	}
	
	public Zalak(float vecPos[3], float vecAng[3], int ally)
	{
		Zalak npc = view_as<Zalak>(CClotBody(vecPos, vecAng, "models/player/heavy.mdl", "0.60", "250", ally));
		
		i_NpcWeight[npc.index] = 1	;
		npc.SetActivity("ACT_MP_RUN_MELEE");
		KillFeed_SetKillIcon(npc.index, "boston_basher");
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		
		SetVariantInt(3);
		AcceptEntityInput(npc.index, "SetBodyGroup");
		SetEntProp(npc.index, Prop_Send, "m_nSkin", 1);

		func_NPCDeath[npc.index] = ClotDeath;
		func_NPCOnTakeDamage[npc.index] = Generic_OnTakeDamage;
		func_NPCThink[npc.index] = ClotThink;
		
		npc.m_flSpeed = 350.0;
		npc.m_flGetClosestTargetTime = 0.0;
		npc.m_flNextMeleeAttack = 0.0;
		npc.m_flAttackHappens = 0.0;
		
		npc.m_iWearable1 = npc.EquipItem("head", "models/workshop/weapons/c_models/c_boston_basher/c_boston_basher.mdl");
		npc.m_iWearable2 = npc.EquipItem("head", "models/workshop/player/items/all_class/hwn2021_hat_outta_hell/hwn2021_hat_outta_hell_scout.mdl");
		npc.m_iWearable3 = npc.EquipItem("head", "models/workshop/player/items/scout/sum22_ripped_rider/sum22_ripped_rider.mdl");
		npc.m_iWearable4 = npc.EquipItem("head", "models/workshop/player/items/scout/fall17_transparent_trousers/fall17_transparent_trousers.mdl");
		npc.m_iWearable5 = npc.EquipItem("head", "models/workshop/player/items/scout/hwn2019_wild_whip/hwn2019_wild_whip.mdl");

		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", 1);
		SetEntProp(npc.m_iWearable3, Prop_Send, "m_nSkin", 1);
		SetEntProp(npc.m_iWearable4, Prop_Send, "m_nSkin", 1);
		SetEntProp(npc.m_iWearable5, Prop_Send, "m_nSkin", 1);

		SetEntityRenderColor(npc.m_iWearable2, 126, 126, 126, 255);
		SetEntityRenderColor(npc.m_iWearable3, 126, 126, 126, 255);
		SetEntityRenderColor(npc.m_iWearable4, 126, 126, 126, 255);
		SetEntityRenderColor(npc.m_iWearable5, 233, 150, 122, 255);

		return npc;
	}
}

static void ClotThink(int iNPC)
{
	Zalak npc = view_as<Zalak>(iNPC);

	float gameTime = GetGameTime(npc.index);
	if(npc.m_flNextDelayTime > gameTime)
		return;
	
	npc.m_flNextDelayTime = gameTime + DEFAULT_UPDATE_DELAY_FLOAT;
	npc.Update();

	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.PlayHurtSound();
		npc.m_blPlayHurtAnimation = false;
	}
	
	if(npc.m_flNextThinkTime > gameTime)
		return;
	
	npc.m_flNextThinkTime = gameTime + 0.1;

	int target = npc.m_iTarget;
	if(i_Target[npc.index] != -1 && !IsValidEnemy(npc.index, target))
		i_Target[npc.index] = -1;
	
	if(i_Target[npc.index] == -1 || npc.m_flGetClosestTargetTime < gameTime)
	{
		target = GetClosestTarget(npc.index);
		npc.m_iTarget = target;
		npc.m_flGetClosestTargetTime = gameTime + 1.0;
	}

	if(target > 0)
	{
		float vecTarget[3]; WorldSpaceCenter(target, vecTarget);
		float VecSelfNpc[3]; WorldSpaceCenter(npc.index, VecSelfNpc);
		float distance = GetVectorDistance(vecTarget, VecSelfNpc, true);	
		
		if(distance < npc.GetLeadRadius())
		{
			float vPredictedPos[3]; PredictSubjectPosition(npc, target,_,_, vPredictedPos);
			npc.SetGoalVector(vPredictedPos);
		}
		else 
		{
			npc.SetGoalEntity(target);
		}

		npc.StartPathing();
		
		if(npc.m_flAttackHappens)
		{
			if(npc.m_flAttackHappens < gameTime)
			{
				npc.m_flAttackHappens = 0.0;
				
				Handle swingTrace;
				npc.FaceTowards(vecTarget, 15000.0);
				if(npc.DoSwingTrace(swingTrace, target, _, _, _, _))
				{
					target = TR_GetEntityIndex(swingTrace);
					if(target > 0)
					{
						float damage = 20.0;
						if(ShouldNpcDealBonusDamage(target))
							damage *= 1.5;

      			  		if(!NpcStats_IsEnemySilenced(npc.index))
						{
							if(Rogue_Paradox_RedMoon())
							{
								StartBleedingTimer(target, npc.index,2.0, 10, -1, DMG_TRUEDAMAGE, 0);
							}
							else
							{
								StartBleedingTimer(target, npc.index,3.0, 20, -1, DMG_TRUEDAMAGE, 0);
							}
						}

						npc.PlayMeleeHitSound();
						SDKHooks_TakeDamage(target, npc.index, npc.index, damage, DMG_CLUB);
					}
				}

				delete swingTrace;
			}
		}

		if(distance < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED) && npc.m_flNextMeleeAttack < gameTime)
		{
			target = Can_I_See_Enemy(npc.index, target);
			if(IsValidEnemy(npc.index, target))
			{
				npc.m_iTarget = target;
				npc.m_flGetClosestTargetTime = gameTime + 1.0;

				npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE");
				npc.PlayMeleeSound();
				
				npc.m_flAttackHappens = gameTime + 0.35;
				npc.m_flNextMeleeAttack = gameTime + 0.85;
			}
		}
	}
	else
	{
		npc.StopPathing();
	}

	npc.PlayIdleSound();
}

static void ClotDeath(int entity)
{
	Zalak npc = view_as<Zalak>(entity);
	if(!npc.m_bGib)
		npc.PlayDeathSound();
	
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
	
	if(IsValidEntity(npc.m_iWearable5))
		RemoveEntity(npc.m_iWearable5);
}

