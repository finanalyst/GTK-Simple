
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Calendar', height => 300, width => 600);
my $calendar = GTK::Simple::Calendar.new;
my $month-entry = GTK::Simple::Entry.new();
my $year-entry = GTK::Simple::Entry.new();
my $day-entry = GTK::Simple::Entry.new();


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
            GTK::Simple::VBox.new(
                GTK::Simple::Label.new(text => "Select your date below: "),
                $date-entry, spacing => 2
            )
        );

$app.set-content($structure);
($day-entry, $month-entry).map: { $_.width = 2 };
$year-entry.width = 4;
($day-entry, $month-entry).map: *.width.say;
$app.run;
