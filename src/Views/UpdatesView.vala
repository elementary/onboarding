/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.UpdatesView : AbstractOnboardingView {
    public UpdatesView () {
        Object (
            view_name: "updates",
            description: _("Updates can be automatically installed when your device is connected to the Internet."),
            icon_name: "system-software-update",
            title: _("Automatic Updates")
        );
    }

    construct {
        var appcenter_check = new Gtk.CheckButton () {
            halign = START
        };

        var appcenter_label = new Granite.HeaderLabel (_("Free & Paid Apps")) {
            secondary_text = _("Unpaid apps will not update automatically")
        };

        var appcenter_box = new Gtk.Box (HORIZONTAL, 0);
        appcenter_box.append (new Gtk.Image.from_icon_name ("io.elementary.appcenter") { icon_size = LARGE });
        appcenter_box.append (appcenter_label);
        appcenter_box.set_parent (appcenter_check);

        var system_check = new Gtk.CheckButton () {
            halign = START
        };

        var system_label = new Granite.HeaderLabel (_("Operating System")) {
            secondary_text = _("Will be installed when you choose to restart this device")
        };

        var system_box = new Gtk.Box (HORIZONTAL, 0);
        system_box.append (new Gtk.Image.from_icon_name ("io.elementary.settings") { icon_size = LARGE });
        system_box.append (system_label);
        system_box.set_parent (system_check);

        custom_bin.append (appcenter_check);
        custom_bin.append (system_check);

        var appcenter_settings = new Settings ("io.elementary.appcenter.settings");
        appcenter_settings.bind ("automatic-updates", appcenter_check, "active", DEFAULT);

        var system_settings = new Settings ("io.elementary.settings-daemon.system-update");
        system_settings.bind ("automatic-updates", system_check, "active", DEFAULT);
    }
}
