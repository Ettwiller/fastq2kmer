#!/usr/bin/perl
use Cwd;
use strict;
use Getopt::Long qw(GetOptions);
use List::Util qw/shuffle/;

my $usage_sentence = "perl $0 --file1 file1.motif --file2 file2.motif. Only if the motif is present in file 1 that the merge happen. Will had a pseudocount to missing values. !!!!! ";
my $file1;
my $file2;

GetOptions ("file1=s" => \$file1,    # numeric
	    "file2=s" => \$file2
    ) or die $usage_sentence;

if (!$file1 || !$file2) {die $usage_sentence;}

my %result; 

my $generic1 = $file1;
$generic1 =~ s/\.motif//;
    
open (FILE1, $file1) or die;
foreach my $line (<FILE1>)
{
    chomp $line;
    my @tmp = split /\s+/, $line;
    
    my $motif = $tmp[0];
    my $v = $tmp[1];
    $result{$motif}{$generic1}=$v;
}
close FILE1;

my $generic2 = $file2;
$generic2 =~ s/\.motif//;

open (FILE2, $file2) or die;
foreach my $line (<FILE2>)
{
    chomp $line;
    my @tmp = split /\s+/, $line;

    my $motif = $tmp[0];
    my $v = $tmp[1];
    if ($result{$motif}) #only if present in file 1 !!!
    { 
   	$result{$motif}{$generic2}=$v;
    }


}
close FILE2;

my @generics = ($generic1, $generic2);

print "motif";
foreach my $e (@generics)
{
    print "\t$e";
}
print "\n";

foreach my $motif (keys %result)
{
    print "$motif";
    foreach my $generic (@generics)
    {
	if ($result{$motif}{$generic})
	{
	    my $value = $result{$motif}{$generic};
	    print "\t$value";
	}
	else {
	    print "\t1";
	}
    }
    print "\n";
}
