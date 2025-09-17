/datum/advclass/lurker
	name = "Feral Soul"
	tutorial = "Those who walk a path that many fear to tread, embracing their innermost instincts."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT //artificial constructs do not have the spark of the wild
	traits_applied = list(TRAIT_OUTLANDER)
	category_tags = list(CTAG_ADVENTURER)

/datum/advclass/lurker/wildlurker
	name = "Wild Lurker"
	class_select_category = CLASS_CAT_FERALSOUL
	tutorial = "You have embraced your feral instincts. You tread through brush and thicket unimpeded, and hunt as the beasts of Dendor do. Civilization is your anathema, and is to be avoided. For what purpose is the safety of a tavern when you thrive in this wild realm?"
	traits_applied = list(TRAIT_OUTLANDER, TRAIT_OUTDOORSMAN, TRAIT_STRONGBITE, TRAIT_CRITICAL_RESISTANCE, TRAIT_WILD_EATER, TRAIT_SEEDKNOW, TRAIT_CIVILIZEDBARBARIAN, TRAIT_AZURENATIVE, TRAIT_WOODWALKER, TRAIT_FERAL)
	subclass_stats = list(
		STATKEY_STR = -4,
		STATKEY_INT = -3,
		STATKEY_PER = 3,
		STATKEY_WIL = 4,
		STATKEY_SPD = 2,
		STATKEY_CON = 3
	)
	subclass_skills = list(
		/datum/skill/misc/athletics =  SKILL_EXP_EXPERT,
		/datum/skill/combat/knives = SKILL_EXP_NOVICE,
		/datum/skill/combat/wrestling = SKILL_EXP_EXPERT,
		/datum/skill/combat/unarmed = SKILL_EXP_EXPERT,
		/datum/skill/misc/swimming = SKILL_EXP_EXPERT,
		/datum/skill/misc/climbing = SKILL_EXP_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_EXP_EXPERT,
		/datum/skill/craft/tanning = SKILL_EXP_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_EXP_EXPERT,
		/datum/skill/misc/tracking = SKILL_EXP_EXPERT,
		/datum/skill/misc/medicine = SKILL_EXP_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_EXP_APPRENTICE,
		/datum/skill/labor/farming = SKILL_EXP_APPRENTICE,
	)
	outfit = /datum/outfit/job/roguetown/adventurer/wildlurker

/datum/outfit/job/roguetown/adventurer/wildlurker/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife/stoneknife
	//cloak = /obj/item/clothing/cloak/raincloak/furcloak
	//backl = /obj/item/storage/backpack/rogue/satchel
	//backpack_contents = list(
		//	/obj/item/rogueweapon/huntingknife/stoneknife = 1,
		//	/obj/item/rogueweapon/scabbard/sheath = 1
	//)
	H.cmode_music = 'sound/music/combat_gronn.ogg'
	H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/natural_armor(H)
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	var/color_one
	var/color_two
	var/heterochromia
	if(eyes)
		color_one = eyes.eye_color
		color_two = eyes.second_color
		heterochromia = eyes.heterochromia
		eyes.Remove(H,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/feral
	if(color_one)
		eyes.eye_color = color_one
	if(color_two)
		eyes.second_color = color_two
	if(heterochromia)
		eyes.heterochromia = heterochromia
	eyes.Insert(H)



/obj/item/organ/eyes/night_vision/feral
	name = "feral eyes"
	desc = ""

/atom/movable/screen/alert/status_effect/buff/feraldebuff
	name = "Feral Natured"
	desc = "These civilized realms are not meant for me. I can feel the walls closing in."
	icon_state = "debuff"

/datum/status_effect/buff/feraldebuff
	id = "feraldebuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/feraldebuff
	effectedstats = list("perception" = -5, "speed" = -2, "strength" = -4, "endurance" = -4, "constitution" = -3)

/datum/status_effect/buff/feraldebuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.town_area))
		owner.remove_status_effect(/datum/status_effect/buff/feraldebuff)
