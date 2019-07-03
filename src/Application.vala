// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2016 elementary LLC. (https://elementary.io)
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
    public static GLib.Settings settings;

    construct {
        application_id = "io.elementary.installer";
        flags = ApplicationFlags.FLAGS_NONE;
        Intl.setlocale (LocaleCategory.ALL, "");
    }

    public override void activate () {
        bool is_terminal = Posix.isatty (Posix.STDIN_FILENO);

        var uid = Posix.getuid ();
        if (uid < MIN_UID)
            quit ();

        settings = new GLib.Settings ("io.elementary.onboarding");
        if (!is_terminal && !settings.get_boolean ("first-run")) {
            quit ();
        }

        var window = new MainWindow ();
        window.show_all ();
        this.add_window (window);

        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("io/elementary/onboarding/application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
}

public static int main (string[] args) {
    var application = new Onboarding.App ();
    return application.run (args);
}

