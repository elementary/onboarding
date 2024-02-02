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
    public uint old_files_age {
        set {
            description = dngettext (Onboarding.GETTEXT_PACKAGE,
                "Old files can be automatically deleted after %u day to save space and help protect your privacy.",
                "Old files can be automatically deleted after %u days to save space and help protect your privacy.",
                value
            ).printf (value);
        }
    }

    public HouseKeepingView () {
        Object (
            view_name: "housekeeping",
            icon_name: "preferences-system-privacy-housekeeping",
            title: _("Housekeeping")
        );
    }

    construct {
        var header_label = new Granite.HeaderLabel (_("Automatically Delete:"));

        var temp_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 6
        };

        var temp_box = new Gtk.Box (HORIZONTAL, 0);
        temp_box.append (new Gtk.Image.from_icon_name ("folder") { pixel_size = 24 });
        temp_box.append (
            new Gtk.Label (_("Old temporary files")) {
                mnemonic_widget = temp_check
            }
        );
        temp_box.set_parent (temp_check);

        var download_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 6
        };

        var download_box = new Gtk.Box (HORIZONTAL, 0);
        download_box.append (new Gtk.Image.from_icon_name ("folder-download") { pixel_size = 24 });
        download_box.append (
            new Gtk.Label (_("Downloaded files")) {
                mnemonic_widget = download_check
            }
        );
        download_box.set_parent (download_check);

        var screenshots_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 6
        };

        var screenshots_box = new Gtk.Box (HORIZONTAL, 0);
        screenshots_box.append (new Gtk.Image.from_icon_name ("folder-screenshots-icon") { pixel_size = 24 });
        screenshots_box.append (
            new Gtk.Label (_("Screenshot files")) {
                mnemonic_widget = screenshots_check
            }
        );
        screenshots_box.set_parent (screenshots_check);

        var trash_check = new Gtk.CheckButton () {
            halign = Gtk.Align.START,
            margin_start = 6
        };

        var trash_box = new Gtk.Box (HORIZONTAL, 0);
        trash_box.append (new Gtk.Image.from_icon_name ("user-trash-full") { pixel_size = 24 });
        trash_box.append (
            new Gtk.Label (_("Trashed files")) {
                mnemonic_widget = trash_check
            }
        );
        trash_box.set_parent (trash_check);

        custom_bin.append (header_label);
        custom_bin.append (download_check);
        custom_bin.append (temp_check);
        custom_bin.append (screenshots_check);
        custom_bin.append (trash_check);

        var privacy_settings = new GLib.Settings ("org.gnome.desktop.privacy");
        privacy_settings.bind ("remove-old-temp-files", temp_check, "active", GLib.SettingsBindFlags.DEFAULT);
        privacy_settings.bind ("remove-old-trash-files", trash_check, "active", GLib.SettingsBindFlags.DEFAULT);

        var housekeeping_settings = new Settings ("io.elementary.settings-daemon.housekeeping");
        housekeeping_settings.bind ("cleanup-downloads-folder", download_check, "active", GLib.SettingsBindFlags.DEFAULT);
        housekeeping_settings.bind ("cleanup-screenshots-folder", screenshots_check, "active", GLib.SettingsBindFlags.DEFAULT);
        housekeeping_settings.bind ("old-files-age", this, "old_files_age", GLib.SettingsBindFlags.GET);
    }
}
