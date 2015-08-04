#!/usr/bin/perl
use Cwd;
use strict;
use Getopt::Long qw(GetOptions);
use List::Util qw/shuffle/;

my $usage_sentence = "perl $0 --fastq file.fq OPTIONAL : --size 25 (default 15) --lower 20 (default 1). --size correspond to the length of the motif and --lower correspond to the minimum occurence of the kmer.";
my $SIZE = 15;
my $lower = 1;
my $file;

GetOptions ("fastq=s" => \$file,    # numeric
	    "lower=s" => \$lower,
	    "size=s" => \$SIZE
    ) or die $usage_sentence;

if (!$file) {die $usage_sentence;}
my $generic = $file;
$generic =~ s/\.fq//;
$generic =~ s/\.fastq//;
$generic =~ s/.*\///g;
$generic = "kmer_".$generic;

#COUNT
my $command1 = "jellyfish count -m $SIZE -o $generic -L $lower -c 10 -s 10000 -t 32 $file";
print"$command1\n";
system($command1);


#MERGE IF NECESSARY :
my $dir =  getcwd;
my $count =0;
my $RE = $generic."\_.*";
opendir (DIR, $dir) or die $!;
while (my $f = readdir(DIR)) {
    if ($f =~ /$RE/){$count ++;}
}
my $generic_merged = $generic;
if ($count > 1)
{
    
    my $command3 = "jellyfish merge -o $generic_merged $generic"."\_*";
    print "$command3\n";
    system($command3);
}
if ($count ==1)
{
    my $command2 = "cp $generic"."\_0 $generic_merged";
    print "$command2\n";
    system($command2);  
}
my $out = $generic.".motif";
#GET MOTIFS
my $command4 = "jellyfish dump -o $out $generic_merged -c";
print "$command4\n";
system($command4);
  
