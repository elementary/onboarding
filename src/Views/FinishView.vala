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

public class Onboarding.FinishView : AbstractOnboardingView {
    public FinishView () {
        Object (
            view_name: "finish",
            description: _("Enjoy using %s! You can always visit System Settings to set up hardware or change your preferences.").printf (Utils.os_name),
            icon_name: "process-completed",
            title: _("Ready to Go")
        );
    }

    construct {
        var launcher_row = new FinishRow (
            _("From the Applications menu or by searching for specific settings"),
            "start-here-symbolic"
        );

        var quicksettings_row = new FinishRow (
            _("From the Quick Settings menu or by middle-clicking toggle buttons"),
            "quick-settings-symbolic"
        );

        var wallpaper_row = new FinishRow (
            _("By secondary-clicking on the wallpaper"),
            "clicking-symbolic"
        );

        var listbox = new Gtk.ListBox () {
            show_separators = true,
            selection_mode = NONE
        };
        listbox.add_css_class (Granite.CssClass.CARD);
        listbox.append (launcher_row);
        listbox.append (quicksettings_row);
        listbox.append (wallpaper_row);

        custom_bin.append (listbox);
    }

    private class FinishRow : Granite.ListItem {
        public string icon_name { get; construct; }
        public string label_string { get; construct; }

        public FinishRow (string label_string, string icon_name) {
            Object (
                label_string: label_string,
                icon_name: icon_name
            );
        }

        construct {
            var image = new Gtk.Image.from_icon_name (icon_name) {
                pixel_size = 16
            };

            var left_label = new Gtk.Label (label_string) {
                hexpand = true,
                max_width_chars = 35,
                wrap = true,
                xalign = 0
            };

            var box = new Granite.Box (HORIZONTAL);
            box.append (image);
            box.append (left_label);

            child = box;
            add_css_class ("link");
        }
    }
}
