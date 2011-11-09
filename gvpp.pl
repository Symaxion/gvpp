#!/usr/bin/perl
use strict;

my $in;

sub error {
    if($#_ == 1) {
        print("error: $ARGV[0]:$_[1]: $_[0]");
    } else {
        print("error: $_[0]\n");
    }
    exit 1;
}

sub warn {
    if($#_ == 1) {
        print("warning: $ARGV[0]:$_[1]: $_[0]");
    } else {
        print("warning: $_[0]\n");
    }
}

sub main {
    if($#ARGV != -1) {
        open($in, "<", $ARGV[0]) or error("$ARGV[0]: $!");
    } else {
        open($in, "<-") or error($!);
    }

    if($ENV{'GRAPHTYPE'} eq "digraph") {
        print "digraph G {\n";
    } else {
        print "graph G {\n";
    }
    
    print "    graph [bgcolor=\"transparent\"];\n";
    print "    edge [fontname=\"Arial\",fontsize=9];\n";
    print "    node [fontname=\"Arial\",fontsize=9];\n";
     
    my $lnum = 0;
    while(my $line = <$in>) {
        chomp $line;
        if($line =~ m/^([[:alnum:]]*) *(\[(.*)\])?$/) {
            print "    label_${1} [shape=none,label=\"\"];\n";
            print "    node_${1} [shape=point,$3];\n";
            print "    label_${1} -- node_${1}
            [color=transparent,len=0.15,headlabel=\"$1\"];\n";
        } elsif($line =~ m/^([[:alnum:]]*) *(-(-|>)) *([[:alnum:]]*)(.*)$/) {
            print "    node_${1} $2 node_${4} $5;\n";
        } else {
            error("Incorrect syntax",$lnum);
        }
        ++$lnum;

    }

    print "}\n";
}

main;
