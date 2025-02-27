//the base mining mob
/mob/living/simple_animal/hostile/asteroid
	vision_range = 2
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("mining")
	weather_immunities = list(TRAIT_LAVA_IMMUNE,TRAIT_ASHSTORM_IMMUNE, TRAIT_TOXICSTORM_IMMUNE)
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_WALLS
	minbodytemp = 0
	maxbodytemp = INFINITY
	unsuitable_heat_damage = 20
	response_harm_continuous = "strikes"
	response_harm_simple = "strike"
	status_flags = 0
	combat_mode = TRUE
	var/throw_message = "bounces off of"
	var/fromtendril = FALSE
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	mob_size = MOB_SIZE_LARGE
	var/icon_aggro = null

	///what trophy this mob drops
	var/crusher_loot
	///what is the chance the mob drops it if all their health was taken by crusher attacks
	var/crusher_drop_mod = 25

/mob/living/simple_animal/hostile/asteroid/Initialize(mapload)
	. = ..()
	if(crusher_loot)
		AddElement(/datum/element/crusher_loot, crusher_loot, crusher_drop_mod, del_on_death)
	AddElement(/datum/element/mob_killed_tally, "mobs_killed_mining")

/mob/living/simple_animal/hostile/asteroid/Aggro()
	..()
	if(vision_range == aggro_vision_range && icon_aggro)
		icon_state = icon_aggro

/mob/living/simple_animal/hostile/asteroid/LoseAggro()
	..()
	if(stat == DEAD)
		return
	icon_state = icon_living

/mob/living/simple_animal/hostile/asteroid/bullet_act(obj/projectile/shot)//Reduces damage from most projectiles to curb off-screen kills
	if(!stat)
		Aggro()
	if(shot.damage < 30 && shot.damage_type != BRUTE)
		shot.damage = (shot.damage / 3)
		visible_message(span_danger("[shot] has a reduced effect on [src]!"))
	..()

/mob/living/simple_animal/hostile/asteroid/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum) //No floor tiling them to death, wiseguy
	if(isitem(AM))
		var/obj/item/T = AM
		if(!stat)
			Aggro()
		if(T.throwforce <= 20)
			visible_message(span_notice("The [T.name] [throw_message] [src.name]!"))
			return
	..()
