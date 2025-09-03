# Repository Guidelines

## Project Structure & Module Organization
- `docker/`: Build context for the image.
  - `Dockerfile`: Debian bookworm-slim + Fish + tooling.
  - `config.fish`: Shell theme, aliases, and PATH.
- `.devcontainer/devcontainer.json`: VS Code Dev Container setup.
- `Makefile`: Build/test shortcuts using Docker Buildx.
- `README.md`, `CLAUDE.md`: Usage overview and agent notes.
- `.env`, `.env.example`: Optional local overrides (do not commit secrets).

## Build, Test, and Development Commands
- `make test`: Build both platforms (arm64, amd64) and clean up test images.
- `make test.arm64` / `make test.amd64`: Build and remove a single-arch test image.
- `make test.build.arm64` / `make test.build.amd64`: Build only (no cleanup).
- Build args (override per run):
  - Example: `make test USER_NAME=myuser USER_ID=1001 GROUP_ID=1001`.

## Coding Style & Naming Conventions
- Dockerfile: Keep logical sections (packages, cloud tools, docker, node, python, fish) with comments; group related RUN steps; favor `--no-install-recommends` and clean apt caches.
- Shell: Fish functions/aliases live in `docker/config.fish`; prefer clear alias names (e.g., `py`, `pip` via `uv`).
- Tags/Names: Use `ghcr.io/bearfield/debian-fish:bookworm` (release) and `:test.bookworm.<arch>` for local tests.

## Testing Guidelines
- No unit tests; validation is through successful multi-arch builds.
- Prereqs: Docker Buildx enabled and QEMU for cross build.
- Local verification: `docker run --rm -it ghcr.io/bearfield/debian-fish:bookworm fish -c 'fish --version && python3 --version'`.
- Keep `make test` green for both architectures before opening a PR.

## Commit & Pull Request Guidelines
- Commits: Japanese, concise, purpose-first. Example: `feature: buildx対応のテストターゲットを追加`.
- Branches: `feature/<内容>` or `fix/<内容>`; avoid direct pushes to `main`.
- PRs: Include summary, rationale, key changes, and linked issues. Add screenshots or logs for build output when relevant.

## Security & Configuration Tips
- Never commit credentials. Update `.env.example` when adding new env vars.
- Devcontainer mounts host configs (gcloud, ssh, claude). Verify paths in `.devcontainer/devcontainer.json`.
- Use least-privilege tokens for CI publishing (if configured).

## Agent-Specific Notes
- Start with `CLAUDE.md` for agent context and commands.
- Limit edits to `docker/`, `.devcontainer/`, `Makefile`, and docs unless otherwise requested.
- Follow repository command policy and prefer `git switch`/PR workflow.

