/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 elementary, Inc. (https://elementary.io)
 *
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class Onboarding.ImmutableView : AbstractOnboardingView {
    public ImmutableView () {
        Object (
            view_name: "immutable",
            description: _("You are using an immutable filesystem."),
            icon_name: "security-high",
            title: _("Immutable")
        );
    }

    construct {
        var filesystem_item = new ListItem (
            "drive-harddisk-symbolic",
            _("You will not be able to modify files outside your Home folder"),
            "orange"
        );

        custom_bin.append (filesystem_item);
    }
}
