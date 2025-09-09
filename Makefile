TARGET_HOME := ~
TARGET_CONFIG := ~/.config
TARGET_LOCAL := ~/.local/share
SNAPSHOT_PATH := /.snapshots
SNAPSHOT_RETAIN := 5

.PHONY: link unlink snapshot install upgrade refresh-package-list reset-audio

## --- Dotfiles 管理 ---
link:
	@echo "🔗 Linking dotfiles..."
	@stow -v --target $(TARGET_HOME) home
	@stow -v --target $(TARGET_CONFIG) config
	@stow -v --target $(TARGET_LOCAL) local

unlink:
	@echo "❌ Unlinking dotfiles..."
	@stow -v --target $(TARGET_HOME) -D home
	@stow -v --target $(TARGET_CONFIG) -D config
	@stow -v --target $(TARGET_LOCAL) -D local


## --- 系統升級 + 快照 ---
upgrade:
	@echo "⬆️  Upgrading system..."
	@sudo dnf upgrade -y
	@make refresh-package-list
	@make snapshot
	@make reset-audio
	
## --- 產生最新手動安裝的套件清單 ---
refresh-package-list:
	@echo "📝 Saving manually installed packages to packages.txt..."
	@dnf repoquery --userinstalled --qf '%{name}\n' > packages.txt


## --- Timeshift 快照管理 ---
snapshot:
	@echo "📸 Creating new Timeshift snapshot..."
	@sudo timeshift --create --comments "manual-$(shell date +%Y%m%d-%H%M%S)" --tags D

snapshot-list:
	@echo "📂 Listing Timeshift snapshots..."
	@sudo timeshift --list

snapshot-restore:
	@echo "♻️  Restoring latest Timeshift snapshot..."
	@sudo timeshift --restore

## --- 套件安裝（來自 package list） ---
install:
	@echo "📦 Installing packages from packages.txt..."
	@if [ ! -f packages.txt ]; then \
		echo "❌ packages.txt not found."; exit 1; \
	fi
	@sudo dnf install -y $$(grep -vE '^\s*#|^\s*$$' packages.txt)


## -- Miscs --
reset-audio:
	@echo "🔄 Resetting PipeWire/WirePlumber state..."
	@rm -rf ~/.local/state/wireplumber
	@systemctl --user restart wireplumber pipewire pipewire-pulse
