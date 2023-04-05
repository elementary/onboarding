/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.GuestView : AbstractOnboardingView {
    public GuestView () {
        Object (
            view_name: "guest",
            description: _("This temporary session will be reset when you log out."),
            icon_name: "avatar-default",
            title: _("Guest Session")
        );
    }

    construct {
        var upgrades_item = new ListItem (
            "user-trash-symbolic",
            _("All data created during this session will be deleted"),
            "orange"
        );

        var features_item = new ListItem (
            "preferences-system-symbolic",
            _("settings will be reset to defaults"),
            "yellow"
        );

        var bugs_item = new ListItem (
            "drive-removable-media-symbolic",
            _("Save files on an external device to access them later"),
            "green"
        );

        custom_bin.append (upgrades_item);
        custom_bin.append (features_item);
        custom_bin.append (bugs_item);
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
                hexpand = true,
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
