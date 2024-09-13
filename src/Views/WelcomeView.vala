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
    private static string _bug_url;
    private static string bug_url {
        get {
            if (_bug_url == null) {
                _bug_url = Environment.get_os_info (GLib.OsInfoKey.BUG_REPORT_URL);

                if (_bug_url == null) {
                    _bug_url = "https://docs.elementary.io/contributor-guide/feedback/reporting-issues";
                }
            }

            return _bug_url;
        }
    }

    private static string _documentation_url;
    private static string documentation_url {
        get {
            if (_documentation_url == null) {
                _documentation_url = Environment.get_os_info (GLib.OsInfoKey.DOCUMENTATION_URL);

                if (_documentation_url == null) {
                    _documentation_url = "https://elementary.io/docs/learning-the-basics";
                }
            }

            return _documentation_url;
        }
    }

    private static string _website_url;
    private static string website_url {
        get {
            if (_website_url == null) {
                _website_url = Environment.get_os_info (GLib.OsInfoKey.HOME_URL);

                if (_website_url == null) {
                    _website_url = "https://elementary.io";
                }
            }

            return _website_url;
        }
    }


    private static string _support_url;
    private static string support_url {
        get {
            if (_support_url == null) {
                _support_url = Environment.get_os_info (GLib.OsInfoKey.SUPPORT_URL);

                if (_support_url == null) {
                    _support_url = "https://elementary.io/support";
                }
            }

            return _support_url;
        }
    }

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
            description: _("Continue to set up some useful features. Visit the links below for more help with getting started."),
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

        var thebasics_link = new LinkRow (
            documentation_url,
            _("Basics Guide"),
            "text-x-generic-symbolic",
            "green"
        );

        var support_link = new LinkRow (
            support_url,
            _("Get Help"),
            "help-contents-symbolic",
            "blue"
        );

        var website_link = new LinkRow (
            website_url,
            _("Our Website"),
            "view-reader-symbolic",
            "slate"
        );

        var getinvolved_link = new LinkRow (
            "https://elementary.io/get-involved",
            _("Get Involved or Sponsor Us"),
            "face-heart-symbolic",
            "pink"
        );

        var links_list = new Gtk.ListBox () {
            show_separators = true,
            selection_mode = NONE
        };
        links_list.add_css_class ("boxed-list");
        links_list.add_css_class (Granite.STYLE_CLASS_RICH_LIST);
        links_list.append (thebasics_link);
        links_list.append (support_link);
        links_list.append (website_link);
        links_list.append (getinvolved_link);

        custom_bin.append (links_list);
    }

    private class LinkRow : Gtk.ListBoxRow {
        public string uri { get; construct; }
        public string icon_name { get; construct; }
        public string label_string { get; construct; }
        public string color { get; construct; }

        public LinkRow (string uri, string label_string, string icon_name, string color) {
            Object (
                uri: uri,
                label_string: label_string,
                icon_name: icon_name,
                color: color
            );
        }

        class construct {
            set_accessible_role (LINK);
        }

        construct {

            var image = new Gtk.Image.from_icon_name (icon_name) {
                pixel_size = 16
            };
            image.add_css_class (Granite.STYLE_CLASS_ACCENT);
            image.add_css_class (color);

            var left_label = new Gtk.Label (label_string) {
                hexpand = true,
                xalign = 0
            };

            var link_image = new Gtk.Image.from_icon_name ("adw-external-link-symbolic");

            var box = new Gtk.Box (HORIZONTAL, 0);
            box.append (image);
            box.append (left_label);
            box.append (link_image);

            child = box;
            add_css_class ("link");
        }
    }
}
