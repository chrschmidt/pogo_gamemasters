BEGIN {
    space = 0;
    for (n=0; n<256; n++) ord[sprintf("%c",n)] = n;

    replace["items"] = "item_templates";
    replace["items:"] = "item_ids:";
    replace["item"] = "item_settings";
    replace["badge"] = "badge_settings";
    replace["move"] = "move_settings";
    replace["move_sequence"] = "move_sequence_settings";
    replace["type:"] = "pokemon_type:";
    replace["badge_ranks:"] = "badge_rank:";
    replace["required_exp:"] = "required_experience:";
    replace["unique_id:"] = "item_id:";
    replace["type1:"] = "type:";
    replace["type2:"] = "type_2:";
    replace["evolution:"] = "evolution_ids:";
    replace["pokemon"] = "pokemon_settings";
    replace["anim_time:"] = "animation_time:";
    replace["parent_id:"] = "parent_pokemon_id:";
    replace["pokemon_class:"] = "rarity:";
    replace["standing_time_between_encounters_sec:"] = "standing_time_between_encounters_seconds:";
    replace["moving_time_between_encounter_sec:"] = "moving_time_between_encounter_seconds:";
    replace["cyl_radius_m:"] = "cylinder_radius_m:";
    replace["cyl_height_m:"] = "cylinder_height_m:";
    replace["cyl_ground_m:"] = "cylinder_ground_m:";

    replace["ease_out_speed:"] = "east_out_speed:";
    replace["duration_s:"] = "duration_seconds:";
    replace["wait_s:"] = "wait_seconds:";
    replace["transition_s:"] = "transition_seconds:";
    replace["angle_deg:"] = "angle_degree:";
    replace["angle_offset_deg:"] = "angle_offset_degree:";
    replace["pitch_deg:"] = "pitch_degree:";
    replace["pitch_offset_deg:"] = "pitch_offset_degree:";
    replace["roll_deg:"] = "roll_degree:";
    replace["distance_m:"] = "distance_meters:";
    replace["height_percent:"] = "height_percent:";

    val_replace["NIDORAN"] = "NIDORAN_FEMALE";

    decode["targets:"] = 1;
    decode["required_experience:"] = 1;
    decode["cp_multiplier:"] = 8;
    decode["leader_slots:"] = 1;
    decode["trainer_slots:"] = 1;
    decode["daily_defender_bonus_per_pokemon:"] = 1;
    decode["rank_num:"] = 1;
    decode["candy_cost:"] = 1;
    decode["stardust_cost:"] = 1;
    decode["quick_moves:"] = 1;
    decode["cinematic_moves:"] = 1;
    decode["evolution:"] = 1;
    decode["attack_scalar:"] = 3;
    decode["animation_time:"] = 7;
    decode["evolution_ids:"] = 1;

    decode["ease_in_speed:"] = 3;
    decode["east_out_speed:"] = 3;
    decode["duration_seconds:"] = 3;
    decode["wait_seconds:"] = 3;
    decode["transition_seconds:"] = 3;
    decode["angle_degree:"] = 3;
    decode["angle_offset_degree:"] = 3;
    decode["pitch_degree:"] = 3;
    decode["pitch_offset_degree:"] = 3;
    decode["roll_degree:"] = 3;
    decode["distance_meters:"] = 3;
    decode["height_percent:"] = 3;
    decode["vert_ctr_ratio:"] = 3;
    decode["interpolation:"] = 1;
    decode["target_type:"] = 1;

    decode["counts:"] = 1;
    decode["item_ids:"] = 1;

    CAM_INTERP[0] = "CAM_INTERP_CUT";
    CAM_INTERP[1] = "CAM_INTERP_LINEAR";
    CAM_INTERP[2] = "CAM_INTERP_SMOOTH";
    CAM_INTERP[3] = "CAM_INTERP_SMOOTH_ROT_LINEAR_MOVE";
    CAM_INTERP[4] = "CAM_INTERP_DEPENDS";

    CAM_TARGET[0] = "CAM_TARGET_ATTACKER";
    CAM_TARGET[1] = "CAM_TARGET_ATTACKER_EDGE";
    CAM_TARGET[2] = "CAM_TARGET_ATTACKER_GROUND";
    CAM_TARGET[3] = "CAM_TARGET_DEFENDER";
    CAM_TARGET[4] = "CAM_TARGET_DEFENDER_EDGE";
    CAM_TARGET[5] = "CAM_TARGET_DEFENDER_GROUND";
    CAM_TARGET[6] = "CAM_TARGET_ATTACKER_DEFENDER";
    CAM_TARGET[7] = "CAM_TARGET_ATTACKER_DEFENDER_EDGE";
    CAM_TARGET[8] = "CAM_TARGET_DEFENDER_ATTACKER";
    CAM_TARGET[9] = "CAM_TARGET_DEFENDER_ATTACKER_EDGE";
    CAM_TARGET[10] = "";
    CAM_TARGET[11] = "CAM_TARGET_ATTACKER_DEFENDER_MIRROR";
    CAM_TARGET[12] = "CAM_TARGET_SHOULDER_ATTACKER_DEFENDER";
    CAM_TARGET[13] = "CAM_TARGET_SHOULDER_ATTACKER_DEFENDER_MIRROR";
    CAM_TARGET[14] = "CAM_TARGET_ATTACKER_DEFENDER_WORLD";

    ITEM_IDS[1] = "ITEM_POKE_BALL";
    ITEM_IDS[301] = "ITEM_LUCKY_EGG";
    ITEM_IDS[401] = "ITEM_INCENSE_ORDINARY";
    ITEM_IDS[902] = "ITEM_INCUBATOR_BASIC";
    ITEM_IDS[1001] = "ITEM_POKEMON_STORAGE_UPGRADE";
    ITEM_IDS[1002] = "ITEM_ITEM_STORAGE_UPGRADE";
}

END {
    printf ("timestamp_ms: 1466197200000");
}

function i2f(value,    sign, expo, frac) {
    sign = rshift (and (value, 0x80000000), 31);
    expo = rshift (and (value, 0x7f800000), 23);
    frac =         and (value, 0x007fffff);

    return (-1.0)^sign * (1 + frac * 2.0^-23) * 2.0^(expo-127);
}

function getbyte_init(value) {
    gb_val = value;
    gb_pos = 1;
    gb_sub = "";
}

function getbyte(gb_tmp) {
    gb_tmp = substr (gb_val, gb_pos, 1);
    if (gb_tmp == "") return -1;
    gb_sub = gb_tmp;
    if (gb_tmp == "\\") {
        gb_pos++;
        gb_tmp = substr (gb_val, gb_pos, 1);
        gb_sub = gb_sub gb_tmp;
        if (gb_tmp ~ /[0-9]/) {
            gb_sub = substr (gb_val, gb_pos-1, 4);
            gb_tmp = "0" substr (gb_val, gb_pos, 3);
            gb_pos += 2;
            gb_tmp = strtonum (gb_tmp);
        } else {
            if (gb_tmp == "t") { gb_tmp = 9; }
            else if (gb_tmp == "n") { gb_tmp = 10; }
            else if (gb_tmp == "r") { gb_tmp = 13; }
            else if (gb_tmp == "\"") { gb_tmp = 34; }
            else if (gb_tmp == "'") { gb_tmp = 39; }
            else if (gb_tmp == "\\") { gb_tmp = 92; }
            else { printf ("unknown escape %s\n", gb_tmp); exit 1; }
        }
    } else {
        gb_tmp = ord[gb_tmp];
    }
    gb_pos++;
    return gb_tmp;
}

function dec_floatarr(key, value, precision,   i, values, ivalues, valnum, position, tmp,
                      strings, sign, expo, frac) {
#    printf ("d_f: input = %s\n", value);
    format = sprintf ("%%s %%.%dg\n", precision);
    getbyte_init(value);
    position = 0;

    while ((tmp = getbyte()) >= 0) {
        position++;
        strings[position] = gb_sub;
        ivalues[position] = tmp;
        for (i=1; i<4; i++) {
            ivalues[position] += getbyte() * 256^i;
            strings[position]  = strings[position] gb_sub;
        }
        sign = rshift (and (ivalues[position], 0x80000000), 31);
        expo = rshift (and (ivalues[position], 0x7f800000), 23);
        frac =         and (ivalues[position], 0x007fffff);

        values[position] = (-1.0)^sign * (1 + frac * 2.0^-23) * 2.0^(expo-127);
        for (i=0; i<space; i++) printf ("  ");
        printf (format, key, values[position]);
#        printf ("%s %.8g %d %d %d %d %s\n", key, values[position], sign, expo, frac, ivalues[position], strings[position]);
    }

#    format = "%s %.8g\n";
#    for (valnum=1; valnum<=position; valnum++) {
#        for (i=0; i<space; i++) printf ("  ");
#        printf (format, key, values[valnum]);
#        printf ("%s %.8g %d %d %d %d %s\n", key, values[valnum], sign, expo, frac, ivalues[valnum], strings[valnum]);
#    }
}

function dec_intarr(key, value,    i, values, flag, valnum, position, strings, tmp) {
#    printf ("d_i: input = %s\n", value);
    getbyte_init(value);
    position = 0;
    flag = 0;

    while ((tmp = getbyte()) >= 0) {
        if (!flag) {
            position++;
            values[position] = 0;
            strings[position] = gb_sub;
        } else {
            strings[position] = strings[position] gb_sub;
        }
        values[position] += and (tmp, 127) * 128^flag;
        if (tmp >= 128) { flag++; }
        else { flag = 0; }
    }

    if (key == "cinematic_moves:" || key == "quick_moves:")
        for (valnum=1; valnum<=position; valnum++)
            values[valnum] = MOVE[values[valnum]];
    if (key == "evolution_ids:")
        for (valnum=1; valnum<=position; valnum++)
            values[valnum] = POKEMON[values[valnum]];
    if (key == "interpolation:")
        for (valnum=1; valnum<=position; valnum++)
            values[valnum] = CAM_INTERP[values[valnum]];
    if (key == "target_type:")
        for (valnum=1; valnum<=position; valnum++)
            values[valnum] = CAM_TARGET[values[valnum]];
    if (key == "item_ids:")
        for (valnum=1; valnum<=position; valnum++)
            values[valnum] = ITEM_IDS[values[valnum]];

    for (valnum=1; valnum<=position; valnum++) {
        for (i=0; i<space; i++) printf ("  ");
        printf ("%s %s\n", key, values[valnum]);
#        printf ("%s %s %s\n", key, values[valnum], strings[valnum]);
    }
}

{
    $1 = tolower(gensub (/^_/, "", "g", gensub (/([A-Z])/, "_\\0", "g", $1)));
    if ($1 in replace) $1 = replace[$1];
    if ($1 == "template_id:") template = $2;
    else if ($1 == "item_id:" && template ~ /V[0-9]+_POKEMON_/) {
        $2 = substr ($2, 15);
        $1 = "pokemon_id:";
    } else if ($1 == "item_id:" && template ~ /V[0-9]+_MOVE_/) {
        $2 = substr (template, 13, length (template)-13);
        $1 = "movement_id:";
    } else if ($1 == "item_id:") $2 = substr (template, 2, length (template)-2);
    else if ($1 == "parent_pokemon_id:") $2 = substr ($2, 15);
    else if ($1 == "family_id:") $2 = families[substr (template, 2, length (template)-2)];
    else if ($1 == "movement_type:") $2 = substr ($2, 13);
    else if ($1 == "rarity:") $2 = gensub (/CLASS/, "RARITY", "g", $2);
    else if ($1 == "}") space--;
    if ($2 in valreplace) $2 = valreplace[$2];
    if ($1 in decode) {
        for (i=3; i<=NF; i++)
            $2 = $2 " " $i;
        $2 = substr ($2, 2, length ($2)-2);
        if (decode[$1] == 1) { dec_intarr($1, $2); }
        else { dec_floatarr($1, $2, decode[$1]); }
    } else {
        for (i=0; i<space; i++) printf ("  ");
        print;
    }
    if ($NF=="{") space++;
}
