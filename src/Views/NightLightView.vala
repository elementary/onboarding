/*-
 * Copyright (c) 2019–2021 elementary, Inc. (https://elementary.io)
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

public class Onboarding.NightLightView : AbstractOnboardingView {
    public NightLightView () {
        Object (
            view_name: "night-light",
            description: _("Make the colors of your display warmer at night to help prevent eye strain and sleeplessness."),
            icon_name: "night-light",
            title: _("Night Light"),
            is_interactive: true
        );
    }

    construct {
        var switch_label = new Gtk.Label (_("Night Light:")) {
            halign = Gtk.Align.END
        };

        var service_switch = new Gtk.Switch () {
            halign = Gtk.Align.START
        };

        var settings_link = new Gtk.LinkButton.with_label ("settings://display/night-light", _("Adjust schedule and temperature…")) {
            valign = Gtk.Align.END,
            vexpand = true
        };

        var settings = new GLib.Settings ("org.gnome.settings-daemon.plugins.color");
        settings.bind ("night-light-enabled", service_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        custom_bin.attach (switch_label, 0, 0);
        custom_bin.attach (service_switch, 1, 0);
        custom_bin.attach (settings_link, 0, 1, 2);
    }
}
