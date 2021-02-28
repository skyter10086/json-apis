package require rl_http
package require rl_json
namespace path {::rl_json}


set url http://127.0.0.1:3000/person/name;#41990081145742 [encoding convertfrom utf-8 http://127.0.0.1:3000/person/name/曾理]
#set url_1 [encoding convertto utf-8 http://127.0.0.1:3000/person/name/曾理]
#puts $url_1
set json_body {
    {"name": "李军"}
}
rl_http instvar h POST $url -headers {Content-Type application/json} -data [encoding convertto utf-8 $json_body]

switch -glob -- [$h code] {
    2* {
        set body [encoding convertfrom utf-8 [$h body]]
        set header [encoding convertfrom utf-8 [$h headers]]
        puts "Got result:\n$body"
        puts "Headers: $header"
    }
    default {
        puts "Something went wrong: [$h code]\n[$h body]"
    }
}

puts "name:  [json get $body 0 name]"
puts {======================================}
puts [json pretty $body]
puts {======================================}

puts "\["
json foreach j_item $body {
    puts "\t\{"
    json foreach {k v} $j_item {
        puts "\t\t$k ==> $v"
    }
    puts "\t\}"
}
puts "\]"


puts {======================================}
set b [json extract $body 0]
foreach key [lsort [json keys $b]] {
    puts "$key: [json get $body  0 $key]"
}
