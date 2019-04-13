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
            description: _("Visit AppCenter to install any apps you need."),
            icon_name: "system-software-install",
            title: _("Get Some Apps")
        );
    }

    construct {
        var appcenter_button = new Gtk.Button.with_label ("Browse AppCenter");
        appcenter_button.get_style_context ().add_class ("appcenter");

        custom_bin.add (appcenter_button);

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

