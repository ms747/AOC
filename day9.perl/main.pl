use List::MoreUtils qw(first_index);

$argc = @ARGV;

if ($argc != 1) {
    print "input.txt not provided\n";
    exit(1);
}

open(FH, "<", @ARGV[0]) or die $!;
@lines = map {$_ + 0} <FH>;
close(FH);

$window_size = 25;
$invalid_number = 0;

for (my $i = $window_size; $i < scalar @lines; $i++) {
    @window = @lines[$i - $window_size..$i - 1];
    $number = @lines[$i] + 0;
    $found = 0;
    foreach (@window) {
        $entry = $number - ($_ + 0);
        if (grep(/^$entry$/, @window)) {
            $found = 1;
            last;
        }
    }

    if ($found != 1) {
        print "Part 1 : $number\n";
        $invalid_number = $number;
        last;
    }
}

$index_of_invalid_number =  first_index { $_ == $invalid_number } @lines;

sub sum {
    $sum = 0;
    foreach $item (@_) {
        $sum += $item;
    }
    return $sum;
}

foreach (2 .. $index_of_invalid_number - 1) {
    my $found = 0;
    foreach $j (0 .. $index_of_invalid_number - $_ - 1) {
        my @window = @lines[$j .. $_ + $j - 1];
        if (sum(@window) == $invalid_number) {
            $ans = @window[0] + @window[scalar(@window) - 1];
            print "Part 2 : $ans\n";
            $found = 1;
            last;
        }
    }
    if ($found == 1) {
        last;
    }
}


