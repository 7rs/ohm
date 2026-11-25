# Mixin overlap of candidates with the installed jars

## 1.0/forgeshot-mc1.20.1-1.0.jar

- same class and method as an installed mixin: 32 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| Minecraft | runTick | Inject @Lnet/minecraft/client/renderer/GameRenderer;render(FJZ)V | asyncparticles(Inject), chloride(Inject), chloride(Redirect), chloride(WrapOperation), embeddium(Inject), ixeris(Inject), xaeros-world-map(Inject), xaeros-world-map(ModifyArg) | no |
| Minecraft | resizeDisplay | ModifyArg @Lcom/mojang/blaze3d/platform/Window;setGuiScale(D)V | create(Inject), superb-warfare(Inject) | no |

## 1.0.1/PowerScreenshot-Minecraft1.20.1-Forge-1.0.1.jar

- same class and method as an installed mixin: 7 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | render | Inject  | embeddium(Inject), lr-tactical(Inject), modernfix(Inject), punchymoves(Inject), rrls(Inject) | no |

## 1.2.1-1.19.2-forge/panoramica_forge_1.2.1_MC_1.19-1.19.2.jar

- same class and method as an installed mixin: 7 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | getFov | Inject  | punchymoves(Inject), shoulder-surfing-reloaded(ModifyVariable), superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | shouldRenderBlockOutline | Inject  | create-steam-n-rails(Inject) | no |

## 1.1.8+1.20.1-forge/picturemode-forge-1.1.8+1.20.1.jar

- same class and method as an installed mixin: 173 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| Minecraft | runTick | WrapOperation @Lcom/mojang/blaze3d/pipeline/RenderTarget;blitToScreen(II)V | asyncparticles(Inject), chloride(Inject), chloride(Redirect), chloride(WrapOperation), embeddium(Inject), ixeris(Inject), xaeros-world-map(Inject), xaeros-world-map(ModifyArg) | no |
| Camera | setup | Inject  | create(ModifyArg), immersive-aircraft(Inject), punchy-fpa(Inject), punchymoves(Inject), shoulder-surfing-reloaded(Inject), shoulder-surfing-reloaded(Redirect), small-ships(Inject), small-ships(ModifyArg), small-ships(WrapOperation), superb-warfare(Inject), vanillabackport(Inject) | no |
| GameRenderer | getFov | Inject  | punchymoves(Inject), shoulder-surfing-reloaded(ModifyVariable), superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | getProjectionMatrix | Inject  | oculus(Redirect) | no |
| GameRenderer | renderLevel | WrapOperation @Ljava/lang/Math;max(DD)D | chloride(Inject), immersive-aircraft(Inject), oculus(Inject), oculus(ModifyArg), oculus(Redirect), punchymoves(Inject), shoulder-surfing-reloaded(Redirect), superb-warfare(Inject) | no |
| GameRenderer | bobView | Inject  | create-steam-n-rails(Inject), punchy-fpa(Inject), shoulder-surfing-reloaded(Inject), superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | bobHurt | Inject  | superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | renderLevel | WrapOperation @Lcom/mojang/blaze3d/systems/RenderSystem;clear(IZ)V | chloride(Inject), immersive-aircraft(Inject), oculus(Inject), oculus(ModifyArg), oculus(Redirect), punchymoves(Inject), shoulder-surfing-reloaded(Redirect), superb-warfare(Inject) | no |
| GameRenderer | renderItemInHand | Inject  | oculus(Redirect) | no |
| GameRenderer | render | ModifyExpressionValue  | embeddium(Inject), lr-tactical(Inject), modernfix(Inject), punchymoves(Inject), rrls(Inject) | no |
| GameRenderer | render | WrapOperation @Lnet/minecraft/client/gui/components/toasts/ToastComponent;r | embeddium(Inject), lr-tactical(Inject), modernfix(Inject), punchymoves(Inject), rrls(Inject) | no |
| LevelRenderer | renderSky | Inject  | botania(Inject), botania(ModifyVariable), clanging-howl(Inject), embeddium(Inject), enhanced-celestials-2-core(Inject), enhanced-celestials-2-core(ModifyExpressionValue), enhanced-celestials-2-core(WrapOperation), oculus(Inject), oculus(ModifyVariable) | no |
| LevelRenderer | renderLevel | WrapOperation @Lnet/minecraft/client/Options;getCloudsType()Lnet/minecraft/ | asyncparticles(Inject), botania(Inject), chloride(Redirect), colorwheel(Inject), create(Inject), create-steam-n-rails(WrapWithCondition), embeddium(Inject), embeddium(ModifyVariable), enhanced-celestials-2-shader-support(Inject), flerovium(Redirect), immersive-vehicles(Inject), obe(WrapOperation), oculus(Inject), oculus(ModifyArg), oculus(ModifyVariable), oculus(Redirect), patchouli(Inject), playeranimator(Inject), punchy-fpa(Inject), punchymoves(Inject), superb-warfare(Inject) | no |
| LevelRenderer | setupRender | ModifyExpressionValue  | create-steam-n-rails(Redirect) | no |
| LevelRenderer | setupRender | Inject @Lnet/minecraft/client/renderer/LevelRenderer;prevCamRotY:D | create-steam-n-rails(Redirect) | no |
| RenderSystem | setShaderFogStart | ModifyVariable  | create(Inject), superb-warfare(Inject) | no |
| RenderSystem | setShaderFogEnd | ModifyVariable  | create(Inject), superb-warfare(Inject) | no |
| SodiumWorldRenderer | setupTerrain | ModifyExpressionValue  | oculus(Redirect) | no |
| SodiumWorldRenderer | setupTerrain | Inject @Lme/jellysquid/mods/sodium/client/render/SodiumWorldRenderer | oculus(Redirect) | no |

## v20.1.0-1.20.1-Forge/Pixelshot-v20.1.0-1.20.1-Forge.jar

- same class and method as an installed mixin: 24 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | renderLevel | ModifyVariable  | chloride(Inject), immersive-aircraft(Inject), oculus(Inject), oculus(ModifyArg), oculus(Redirect), punchymoves(Inject), shoulder-surfing-reloaded(Redirect), superb-warfare(Inject) | no |
| GameRenderer | renderLevel | WrapOperation @Lnet/minecraft/client/renderer/GameRenderer;getProjectionMat | chloride(Inject), immersive-aircraft(Inject), oculus(Inject), oculus(ModifyArg), oculus(Redirect), punchymoves(Inject), shoulder-surfing-reloaded(Redirect), superb-warfare(Inject) | no |
| LevelRenderer | renderClouds | Inject  | distanthorizons(Inject), embeddium(Inject), oculus(Inject) | no |

## 1.3.5+forge-1.20.1/snapmatica-1.3.5+forge-1.20.1.jar

- same class and method as an installed mixin: 83 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| Camera | setup | Inject  | create(ModifyArg), immersive-aircraft(Inject), punchy-fpa(Inject), punchymoves(Inject), shoulder-surfing-reloaded(Inject), shoulder-surfing-reloaded(Redirect), small-ships(Inject), small-ships(ModifyArg), small-ships(WrapOperation), superb-warfare(Inject), vanillabackport(Inject) | no |
| GameRenderer | getFov | Inject  | punchymoves(Inject), shoulder-surfing-reloaded(ModifyVariable), superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | getProjectionMatrix | Inject  | oculus(Redirect) | no |
| GameRenderer | renderLevel | Inject @Lnet/minecraft/client/Camera;getXRot()F | chloride(Inject), immersive-aircraft(Inject), oculus(Inject), oculus(ModifyArg), oculus(Redirect), punchymoves(Inject), shoulder-surfing-reloaded(Redirect), superb-warfare(Inject) | no |
| GameRenderer | bobView | Inject  | create-steam-n-rails(Inject), punchy-fpa(Inject), shoulder-surfing-reloaded(Inject), superb-warfare(Inject), timeless-and-classics-zero(Inject) | no |
| GameRenderer | render | Inject @Lnet/minecraft/client/renderer/GameRenderer;renderLevel(FJLc | embeddium(Inject), lr-tactical(Inject), modernfix(Inject), punchymoves(Inject), rrls(Inject) | no |
| Gui | renderCrosshair | Inject  | betterf3(Redirect), punchymoves(Redirect), shoulder-surfing-reloaded(Redirect), small-ships(Inject) | no |
| MouseHandler | onScroll | Inject  | small-ships(Inject) | no |
| MouseHandler | turnPlayer | Inject  | punchymoves(WrapOperation), shoulder-surfing-reloaded(Redirect), small-ships(Inject), superb-warfare(ModifyVariable), timeless-and-classics-zero(WrapOperation) | no |
| MouseHandler | onPress | Inject  | punchymoves(Inject), small-ships(Inject) | no |
| ParticleEngine | tick | Inject  | asyncparticles(Inject), asyncparticles(WrapOperation) | no |

