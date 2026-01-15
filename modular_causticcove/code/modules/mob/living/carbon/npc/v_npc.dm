//Anything related to NPC that does vore.
/mob/living
	var/vore_stomach_name				// The name for the first belly if not "stomach"
	var/vore_stomach_flavor				// The flavortext for the first belly if not the default
	var/vore_default_mode = DM_DIGEST	// Default bellymode (DM_DIGEST, DM_HOLD, DM_ABSORB)
	var/vore_default_flags = 0			// No flags
	var/vore_digest_chance = 25			// Chance to switch to digest mode if resisted
	var/vore_absorb_chance = 0			// Chance to switch to absorb mode if resisted
	var/vore_escape_chance = 25			// Chance of resisting out of mob
	var/vore_escape_chance_absorbed = 20// Chance of absorbed prey finishing an escape. Requires a successful escape roll against the above as well.
	var/vore_default_item_mode = IM_DIGEST_FOOD			//How belly will interact with items
	var/vore_default_contaminates = FALSE				//Will it contaminate? // CHOMPedit: Put back to true like it always was.
	var/vore_default_contamination_flavor = "Generic"	//Contamination descriptors
	var/vore_default_contamination_color = "green"		//Contamination color
	var/swallowTime = 5 SECONDS	

/mob/living/carbon/human
	//are they able to eat nerds.
	var/is_voracious_npc = FALSE

/mob/living/carbon/human/proc/increase_belly_size()
	var/obj/item/organ/belly/_belly = getorganslot("belly")
	if(!_belly)
		return
	_belly.belly_size = 3
	src.regenerate_icons()

/mob/living/carbon/human/proc/decrease_belly_size()
	var/obj/item/organ/belly/_belly = getorganslot("belly")
	if(!_belly)
		return
	_belly.belly_size = 0
	src.regenerate_icons()

/mob/living/proc/load_mob_bellies()
	//A much more detailed version of the default /living implementation
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = TRUE
	B.can_taste = TRUE
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside %pred."
	B.digest_mode = vore_default_mode
	B.mode_flags = vore_default_flags
	B.item_digest_mode = vore_default_item_mode
	B.contaminates = vore_default_contaminates
	B.contamination_flavor = vore_default_contamination_flavor
	B.contamination_color = vore_default_contamination_color
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.escapechance_absorbed = vore_escape_chance_absorbed
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
	can_be_drop_pred = TRUE // Mobs will eat anyone that decides to drop/slip into them by default.
	B.belly_fullscreen = "a_tumby"
	B.belly_fullscreen_color = "#823232"
	B.belly_fullscreen_color2 = "#823232"


/*
/datum/special_intent/tongue_pull
	name = "Tongue"
	desc = "A long-range lash that coils around the ankles of the target, throwing them toward you."
	tile_coordinates = list(list(0,0))	//Just one tile exactly where our cursor is.
	post_icon_state = "strike"
	pre_icon_state = "trap"
	sfx_pre_delay = 'sound/combat/flail_sweep.ogg'
	respect_adjacency = FALSE
	use_clickloc = TRUE
	delay = 0.4 SECONDS
	cooldown = 15 SECONDS
	range = 4
	stamcost = 20	//Stamina cost
	var/immob_dur = 3.5 SECONDS
	var/pull_distance = 3

/datum/special_intent/tongue_pull/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		to_chat(howner, span_notice("You pull [L.name] towards you!"))
		L.visible_message(span_danger("[L.name] is pulled by [howner.name]'s [name]!"))

		// Calculate the direction from the target to the attacker
		var/pull_dir = get_dir(L, howner)
		var/turf/current_target_turf = get_turf(L)
		var/turf/destination_turf = get_ranged_target_turf(current_target_turf, pull_dir, pull_distance)
		L.throw_at(destination_turf, pull_distance, 1, howner, force = MOVE_FORCE_VERY_STRONG)
	..()
*/
