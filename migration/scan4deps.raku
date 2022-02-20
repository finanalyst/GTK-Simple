#!/usr/bin/env perl6
use v6.*;

my @deps = <
   GtkSymbolicColor
   GtkGradient
   GtkStyle
   GtkHScale
   GtkVScale
   GtkTearoffMenuItem
   GtkColorSelection
   GtkColorSelectionDialog
   GtkHSV
   GtkFontSelection
   GtkFontSelectionDialog
   GtkHBox
   GtkVBox
   GtkHButtonBox
   GtkVButtonBox
   GtkHPaned
   GtkVPaned
   GtkTable
   GtkHSeparator
   GtkVSeparator
   GtkHScrollbar
   GtkVScrollbar
   GtkUIManager
   GtkActionGroup
   GtkAction
   GtkToggleAction
   GtkRadioAction
   GtkRecentAction
   GtkActivatable
   GtkImageMenuItem
   GtkMisc
   GtkNumerableIcon
   GtkArrow
   GtkStatusIcon
   GtkThemingEngine
   GtkAlignment
>;
@deps .= map({ 'gtk_' ~ .substr(3).lc});
my @files = "lib/GTK".IO;
my @mod-files = gather while @files {
    with @files.pop {
        when :d { @files.append: .dir }
        .take when .extension.lc eq 'pm6'
    }
}
my @outp;
for @mod-files -> $fn {
    my $taint = False;
    for $fn.lines {
        if $_ ~~ / @deps / {
            @outp.append($fn) unless $taint;
            $taint = True;
            @outp.append: "\t$_"
        }
    }
}
'migration/files_with_deprecations.txt'.IO.spurt: @outp.join("\n");
