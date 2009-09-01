#!/usr/bin/perl -w
use Cwd 'abs_path';
use strict;
use warnings;

require $ENV{'MASSSPEC_TOOLBOX_HOME'}.'/pipeline/conf.pl';

my $path_conf = &get_path();

my $file_db = $path_conf->{'FASTA_file'};
my $file_script = "run-srf2pepxml.sh";
my $dir_output = "sequest.pepxml";

open(SCRIPT,">$file_script");
print SCRIPT "#!/bin/bash\n";
foreach my $file_srf (`ls SRF/*.srf`) {
  chomp($file_srf);
  my $file_old_pepxml = $file_srf;
  $file_old_pepxml =~ s/SRF/sequest\.pepxml/;
  $file_old_pepxml =~ s/srf$/xml/g;
  my $file_new_pepxml = $file_old_pepxml;
  $file_new_pepxml =~ s/xml$/sequest\.pepxml/;
  print STDERR $file_srf,"\n";
  print SCRIPT 'echo "process ',$file_srf,"\"\n";
  print SCRIPT join(" ", 'bioworks_to_pepxml.rb',
                  '--dbpath', $file_db,
                  '--outdir', $dir_output, $file_srf),"\n";
  print SCRIPT "mv $file_old_pepxml $file_new_pepxml\n";
}
close(SCRIPT);
`chmod 744 $file_script`;
