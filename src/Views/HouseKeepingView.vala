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
            view_name: "housekeeping",
            icon_name: "preferences-system-privacy-housekeeping",
            title: _("Housekeeping")
        );
    }

    construct {
        var settings = new GLib.Settings ("org.gnome.desktop.privacy");

        description = _("Old files can be automatically deleted after %u days to save space and help protect your privacy.").printf (settings.get_uint ("old-files-age"));

        var header_label = new Granite.HeaderLabel (_("Automatically Delete:"));

        var temp_switch = new Gtk.CheckButton.with_label (_("Temporary files"));
        temp_switch.margin_start = 12;

        var trash_switch = new Gtk.CheckButton.with_label (_("Trashed files"));
        trash_switch.margin_start = 12;

        custom_bin.attach (header_label, 0, 0);
        custom_bin.attach (temp_switch, 0, 1);
        custom_bin.attach (trash_switch, 0, 2);

        settings.bind ("remove-old-temp-files", temp_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        settings.bind ("remove-old-trash-files", trash_switch, "active", GLib.SettingsBindFlags.DEFAULT);
    }
}
