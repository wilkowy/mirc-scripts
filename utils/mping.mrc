;# MPing v1.1 by wilk (03.10.2008-09.08.2015)
;############################################################
;# Features:
;# - milisecond ping
;#
;# Commands:
;# /mping <nick> - ping person
;############################################################

alias mping {
  if ($1 != $null) {
    .quote PRIVMSG $1 : $+ $chr(1) $+ PING $ctime $ticks $+ $chr(1)
    echo $color(ctcp) $iif($active == Status Window, -tse, -ta) -> [[ $+ $1 $+ ]] PING
  }
}

on *:start: {
  echo -s MPing v1.1 by wilk - loaded...
}

on *:CTCPREPLY:PING*: {
  if (($3 != $null) && ($3 isnum)) {
    echo $color(ctcp) $iif($active == Status Window, -tse, -ta) [ $+ $nick PING reply]: $calc(($ticks - $3) / 1000) $+ secs
    haltdef
  } 
}
