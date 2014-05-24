use GTK::Simple;

my GTK::Simple::App $app .= new(title => "Toggle buttons");

$app.set_content(
    GTK::Simple::VBox.new(
        my $check_button  = GTK::Simple::CheckButton.new(label => "check me out!"),
        my $status_label  = GTK::Simple::Label.new(text => "the toggles are off and off"),
        my $toggle_button = GTK::Simple::ToggleButton.new(label=> "time to toggle!"),
    )
);

$app.border_width = 50;

enum ToggleState <off on>;

sub update_label($b) {
    $status_label.text = "the toggles are " ~
        ($check_button, $toggle_button)>>.status.map({ ToggleState $_ }).join(" and ");
}

$check_button\.toggled.tap: &update_label;
$toggle_button.toggled.tap: &update_label;

$app.run;
