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

public abstract class AbstractInstallerView : Gtk.Grid {
    public string description { get; construct; }
    public string icon_name { get; construct; }
    public string title { get; construct; }

    public Gtk.Grid custom_bin { get; private set; }

    construct {
        var image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.DIALOG);

        var title_label = new Gtk.Label (title);
        title_label.get_style_context ().add_class ("h2");
        title_label.halign = Gtk.Align.CENTER;

        var description_label = new Gtk.Label (description);
        description_label.halign = Gtk.Align.CENTER;
        description_label.justify = Gtk.Justification.CENTER;
        description_label.wrap = true;
        description_label.max_width_chars = 50;

        var header_area = new Gtk.Grid ();
        header_area.column_spacing = 12;
        header_area.row_spacing = 12;
        header_area.orientation = Gtk.Orientation.VERTICAL;
        header_area.add (image);
        header_area.add (title_label);
        header_area.add (description_label);

        custom_bin = new Gtk.Grid ();
        custom_bin.column_spacing = 12;
        custom_bin.halign = Gtk.Align.CENTER;

        orientation = Gtk.Orientation.VERTICAL;
        row_spacing = 48;
        add (header_area);
        add (custom_bin);
    }
}
