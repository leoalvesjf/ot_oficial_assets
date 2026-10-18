# Combat and creature visual assets (1525)

This package preserves existing server IDs for visual replacements and includes dedicated effects awaiting server routing. Install the complete catalog, its referenced appearances file, spritesheets and Echo shader directory together in `data/things/1525/`. Runtime IDs are independent of Elderan/OTS Creator editor IDs. No server mechanics or client executable is shipped here.

## Spell/effect contract

| Purpose | Runtime effect | Source |
|---|---:|---|
| Critical label | 173 | Elderan36 CRIT;35 BLESS is not used |
| Exori/shared physical area | 10 | Elderan50 |
| Blue healing/shared magic blue | 13 | Elderan58 |
| Haste/shared magic green | 15 | Elderan57 |
| SD impact, modern/traditional | 18 /352 | Elderan65 |
| Energy impact/area/strike/wave | 12 /38 /354 /358 | Elderan29 |
| Exevo mas san/shared holy area | 50 | Elderan41 |
| Exevo gran mas vis, traditional/modern | 351 /41 | Elderan60, native palette5 recolor;11x80ms |
| Exevo gran mas tera, traditional/modern | 9 /46 | Medivia485 refined;10x75ms;56px content on64px canvas |
| Exori ico sword/axe/club | 362 /363 /364 | Elderan72/74/76;server selection pending |
| Previous nondirectional melee slash | 365 | Elderan71;superseded by directional contract below |
| Exori con dedicated impact | 384 | Elderan31;server routing/availability pending |
| Melee north/east/south/west | 385 /386 /387 /388 | User-reduced editor87 derived from Elderan71;6x60ms |

Directional effects are installed and available. All use a64x64 transparent canvas;east/west content64x32,north/south32x64,centered without interpolation. Server chooses ONE based on attacker/target delta at a confirmed successful melee hit;no automatic rotation or direction inferred by client. Four cardinal directions only;diagonal policy and anchors must be verified in gameplay. Preserve blood360/361 andcritical173;exclude spells,ranged,wands,misses,blocks,zero damage;do not duplicate on primary+secondary damage.364 is a club spell effect,not an attack direction. IDs88..91 remain editor-only.

Projectile replacements:energy5/71 <- Elderan16;arrow3 <-17;SD32/69 <-22;bolt2 <-29;powerbolt14 <-31. Shared effect/projectile IDs change every producer that sends them,including other spells or NPC actions. In particular exori con is not mapped onto shared10,which would overwrite the exori visual.

## Creature and corpse replacements

38 species outfits are replaced using their existing lookTypes;CommunityManager266 additionally uses Elderan400. Dog uses source256 ->32;Cat257 ->276. Dragon34,DragonLord39,GiantSpider38 retain their lookTypes. Source layers,directions,addons,idle/walk phases and durations are preserved. Dog/Cat source idle has one frame;no new idle motion is claimed.

| Creature | Initial corpse | Decay chain |
|---|---:|---|
| Dragon34 | 5973 | 4025 ->4026 ->4027 ->removed |
| DragonLord39 | 5984 | 4062 ->4063 ->4064 ->removed |
| GiantSpider38 | 5977 | 4038 ->4039 ->4040 ->removed |

These12corpse objects supplement128previous replacements,including decay states. Legacy first corpse imagery is also used for modern initial corpse IDs;do not assume identical numeric IDs across packages. All item properties and decay durations remain server-defined and unchanged. Cat corpses286..289 lack a confirmed replacement and remain unchanged;shared ashes7349 are retained. TargetDummy item15710 uses Elderanoutfit258 visual;TrainingMachine/Maxxenius1142 are unchanged.

Originals are preserved in client appearance IDs:outfits1950..1988;objects54267..54407;effects366..383;missiles72..78. These are archive visuals,not new server gameplay items. The rejected generated Dog32 and generated explosion proposal are excluded. Native editable OTOBJ sources are under`sources/animations/`.

## Verification and limitations

Conversions check decoded pixels against BMP/LZMA roundtrips,source phase counts/timings,unique IDs/nonoverlapping spritesheet ranges,unchanged unrelated appearance records and synchronized local Assets/Client hashes. Effect animations play once(COUNTED1). Historical manifests describe each conversion's base/result hashes;only the current catalog determines the active appearance file. They are provenance records,not a launcher update manifest. Runtime updates must follow the repository distribution process.

User gameplay checks and deployment are separate from static/conversion verification. New custom IDs need server validation/selection before they appear. Exori con currently belongs to Paladin/RoyalPaladin in server sources;the requested Knight availability is a separate server demand and must not silently remove Paladin access. Exori ico is registered for Knight/EliteKnight;the server must verify the actual gate that blocks it. No damage,cost,cooldown or vocation formula is recalculated here.
