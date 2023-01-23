
use v6;

unit module GTK::Simple;

need GTK::Simple::ConnectionHandler;
need GTK::Simple::Widget;
need GTK::Simple::Container;
need GTK::Simple::Window;
need GTK::Simple::Scheduler;
need GTK::Simple::App;
need GTK::Simple::Box;
need GTK::Simple::HBox;
need GTK::Simple::VBox;
need GTK::Simple::Grid;
need GTK::Simple::Label;
need GTK::Simple::MarkUpLabel;
need GTK::Simple::Scale;
need GTK::Simple::Entry;
need GTK::Simple::TextView;
need GTK::Simple::Button;
need GTK::Simple::ToggleButton;
need GTK::Simple::CheckButton;
need GTK::Simple::DrawingArea;
need GTK::Simple::Switch;
need GTK::Simple::StatusBar;
need GTK::Simple::Separator;
need GTK::Simple::ProgressBar;
need GTK::Simple::Frame;
need GTK::Simple::ComboBoxText;
need GTK::Simple::ActionBar;
need GTK::Simple::Spinner;
need GTK::Simple::Toolbar;
need GTK::Simple::MenuToolButton;
need GTK::Simple::MenuBar;
need GTK::Simple::Menu;
need GTK::Simple::MenuItem;
need GTK::Simple::FileChooserButton;
need GTK::Simple::PlacesSidebar;
need GTK::Simple::RadioButton;
need GTK::Simple::LevelBar;
need GTK::Simple::LinkButton;
need GTK::Simple::ScrolledWindow;
need GTK::Simple::Calendar;
need GTK::Simple::ListBox;
need GTK::Simple::CheckMenuItem;

# Exports above class constructors, ex. level-bar => GTK::Simple::LevelBar.new
my module EXPORT::subs {
    for GTK::Simple::.kv -> $name, $class {
        my $sub-name = '&' ~ ($name ~~ / (<:Lu><:Ll>*)* /).values.map({ .Str.lc }).join("-");
        OUR::{ $sub-name } := -> |c { $class.new(|c) };
    }
}
