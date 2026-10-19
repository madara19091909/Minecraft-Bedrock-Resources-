# Resource Pack Studio — Flutter starter

Arabic-first Android starter for Minecraft Bedrock resource-pack inspection and selection.

## Current MVP
- Import `.mcpack` and `.zip` files from Android storage.
- Index archive entries and provide category heuristics plus per-file checkboxes.
- Edit pack name, description, author and version.
- Select an optional pack icon.
- Export a new `.mcpack`, then share it or attempt to open it in Minecraft.
- GitHub Actions workflow builds a release APK artifact.

## Important limitations of this starter
- Category assignment is heuristic based on file paths, not a full semantic parser for every Bedrock resource-pack schema.
- Files are imported under a source prefix for indexing; export strips the first path segment. Do not import nested archives with unusual layouts without testing the result.
- The current conflict rule uses the last imported candidate by default. The `_conflictChoice` map is a foundation for a future UI; the conflict chooser UI is not implemented yet.
- Resource-pack files such as `textures/terrain_texture.json`, `textures/item_texture.json`, atlases, render controllers, geometry, and other references can require coordinated files. Arbitrary file filtering can break packs. This MVP is a prototype and exported packs must be tested in a disposable world.
- The built-in library is not populated with third-party packs. Add only packs you created or have permission to redistribute. A proper built-in catalog should store metadata separately from downloadable pack archives.
- The generated manifest uses a baseline `min_engine_version`; confirm and tune this against the Minecraft Bedrock versions you target.

## Use with an existing Flutter repository
1. Back up your current repository first.
2. Copy `lib/main.dart` and merge dependencies from `pubspec.yaml` into your existing project.
3. Copy `.github/workflows/build-apk.yml` if you want this workflow; adjust it to preserve any existing tests and analysis configuration.
4. Ensure `flutter test` succeeds. If the repository has no `test/` directory, add a minimal test or remove that step intentionally.
5. Push to GitHub, open **Actions**, and download `resource-pack-studio-apk` from a successful run.

This source bundle has not been compiled or tested against Minecraft in this environment.
