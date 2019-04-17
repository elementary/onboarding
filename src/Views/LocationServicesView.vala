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

public class Onboarding.LocationServicesView : AbstractOnboardingView {
    public LocationServicesView () {
        Object (
            description: _("While Location Services are enabled, apps will be able to make requests to use this device's location."),
            icon_name: "find-location",
            title: _("Location Services"),
            setting_path: "privacy/location",
            setting_tooltip: _("Security & Privacy → Location Services")
        );
    }

    construct {
        var switch_label = new Gtk.Label (_("Location Services:"));

        var service_switch = new Gtk.Switch ();

        var settings = new GLib.Settings ("io.elementary.desktop.agent-geoclue2");
        settings.bind ("location-enabled", service_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        custom_bin.add (switch_label);
        custom_bin.add (service_switch);
    }
}
