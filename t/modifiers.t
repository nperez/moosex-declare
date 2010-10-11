use Test::More;
use MooseX::Declare;

my @log = ();
BEGIN { $SIG{__WARN__} = sub { push @log, \@_ } };

role Bar {
  before do_foo {
    push @log, { before => 'string' };
  }
}

role Baz {
    after [qw/do_foo do_boo/] {
        push @log, { after => 'string' };
    }
}

class Foo with (Bar, Baz) {
  method do_foo {
    push @log, { class => 'string' };
  }

  method do_boo {
    push @log, { also_class => 'another string' };
  }
}

my $foo = Foo->new();
$foo->do_foo;
$foo->do_boo;

is_deeply(\@log, [{'before', 'string'}, {'class','string'}, {'after', 'string'}, {'also_class', 'another string'}, {'after', 'string'}] );

done_testing;
