package require tdbc::postgres

tdbc::postgres::connection create db  -host localhost -port 5432 -user postgres -password Root123456 -db postgres 

set stmt [db prepare {
    SELECT * FROM public.nation
}]
puts "民族代码表: "
$stmt foreach row {
    set code [dict get $row code]
    set val [dict get $row value]
    puts "$code ==> $val"

}

$stmt close
db close

