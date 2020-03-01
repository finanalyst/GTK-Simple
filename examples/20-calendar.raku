
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Calendar', height => 300, width => 600);
my $calendar = GTK::Simple::Calendar.new;

my $month-entry = GTK::Simple::Entry.new(text => ~$calendar.month);
my $year-entry  = GTK::Simple::Entry.new(text => ~$calendar.year);
my $day-entry   = GTK::Simple::Entry.new(text => ~$calendar.day);

$calendar.day-selected.tap: {
    $year-entry.text    = .year.Str;
    $month-entry.text   = .month.Str;
    $day-entry.text     = .day.Str;
};

my $date-view = GTK::Simple::Grid.new(
    [0, 0, 1, 1] => GTK::Simple::Label.new(text => "Day"),
    [1, 0, 1, 1] => $day-entry,
    [2, 0, 1, 1,] => GTK::Simple::Label.new(text => "Month"),
    [3, 0, 1, 1] => $month-entry,
    [4, 0, 1, 1] => GTK::Simple::Label.new(text => "Year"),
    [5, 0, 1, 1] => $year-entry
);

$date-view.column-spacing = 8;

my $structure = GTK::Simple::HBox.new(
    $calendar,
    my $side = GTK::Simple::VBox.new(
        $date-view
    )
);

$app.set-content($structure);

$side.border-width = 16;

($day-entry, $month-entry).map: { .width-chars = 2 };
$year-entry.width-chars = 4;

$date-view.size-request(300, 120);
$calendar.size-request(300,300);

$app.run;
