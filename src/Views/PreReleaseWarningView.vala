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
 *
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class Onboarding.PreReleaseWarningView : AbstractOnboardingView {
    public PreReleaseWarningView () {
        Object (
            view_name: "pre-release-warning",
            description: _("You're running an early daily build of %s. Things will be broken.").printf (Utils.os_name),
            icon_name: "dialog-warning",
            title: _("Pre-release version of %s").printf (Utils.os_name)
        );
    }

    construct {
        custom_bin.orientation = Gtk.Orientation.VERTICAL;

        var apps_label = new Gtk.Label (_("Curated apps are not available in AppCenter"));
        custom_bin.add (apps_label);

        var style_label = new Gtk.Label (_("The visual style is unfinished"));
        custom_bin.add (style_label);

        var more_link = new Gtk.LinkButton.with_label (
            "https://github.com/orgs/elementary/projects/55",
            _("More…")
        );
        custom_bin.add (more_link);
    }
}
