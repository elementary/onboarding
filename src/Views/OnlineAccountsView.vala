/*
 * Copyright (c) 2021 elementary, Inc. (https://elementary.io)
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

public class Onboarding.OnlineAccountsView : AbstractOnboardingView {
    public OnlineAccountsView () {
        Object (
            view_name: "onlineaccounts",
            description: _("Use Mail, Calendar, and Tasks with an existing online account to sync emails, events, and tasks with this device."),
            icon_name: "preferences-desktop-online-accounts",
            title: _("Online Accounts")
        );
    }

    construct {
        var settings_link = new Gtk.LinkButton.with_label ("settings://accounts/online", _("Connect Online Accounts…"));

        custom_bin.add (settings_link);
    }
}
