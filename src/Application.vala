/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2016-2023 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.App : Gtk.Application {
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
