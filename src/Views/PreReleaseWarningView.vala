/*-
 * Copyright (c) 2020 elementary, Inc. (https://elementary.io)
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
            description: _("You're running a <b>pre-release</b> daily development build of %s. Things may be broken. Current major known issues include, but are not limited to:").printf (Utils.os_name),
            icon_name: "dialog-warning",
            title: _("Early Access Build")
        );
    }

    construct {
        custom_bin.orientation = Gtk.Orientation.VERTICAL;

        var apps_label = new Gtk.Label ("• " + _("Curated apps are not available in AppCenter")) {
            hexpand = true,
            xalign = 0
        };
        custom_bin.add (apps_label);

        var style_label = new Gtk.Label ("• " + _("The visual style is unfinished")) {
            hexpand = true,
            xalign = 0
        };
        custom_bin.add (style_label);

        var more_link = new Gtk.LinkButton.with_label (
            "https://github.com/orgs/elementary/projects/55",
            _("View the 6.0 Release Project")
        ) {
            valign = Gtk.Align.END,
            vexpand = true
        };
        custom_bin.add (more_link);
    }
}
