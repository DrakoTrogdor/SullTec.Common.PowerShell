# Using SemVer

Build with the following commands:

```ps1
    dotnet build
    dotnet build --configuration Release
```

Building will automatcially copy dll file to /Assemblies folder

Clean output folders with:

```ps1
    dotnet clean
```

Optimized builds can be created using the following:

```ps1
    dotnet --info # Retrieve the RID (Runtime Identifier) for the environement. Will be win10-x64 on a Windows 10 64bit environment.
    dotnet publich -c Release -r <RID> /p:PublishReadyToRun=true # Compile application to ReadyToRun format for the target platform
    dotnet publish -c Release --self-contained true -r win10-x64 /p:PublishReadyToRun=true # Add --self-contained true in order to use the .NET IL Link to remove unused code.
```

If the follow error occurs:

```txt
    SullTec.Common.PowerShell.SemVer.csproj : error NU1301: The local source 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\NuGetPackages' doesn't exist.
```

Run the following:

```ps1
    New-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\Shared\NuGetPackages' -Force -ErrorAction SilentlyContinue
```
