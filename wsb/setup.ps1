$homedir = Resolve-Path ~
$sandbox = Join-Path -Path ~/Downloads -ChildPath Sandbox
New-Item -Path $sandbox -ItemType Directory

New-Item -Path \Local -ItemType Directory
New-Item -Path \Local -ItemType Directory
