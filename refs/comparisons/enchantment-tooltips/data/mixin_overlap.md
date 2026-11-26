# Mixin overlap of candidates with the installed jars

## bs/Bookshelf-Forge-1.20.1-20.2.15.jar

- same class and method as an installed mixin: 10 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| LightningBolt | powerLightningRod | Inject  | vanillabackport(Inject) | no |
| LivingEntity | hurt | Inject  | aether(WrapWithCondition), irons-spells-n-spellbooks(Inject), l2-complements(WrapOperation), l2hostility(WrapOperation) | no |
| ClientLanguage | getOrDefault | Inject  | oculus(Inject), punchy-fpa(Inject), touhou-little-maid(Inject) | no |
| ClientLanguage | has | Inject  | oculus(Inject), touhou-little-maid(Inject) | no |

