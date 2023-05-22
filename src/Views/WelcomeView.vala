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
    public WelcomeView (bool updates) {
        string _title= "";
        string _badge_icon = "";

        if (updates) {
            _title = _("What’s New");
            _badge_icon = "system-software-update";
        } else {
            _title = _("Welcome!");
        }

        Object (
            view_name: "welcome",
            title: _title,
            description: _("Continue to set up some useful features. Visit the links below for more information about elementary OS."),
            icon_name: Utils.logo_icon_name,
            badge_name: _badge_icon
        );
    }

    construct {
        if (Gtk.IconTheme.get_for_display (Gdk.Display.get_default ()).has_icon (icon_name + "-symbolic")) {
            foreach (unowned var path in Environment.get_system_data_dirs ()) {
                var file_path = Path.build_path (Path.DIR_SEPARATOR_S, path, "backgrounds", "elementaryos-default");
                var file = File.new_for_path (file_path);

                if (file.query_exists ()) {
                    var style_provider = new Gtk.CssProvider ();
                    style_provider.load_from_resource ("io/elementary/onboarding/WelcomeView.css");

                    var background_provider = new Gtk.CssProvider ();
                    background_provider.load_from_data (
                    """
                    image.logo {
                        background-image:
                            linear-gradient(
                                to bottom,
                                alpha(@accent_color_500, 0.25),
                                alpha(@accent_color_700, 0.75)
                            ),
                            url("file://%s");
                    }
                    """.printf (file_path).data
                    );

                    image.pixel_size = 48;
                    image.add_css_class ("logo");
                    image.get_style_context ().add_provider (style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
                    image.get_style_context ().add_provider (background_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

                    break;
                }
            }
        }

        var thebasics_link = new ImageLinkButton (
            Utils.documentation_url,
            _("Basics Guide…"),
            "text-x-generic-symbolic"
        );

        var blog_link = new ImageLinkButton (
            "https://blog.elementary.io",
            _("Our Blog…"),
            "view-reader-symbolic"
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

        custom_bin.spacing = 3;
        custom_bin.append (thebasics_link);
        custom_bin.append (blog_link);
        custom_bin.append (support_link);
        custom_bin.append (getinvolved_link);
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

            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 3);
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
