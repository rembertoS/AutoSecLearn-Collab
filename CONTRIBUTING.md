# Contributing to AutoSecLearn

## Project Structure

The app has **5 tabs**:

| Tab | Owner | File | Description |
|-----|-------|------|-------------|
| Home | Bryan Puckett | `HomeView.swift` | App info, team listing, features |
| Tab 2 | Giovanna Curry | `GiovannaView.swift` | Giovanna's section |
| Tab 3 | Remberto Silva | `RembertoView.swift` | Remberto's section |
| Tab 4 | Meagan Alfaro | `MeaganView.swift` | Meagan's section |
| Tab 5 | Alec Rivera | `AlecView.swift` | Alec's section |

> **Your file is the one with your name. Only edit your own file.**

```
AutoSecLearn/
├── AutoSecLearnApp.swift          -- App entry point (DO NOT EDIT)
├── Theme.swift                    -- Shared colors, fonts & styles (feel free to use!)
├── Modules/
│   ├── Module.swift               -- Data models
│   └── Quiz.swift                 -- Quiz models
├── Views/
│   ├── ContentView.swift          -- Tab bar with 5 tabs (DO NOT EDIT)
│   ├── HomeView.swift             -- Home tab (DO NOT EDIT)
│   ├── GiovannaView.swift         -- Giovanna's section
│   ├── RembertoView.swift         -- Remberto's section
│   ├── MeaganView.swift           -- Meagan's section
│   ├── AlecView.swift             -- Alec's section
│   ├── Remberto/                  -- Remberto's additional files
│   └── Alec/                      -- Alec's additional files
└── Assets.xcassets/               -- App icons and colors
```

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| Swift | Programming language |
| SwiftUI | UI framework |
| Xcode 16 | IDE |
| iOS 18+ | Target platform |

## Getting Started

Follow these steps **in order**. If you get stuck, check the [Troubleshooting](#troubleshooting) section at the bottom.

### 1. Install Xcode

Download **Xcode** from the Mac App Store. It's free but large (~7 GB).

You also need the command line tools. Open **Terminal** and run:

```bash
xcode-select --install
```

### 2. Clone the Repository

In Terminal, paste this command:

```bash
git clone https://github.com/AutoSecLearnFIU/AutoSecLearn-Collab.git
```

This downloads the project to a folder called `AutoSecLearn-Collab` in your home directory.

### 3. Open in Xcode

Run this in Terminal:

```bash
open AutoSecLearn-Collab/AutoSecLearn/AutoSecLearn.xcodeproj
```

Or navigate to the folder in Finder and double-click the `.xcodeproj` file.

### 4. Run the App

1. In Xcode, click the device dropdown at the top and pick **iPhone 16 Pro** (or any simulator)
2. Press **Cmd + R** or click the Play button
3. The app should launch with 5 tabs

If the build fails or the simulator doesn't open, see [Troubleshooting](#troubleshooting).

## Working on Your Section

Do these steps **every time** you sit down to code.

### Step 1: Pull the Latest Code

Before you start, always get the latest version:

```bash
cd ~/AutoSecLearn-Collab
git pull origin main
```

This makes sure you have everyone's latest changes.

### Step 2: Create Your Branch

A branch is your own copy of the code that won't mess up anyone else's work.

```bash
git checkout -b your-name-section
```

Replace `your-name-section` with your actual name:

| Person | Command |
|--------|---------|
| Giovanna | `git checkout -b giovanna-section` |
| Remberto | `git checkout -b remberto-section` |
| Meagan | `git checkout -b meagan-section` |
| Alec | `git checkout -b alec-section` |

> **Note:** If you already created your branch before, use `git checkout your-name-section` (without the `-b`) to switch back to it.

### Step 3: Edit Your File

Open your file in Xcode and build whatever you want. Here's a starter example:

```swift
import SwiftUI

struct GiovannaView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, this is my section!")
                    .font(.title)

                // Add your content here
            }
            .navigationTitle("Giovanna's Section")
        }
    }
}
```

**Only edit the file with YOUR name.** Do not touch other people's files or any file marked `DO NOT EDIT`.

### Step 4: Test Your Changes

Press **Cmd + R** to run the app. Navigate to your tab and make sure everything looks right.

### Step 5: Commit and Push

When you're happy with your work, open Terminal and run these commands **one at a time**:

```bash
cd ~/AutoSecLearn-Collab
```

```bash
git add .
```

```bash
git commit -m "Added my section - YourName"
```

```bash
git push origin your-name-section
```

Replace `YourName` and `your-name-section` with your actual name and branch name.

### Step 6: Create a Pull Request

1. Go to the repo page: [github.com/AutoSecLearnFIU/AutoSecLearn-Collab](https://github.com/AutoSecLearnFIU/AutoSecLearn-Collab)
2. You should see a yellow banner that says your branch had recent pushes
3. Click the green **"Compare & pull request"** button
4. Add a title (like "Giovanna's section") and click **"Create pull request"**
5. Bryan will review and merge it

> **Important:** Pushing your code does NOT automatically create a pull request. You have to do step 6 manually on GitHub.

## Important Rules

| # | Rule |
|---|------|
| 1 | **Only edit YOUR file.** Do not touch `ContentView.swift`, `HomeView.swift`, `Theme.swift`, `AutoSecLearnApp.swift`, or anyone else's file. |
| 2 | **Always create a branch first.** Never code directly on `main`. |
| 3 | **Pull before you start.** Run `git pull origin main` every time before you begin working. |
| 4 | **Extra files go in your own folder.** If you need helpers or models, create `Views/YourName/` and put them there. |
| 5 | **Test before pushing.** Run the app with Cmd + R and make sure your tab works before you commit. |

## Using the Shared Theme (Optional)

The `Theme.swift` file has reusable colors, fonts, and styles. You don't have to use them, but they're there if you want a consistent look.

**Colors:**
```swift
AppTheme.primary              // Teal accent color
AppTheme.primaryGradient      // Teal-to-blue gradient
AppTheme.secondaryGradient    // Indigo-to-purple gradient
AppTheme.cardBackground       // Light gray background
```

**Fonts:**
```swift
AppTheme.largeTitle    // 28pt bold rounded
AppTheme.title         // 22pt bold rounded
AppTheme.headline      // 17pt semibold rounded
AppTheme.body          // 15pt regular
AppTheme.caption       // 13pt medium
```

**Card Style:** Wrap any view in `.cardStyle()` to give it a card background:

```swift
VStack {
    Text("My Content")
}
.cardStyle()
```

## Can My Section Use Data From Someone Else's Section?

**Short answer: Not easily, and you probably don't need to.**

Each tab is independent. Think of it like separate mini-apps inside one app. If you build flashcards in your tab and someone else builds a quiz in theirs, those are two separate features that don't talk to each other.

If you absolutely need shared data (like a shared score or user profile):

1. Create a shared model file (a new `.swift` file both tabs import)
2. Pass it through the app's environment (requires editing `ContentView.swift` and `AutoSecLearnApp.swift`)
3. Coordinate with Bryan to set that up

**For this project, just focus on making your own tab great. Keep it simple.**

## Troubleshooting

### I can't clone the repo

Make sure Git is installed:

```bash
git --version
```

If it says "command not found", install the Xcode Command Line Tools:

```bash
xcode-select --install
```

### I can't push

You probably don't have access to the repo. Send Bryan your GitHub username so he can add you as a collaborator. You also need to accept the invite (check your email or GitHub notifications).

### Xcode says "No such module" or can't find a file

1. Close Xcode completely (Cmd + Q)
2. Reopen the `.xcodeproj` file
3. Try building again (Cmd + R)

If that doesn't work:

1. Go to **Product > Clean Build Folder** (Shift + Cmd + K)
2. Build again with Cmd + R

### My code won't build

Make sure you only edited YOUR file. If you accidentally changed another file, undo it with:

```bash
git checkout -- AutoSecLearn/AutoSecLearn/Views/ContentView.swift
```

### I get a merge conflict

This means you edited a file someone else also changed. To fix it:

1. Save your work: `git stash`
2. Get the latest code: `git pull origin main`
3. Bring your changes back: `git stash pop`
4. If there's still a conflict, open the file and look for lines starting with `<<<<<<<`. Keep the code you want and delete the conflict markers.

If this is confusing, ask Bryan for help.

### I pushed but don't see a pull request

Pushing does NOT automatically create a pull request. You need to:

1. Go to the [repo page on GitHub](https://github.com/AutoSecLearnFIU/AutoSecLearn-Collab)
2. Click the green **"Compare & pull request"** button (or go to Pull Requests > New pull request)
3. Add a title and click **"Create pull request"**

### The simulator won't launch

1. Make sure you picked a simulator from the device dropdown at the top of Xcode (like iPhone 16 Pro)
2. If it still doesn't work, go to **Window > Devices and Simulators**, delete the simulator, and Xcode will recreate it
3. Try building again with Cmd + R

### I accidentally committed to main

Don't panic. Run:

```bash
git log --oneline -3
```

Then create a branch from where you are:

```bash
git checkout -b your-name-section
git push origin your-name-section
```

This moves your commit to a proper branch. Tell Bryan so he can clean up main.

### Where do I put new files?

If you need extra Swift files (models, helpers, subviews, etc.), create a folder with your name inside Views:

```
Views/
├── Giovanna/
│   ├── MyHelper.swift
│   └── MyModel.swift
├── GiovannaView.swift
└── ...
```

### How do I undo my last commit?

If you committed but haven't pushed yet:

```bash
git reset --soft HEAD~1
```

This undoes the commit but keeps your changes. You can then edit your code and commit again.

> **Warning:** Only do this if you have NOT pushed yet. If you already pushed, do not use this command.
