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

public class Onboarding.UpdatesView : AbstractOnboardingView {
    public UpdatesView () {
        Object (
            description: _("Keep device firmware up to date. Updates come from a secure third-party service and diagnostic data may be sent to the manufacturer."),
            icon_name: "application-x-firmware",
            title: _("Stay Secure")
        );
    }

    construct {
        var switch_label = new Gtk.Label (_("Firmware updates:"));
        var service_switch = new Gtk.Switch ();
        var privacy_button = new Gtk.LinkButton.with_label ("https://fwupd.org/privacy", _("Privacy Policy…"));

        custom_bin.attach (switch_label, 0, 0);
        custom_bin.attach (service_switch, 1, 0);
        custom_bin.attach (privacy_button, 0, 1, 2);
    }
}

