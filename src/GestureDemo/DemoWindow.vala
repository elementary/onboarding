public class Onboarding.DemoWindow : Gtk.Window {
    public Adw.Carousel carousel { get; set; }
    public DemoWindow (Onboarding.MultitouchView view) {
        Object (
            transient_for: (Onboarding.MainWindow) view.get_root ()
        );
    }

    construct {
        default_width = 960;
        default_height = 640;
        resizable = false;

        var front_page = new Granite.Placeholder ("Try Multitouch Gestures!") {
            description = "This is a demo of multitouch gestures used throughout the system",
            icon = new ThemedIcon ("preferences-desktop-workspaces"),
            hexpand = true,
            vexpand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };

        var show_workspace = new Onboarding.ShowWorkspace () {
            hexpand = true,
            vexpand = true
        };

        var switch_workspace = new Onboarding.SwitchWorkspace () {
            hexpand = true,
            vexpand = true
        };

        carousel = new Adw.Carousel () {
            hexpand = true,
            vexpand = true
        };
        carousel.append (front_page);
        carousel.append (show_workspace);
        carousel.append (switch_workspace);

        var skip_button = new Gtk.Button.with_label (_("Skip All"));

        var next_button = new Gtk.Button.with_label (_("Next"));
        next_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        var buttons_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        buttons_group.add_widget (skip_button);
        buttons_group.add_widget (next_button);

        var action_area = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            valign = Gtk.Align.END
        };
        action_area.add_css_class ("dialog-action-area");
        action_area.append (skip_button);
        action_area.append (new Adw.Bin () { hexpand = true });
        action_area.append (next_button);

        var grid = new Gtk.Grid () {
            row_spacing = 12
        };
        grid.attach (carousel, 0, 0);
        grid.attach (action_area, 0, 1);

        child = grid;
        titlebar = new Adw.Bin () { visible = false };

        add_css_class ("dialog");

        skip_button.clicked.connect (() => {
            if (carousel.position == 0) {
                this.hide ();
            } else {
                if (carousel.position == 1) {
                    skip_button.label = "Skip All";
                }

                next_button.label = "Next";
                carousel.scroll_to (carousel.get_nth_page ((uint) carousel.position - 1), true);
            }
        });

        next_button.clicked.connect (() => {
            if (carousel.position < carousel.n_pages - 1) {
                if (carousel.position == 1) {
                    next_button.label = "Done";
                }

                skip_button.label = "Previous";
                carousel.scroll_to (carousel.get_nth_page ((uint) carousel.position + 1), true);
            } else {
                this.hide ();
            }
        });
    }
}
