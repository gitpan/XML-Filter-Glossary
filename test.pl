use strict;

BEGIN { $| = 1; print "1..1\n"; }

use XML::SAX::Writer;
use XML::Filter::Glossary;
use XML::SAX::ParserFactory;

#

eval { require XML::SAX::Expat; };

if ($@) {

  eval { require XML::LibXML::SAX; };

  if ($@) {
    print 
      "$@\n",
      "Can't locate XML::SAX::Expat or XML::LibXML::SAX::Parser.\n",
      "I will use PerlPerl parser instead - this may take a while.\n";
  }

  else { $XML::SAX::ParserPackage = "XML::LibXML::SAX::Parser"; }
}

else { $XML::SAX::ParserPackage = "XML::SAX::Expat"; }

#

my $output   = "";
my $writer   = undef;
my $glossary = undef;
my $parser   = undef;

$writer = XML::SAX::Writer->new(Output=>\$output);

if (! $writer) {
  print "Failed to create \$writer, $!\n";
  print "not ok 1\n";
  exit;
}

$glossary = XML::Filter::Glossary->new(Handler=>$writer);

if (! $glossary) {
  print "Failed to create \$glossary, $!\n";
  print "not ok 1\n";
  exit;
}

$parser = XML::SAX::ParserFactory->parser(Handler=>$glossary);

if (! $parser) {
    print "Failed to create \$parser, $!\n";
    print "not ok 1\n";
    exit;
  }


$glossary->set_glossary("./test.xbel");
$parser->parse_uri("./test.html");

if ($@) {
  print $@;
  print "not ok 1\n";
  exit;
}

print $output."\n\n";

print "ok 1\n";
print "Passed all tests\n";
