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
        image = new Gtk.Image () {
            icon_name = icon_name,
            pixel_size = 64
        };

        var badge = new Gtk.Image () {
            halign = Gtk.Align.END,
            valign = Gtk.Align.END,
            icon_name = badge_name,
            pixel_size = 32
        };

        var overlay = new Gtk.Overlay () {
            halign = Gtk.Align.CENTER,
            child = image,
            margin_bottom = 6
        };
        overlay.add_overlay (badge);

        var title_label = new Gtk.Label (title) {
            halign = Gtk.Align.CENTER,
            justify = Gtk.Justification.CENTER,
            wrap = true,
            max_width_chars = 50,
            mnemonic_widget = this,
            use_markup = true
        };
        title_label.add_css_class (Granite.STYLE_CLASS_H1_LABEL);

        var description_label = new Gtk.Label (description) {
            halign = Gtk.Align.CENTER,
            justify = Gtk.Justification.CENTER,
            wrap = true,
            max_width_chars = 50,
            mnemonic_widget = this,
            use_markup = true
        };
        description_label.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

        var header_area = new Gtk.Box (Gtk.Orientation.VERTICAL, 3);
        header_area.append (overlay);
        header_area.append (title_label);
        header_area.append (description_label);

        custom_bin = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            hexpand = true,
            vexpand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };

        var skip_button = new Gtk.Button.with_label (_("Skip All"));

        var next_button = new Gtk.Button.with_label (_("Next")) {
            halign = END,
            hexpand = true,
            receives_default = true
        };
        next_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        var buttons_group = new Gtk.SizeGroup (BOTH);
        buttons_group.add_widget (skip_button);
        buttons_group.add_widget (next_button);

        var action_area = new Gtk.Box (HORIZONTAL, 0) {
            vexpand = true,
            valign = END
        };
        action_area.add_css_class ("dialog-action-area");

        if (!(this is FinishView)) {
            action_area.append (skip_button);
        } else {
            next_button.label = _("Get Started");
        }

        action_area.append (next_button);

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

        shown.connect (mark_viewed);

        // next_button.clicked.connect (() => {
        //     int index = (int) Math.round (navigation_view.position);
        //     if (index < navigation_view.navigation_stack.get_n_items () - 1) {
        //         navigation_view.scroll_to (navigation_view.get_nth_page (index + 1), true);
        //     } else {
        //         destroy ();
        //     }
        // });

        // skip_button.clicked.connect (() => {
        //     for (var view_count = 0; view_count < navigation_view.navigation_stack.get_n_items (); view_count++) {
        //         var view = navigation_view.get_nth_page (view_count);
        //         assert (view is AbstractOnboardingView);

        //         var view_name = ((AbstractOnboardingView) view).view_name;

        //         mark_viewed (view_name);
        //     }

        //     navigation_view.scroll_to (finish_view, true);
        // });
    }

    private void mark_viewed () {
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
