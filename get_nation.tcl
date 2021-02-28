package require tdbc::postgres
package require Tk

tdbc::postgres::connection create db -host localhost -port 5432 -user postgres -password Root123456 -db postgres

set stmt [db prepare {
    SELECT * FROM public.nation WHERE code = :ncode
}]


proc get_nation {code} {
    global stmt
    set ncode $code
    $stmt foreach row {
       set nation [dict get $row value]
    }
    return $nation
}

#puts [get_nation 12]

wm title . "Nation Searching"
wm geometry . 480x320

label .codeLabel -text "代码:"
entry .codeEntry -textvariable icode
label .nationLabel -text "民族:"
label .myLabel -textvariable nationVal
#text .myText -width 10 -height 2
#button .searchButton -text "查询" -command {.myText delete ;.myText insert 1.0 [get_nation $icode] }
button .searchButton -text "查询" -command {set nationVal [get_nation $icode] }
grid .codeLabel .codeEntry
grid .nationLabel .myLabel .searchButton
#pack .