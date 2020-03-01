
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Calendar', height => 300, width => 600);
my $calendar = GTK::Simple::Calendar.new;

dd $calendar.DateTime;
my $month-entry = GTK::Simple::Entry.new(text => $calendar.month.Int.Str);
my $year-entry = GTK::Simple::Entry.new(text => $calendar.year.Int.Str);
my $day-entry = GTK::Simple::Entry.new(text => $calendar.day.Int.Str);

$calendar.day-selected.tap: {
    $year-entry.text    = .year.Int.Str;
    $month-entry.text   = .month.Int.Str;
    $day-entry.text     = .day.Int.Str;
};
#my $date-entry = GTK::Simple::HBox.new(
#        GTK::Simple::Label.new(text => "Day"),
#        $day-entry,
#        GTK::Simple::Label.new(text => "Month"),
#        $month-entry,
#        GTK::Simple::Label.new(text => "Year"),
#        $year-entry
#        );

my $date-entry = GTK::Simple::Grid.new(
        [0, 0, 1, 1] => GTK::Simple::Label.new(text => "Day"),
        [1, 0, 1, 1] => $day-entry,
        [2, 0, 1, 1,] => GTK::Simple::Label.new(text => "Month"),
        [3, 0, 1, 1] => $month-entry,
        [4, 0, 1, 1] => GTK::Simple::Label.new(text => "Year"),
        [5, 0, 1, 1] => $year-entry
        );

$date-entry.column-spacing = 8;

my $structure = GTK::Simple::HBox.new(
            $calendar,
            my $side = GTK::Simple::VBox.new(
                GTK::Simple::Label.new(text => "Select your date below: "),
                $date-entry
            )
        );

$app.set-content($structure);

$side.border-width = 16;

($day-entry, $month-entry).map: { $_.width = 2 };
$year-entry.width = 4;
($day-entry, $month-entry).map: *.width.say;
$date-entry.size-request(300, 120);

$calendar.size-request(300,300);

$app.run;
