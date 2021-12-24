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
        var header_label = new Granite.HeaderLabel (_("Automatically Delete:"));

        var temp_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        temp_grid.pack_start (new Gtk.Image.from_icon_name ("folder", Gtk.IconSize.LARGE_TOOLBAR));
        temp_grid.pack_start (new Gtk.Label (_("Old temporary files")));

        var temp_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 12
        };
        temp_check.add (temp_grid);

        var download_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        download_grid.pack_start (new Gtk.Image.from_icon_name ("folder-download", Gtk.IconSize.LARGE_TOOLBAR));
        download_grid.pack_start (new Gtk.Label (_("Downloaded files")));

        var download_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 12
        };
        download_check.add (download_grid);

        var trash_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        trash_grid.pack_start (new Gtk.Image.from_icon_name ("user-trash-full", Gtk.IconSize.LARGE_TOOLBAR));
        trash_grid.pack_start (new Gtk.Label (_("Trashed files")));

        var trash_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 12,
            margin_bottom = 18
        };
        trash_check.add (trash_grid);

        custom_bin.attach (header_label, 0, 0);
        custom_bin.attach (download_check, 0, 1);
        custom_bin.attach (temp_check, 0, 2);
        custom_bin.attach (trash_check, 0, 3);

        var privacy_settings = new GLib.Settings ("org.gnome.desktop.privacy");
        privacy_settings.bind ("remove-old-temp-files", temp_check, "active", GLib.SettingsBindFlags.DEFAULT);
        privacy_settings.bind ("remove-old-trash-files", trash_check, "active", GLib.SettingsBindFlags.DEFAULT);

        description = _("Old files can be automatically deleted after %u days to save space and help protect your privacy.").printf (privacy_settings.get_uint ("old-files-age"));

        var housekeeping_settings = new Settings ("io.elementary.settings-daemon.housekeeping");
        housekeeping_settings.bind ("cleanup-downloads-folder", download_check, "active", GLib.SettingsBindFlags.DEFAULT);
    }
}
