# ebertek-wordpress

Minimal WordPress PHP 8.3 FPM Alpine derivative with `pdo_mysql` for YOURLS and other PHP applications.

## Release policy

The Dockerfile pins the exact upstream WordPress version and PHP variant. Renovate proposes updates to upstream WordPress releases within PHP 8.3 FPM Alpine and is configured to automerge passing PRs. A successful build on `main` publishes:

- `ghcr.io/ebertek/ebertek-wordpress:<wordpress-version>-php8.3-fpm-alpine` (immutable-by-convention release tag)
- `ghcr.io/ebertek/ebertek-wordpress:php8.3-fpm-alpine` (rolling tag)

A matching GitHub release `v<wordpress-version>` is created only after a successful image push.

The GitHub release reflects the bundled upstream WordPress version; it is not an official WordPress release.

## Setup

1. Enable the Renovate GitHub app on this repository.
2. Allow GitHub Actions to publish packages and create releases (`GITHUB_TOKEN` with `packages:write` and `contents:write`).
3. Confirm the first GitHub Actions run passes and GHCR tags exist.
4. In `ebertek-compose`, update WordPress's `image:` to the GHCR tag. Keep existing volumes and PHP configuration mounts; verify application health before production migration.

## Details

- The upstream image already includes `intl`, `mysqli`, `imagick`, `gd` and `zip`; this image installs just `pdo_mysql`.
- Runs PHP-FPM as `www-data`, matching the previous custom image.
- `php-fpm -t` validates FPM configuration, not actual site/database availability.
- Mounted `/usr/local/etc/php/conf.d` overrides image-provided extension INI files. Preserve the extension-enabling configurations.
- This workflow builds `linux/amd64`; changing PHP versions requires a deliberate edit.
- Renovate PR automerge depends on GitHub repository permissions and rules. Changes to upstream package layers without WordPress version changes do not trigger version releases.
