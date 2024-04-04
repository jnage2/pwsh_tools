


function Update-ScriptFromGitHub {
    param (
        [string]$RepositoryUrl,
        [string]$DeployKeyPath,
        [string]$LocalScriptPath,
        [string]$LocalHashPath
    )

    # Configuration SSH pour utiliser la clé de déploiement
    $env:GIT_SSH_COMMAND = "ssh -i `"$DeployKeyPath`""

    # Récupérer le hash du dernier commit depuis GitHub
    $latestCommit = Invoke-RestMethod -Uri "$RepositoryUrl/commits/master" -Headers @{Authorization = "Bearer <VotreTokenGitHub>"}
    $latestHash = $latestCommit.sha

    # Lire le hash local
    $localHash = ""
    if (Test-Path $LocalHashPath) {
        $localHash = Get-Content $LocalHashPath
    }

    # Comparer les hashes et mettre à jour si nécessaire
    if ($latestHash -ne $localHash) {
        Write-Output "Une mise à jour est disponible. Mise à jour en cours..."

        # Télécharger la mise à jour
        git -C $(Split-Path $LocalScriptPath) pull

        # Mise à jour du hash local
        Set-Content -Path $LocalHashPath -Value $latestHash

        Write-Output "Mise à jour terminée."
    } else {
        Write-Output "Votre script est déjà à jour."
    }
}
function Install-LatestModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$moduleName
    )

    process {
        # Vérifier si le module est déjà  installé
        $installedModule = Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue

        if ($installedModule) {
            # Le module est déjà  installé, vérifier s'il y a une mise à jour disponible
            $latestVersion = Find-Module -Name $moduleName | Sort-Object Version -Descending | Select-Object -First 1

            if ($latestVersion.Version -gt $installedModule.Version) {
                # Installer la dernière version du module
                Install-Module -Name $moduleName -Force -AllowClobber
                Write-Host "Module $moduleName mis à jour vers la version $($latestVersion.Version)"
            }
            else {
                Write-Host "Module $moduleName est déjà à la dernière version."
            }
        }
        else {
            # Installer le module s'il n'est pas déjà  installé
            Install-Module -Name $moduleName -Force
            Write-Host "Module $moduleName installé avec succès."
        }
    }
}