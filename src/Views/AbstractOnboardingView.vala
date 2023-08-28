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

public abstract class AbstractOnboardingView : Gtk.Box {
    public string view_name { get; construct; }
    public string description { get; set; }
    public string icon_name { get; construct; }
    public string? badge_name { get; construct; }
    public string title { get; construct; }

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
            use_markup = true
        };
        title_label.add_css_class (Granite.STYLE_CLASS_H1_LABEL);

        var description_label = new Gtk.Label (description) {
            halign = Gtk.Align.CENTER,
            justify = Gtk.Justification.CENTER,
            wrap = true,
            max_width_chars = 50,
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

        margin_start = 10;
        margin_end = 10;
        margin_top = 22;
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 24;
        hexpand = true;
        vexpand = true;
        append (header_area);
        append (custom_bin);

        bind_property ("description", description_label, "label");

        var focus_controller = new Gtk.EventControllerFocus ();
        add_controller (focus_controller);

        // FIXME: workaround for https://gitlab.gnome.org/GNOME/libadwaita/-/issues/724
        focus_controller.notify["contains-focus"].connect (() => {
            var carousel = (Adw.Carousel) get_ancestor (typeof (Adw.Carousel));
            carousel.scroll_to (this, true);
        });
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
