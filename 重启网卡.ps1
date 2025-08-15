
# Windows 出于安全考虑，默认 不允许执行脚本，你需要设置执行策略。
# 查看当前策略：
# Get-ExecutionPolicy
# 临时设置为允许本地脚本运行：
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# RemoteSigned：运行本地脚本无需签名，但下载的脚本必须由可信发布者签名。



# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb RunAs -ArgumentList $Command
        Exit
 }
}

# Place your script here
Disable-NetAdapter -InterfaceDescription "Intel(R) WiFi Link 5100 AGN" -Confirm:$false
Enable-NetAdapter -InterfaceDescription "Intel(R) WiFi Link 5100 AGN" -Confirm:$false