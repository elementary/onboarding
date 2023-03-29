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
        var switch_label = new Gtk.Label (_("Free & Paid Apps:")) {
            halign = Gtk.Align.END
        };

        var switch = new Gtk.Switch () {
            halign = Gtk.Align.START
        };

        var settings = new GLib.Settings ("io.elementary.appcenter.settings");
        settings.bind ("automatic-updates", switch, "active", GLib.SettingsBindFlags.DEFAULT);

        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        box.append (switch_label);
        box.append (switch);

        custom_bin.append (box);
    }
}
