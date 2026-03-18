# BlockBlast — Android APK Export Guide

## Required GitHub Secrets

**No secrets are required for debug builds.** The workflow generates a fresh debug keystore on every run automatically.

If you want **release/Play Store builds** (see section below), you will need to add secrets. For debug builds, just push to `main` or trigger manually.

---

## How to Trigger the Build

### Automatic
Push any commit to `main` or `master` — the workflow starts automatically.

### Manual
1. Go to your repo on GitHub
2. Click **Actions** in the top navigation
3. In the left sidebar, click **"Build Android APK"**
4. Click the **"Run workflow"** button on the right
5. Select branch `main` and click **"Run workflow"**

---

## How to Download the APK Artifact

1. Go to **Actions** → click the completed workflow run
2. Scroll to the bottom of the run page to find the **Artifacts** section
3. Click **"BlockBlast-APK"** to download a `.zip` file
4. Extract the `.zip` — inside is `BlockBlast.apk`

> Artifacts are kept for **30 days** by default.

---

## How to Install on an Android Device

### Step 1 — Enable installation from unknown sources

**Android 8+:**
1. Settings → Apps → Special app access → Install unknown apps
2. Find your file manager or browser → toggle **Allow from this source**

**Older Android:**
1. Settings → Security → toggle **Unknown sources**

### Step 2 — Transfer and install

- Connect your phone via USB and copy `BlockBlast.apk` to it, **or**
- Email the APK to yourself and open it on the phone, **or**
- Use Google Drive / any cloud storage

Tap the APK file in your file manager and follow the install prompts.

---

## Changing the Package Name

Edit `export_presets.cfg` and update this line:

```
package/unique_name="com.yourname.blockblast"
```

Replace `com.yourname.blockblast` with your own reverse-domain identifier (e.g. `com.studiofoo.blockblast`). Use only lowercase letters, digits, and dots. **This must be unique on the Play Store.**

Also bump `version/code` (integer) and `version/name` (string) with every release you publish.

---

## Adding a Release Keystore for Play Store Builds

Debug APKs cannot be published to the Play Store. You need a **release keystore** signed with your own key.

### Step 1 — Generate a release keystore (do this once, locally)

```bash
keytool -genkey -v \
  -keystore release.keystore \
  -alias my-release-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Keep `release.keystore` **secret** — never commit it to the repo.

### Step 2 — Add secrets to GitHub

In your repo: **Settings → Secrets and variables → Actions → New repository secret**

| Secret name              | Value                                      |
|--------------------------|--------------------------------------------|
| `RELEASE_KEYSTORE_BASE64`| `base64 -w 0 release.keystore`             |
| `RELEASE_KEY_ALIAS`      | The alias you used (e.g. `my-release-key`) |
| `RELEASE_KEY_PASSWORD`   | Your key password                          |
| `RELEASE_STORE_PASSWORD` | Your keystore password                     |

### Step 3 — Update the workflow

Add a step to decode the keystore and use it:

```yaml
- name: Decode release keystore
  run: |
    echo "${{ secrets.RELEASE_KEYSTORE_BASE64 }}" | base64 -d > ~/release.keystore

- name: Configure release keystore in editor settings
  run: |
    cat >> ~/.config/godot/editor_settings-4.tres <<EOF
    export/android/release_keystore = "$HOME/release.keystore"
    export/android/release_keystore_user = "${{ secrets.RELEASE_KEY_ALIAS }}"
    export/android/release_keystore_pass = "${{ secrets.RELEASE_KEY_PASSWORD }}"
    EOF
```

Then change the export step to use `--export-release` instead of `--export-debug`:

```yaml
- name: Export Android APK (release)
  run: godot --headless --export-release "Android" "./build/BlockBlast.apk"
```

And update `export_presets.cfg` to reference the release keystore:

```ini
keystore/release="$HOME/release.keystore"
keystore/release_user="my-release-key"
keystore/release_password="your-password"
package/signed=true
```
