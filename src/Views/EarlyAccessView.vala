/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2023 elementary, Inc. (https://elementary.io)
 *
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 *              Cassidy James Blaede <cassidy@elementary.io>
 */

public class Onboarding.EarlyAccessView : AbstractOnboardingView {
    public EarlyAccessView () {
        Object (
            view_name: "early-access",
            description: _("Only use this pre-release version of %s on devices dedicated for development.").printf (Utils.os_name),
            icon_name: "applications-development",
            title: _("Early Access Build")
        );
    }

    construct {
        var upgrades_item = new ListItem (
            "software-update-available-symbolic",
            _("You will not be able to upgrade to a stable release"),
            "orange"
        );

        var features_item = new ListItem (
            "dialog-warning-symbolic",
            _("Some features may be missing or incomplete"),
            "yellow"
        );

        var bugs_item = new ListItem (
            "bug-symbolic",
            _("Report issues using the Feedback app"),
            "green"
        );

        var list_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            halign = Gtk.Align.CENTER
        };
        list_box.append (upgrades_item);
        list_box.append (features_item);
        list_box.append (bugs_item);

        custom_bin.attach (list_box, 0, 0);
    }

    private class ListItem : Gtk.Box {
        public string color { get; construct; }
        public string icon_name { get; construct; }
        public string label { get; construct; }

        public ListItem (string icon_name, string label, string color) {
            Object (
                icon_name: icon_name,
                label: label,
                color: color
            );
        }

        construct {
            var image = new Gtk.Image.from_icon_name (icon_name);
            image.add_css_class (Granite.STYLE_CLASS_ACCENT);
            image.add_css_class (color);

            var description_label = new Gtk.Label (label) {
                max_width_chars = 40,
                wrap = true,
                xalign = 0
            };

            spacing = 6;
            append (image);
            append (description_label);
        }
    }
}
