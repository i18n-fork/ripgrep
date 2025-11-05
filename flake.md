# 使用 Nix Flake 安装 ripgrep

本文档将指导您如何使用 Nix Flake 从 GitHub 仓库安装 `ripgrep`。

## 1. 开启 Nix Flakes 功能 (如果尚未开启)

编辑您的 Nix 配置文件 (`/etc/nixos/configuration.nix` 或 `~/.config/nix/nix.conf`) 并添加以下行：

```nix
experimental-features = nix-command flakes
```

对于 NixOS，请运行 `sudo nixos-rebuild switch` 重建系统。

## 2. 安装 ripgrep

运行以下命令，即可从 GitHub 仓库直接安装 `ripgrep` 到您的用户环境：

```bash
nix profile install 'github:i18n-fork/ripgrep'
```

安装完成后，您就可以在任何终端中使用 `rg` 命令。

```bash
rg --version
```

## 3. NixOS 系统级安装

如果您是 NixOS 用户，并希望将 `ripgrep` 作为系统包安装，可以修改您的系统 Flake 配置文件 (例如 `/etc/nixos/flake.nix`)。

1.  **添加 Flake 输入：** 在 `inputs` 部分添加 `ripgrep` Flake，并使用 `follows` 来统一 `nixpkgs` 的版本：

    ```nix
    # /etc/nixos/flake.nix
    {
      inputs = {
        # 确保您的系统中定义了 nixpkgs
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # ... 其他输入

        ripgrep = {
          url = "github:i18n-fork/ripgrep";
          # 确保 ripgrep 使用与您系统相同的 nixpkgs，避免依赖冲突
          inputs.nixpkgs.follows = "nixpkgs";
        };
      };

      outputs = { self, nixpkgs, ripgrep, ... }@inputs: {
        # ...
      };
    }
    ```

2.  **添加系统包：** 在您的 NixOS 模块 (例如 `/etc/nixos/configuration.nix`) 中，通过 `inputs` 参数来引用 `ripgrep` 包。

    ```nix
    # /etc/nixos/configuration.nix
    # 请确保 inputs 参数已在模块头部声明 { config, pkgs, inputs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # ... 其他包
        inputs.ripgrep.packages.${pkgs.system}.default
      ];
    }
    ```

3.  **重建系统：** 保存配置后，运行以下命令重建您的 NixOS 系统：

    ```bash
    sudo nixos-rebuild switch --flake /etc/nixos#
    ```

重建成功后，`rg` 命令将在您的整个系统中可用。