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

public class Onboarding.AppCenterView : AbstractOnboardingView {
    public AppCenterView () {
        Object (
            view_name: "appcenter",
            description: _("Get the apps you need on AppCenter. Curated apps are made for elementary OS and reviewed by elementary."),
            icon_name: "system-software-install",
            title: _("Get Some Apps")
        );
    }

    construct {
        var appcenter_button = new Gtk.Button.with_label (_("Browse AppCenter…"));

        unowned var appcenter_button_context = appcenter_button.get_style_context ();
        appcenter_button_context.add_class (Gtk.STYLE_CLASS_FLAT);
        appcenter_button_context.add_class ("link");

        var flathub_link = "<a href='https://flathub.org'>%s</a>".printf (_("Flathub"));

        var flatpak_note = new Gtk.Label (_("You can also sideload Flatpak apps e.g. from %s").printf (flathub_link)) {
            justify = Gtk.Justification.CENTER,
            max_width_chars = 45,
            use_markup = true,
            valign = Gtk.Align.END,
            vexpand = true,
            wrap = true
        };

        unowned var flatpak_note_context = flatpak_note.get_style_context ();
        flatpak_note_context.add_class (Granite.STYLE_CLASS_SMALL_LABEL);
        flatpak_note_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        custom_bin.orientation = Gtk.Orientation.VERTICAL;
        custom_bin.valign = Gtk.Align.FILL;
        custom_bin.add (appcenter_button);
        custom_bin.add (flatpak_note);

        appcenter_button.clicked.connect (() => {
            try {
                var appcenter = AppInfo.create_from_commandline (
                    "io.elementary.appcenter",
                    "AppCenter",
                    AppInfoCreateFlags.SUPPORTS_STARTUP_NOTIFICATION
                );
                appcenter.launch (null, null);
            } catch (Error e) {
                critical (e.message);
            }
        });
    }
}
