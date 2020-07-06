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

    public Gtk.Grid custom_bin { get; private set; }

    construct {
        var image = new Gtk.Image ();
        image.icon_name = icon_name;
        image.pixel_size = 64;

        var badge = new Gtk.Image ();
        badge.halign = badge.valign = Gtk.Align.END;
        badge.icon_name = badge_name;
        badge.pixel_size = 32;

        var overlay = new Gtk.Overlay ();
        overlay.halign = Gtk.Align.CENTER;
        overlay.add (image);
        overlay.add_overlay (badge);

        var title_label = new Gtk.Label (title);
        title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        title_label.halign = Gtk.Align.CENTER;

        var description_label = new Gtk.Label (description);
        description_label.halign = Gtk.Align.CENTER;
        description_label.justify = Gtk.Justification.CENTER;
        description_label.wrap = true;
        description_label.max_width_chars = 50;
        description_label.use_markup = true;

        var header_area = new Gtk.Grid ();
        header_area.column_spacing = 12;
        header_area.halign = Gtk.Align.CENTER;
        header_area.expand = true;
        header_area.row_spacing = 6;
        header_area.orientation = Gtk.Orientation.VERTICAL;
        header_area.add (overlay);
        header_area.add (title_label);
        header_area.add (description_label);

        custom_bin = new Gtk.Grid ();
        custom_bin.column_spacing = 12;
        custom_bin.expand = true;
        custom_bin.row_spacing = 6;
        custom_bin.halign = Gtk.Align.CENTER;

        margin_start = margin_end = 10;
        margin_top = 22;
        orientation = Gtk.Orientation.VERTICAL;
        row_spacing = 24;
        expand = true;
        add (header_area);
        add (custom_bin);

        bind_property ("description", description_label, "label");
    }
}
