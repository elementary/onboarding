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

public class Onboarding.EarlyAccessView : AbstractOnboardingView {
    public EarlyAccessView () {
        Object (
            view_name: "early-access",
            description: _("This is a pre-release version of %s that should not be used in production. <b>It will not be possible to upgrade to the stable release</b> from this installation.").printf (Utils.os_name),
            icon_name: "dialog-warning",
            title: _("Early Access Build")
        );
    }

    construct {
        var title_label = new Gtk.Label (_("Current major known issues include:")) {
            margin_bottom = 12,
            xalign = 0
        };

        var apps_label = new Gtk.Label ("• " + _("Curated apps are not available in AppCenter")) {
            xalign = 0
        };

        var style_label = new Gtk.Label ("• " + _("The visual style is unfinished")) {
            xalign = 0
        };

        var list_grid = new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            margin_bottom = 12,
            orientation = Gtk.Orientation.VERTICAL
        };
        list_grid.add (title_label);
        list_grid.add (apps_label);
        list_grid.add (style_label);

        var more_link = new Gtk.LinkButton.with_label (
            "https://github.com/orgs/elementary/projects/55",
            _("More issues on the 6.0 Release Project")
        ) {
            valign = Gtk.Align.END,
            vexpand = true
        };

        custom_bin.orientation = Gtk.Orientation.VERTICAL;
        custom_bin.add (list_grid);
        custom_bin.add (more_link);
    }
}
