;# AntiIdle v1.0 by wilk wilkowy (10.08.2015)
;######################################################
;# Features:
;# - simulates conversation and resets an idle 
;#
;# ToDo:
;# - support for multiple connections
;#
;# Commands:
;# /antiidle - show configuration dialog (alias: /ai)
;######################################################

alias ai antiidle
alias antiidle dialog -mr antiidle.dialog antiidle.dialog

on *:START: {
  if (%antiidle.enabled == $null) {
    set %antiidle.enabled 0
    set %antiidle.random 0
    set %antiidle.delay_min 60
    set %antiidle.delay_max 120
  }
  set -e %antiidle._delay $iif(%antiidle.random == 1, $rand(%antiidle.delay_min, %antiidle.delay_max), %antiidle.delay_min)
  .timer(antiidle) -o $iif(%antiidle.random == 1, 1, 0) %antiidle._delay antiidle.chat
  echo -s AntiIdle v1.0 by wilk - loaded $+ $iif(%antiidle.enabled == 1, $chr(32) $+ $chr(40) $+ active $+ $chr(41)) $+ ...
}

on *:EXIT: {
  .timer(antiidle) off
  unset %antiidle._*
}

on *:UNLOAD: {
  .timer(antiidle) off
  unset %antiidle._*
}

dialog -l antiidle.dialog {
  title "AntiIdle v1.0 by wilk"
  size -1 -1 92 48
  option dbu
  button "&OK", 1, 2 34 38 12, default flat ok
  button "&Cancel", 2, 52 34 38 12, flat cancel
  box "", 3, 2 0 88 32
  check "Enabled?", 4, 6 6 32 10, flat
  check "Random?", 5, 46 6 34 10, flat
  text "Chat delay:", 6, 6 20 30 8
  edit "", 7, 40 18 18 10, right
  text "-", 8, 60 20 4 8
  edit "", 9, 64 18 18 10, right
  text "s", 10, 84 20 6 8
}

; init dialog
on *:DIALOG:antiidle.dialog:INIT:*: {
  did $iif(%antiidle.enabled == 1, -c, -u) $dname 4
  did $iif(%antiidle.enabled == 1, -e, -b) $dname 5,6,7,10
  did $iif(%antiidle.random == 1, -c, -u) $dname 5
  did $iif((%antiidle.enabled == 1) && (%antiidle.random == 1), -e, -b) $dname 8,9
  did -a $dname 7 %antiidle.delay_min
  did -a $dname 9 %antiidle.delay_max
}

; dialog click - ok
on *:DIALOG:antiidle.dialog:SCLICK:1: {
  set %antiidle.enabled $did($dname, 4).state
  set %antiidle.random $did($dname, 5).state
  var %delay_min = $did($dname, 7).text
  var %delay_max = $did($dname, 9).text
  if ((%delay_min != $null) && (%delay_min isnum) && (%delay_min > 0)) set %antiidle.delay_min %delay_min
  if ((%delay_max != $null) && (%delay_max isnum) && (%delay_max > 0)) set %antiidle.delay_max %delay_max
  if (%antiidle.delay_min > %antiidle.delay_max) {
    var %temp = %antiidle.delay_max
    set %antiidle.delay_max %antiidle.delay_min
    set %antiidle.delay_min %temp
  }
  .timer(antiidle) off
  set -e %antiidle._delay $iif(%antiidle.random == 1, $rand(%antiidle.delay_min, %antiidle.delay_max), %antiidle.delay_min)
  .timer(antiidle) -o $iif(%antiidle.random == 1, 1, 0) %antiidle._delay antiidle.chat
}

; dialog click - enable/disable
on *:DIALOG:antiidle.dialog:SCLICK:4: {
  did $iif($did($dname, 4).state == 1, -e, -b) $dname 5,6,7,10
  did $iif(($did($dname, 4).state == 1) && ($did($dname, 5).state == 1), -e, -b) $dname 8,9
}

; dialog click - random
on *:DIALOG:antiidle.dialog:SCLICK:5: {
  did $iif($did($dname, 5).state == 1, -e, -b) $dname 8,9
}

; main timer handler
alias -l antiidle.chat {
  if ((%antiidle.enabled == 1) && ($status == connected)) {
    .msg $me [wilk-anti-idle]
    if (%antiidle.random == 1) {
      set -e %antiidle._delay $rand(%antiidle.delay_min, %antiidle.delay_max)
      .timer(antiidle) -o 1 %antiidle._delay antiidle.chat
    }
  }
}

on ^*:TEXT:[wilk-anti-idle]:?: {
  if ((%antiidle.enabled == 1) && ($nick == $me)) {
    window -h $me
    haltdef
  }
}
