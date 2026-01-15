/mob/living/carbon/human/species/goblinevil
	name = "goblin"
	skin_tone = SKIN_COLOR_GROONN
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	var/goblinevil_outfit = /datum/outfit/job/roguetown/goblinevil/npc

	race = /datum/species/goblinp
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					 /obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	ambushable = FALSE

	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak, /datum/rmb_intent/swift, /datum/rmb_intent/riposte)

/mob/living/carbon/human/species/goblinevil/npc
	faction = list("orcs", "station")
	aggressive = 1
	rude = TRUE
	mode = NPC_AI_IDLE
	wander = FALSE
	cmode_music = FALSE
	is_voracious_npc = TRUE
	voremode = TRUE

/mob/living/carbon/human/species/goblinevil/npc/Initialize()
	. = ..()
	set_species(/datum/species/goblinp)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	load_mob_bellies()

/mob/living/carbon/human/species/goblinevil/npc/load_mob_bellies()
	..()

/mob/living/carbon/human/species/goblinevil/npc/after_creation()
	..()
	job = "Goblin"
	equipOutfit(new goblinevil_outfit)
	gender = pick(MALE, FEMALE)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid, 
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher, 
						/datum/sprite_accessory/hair/head/lowbraid))
	head.sellprice = 30

	src.set_patron(/datum/patron/inhumen/graggar)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)

	if(organ_eyes)
		organ_eyes.eye_color = "#FF0000"
		organ_eyes.accessory_colors = "#FF0000#FF0000"

	skin_tone = "50715C"

	if(organ_ears)
		organ_ears.accessory_colors = "#50715C"

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
		var/obj/item/organ/breasts/breasts = src.getorganslot(ORGAN_SLOT_BREASTS)
		if(!breasts)
			breasts = new()
			breasts.Insert(src, TRUE, FALSE)
		breasts.accessory_type = /datum/sprite_accessory/breasts/pair
		breasts.breast_size = rand(1,16)
		breasts.accessory_colors = "#50715C"

	else
		new_hair.set_accessory_type(hairm, null, src)
		
	var/obj/item/organ/butt/butt = src.getorganslot(ORGAN_SLOT_BUTT)
	if(!butt)
		butt = new()
		butt.Insert(src, TRUE, FALSE)
	butt.accessory_type = /datum/sprite_accessory/butt/pair
	butt.organ_size = rand(0,5)
	butt.accessory_colors = "#50715C"

	var/obj/item/organ/belly/belly = src.getorganslot(ORGAN_SLOT_BELLY)
	if(!belly)
		belly = new()
		belly.Insert(src, TRUE, FALSE)
	belly.accessory_type = /datum/sprite_accessory/belly
	belly.belly_size = 0
	belly.accessory_colors = "#50715C"

	head.add_bodypart_feature(new_hair)

	new_hair.accessory_colors = "#31302E"
	new_hair.hair_color = "#31302E"
	hair_color = "#31302E"

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/other/halforcf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/other/halforcm.txt"))
	update_hair()
	update_body()

/datum/outfit/job/roguetown/goblinevil/npc/pre_equip(mob/living/carbon/human/H) //gives some default skills and equipment for player controlled orcs
	H.STASTR = 8
	var/chance_zjumper = 5
	var/chance_treeclimber = 30
	H.STASPD = 14
	if(prob(chance_zjumper))
		ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
		H.find_targets_above = TRUE
	if(prob(chance_treeclimber))
		H.tree_climber = TRUE
		H.find_targets_above = TRUE // so they can taunt
	H.STACON = 6
	H.STAWIL = 15
	H.STAINT = 4
	var/loadout = rand(1,5)
	switch(loadout)
		if(1) //tribal spear
			r_hand = /obj/item/rogueweapon/spear/stone
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
		if(2) //tribal axe
			r_hand = /obj/item/rogueweapon/stoneaxe
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
		if(3) //tribal club
			r_hand = /obj/item/rogueweapon/mace/woodclub
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
			if(prob(10))
				head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
		if(4) //lightly armored sword/flail/daggers
			if(prob(50))
				r_hand = /obj/item/rogueweapon/sword/iron
			else
				r_hand = /obj/item/rogueweapon/mace/spiked
			if(prob(30))
				l_hand = /obj/item/rogueweapon/shield/wood
			if(prob(23))
				r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
				l_hand = /obj/item/rogueweapon/huntingknife/stoneknife
			armor = /obj/item/clothing/suit/roguetown/armor/leather/goblin
			if(prob(80))
				head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
		if(5) //heavy armored sword/flail/shields
			if(prob(30))
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/goblin
			if(prob(80))
				head = /obj/item/clothing/head/roguetown/helmet/goblin
			else
				head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
			if(prob(50))
				r_hand = /obj/item/rogueweapon/sword/iron
			else
				r_hand = /obj/item/rogueweapon/mace/spiked
			if(prob(20))
				r_hand = /obj/item/rogueweapon/flail
				l_hand = /obj/item/rogueweapon/shield/wood
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE) // Trash mob
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
