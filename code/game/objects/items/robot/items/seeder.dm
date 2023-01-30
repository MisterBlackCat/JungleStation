
#define FRUIT_SEEDS list (\
	/obj/item/seeds/apple,\
	/obj/item/seeds/banana,\
	/obj/item/seeds/chili/bell_pepper,\
	/obj/item/seeds/berry,\
	/obj/item/seeds/cherry,\
	/obj/item/seeds/chili,\
	/obj/item/seeds/cocoapod,\
	/obj/item/seeds/eggplant,\
	/obj/item/seeds/grape,\
	/obj/item/seeds/lemon,\
	/obj/item/seeds/lime,\
	/obj/item/seeds/olive,\
	/obj/item/seeds/orange,\
	/obj/item/seeds/pineapple,\
	/obj/item/seeds/plum,\
	/obj/item/seeds/pumpkin,\
	/obj/item/seeds/toechtauese,\
	/obj/item/seeds/tomato,\
	/obj/item/seeds/watermelon\
)

#define VEGETABLE_SEEDS list(\
	/obj/item/seeds/cabbage = 1,\
	/obj/item/seeds/carrot = 1,\
	/obj/item/seeds/corn = 1,\
	/obj/item/seeds/cucumber = 1,\
	/obj/item/seeds/garlic = 1,\
	/obj/item/seeds/greenbean = 1,\
	/obj/item/seeds/herbs = 1,\
	/obj/item/seeds/onion = 1,\
	/obj/item/seeds/peanut = 1,\
	/obj/item/seeds/peas = 1,\
	/obj/item/seeds/potato = 1,\
	/obj/item/seeds/soya = 1,\
	/obj/item/seeds/sugarcane = 1,\
	/obj/item/seeds/whitebeet = 1\
)

#define FLOWER_SEEDS list(\
	/obj/item/seeds/aloe = 1,\
	/obj/item/seeds/ambrosia = 1,\
	/obj/item/seeds/poppy = 1,\
	/obj/item/seeds/rose = 1,\
	/obj/item/seeds/sunflower = 1\
)

#define MISC_SEEDS list(\
	/obj/item/seeds/chanter = 1,\
	/obj/item/seeds/coffee = 1,\
	/obj/item/seeds/cotton = 1,\
	/obj/item/seeds/grass = 1,\
	/obj/item/seeds/korta_nut = 1,\
	/obj/item/seeds/wheat/rice = 1,\
	/obj/item/seeds/tea = 1,\
	/obj/item/seeds/tobacco = 1,\
	/obj/item/seeds/tower = 1,\
	/obj/item/seeds/wheat = 1\
)

#define BASE_HYDRO_REAGENTS list(\
		/datum/reagent/plantnutriment/robustharvestnutriment,\
		/datum/reagent/plantnutriment/eznutriment,\
		/datum/reagent/medicine/c2/multiver,\
		/datum/reagent/toxin/pestkiller\
	)

/datum/data/seed_packet
	name = "generic"
	var/description = "generic"
	var/product_path = null

/obj/item/seeder
	name = "cyborg seeder"
	desc = "An advanced synthesizer and injection system, designed planting seeds in botany plots and bins."
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "borg_seeder"

	/** The maximum volume for each reagent stored in this hypospray
	 * In most places we add + 1 because we're secretly keeping [max_volume_per_reagent + 1]
	 * units, so that when this reagent runs out it's not wholesale removed from the reagents
	 */
	/// Maximum seeds that can be stored
	var/max_seeds = 15;
	var/current_seeds = 15;
	/// Cell cost for charging a reagent
	var/charge_cost = 100
	/// Counts up to the next time we charge
	var/charge_timer = 0
	/// Time it takes for shots to recharge (in seconds)
	var/recharge_time = 60
	/// If this seeder has been upgraded
	var/upgraded = FALSE
	var/cooldown = 0
	///How long should the minimum period between this RSF's item dispensings be?
	var/cooldowndelay = 0 SECONDS
	/// The basic reagents that come with this hypo
	var/list/default_seeds

	var/tgui_theme = "ntos"

	var/datum/data/seed_packet/selected_reagent
	var/list/allowed_surfaces = list(/turf/open/floor, /obj/structure/table, /obj/machinery/hydroponics)

/obj/item/seeder/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/seeder/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/// Every [recharge_time] seconds, recharge some reagents for the cyborg
/obj/item/seeder/process(delta_time)
	var/mob/living/silicon/robot/cyborg = src.loc
	if(iscyborg(src.loc))
		if(cyborg?.cell)
			charge_timer += delta_time
			if(charge_timer >= recharge_time)
				if(current_seeds < max_seeds)
					cyborg.cell.use(charge_cost)
					current_seeds = current_seeds + 1
	return 1

/// Regenerate our supply of all reagents (if they're not full already)
/obj/item/seeder/proc/regenerate_reagents(list/reagents_to_regen)
	if(iscyborg(src.loc))
		var/mob/living/silicon/robot/cyborg = src.loc

/obj/item/seeder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgSeeder", name)
		ui.open()

/obj/item/seeder/ui_data(mob/user)
	var/data = list()

	var/list/list_of_fruit = list()
	for(var/obj/item/seedo as anything in FRUIT_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		R.description = initial(temp.desc)
		var/list/some_record = list(list(
			"name" = R.name,
			"description" = R.description
		))
		list_of_fruit.Add(some_record)


	var/list/list_of_vegetables = list()
	for(var/obj/item/seedo as anything in VEGETABLE_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		R.description = initial(temp.desc)
		var/list/some_record = list(list(
			"name" = R.name,
			"description" = R.description
		))
		list_of_vegetables.Add(some_record)

	var/list/list_of_flowers = list()
	for(var/obj/item/seedo as anything in FLOWER_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		R.description = initial(temp.desc)
		var/list/some_record = list(list(
			"name" = R.name,
			"description" = R.description
		))
		list_of_flowers.Add(some_record)

	var/list/list_of_misc = list()
	for(var/obj/item/seedo as anything in MISC_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		R.description = initial(temp.desc)
		var/list/some_record = list(list(
			"name" = R.name,
			"description" = R.description
		))
		list_of_misc.Add(some_record)

	data["theme"] = tgui_theme
	data["selectedReagent"] = selected_reagent?.name
	data["fruits"] = list_of_fruit
	data["vegetables"] = list_of_vegetables
	data["flowers"] = list_of_flowers
	data["misc"] = list_of_misc

	return data

/obj/item/seeder/attack_self(mob/user)
	ui_interact(user)

/obj/item/seeder/afterattack(atom/A, mob/user, proximity)
	if(!selected_reagent)
		if(current_seeds == 0)
			var/mob/living/silicon/robot/cyborg = loc
			balloon_alert(cyborg, "No seed selected!")
		return .
	if(cooldown > world.time)
		return
	. = ..()
	if(!proximity)
		return .
	. |= AFTERATTACK_PROCESSED_ITEM
	if (!is_allowed(A))
		return .
	playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
	if (is_hydroponics_basin(A))
		var/mob/living/silicon/robot/cyborg = loc
		if(current_seeds == 0)
			balloon_alert(cyborg, "No seeds left!")
		var/atom/basin_seed = new selected_reagent.product_path(get_turf(A))
		var/obj/machinery/hydroponics/target_basin = A
		target_basin.borg_seed_plant(basin_seed, cyborg)
		return .
	if(current_seeds == 0)
		var/mob/living/silicon/robot/cyborg = loc
		balloon_alert(cyborg, "No seeds left!")
	var/atom/meme = new selected_reagent.product_path(get_turf(A))
	cooldown = world.time + cooldowndelay
	return .

/obj/item/seeder/proc/is_allowed(atom/to_check)
	for(var/sort in allowed_surfaces)
		if(istype(to_check, sort))
			return TRUE
	return FALSE

/obj/item/seeder/proc/is_hydroponics_basin(atom/to_check)
	if(istype(to_check, /obj/machinery/hydroponics))
		return TRUE
	return FALSE

/obj/item/seeder/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/robot/cyborg = loc
	if(istype(loc, /obj/item/robot_model))
		var/obj/item/robot_model/container_model = loc
		cyborg = container_model.robot
	playsound(cyborg, 'sound/effects/pop.ogg', 50, FALSE)
	for(var/obj/item/seedo as anything in FRUIT_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		if(R.name == action)
			balloon_alert(cyborg, "Dispensing [R.name]")
			R.product_path = seedo
			selected_reagent = R
	for(var/obj/item/seedo as anything in VEGETABLE_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		if(R.name == action)
			balloon_alert(cyborg, "Dispensing [R.name]")
			R.product_path = seedo
			selected_reagent = R
	for(var/obj/item/seedo as anything in FLOWER_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		if(R.name == action)
			balloon_alert(cyborg, "Dispensing [R.name]")
			R.product_path = seedo
			selected_reagent = R
	for(var/obj/item/seedo as anything in MISC_SEEDS)
		var/obj/item/temp = seedo
		var/datum/data/seed_packet/R = new /datum/data/seed_packet()
		R.name = initial(temp.name)
		if(R.name == action)
			balloon_alert(cyborg, "Dispensing [R.name]")
			R.product_path = seedo
			selected_reagent = R

/obj/item/seeder/examine(mob/user)
	. = ..()
	. += "Currently loaded: [selected_reagent ? "[selected_reagent]. [selected_reagent.description]" : "nothing."]"

/obj/item/seeder/AltClick(mob/living/user)
	. = ..()
	if(user.stat == DEAD || user != loc)
		return //IF YOU CAN HEAR ME SET MY TRANSFER AMOUNT TO 1




///Borg Watering Can; It's just the advanced watering can with a different icon + more water.
/obj/item/reagent_containers/cup/watering_can/advanced/borg
	desc = "Everything a botanist module would want in a watering gun. This marvel of technology generates its own water!"
	name = "watering hose"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "borg_watering_can"
	list_reagents = list(/datum/reagent/water = 250)
	volume = 250
	var/recharge_ammount = 25
	var/charge_cost = 15
	/// Counts up to the next time we charge
	var/charge_timer = 0
	/// Time it takes for shots to recharge (in seconds)
	var/recharge_time = 15

/obj/item/reagent_containers/cup/watering_can/advanced/borg/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/cup/watering_can/advanced/borg/process(delta_time)
	///How much to refill
	charge_timer += delta_time
	var/mob/living/silicon/robot/cyborg = src.loc
	if(iscyborg(src.loc))
		if(cyborg?.cell)
			if(charge_timer >= recharge_time)
				charge_timer = 0
				var/volume_adding = volume - reagents.total_volume
				if(volume_adding > recharge_ammount)
					volume_adding = recharge_ammount
				if(volume_adding > 0)
					cyborg.cell.use(charge_cost)
					reagents.add_reagent(refill_reagent, volume_adding)
	return 1

/obj/item/reagent_containers/cup/watering_can/advanced/borg/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()






///Borg Hypospray
/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser
	name = "hydroponics chemical injector"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty botany equipment."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "mister"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(2,5)
	volume = 30
	recharge_ammount = 10
	charge_cost = 15
	/// The reagents we're actually storing
	var/datum/reagents/stored_reagents
	/// The reagent we've selected to dispense
	var/datum/reagent/selected_reagent
	/// The theme for our UI (hacked hypos get syndicate UI)
	var/tgui_theme = "ntos"
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	charge_timer = 0
	/// Time it takes for shots to recharge (in seconds)
	recharge_time = 5
	refill_reagent = /datum/reagent/plantnutriment/robustharvestnutriment
	list_reagents = list(/datum/reagent/plantnutriment/robustharvestnutriment = 30)


/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/Initialize(mapload)
	. = ..()
	stored_reagents = new(new_flags = NO_REACT | DRAINABLE)
	stored_reagents.maximum_volume = length(BASE_HYDRO_REAGENTS) * (5 + 1)
	for(var/reagent in BASE_HYDRO_REAGENTS)
		add_new_reagent(reagent)
	START_PROCESSING(SSobj, src)
	selected_reagent = reagents.get_reagent(/datum/reagent/plantnutriment/robustharvestnutriment)

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/proc/add_new_reagent(datum/reagent/reagent)
	stored_reagents.add_reagent(reagent, (5 + 1), reagtemp = dispensed_temperature, no_react = TRUE)

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/process(delta_time)
	charge_timer += delta_time
	var/mob/living/silicon/robot/cyborg = src.loc
	if(iscyborg(src.loc))
		if(cyborg?.cell)
			if(charge_timer >= recharge_time)
				if(reagents.total_volume < volume)
					var/volume_adding = volume - reagents.total_volume
					if(volume_adding > recharge_ammount)
						volume_adding = recharge_ammount
					cyborg.cell.use(charge_cost)
					reagents.add_reagent(selected_reagent.type, volume_adding)
				charge_timer = 0
	return 1

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/attack_self(mob/user)
	ui_interact(user)

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgChemsprayer", name)
		ui.open()

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/ui_data(mob/user)
	var/list/available_reagents = list()
	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent)
			available_reagents.Add(list(list(
				"name" = reagent.name,
				"volume" = 30,
				"description" = reagent.description,
			))) // list in a list because Byond merges the first list...

	var/data = list()
	data["theme"] = tgui_theme
	data["maxVolume"] = volume
	data["reagents"] = available_reagents
	data["selectedReagent"] = selected_reagent?.name
	return data

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return

	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent.name == action)
			var/cur_volume = reagents.total_volume
			reagents.remove_all(cur_volume)
			selected_reagent = reagent
			. = TRUE
			reagents.add_reagent(selected_reagent.type, cur_volume)

			var/mob/living/silicon/robot/cyborg = loc
			if(istype(loc, /obj/item/robot_model))
				var/obj/item/robot_model/container_model = loc
				cyborg = container_model.robot
			playsound(cyborg, 'sound/effects/pop.ogg', 50, FALSE)
			balloon_alert(cyborg, "dispensing [selected_reagent.name]")
			break

/obj/item/reagent_containers/cup/watering_can/advanced/borg/nutrient_dispenser/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
