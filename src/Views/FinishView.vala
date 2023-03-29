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

public class Onboarding.FinishView : AbstractOnboardingView {
    public FinishView () {
        Object (
            view_name: "finish",
            description: _("Enjoy using %s! You can always visit System Settings to set up hardware or change your preferences.").printf (Utils.os_name),
            icon_name: "io.elementary.onboarding",
            title: _("Ready to Go")
        );
    }

    construct {
        var link_button = new Gtk.LinkButton.with_label ("settings://", _("Open System Settings…"));

        custom_bin.append (link_button);
    }
}
