# EnrolZSH - Project Boilerplate

This boilerplate is for the EnrolZSH plugin. It easily creates the needed structure inside your project folder and adds a custom script.

The whole structure is stored inside a `enrol` folder, which is also given inside this repo.
All credentials are hardcoded into the script. This makes everything more simple in the first step. Supports VCS, so you can share the scripts between coworkers.

## Requirements:

- oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
- enrolzsh (https://github.com/motionstudio/enrolzsh)

## Installation:

- Copy the git repo into your projects root directory.
- Replace the uppercase written names inside the `deploy.zsh` by your own project settings/credentials.

## Available commands:

| Commands | Description |
|---|---|
| **Shorthand** | Just works when included in your workflow, e.g bower, npm, browsersync |
| `PROJECT.project` | Moves to project directory |
| `PROJECT.theme` | Moves to your theme directory |
| `PROJECT.bower` | Installs bower components |
| `PROJECT.npm` | Installs node modules |
| `PROJECT.gulp` | Runs gulp in theme directory |
| `PROJECT.gw` | Runs gulp watch in theme directory (starts Browsersync) |
| **Deployment** | stage name = dev or live |
| `PROJECT.deploy` | Deploys code to staging by default, with optional argument <stage name> deploys to <stage name> |
| **Push/Pull (Sync)** |
| `PROJECT.files-push` | Pushes uploads from local to remote |
| `PROJECT.files-pull` | Pulls uploads from remote to local |
| `PROJECT.push` | Get installed version |
| `PROJECT.pull` | Get installed version |

You can easily customize all commands by just adding or editing the existing `deploy.zsh` file.