/*-
 * Copyright (c) 2019 elementary, Inc. (https://elementary.io)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public abstract class Onboarding.AbstractOnboardingView : Adw.NavigationPage {
    public string view_name { get; construct; }
    public string description { get; set; }
    public string icon_name { get; construct; }
    public string? badge_name { get; construct; }

    protected Gtk.Box custom_bin { get; private set; }
    protected Gtk.Image image { get; private set; }

    construct {
        image = new Gtk.Image.from_icon_name (icon_name) {
            icon_size = LARGE
        };

        var badge = new Gtk.Image.from_icon_name (badge_name) {
            halign = END,
            valign = END,
            icon_size = NORMAL
        };

        var overlay = new Gtk.Overlay () {
            halign = CENTER,
            child = image
        };
        overlay.add_overlay (badge);

        var title_label = new Gtk.Label (title) {
            halign = CENTER,
            justify = CENTER,
            wrap = true,
            max_width_chars = 50,
            mnemonic_widget = this,
            use_markup = true
        };
        title_label.add_css_class (Granite.STYLE_CLASS_H1_LABEL);

        var description_label = new Gtk.Label (description) {
            halign = CENTER,
            justify = CENTER,
            wrap = true,
            max_width_chars = 50,
            mnemonic_widget = this,
            use_markup = true
        };
        description_label.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

        var header_area = new Gtk.Box (VERTICAL, 0);
        header_area.append (overlay);
        header_area.append (title_label);
        header_area.append (description_label);
        header_area.add_css_class ("header-area");

        custom_bin = new Gtk.Box (VERTICAL, 0) {
            hexpand = true,
            vexpand = true,
            halign = CENTER,
            valign = CENTER
        };
        custom_bin.add_css_class ("content-area");

        var levelbar = new Gtk.LevelBar () {
            min_value = 0,
            hexpand = true,
            valign = CENTER
        };

        var skip_button = new Gtk.Button.with_label (_("Skip All")) {
            action_name = "win.skip"
        };

        var next_button = new Gtk.Button.with_label (_("Next")) {
            action_name = "win.next"
        };
        next_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        var buttons_group = new Gtk.SizeGroup (BOTH);
        buttons_group.add_widget (skip_button);
        buttons_group.add_widget (next_button);

        var action_area = new Gtk.CenterBox () {
            center_widget = levelbar,
            end_widget = next_button,
            vexpand = true,
            valign = END
        };
        action_area.add_css_class ("dialog-action-area");

        if (!(this is FinishView)) {
            action_area.start_widget = skip_button;
        } else {
            next_button.label = _("Get Started");
        }

        var box = new Gtk.Box (VERTICAL, 0) {
            hexpand = true,
            vexpand = true
        };
        box.append (header_area);
        box.append (custom_bin);
        box.append (action_area);

        child = box;

        bind_property ("description", description_label, "label");
        bind_property ("title", title_label, "label");

        // Grab focus early so we don't interupt the screen reader
        showing.connect (() => next_button.grab_focus ());
        shown.connect (mark_viewed);

        realize.connect (() => {
            uint pos = -1;
            MainWindow.pages.find (this, out pos);

            levelbar.max_value = MainWindow.pages.get_n_items ();
            levelbar.value = pos + 1;

            levelbar.add_offset_value (Gtk.LEVEL_BAR_OFFSET_HIGH, levelbar.max_value - 1);
            levelbar.add_offset_value (Gtk.LEVEL_BAR_OFFSET_FULL, levelbar.max_value);
        });
    }

    public void mark_viewed () {
        if (Posix.isatty (Posix.STDIN_FILENO)) {
            return;
        }

        var viewed = MainWindow.settings.get_strv ("viewed");
        if (!(view_name in viewed)) {
            var viewed_copy = viewed;
            viewed_copy += view_name;
            viewed = viewed_copy;

            MainWindow.settings.set_strv ("viewed", viewed);
        }
    }

    public class ListItem : Gtk.Box {
        public string color { get; construct; }
        public string icon_name { get; construct; }
        public string label { get; construct; }

        public ListItem (string icon_name, string label, string color) {
            Object (
                icon_name: icon_name,
                label: label,
                color: color
            );
        }

        construct {
            var image = new Gtk.Image.from_icon_name (icon_name);
            image.add_css_class (Granite.STYLE_CLASS_ACCENT);
            image.add_css_class (color);

            var description_label = new Gtk.Label (label) {
                hexpand = true,
                max_width_chars = 40,
                wrap = true,
                xalign = 0
            };

            spacing = 6;
            append (image);
            append (description_label);
        }
    }
}
