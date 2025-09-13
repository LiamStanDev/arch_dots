TARGET_HOME := ~
TARGET_CONFIG := ~/.config
TARGET_LOCAL := ~/.local/share

.PHONY: link unlink install upgrade refresh-package-list reset-audio

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
	@flatpak update -y
	@make refresh-flatpak-list
	@make reset-audio
	
## --- 產生最新手動安裝的套件清單 ---
refresh-package-list:
	@echo "📝 Saving manually installed packages to packages.txt..."
	@dnf repoquery --userinstalled --qf '%{name}\n' > packages.txt

refresh-flatpak-list:
	@echo "📝 Saving manually installed flatpak packages to flatpak-packages.txt..."
	@flatpak list --app --columns=application,origin | awk '{print $$1 " " $$2}' > flatpak-packages.txt

## --- 套件安裝（來自 package list） ---
install:
	@echo "📦 Installing packages from packages.txt..."
	@if [ ! -f packages.txt ]; then \
		echo "❌ packages.txt not found."; exit 1; \
	fi
	@sudo dnf install -y $$(grep -vE '^\s*#|^\s*$$' packages.txt)
	@if [ ! -f flatpak-packages.txt ]; then \
		echo "❌ flatpak-packages.txt not found."; exit 1; \
	fi
	@awk '{print $$2 " " $$1}' flatpak-packages.txt | xargs -L1 flatpak install -y --noninteractive

## -- Miscs --
reset-audio:
	@echo "🔄 Resetting PipeWire/WirePlumber state..."
	@rm -rf ~/.local/state/wireplumber
	@systemctl --user restart wireplumber pipewire pipewire-pulse
