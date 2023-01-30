#define BASE_BOTANY_REAGENTS list(\
		/datum/reagent/water,\
		/datum/reagent/ammonia,\
		/datum/reagent/consumable/nutriment,\
		/datum/reagent/medicine/c2/multiver,\
	)

#define UPGRADED_BOTANY_REAGENTS list(\
		/datum/reagent/water,\
		/datum/reagent/ammonia,\
		/datum/reagent/consumable/nutriment,\
		/datum/reagent/medicine/c2/multiver,\
	)

/obj/item/reagent_containers/spray/borg_hydro
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "mister"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,25,50,100)
	can_fill_from_container = FALSE
	volume = 250
	var/list/special_objects = list(/obj/machinery/hydroponics, /obj/item/reagent_containers)
	var/recharge_ammount = 25
	var/charge_cost = 15
	/// Counts up to the next time we charge
	var/charge_timer = 0
	/// Time it takes for shots to recharge (in seconds)
	var/recharge_time = 5
	///Optional variable to override the temperature add_reagent() will use
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	reagent_flags = DRAINABLE


/obj/item/reagent_containers/spray/borg_hydro/afterattack(atom/target, mob/user, proximity)
	///playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
	if(target.loc == loc) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return
	if(istype(target, /obj/structure/sink) || istype(target, /obj/structure/mop_bucket/janitorialcart) || istype(target, /obj/machinery/hydroponics))
		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You fill \the [src] with [trans] units of the contents of \the [target]."))
		if(trans > 0)
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		return
	return ..()

/obj/item/reagent_containers/spray/borg_hydro/Initialize(mapload)
	. = ..()
	reagents = new(new_flags = NO_REACT)
	reagents.maximum_volume = volume
	reagents.add_reagent(/datum/reagent/water, volume, reagtemp = dispensed_temperature, no_react = TRUE)
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/spray/borg_hydro/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/spray/borg_hydro/process(delta_time)
	charge_timer += delta_time
	if(charge_timer >= recharge_time)
		regenerate_reagents()
		charge_timer = 0
	return 1

/obj/item/reagent_containers/spray/borg_hydro/examine(mob/user)
	. = ..()
	. += "Currently holds [reagents.total_volume] of water."
	. += span_notice("<i>Alt+Click</i> to change transfer amount. Currently set to [amount_per_transfer_from_this]u.")

/obj/item/reagent_containers/spray/borg_hydro/proc/regenerate_reagents()
	if(iscyborg(src.loc))
		var/mob/living/silicon/robot/cyborg = src.loc
		if(cyborg?.cell)
			if(reagents.total_volume < volume)
				var/volume_to_add = volume - reagents.total_volume
				if(volume_to_add > recharge_ammount)
					volume_to_add = recharge_ammount
				cyborg.cell.use(charge_cost)
				reagents.add_reagent(/datum/reagent/water, volume_to_add, reagtemp = dispensed_temperature, no_react = TRUE)


