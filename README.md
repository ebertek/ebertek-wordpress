# ebertek-wordpress

Minimal WordPress PHP 8.5 FPM Alpine derivative with `pdo_mysql` for YOURLS and other PHP applications.

## Release policy

The Dockerfile pins the exact upstream WordPress version and PHP variant. Renovate proposes both WordPress version updates and digest updates when upstream rebuilds an unchanged tag (for example, for CVE fixes). It pins the upstream Dockerfile FROM reference to a digest, and is configured to automerge eligible non-major and digest updates. A successful build on `main` publishes:

- `ghcr.io/ebertek/ebertek-wordpress:<wordpress-version>-php8.5-fpm-alpine-<git-sha12>` (immutable-by-convention build tag)
- `ghcr.io/ebertek/ebertek-wordpress:<wordpress-version>-php8.5-fpm-alpine` (rolling per-WordPress-version tag)
- `ghcr.io/ebertek/ebertek-wordpress:php8.5-fpm-alpine` (rolling tag)

A distinct GitHub release `v<wordpress-version>-php8.5-<git-sha12>` is created after each successful published build, including security rebuilds where the WordPress version is unchanged.

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
- Renovate's first run with digest pinning enabled should propose a pinDigest PR, then subsequent upstream digest changes will trigger digest PRs. The Dockerfile's FROM stays on the same human-readable WordPress tag and appends `@sha256:...`.
- Renovate PR automerge depends on GitHub repository permissions and branch rules. Protect the default branch with required build checks before allowing automatic merges.
- The workflow creates a distinct build release for every qualifying Dockerfile change. Deploy the commit-suffixed tag (or a downstream pinned digest) when you need immutable deployments.
