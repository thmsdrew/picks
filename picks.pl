use URI;
use Web::Scraper;
use Encode;
use String::Util qw(trim);
use Data::Dumper;

my $picks = scraper {
	process 'table[class="results"] td[width="37px"]', "majorities[]" => scraper {
		process "td", majority => 'TEXT';
	};
};

my $res = $picks->scrape(URI->new("http://nflpickwatch.com/?text=1"));

my @majs;
for my $majority (@{$res->{majorities}}) {
	my $maj = Encode::encode("utf8", "$majority->{majority}");
	if (defined $maj and $maj ne "") {
		push(@majs, $maj);
	}
}

my @sorted = map  { $_->[0] } sort { $a->[1] <=> $b->[1] } map  { [$_, $_=~/(\d+)/] } @majs;

my $filename = 'C:\\Users\\thomasdr\\Desktop\\picks.txt';
open(my $fh, '>', $filename) or die;

my $index = 1;
for my $pick (@sorted) {
	if ($pick =~ /\d/a) {
		substr($pick, $-[0], 0) = "\t";
		print $fh "$index:\t$pick\n";
		$index++;
	}
}

close $fh;