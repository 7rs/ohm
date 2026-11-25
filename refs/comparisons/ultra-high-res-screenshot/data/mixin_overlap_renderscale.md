# Mixin overlap of candidates with the installed jars

## 1.0.1/PowerScreenshot-Minecraft1.20.1-Forge-1.0.1.jar

- same class and method as an installed mixin: 2 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | render | Inject  | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |

## 1.1.8+1.20.1-forge/picturemode-forge-1.1.8+1.20.1.jar

- same class and method as an installed mixin: 8 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | renderLevel | WrapOperation @Ljava/lang/Math;max(DD)D | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |
| GameRenderer | renderLevel | WrapOperation @Lcom/mojang/blaze3d/systems/RenderSystem;clear(IZ)V | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |
| GameRenderer | render | ModifyExpressionValue  | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |
| GameRenderer | render | WrapOperation @Lnet/minecraft/client/gui/components/toasts/ToastComponent;r | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |

## v20.1.0-1.20.1-Forge/Pixelshot-v20.1.0-1.20.1-Forge.jar

- same class and method as an installed mixin: 4 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | renderLevel | ModifyVariable  | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |
| GameRenderer | renderLevel | WrapOperation @Lnet/minecraft/client/renderer/GameRenderer;getProjectionMat | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |

## 1.3.5+forge-1.20.1/snapmatica-1.3.5+forge-1.20.1.jar

- same class and method as an installed mixin: 6 pairs; hard-conflict candidates: 0

| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |
|---|---|---|---|---|
| GameRenderer | renderLevel | Inject @Lnet/minecraft/client/Camera;getXRot()F | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |
| GameRenderer | render | Inject @Lnet/minecraft/client/renderer/GameRenderer;renderLevel(FJLc | renderscale-2.0.0-beta.1-forge+1.20.1.jar(Inject) | no |

