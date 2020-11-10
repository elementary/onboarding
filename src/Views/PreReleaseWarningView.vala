/*
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
 *              Cassidy James Blaede <cassidy@elementary.io>
 */

public class Onboarding.PreReleaseWarningView : AbstractOnboardingView {
    public PreReleaseWarningView () {
        Object (
            view_name: "pre-release-warning",
            description: _("You're running a <b>pre-release</b> development build of %s. Current major known issues include:").printf (Utils.os_name),
            icon_name: "dialog-warning",
            title: _("Early Access Build")
        );
    }

    construct {
        var apps_label = new Gtk.Label ("• " + _("Curated apps are not available in AppCenter")) {
            xalign = 0
        };

        var style_label = new Gtk.Label ("• " + _("The visual style is unfinished")) {
            xalign = 0
        };

        var list_grid = new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            orientation = Gtk.Orientation.VERTICAL
        };
        list_grid.add (apps_label);
        list_grid.add (style_label);

        var upgrade_label = new Gtk.Label (_("This build uses unstable daily repos and should not be used on production systems. <b>It will not be possible to upgrade to the stable release</b> from this installation.")) {
            margin_bottom = 12,
            margin_top = 12,
            max_width_chars = 50,
            use_markup = true,
            vexpand = true,
            wrap = true
        };

        var more_link = new Gtk.LinkButton.with_label (
            "https://github.com/orgs/elementary/projects/55",
            _("View the 6.0 Release Project")
        );

        custom_bin.orientation = Gtk.Orientation.VERTICAL;
        custom_bin.add (list_grid);
        custom_bin.add (upgrade_label);
        custom_bin.add (more_link);
    }
}
