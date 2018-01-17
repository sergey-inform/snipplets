#!/usr/bin/perl
use Socket;

die("usage: gethostby-lookup name hostname\ngetbhostby-lookup addr ip\n") unless(defined($ARGV[0]) and defined($ARGV[1]));

if($ARGV[0] eq "name") {
        $packed_ip = gethostbyname("$ARGV[1]");
        if (defined $packed_ip) {
                $ip_address = inet_ntoa($packed_ip);
                print "$ip_address\n";
        }
} elsif($ARGV[0] eq "addr") {
        $iaddr = inet_aton("$ARGV[1]"); # or whatever address
        $name  = gethostbyaddr($iaddr, AF_INET);
        print "$name\n";
} else {
        die("usage: gethostby-lookup name hostname\ngetbhostby-lookup addr ip\n");
}
