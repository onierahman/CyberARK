# Define the path to the text file containing IP addresses
$IPFilePath = "C:\Users\User\Desktop\IP List.txt"

# Define the port number to test
$Port = 3389  # Change this to the port you want to test

# Define the output file for results
$OutputFilePath = "C:\Users\User\Desktop\output.txt"

# Clear the output file if it exists, or create it
if (Test-Path -Path $OutputFilePath) {
    Clear-Content -Path $OutputFilePath
} else {
    New-Item -ItemType File -Path $OutputFilePath
}

# Check if the IP address file exists
if (!(Test-Path -Path $IPFilePath)) {
    Write-Output "IP list file not found at $IPFilePath" | Out-File -FilePath $OutputFilePath -Append
    exit
}

# Read all IP addresses from the file
$IPAddresses = Get-Content -Path $IPFilePath

# Loop through each IP address and test the port connection
foreach ($IPAddress in $IPAddresses) {
    # Attempt to connect to the IP address on the specified port
    try {
        $TcpConnection = New-Object System.Net.Sockets.TcpClient
        $TcpConnection.Connect($IPAddress, $Port)
        
        if ($TcpConnection.Connected) {
            $result = "Connection to ${IPAddress} on port ${Port}: SUCCESS"
        }
        $TcpConnection.Close()
    }
    catch {
        $result = "Connection to ${IPAddress} on port ${Port}: FAILED"
    }
    # Write the result to the output file
    $result | Out-File -FilePath $OutputFilePath -Append
}

# Confirm that the script has completed
Write-Output "Port check completed. Results saved to $OutputFilePath."