#!/bin/sh

DSOURCE="../Game Master 0.37.0"
FILE="GAME_MASTER_v0_1.protobuf"
TARGET="../000001556029CC80.txt"

awk '
BEGIN { printf ("BEGIN {\n"); }
($1 == "template_id:") { template = $2; }
($1 == "family_id:") { printf ("families[%s] = \"%s\";\n", template, $2); }
END { printf ("}\n"); }
' < "${DSOURCE}" > families.awk

awk '
BEGIN { printf ("BEGIN {\n"); }
($1 == "TemplateId:" && $2 ~ /^"V0/) {
    num = substr ($2, 3, 4);
    words = split ($2, a, /_/);
    type = a[2];
    name = "";
    for (i=3; i<=words; i++) name = name "_" a[i];
    name = substr (name, 2, length (name) - 2);
    printf ("%s[%d] = \"%s\";\n", type, num, name);
}
END { printf ("}\n"); }
' < "${FILE}" > data.awk


awk -f data.awk -f families.awk -f convert.awk < "${FILE}" | \
    sed -e "s/5.877472e-39/0/" -e "s/2.066667/2.0666671/" \
        -e "s/1.466667/1.4666671/" -e "s/5.88e-39/0/" \
    > "${TARGET}"

