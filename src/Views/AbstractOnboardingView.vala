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

public abstract class AbstractOnboardingView : Gtk.Grid {
    public string view_name { get; construct; }
    public string description { get; set; }
    public string icon_name { get; construct; }
    public string? badge_name { get; construct; }
    public string title { get; construct; }

    protected Gtk.Image image { get; private set; }
    public Gtk.Grid custom_bin { get; private set; }

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
            child = image
        };
        overlay.add_overlay (badge);

        var title_label = new Gtk.Label (title) {
            halign = Gtk.Align.CENTER
        };
        title_label.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

        var description_label = new Gtk.Label (description) {
            halign = Gtk.Align.CENTER,
            justify = Gtk.Justification.CENTER,
            wrap = true,
            max_width_chars = 50,
            use_markup = true
        };

        var header_area = new Gtk.Grid () {
            column_spacing = 12,
            halign = Gtk.Align.CENTER,
            vexpand = true,
            hexpand = true,
            row_spacing = 6
        };
        header_area.attach (overlay, 0, 0);
        header_area.attach (title_label, 0, 1);
        header_area.attach (description_label, 0, 2);

        custom_bin = new Gtk.Grid () {
            column_spacing = 12,
            hexpand = true,
            row_spacing = 6,
            vexpand = true,
            halign = Gtk.Align.CENTER
        };

        margin_start = 10;
        margin_end = 10;
        margin_top = 22;
        row_spacing = 24;
        hexpand = true;
        vexpand = true;
        attach (header_area, 0, 0);
        attach (custom_bin, 0, 1);

        bind_property ("description", description_label, "label");
    }
}
