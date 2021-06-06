// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2016–2021 elementary LLC. (https://elementary.io)
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
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Onboarding.App : Gtk.Application {
    private MainWindow window;

    construct {
        application_id = "io.elementary.onboarding";
        flags = ApplicationFlags.FLAGS_NONE;
        Intl.setlocale (LocaleCategory.ALL, "");

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);

        set_accels_for_action ("app.quit", {"<Control>q"});

        quit_action.activate.connect (() => {
            if (window != null) {
                var settings = new GLib.Settings ("io.elementary.onboarding");
                var viewed = settings.get_strv ("viewed");

                if (!("finish" in viewed)) {
                    /* Send a notification to let users know
                    that they have not completed onboarding. */
                    var notification = new Notification (_("Onboarding was incomplete"));
                    notification.set_body (_("You may not have tailored your system to your preferences"));
                    send_notification ("onboarding-incomplete", notification);
                }

                /* Not sure why but if the window is destroyed too quickly
                the notification will not register. */
                window.hide ();
                Timeout.add (500, () => {
                    window.destroy ();
                });
            }
        });
    }

    public override void activate () {
        if (Posix.getuid () < MIN_UID) {
            quit ();
        }

        window = new MainWindow ();
        window.application = this;
        window.show_all ();

        window.delete_event.connect (() => {
            activate_action ("quit", null);

            return true;
        });
    }
}

public static int main (string[] args) {
    var application = new Onboarding.App ();
    return application.run (args);
}
