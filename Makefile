SNAPSHOT_PATH := /snapshots

.PHONY: link unlink snapshot install upgrade refresh-package-list

## --- Dotfiles 管理 ---
link:
	@echo "🔗 Linking dotfiles..."
	@stow -v --target ~ home
	@stow -v --target ~/.config config
	@stow -v --target ~/.local/share local
	@fc-cache -f

unlink:
	@echo "❌ Unlinking dotfiles..."
	@stow -v --target ~ -D home
	@stow -v --target ~/.config -D config
	@stow -v --target ~/.local/share -D local
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
	@test -f packages.txt && paru -S --needed --noconfirm $$(grep -vE '^\s*#|^\s*$$' packages.txt) || \
	(echo "packages.txt not found."; exit 1)

## --- 系統升級 + 快照 ---
upgrade:
	@echo "⬆️  Upgrading system..."
	@make snapshot
	@paru -Syu

## --- 產生最新手動安裝的套件清單 ---
refresh-package-list:
	@echo "📝 Saving manually installed packages to packages.txt..."
	@paru -Qeq > packages.txt
