# How to update Homebrew recipe

1. [Install current version with Homebrew](https://github.com/porras/crul#mac) if it wasn't installed
1. `brew edit crul`
  * Edit `url`
  * Remove `bottle` section
1. `brew uninstall crul`
1. `brew install crul`
  * This will fail because the checksum doesn't match. The new one will be shown
  * **Check it**
  * Update it running `brew edit crul` again
  * Retry the install
1. Optionally, create a *bottle* (see below)
1. `cd /usr/local/Homebrew/Library/Taps/porras/homebrew-tap`
1. Commit (message can be `[crul] vX.Y.Z`) and push
  * If login is prompted, cancel and add a `mine` remote with `git remote add mine git@github.com:porras/homebrew-tap.git`)
  * From now on the push command will be `git push mine master`

## How to create a *bottle*

1. Uninstall and reinstall with `brew install crul --build-bottle`
1. `brew bottle crul`
1. Upload the generated `tar.gz` to the release and copy its download URL
1. Copy the generated snippet into `brew edit crul` and add a `root_url` line with the copied URL **minus the filename**
1. Check it by uninstalling and installing again (no flags)

# How to build and release Ubuntu package

1. Run `./release.linux` (requires Docker, and probably a fast internet connection 😁)
1. Upload the generated `build/whatever.deb` to the release
