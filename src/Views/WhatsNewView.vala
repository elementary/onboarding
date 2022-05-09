/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2019-2022 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.WhatsNewView : AbstractOnboardingView {
    public WhatsNewView () {
        Object (
            view_name: "whats-new",
            description: _("Continue to set up some useful new features. For more detailed information about updates, check out <a href='https://blog.elementary.io'>our blog</a>."),
            icon_name: Utils.logo_icon_name,
            badge_name: "system-software-update",
            title: _("What’s New")
        );
    }
}
