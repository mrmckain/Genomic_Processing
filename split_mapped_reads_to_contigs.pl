#!/usr/bin/env perl -w
use strict;

my %grouped_reads;

open my $samfile, "<", $ARGV[0];
	while(<$samfile>){
    	chomp;
        if(/^@/){
        	next;
        }
        my @tarray = split /\s+/;

        if($tarray[2] eq "*"){
            next;
        }

        $grouped_reads{$tarray[2]}{$tarray[0]}=1;
   }

for my $match_id (keys %grouped_reads){
	`mkdir $match_id`;
	#chdir($match_id);
	open my $file1, "<", $ARGV[1];
	open my $out1, ">", $match_id . "/" . $match_id . "_R1_matches.fq";
	while(<$file1>){
		chomp;
		 my $trueid="NA";
                if(/\s+/){
                        /\@(.*?)\s/;
                        $trueid=$1;
                }
                 else{
                        $trueid=$_;
                }
		if(exists $grouped_reads{$match_id}{$trueid}){
				my $id = $_;
				my $seq = readline($file1);
				my $plus = readline($file1);
				my $phred = readline($file1);
				print $out1 "$id\n$seq\n$plus\n$phred\n"; 
		}

	}
	close($out1);
	close($file1);

	open my $file2, "<", $ARGV[2];
	open my $out2, ">", $match_id . "/" . $match_id . "_R2_matches.fq";
	while(<$file2>){
		chomp;
		 my $trueid="NA";
                if(/\s+/){
                        /\@(.*?)\s/;
                        $trueid=$1;
               	}
               	 else{
                        $trueid=$_;
                }
		if(exists $grouped_reads{$match_id}{$trueid}){
				my $id = $_;
				my $seq = readline($file2);
				my $plus = readline($file2);
				my $phred = readline($file2);
				print $out2 "$id\n$seq\n$plus\n$phred\n"; 
		}

	}
	close($out2);
	close($file2);
}