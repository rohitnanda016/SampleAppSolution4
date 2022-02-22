# function Install-NpmPackages($path) {
#         echo "calling install npm packages"
#         echo $path
#         # Npm packages are installed on the pipeline via [Task group : Authenticate and install npm packages](https://dev.azure.com/dynamicscrm/OneCRM/_taskgroup/9527f1c6-0411-450f-af8c-60fed0cdadea)

#         if ($env:WSRoot -ne $path) {
#             $null = Copy-Item -Path "$env:WSRoot\.npmrc" -Destination "$path\.npmrc"
#         }

#         $null = Push-Location $path
#         try {
#             echo "Registry: $(npm config get registry)"
#             npm install
#         } finally {
#             $null = Pop-Location
#         }
    
# }

# echo "Installing node module packages"
# Install-NpmPackages "$env:WSRoot\solutions\SampleApp"