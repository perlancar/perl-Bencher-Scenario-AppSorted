package Bencher::Scenario::AppSorted;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use File::Slurper 'write_text';
use File::Temp qw(tempdir);

my $dir = tempdir();
write_text("$dir/100k-sorted"            , join("", map {sprintf "%06d\n", $_} 1..100_000));
write_text("$dir/100k-unsorted-middle"   , join("", map {sprintf "%06d\n", $_} 1..50_000, 50_002, 50_001, 50_003..100_000));
write_text("$dir/100k-unsorted-beginning", join("", map {sprintf "%06d\n", $_} 2,1, 3..100_000));

our $scenario = {
    summary => 'Benchmark sorted vs is-sorted',
    participants => [
        {name=>"sorted"   , module=>'App::sorted', cmdline_template=>'sorted -q <filename>; true'},
        {name=>"is-sorted", module=>'File::IsSorted', cmdline_template=>'is-sorted check <filename>; true'},
    ],
    precision => 7,
    datasets => [
        {name=>'100k-sorted', args=>{filename=>"$dir/100k-sorted"}},
        {name=>'100k-unsorted-middle', args=>{filename=>"$dir/100k-unsorted-middle"}},
        {name=>'100k-unsorted-beginning', args=>{filename=>"$dir/100k-unsorted-beginning"}},
    ],
};

1;
# ABSTRACT:
