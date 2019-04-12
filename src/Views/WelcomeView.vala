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

public class Onboarding.WelcomeView : AbstractInstallerView {
    public WelcomeView () {
        Object (
            description: _("There's just a few questions to answer to get started. You can also choose to skip this process. These settings and more can be changed at any time from within System Settings."),
            icon_name: "preferences-desktop",
            title: _("Welcome!")
        );
    }

    construct {
        var link_button = new Gtk.LinkButton.with_label ("settings://", _("Open System Settings…"));

        custom_bin.add (link_button);
    }
}
