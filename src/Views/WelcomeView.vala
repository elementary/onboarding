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

public class Onboarding.WelcomeView : AbstractOnboardingView {
    public WelcomeView () {
        Object (
            view_name: "welcome",
            description: _("Continue to set up some useful features. Visit the links below for more information about %s.").printf (Utils.os_name),
            icon_name: Utils.logo_icon_name,
            title: _("Welcome to %s!").printf (Utils.os_name)
        );
    }

    construct {
        var thebasics_link = new ImageLinkButton (
            Utils.documentation_url,
            _("Basics Guide…"),
            "text-x-generic-symbolic"
        );

        var support_link = new ImageLinkButton (
            Utils.support_url,
            _("Community Support…"),
            "help-contents-symbolic"
        );

        var getinvolved_link = new ImageLinkButton (
            "https://elementary.io/get-involved",
            _("Get Involved…"),
            "applications-development-symbolic"
        );

        custom_bin.attach (thebasics_link, 0, 0);
        custom_bin.attach (support_link, 0, 1);
        custom_bin.attach (getinvolved_link, 0, 2);
    }

    private class ImageLinkButton : Gtk.Widget {
        public string uri { get; construct; }
        public string icon_name { get; construct; }
        public string label_string { get; construct; }
        public Gtk.LinkButton link_button_widget { get; set; }

        public ImageLinkButton (string uri, string label_string, string icon_name) {
            Object (
                uri: uri,
                label_string: label_string,
                icon_name: icon_name
            );
        }

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            var image = new Gtk.Image.from_icon_name (icon_name) {
                pixel_size = 16
            };

            var left_label = new Gtk.Label (label_string) {
                xalign = 0
            };

            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.append (image);
            box.append (left_label);

            link_button_widget = new Gtk.LinkButton.with_label (uri, label_string) {
                icon_name = icon_name,
                child = box
            };
            link_button_widget.set_parent (this);
        }

        ~ImageLinkButton () {
            while (get_last_child () != null) {
                get_last_child ().unparent ();
            }
        }
    }
}
