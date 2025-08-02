TARGET_HOME := ~
TARGET_CONFIG := ~/.config
TARGET_LOCAL := ~/.local/share
SNAPSHOT_PATH := /snapshots

.PHONY: link unlink snapshot install upgrade refresh-package-list reset-audio

## --- Dotfiles 管理 ---
link:
	@echo "🔗 Linking dotfiles..."
	@stow -v --target $(TARGET_HOME) home
	@stow -v --target $(TARGET_CONFIG) config
	@stow -v --target $(TARGET_LOCAL) local
	@fc-cache -f

unlink:
	@echo "❌ Unlinking dotfiles..."
	@stow -v --target $(TARGET_HOME) -D home
	@stow -v --target $(TARGET_CONFIG) -D config
	@stow -v --target $(TARGET_LOCAL) -D local
	@fc-cache -f

## --- 建立 Btrfs 快照 ---
snapshot:
	@echo "📸 Creating btrfs snapshots..."
	@NOW=$$(date +%Y%m%d-%H%M%S); \
	sudo btrfs su snap / $(SNAPSHOT_PATH)/root-$$NOW && \
	sudo btrfs su snap /home $(SNAPSHOT_PATH)/home-$$NOW

## --- 套件安裝（來自 package list） ---
install:
	@echo "📦 Installing packages from packages.txt..."
	@if [ ! -f packages.txt ]; then \
		echo "❌ packages.txt not found."; exit 1; \
	fi
	@paru -S --needed --noconfirm $$(grep -vE '^\s*#|^\s*$$' packages.txt)

## --- 系統升級 + 快照 ---
upgrade:
	@echo "⬆️  Upgrading system..."
	@make snapshot
	@paru -Syu
	@make reset-audio

## --- 產生最新手動安裝的套件清單 ---
refresh-package-list:
	@echo "📝 Saving manually installed packages to packages.txt..."
	@paru -Qeq > packages.txt

## -- Miscs --
reset-audio:
	@echo "🔄 Resetting PipeWire/WirePlumber state..."
	@rm -rf ~/.local/state/wireplumber
	@systemctl --user restart wireplumber pipewire pipewire-pulse
