Function Format-CounterList 
{
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Array]$CounterSamples
    )
   
   [Array]$CounterObjects = @()
   [String]$RegexPattern = '(?<ComputerName>(?:\\\\).+)(?<Counterset>(?:\\).+(?:\\))(?<Counter>.+(?:\:))(?<Value>\n?.*)'
   
   ForEach($Counter in $CounterSamples) {

        [PSCustomObject]$CounterObj = [PSCustomObject]@{DateTime = $Counter.Timestamp}

        [String]$CounterString =  ($Counter.Path + ":" + $Counter.CookedValue)
        
        $CounterMatches = [Regex]::Match($CounterString, $RegexPattern)
                
        ForEach ($Match in $CounterMatches.Groups) {
            if ($Match.Name -eq "0") { Continue }
            
            Add-Member -InputObject $CounterObj `
                       -Name $Match.Name `
                       -Value $Match.Value.Replace("\","").Replace(":","")`
                       -MemberType NoteProperty
        }
        $CounterObjects += $CounterObj
   }
   return $CounterObjects
}
Get-Counter | Format-CounterList 
