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
            description: _("This pre-release version of %s should not be used in production. <b>It will not be possible to upgrade to the stable release</b> from this installation.").printf (Utils.os_name),
            icon_name: Utils.logo_icon_name,
            badge_name: "dialog-warning",
            title: _("Early Access Build")
        );
    }

    construct {
        var title_label = new Granite.HeaderLabel (_("Major Known Issues"));

        var apps_icon = new Gtk.Image.from_icon_name ("system-software-install-symbolic", Gtk.IconSize.BUTTON);
        apps_icon.get_style_context ().add_class (Granite.STYLE_CLASS_ACCENT);
        apps_icon.get_style_context ().add_class ("purple");

        var apps_label = new Gtk.Label (_("Curated apps are not available in AppCenter")) {
            xalign = 0
        };

        var style_icon = new Gtk.Image.from_icon_name ("applications-graphics-symbolic", Gtk.IconSize.BUTTON);
        style_icon.get_style_context ().add_class (Granite.STYLE_CLASS_ACCENT);
        style_icon.get_style_context ().add_class ("pink");

        var style_label = new Gtk.Label (_("The visual style is unfinished")) {
            xalign = 0
        };

        var feature_icon = new Gtk.Image.from_icon_name ("preferences-other-symbolic", Gtk.IconSize.BUTTON);
        feature_icon.get_style_context ().add_class (Granite.STYLE_CLASS_ACCENT);
        feature_icon.get_style_context ().add_class ("slate");

        var feature_label = new Gtk.Label (_("Some features are missing or incomplete")) {
            xalign = 0
        };

        var list_grid = new Gtk.Grid () {
            column_spacing = 6,
            row_spacing = 6,
            halign = Gtk.Align.CENTER,
            margin_bottom = 12
        };
        list_grid.attach (title_label, 0, 0, 2);
        list_grid.attach (apps_icon, 0, 1);
        list_grid.attach (apps_label, 1, 1);
        list_grid.attach (style_icon, 0, 2);
        list_grid.attach (style_label, 1, 2);
        list_grid.attach (feature_icon, 0, 3);
        list_grid.attach (feature_label, 1, 3);

        var more_link = new Gtk.LinkButton.with_label (
            "https://github.com/orgs/elementary/projects/55",
            _("More issues on the 6.0 Release Project…")
        ) {
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            vexpand = true
        };

        custom_bin.orientation = Gtk.Orientation.VERTICAL;
        custom_bin.add (list_grid);
        custom_bin.add (more_link);
    }
}
