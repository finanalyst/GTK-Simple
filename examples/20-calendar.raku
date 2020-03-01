
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Calendar');
my $calendar = GTK::Simple::Calendar.new;
my $month-entry = GTK::Simple::Entry.new();
my $year-entry = GTK::Simple::Entry.new();
my $day-entry = GTK::Simple::Entry.new();
my $date-entry = GTK::Simple::HBox.new(
        GTK::Simple::Label.new(text => "Day"),
        $day-entry,
        GTK::Simple::Label.new(text => "Month"),
        $month-entry,
        GTK::Simple::Label.new(text => "Year"),
        $year-entry
        );

my $structure = GTK::Simple::HBox.new(
            $calendar,
            GTK::Simple::VBox.new(
                GTK::Simple::Label.new(text => "Select your date below: "),
                $date-entry
            )
        );
$app.set-content($structure);
$date-entry.size-request(1, 24);
$app.run;
