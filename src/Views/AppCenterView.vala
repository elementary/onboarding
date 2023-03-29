/*-
 * Copyright 2019-2023 elementary, Inc. (https://elementary.io)
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

public class Onboarding.AppCenterView : AbstractOnboardingView {
    public AppCenterView () {
        Object (
            view_name: "appcenter",
            description: _("Get the apps you need on AppCenter or sideload Flatpak apps from alternative stores."),
            icon_name: "system-software-install",
            title: _("Get Some Apps")
        );
    }

    construct {
        var appcenter_image = new Gtk.Image.from_icon_name ("io.elementary.appcenter") {
            icon_size = Gtk.IconSize.LARGE
        };

        var appcenter_label = new Gtk.Label (_("Get apps made for elementary OS and reviewed by elementary on AppCenter")) {
            max_width_chars = 35,
            wrap = true
        };

        var appcenter_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        appcenter_box.append (appcenter_image);
        appcenter_box.append (appcenter_label);

        var appcenter_button = new Gtk.Button () {
            child = appcenter_box
        };

        var sideload_image = new Gtk.Image.from_icon_name ("io.elementary.sideload") {
            icon_size = Gtk.IconSize.LARGE
        };

        var sideload_label = new Gtk.Label (_("Sideload apps from alternative app stores like Flathub")) {
            max_width_chars = 35,
            wrap = true
        };

        var sideload_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        sideload_box.append (sideload_image);
        sideload_box.append (sideload_label);

        var sideload_button = new Gtk.Button () {
            child = sideload_box
        };

        custom_bin.append (appcenter_button);
        custom_bin.append (sideload_button);

        appcenter_button.clicked.connect (() => {
            try {
                var appcenter = new DesktopAppInfo ("io.elementary.appcenter.desktop");
                appcenter.launch (null, null);
            } catch (Error e) {
                critical (e.message);
            }
        });

        sideload_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://flathub.org", null);
            } catch (Error e) {
                critical (e.message);
            }
        });
    }
}
