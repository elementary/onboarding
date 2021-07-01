/*-
 * Copyright (c) 2020 elementary, Inc. (https://elementary.io)
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


public class Onboarding.ImageLinkButton : Gtk.LinkButton {
        public string icon_name { get; construct; }
        public string label_string { get; construct; }

        public ImageLinkButton (string uri, string label_string, string icon_name) {
            Object (
                uri: uri,
                label_string: label_string,
                icon_name: icon_name
            );
        }

        construct {
            var image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.MENU);

            var left_label = new Gtk.Label (label_string);
            left_label.xalign = 0;

            var grid = new Gtk.Grid ();
            grid.add (image);
            grid.add (left_label);

            add (grid);
        }
    }
