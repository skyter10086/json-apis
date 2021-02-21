use Mojolicious::Lite -signatures;
use utf8::all;
#use DBI;
use DBIx::Connector;

    my $dsn = 'dbi:Pg:dbname=postgres';
    my $usr = 'postgres';
    my $pwd = '';
    my $conn = DBIx::Connector->new($dsn, $usr, $pwd,{RaiseError=>1,AutoCommit=>1}) || 
              die "Can not connect the DB!";
    #$conn->mode('fixup');



app->config(hypnotoad => 
            {
                listen  => ['http://*:8080'],
                workers => 10});


sub get_sex {
    my $key = shift;
    my $sql = 'SELECT * FROM public.sex WHERE key = ?';
    my $sth = $conn->run(fixup => sub {
        my $sth = $_->prepare($sql);
        $sth->execute($key);
        $sth;

    } );
    return $sth->fetchrow_hashref;
}
sub get_nation {
    my $code = shift;
    my $sql = 'SELECT * FROM public.nation WHERE code = ?';
    my $sth = $conn->run(fixup => sub {
        my $sth = $_->prepare($sql);
        $sth->execute($code);
        $sth;

    } );
    #$sth->execute($code);
    return $sth->fetchrow_hashref;
}
sub person_sn {
    my $sn = shift;
    my $sql = 'SELECT * FROM public.baseinfo WHERE sn = ?';
    my $sth = $conn->run(fixup => sub {
        my $sth = $_->prepare($sql);
        $sth->execute($sn);
        $sth;

    } );
    return $sth->fetchrow_hashref;
}

sub person_id {
    my $id = shift;
    my $sql = 'SELECT aab001,sn,company_id,name,id,sex,status_code FROM public.baseinfo WHERE id = ?';
    my $sth = $conn->run(fixup => sub {
        my $sth = $_->prepare($sql);
        $sth->execute($id);
        $sth;

    } );
    return $sth->fetchall_arrayref({});
}

sub person_name {
    my $name = shift;
    my $sql = 'SELECT aab001,sn,company_id,name,id,sex,status_code FROM public.baseinfo WHERE name = ?';
    my $sth = $conn->run(fixup => sub {
        my $sth = $_->prepare($sql);
        $sth->execute($name);
        $sth;

    } );
    return $sth->fetchall_arrayref({});
}


get '/nation/:code' => sub ($c) {
    my $code = $c->stash('code');
    my $kv_hr = get_nation($code);
    $c->render(json => $kv_hr);
};

get '/' => {text => 'I ♥ Mojolicious!'};

get '/sex/:key' => sub ($c) {
    my $key = $c->stash('key');
    my $kv = get_sex($key);
    $c->render(json=>$kv);
};

get '/person/:sn' => sub ($c) {
    my $sn = $c->stash('sn');
    my $kv = person_sn($sn);
    $c->render(json=>$kv);
};

get '/person/id/:id' => sub ($c) {
    my $id = $c->stash('id');
    my $kv = person_id($id);
    $c->render(json=>$kv);
};

get '/person/name/:name' => sub ($c) {
    my $name = $c->stash('name');
    my $kv = person_name($name);
    $c->render(json=>$kv);
};

app->start;


__END__

./script/my_app prefork -m production -w 10 -c 1





