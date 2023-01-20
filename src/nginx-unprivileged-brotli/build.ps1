[CmdletBinding(PositionalBinding = $false)]
param (
  [ValidateSet('docker')]
  [string]$Provider = 'docker',
  [string]$Repository = 'bases',
  [string]$Platform = 'linux/arm64,linux/amd64',
  [string]$NginxVersion = '1.23.3'
)

switch ($Provider) {
  docker {
    $repository = "jensdll/$Repository"
  }
}

$target = 'nginx-unprivileged-brotli'

docker buildx bake $target --file "$PSScriptRoot/../docker-bake.hcl" --push `
  --set "$target.context=$PSScriptRoot" `
  --set "*.platform=$platform" `
  --set "$target.args.NGINX_VERSION=$NginxVersion" `
  --set "$target.tags=${repository}:$target-$NginxVersion-alpine"
