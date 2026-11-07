# Vizion

A dark, modern dashboard theme for [Paymenter](https://paymenter.org), inspired by a dark billing dashboard design. Includes a small CLI to install, update and uninstall the theme.

## Requirements

- A working Paymenter installation
- Node.js 20 or newer and npm
- Git (only if you want `update` to pull from GitHub)

## Repository structure

```
vizion/
├── vizion.sh                      # CLI: install, update, uninstall
├── README.md
├── .gitignore
└── themes/
    └── vizion/
        ├── theme.php              # Theme name and admin settings
        ├── resources/
        │   └── css/
        │       └── vizion.css     # Dark theme styles
        └── views/                 # Blade views (see setup below)
```

## One-time setup: add the Blade views

The theme needs Paymenter's Blade views to work. They are not included in this repository, so copy them from Paymenter once:

```bash
cp -r /var/www/paymenter/themes/default/views/. themes/vizion/views/
```

Then link the Vizion styles in the theme's main CSS file (`themes/vizion/resources/css/app.css`):

```css
@import "./vizion.css";
```

Commit the views to your repository after this step.

## CLI usage

Run these commands from the repository folder:

```bash
./vizion.sh install     # Install the theme and build its assets
./vizion.sh update      # Pull the latest changes and rebuild
./vizion.sh uninstall   # Remove the theme and rebuild the default assets
./vizion.sh help        # Show help
```

If Paymenter is not in `/var/www/paymenter`, set the path first:

```bash
PAYMENTER_PATH=/path/to/paymenter ./vizion.sh install
```

After installing, go to the admin panel, open Settings, and select **Vizion** as the theme.

Note: `update` replaces the theme folder inside Paymenter, so keep any custom changes in this repository, not directly in Paymenter.

## Upload to GitHub

```bash
cd vizion
git init
git add .
git commit -m "Initial commit: Vizion theme and CLI"
git branch -M main
git remote add origin https://github.com/<your-username>/vizion.git
git push -u origin main
```

Create the empty `vizion` repository on GitHub first, then run these commands.
