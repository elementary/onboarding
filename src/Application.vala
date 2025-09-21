/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2016-2023 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.App : Gtk.Application {
    public const string ACTION_PREFIX = "app.";
    public const string ACTION_QUIT = "action-quit";

    private const ActionEntry[] ACTION_ENTRIES = {
        { ACTION_QUIT, quit }
    };

    construct {
        application_id = "io.elementary.onboarding";
        flags = ApplicationFlags.FLAGS_NONE;
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (Onboarding.GETTEXT_PACKAGE, Onboarding.LOCALEDIR);
        Intl.bind_textdomain_codeset (Onboarding.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Onboarding.GETTEXT_PACKAGE);
    }

    protected override void startup () {
        base.startup ();

        Granite.init ();

        add_action_entries (ACTION_ENTRIES, this);
        set_accels_for_action (ACTION_PREFIX + ACTION_QUIT, {"<Ctrl>Q"});

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
    }

    public override void activate () {
        if (Posix.getuid () < MIN_UID && !(Environment.get_user_name ().has_prefix ("guest-"))) {
            quit ();
        }

        var window = new MainWindow () {
            application = this
        };
        window.present ();
    }
}

public static int main (string[] args) {
    var application = new Onboarding.App ();
    return application.run (args);
}
