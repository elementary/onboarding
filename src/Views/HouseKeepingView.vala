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

public class Onboarding.HouseKeepingView : AbstractOnboardingView {
    public HouseKeepingView () {
        Object (
            icon_name: "preferences-system-privacy-housekeeping",
            title: _("Housekeeping")
        );
    }

    construct {
        var settings = new GLib.Settings ("org.gnome.desktop.privacy");

        description = _("Old files can be automatically cleaned up after %u days to save space and help protect your privacy.").printf (settings.get_uint ("old-files-age"));

        var temp_label = new Gtk.Label (_("Automatically delete old temporary files:"));
        temp_label.halign = Gtk.Align.END;

        var temp_switch = new Gtk.Switch ();

        var trash_label = new Gtk.Label (_("Automatically delete old trashed files:"));
        trash_label.halign = Gtk.Align.END;

        var trash_switch = new Gtk.Switch ();

        custom_bin.attach (temp_label, 0, 0);
        custom_bin.attach (temp_switch, 1, 0);
        custom_bin.attach (trash_label, 0, 1);
        custom_bin.attach (trash_switch, 1, 1);

        settings.bind ("remove-old-temp-files", temp_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        settings.bind ("remove-old-trash-files", trash_switch, "active", GLib.SettingsBindFlags.DEFAULT);
    }
}
