/*
 * Copyright (c) 2021 elementary, Inc. (https://elementary.io)
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
 *
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class Onboarding.NetworkView : AbstractOnboardingView {
    public NetworkView () {
        Object (
            view_name: "network",
            description: _("Manage network devices and connectivity."),
            icon_name: "preferences-system-network",
            title: _("Network")
        );
    }

    construct {
        var settings_link = new Gtk.LinkButton.with_label ("settings://network", _("Manage network devices…"));

        custom_bin.add (settings_link);
    }
}
