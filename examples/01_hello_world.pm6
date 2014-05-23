use GTK::Simple;

my GTK::Simple::App $app .= new(title => "Hello GTK!");

$app.set_content(
    GTK::Simple::VBox.new(
        (my $button = GTK::Simple::Button.new(label => "Hello World!")),
        (my $second = GTK::Simple::Button.new(label => "Goodbye!"))
    )
);

$app.border_width = 20;

$second.sensitive = 0;

$button.clicked.tap({ .sensitive = 0; $second.sensitive = 1 });

$second.clicked.tap({ $app.exit; });

$app.run;
