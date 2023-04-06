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
            _("Settings will be reset to defaults"),
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
}
