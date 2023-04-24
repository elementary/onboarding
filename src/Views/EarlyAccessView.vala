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

        custom_bin.append (upgrades_item);
        custom_bin.append (features_item);
        custom_bin.append (bugs_item);
    }
}
