/*-
 * Copyright (c) 2019 elementary, Inc. (https://elementary.io)
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
 */

public class Onboarding.UpdateView : AbstractOnboardingView {
    public UpdateView () {
        Object (
            view_name: "update",
            description: _("Continue to set up some useful new features. For more detailed information about updates, check out <a href='https://blog.elementary.io'>our blog</a>."),
            icon_name: Utils.logo_icon_name,
            badge_name: "system-software-update",
            title: _("What’s New")
        );
    }
}
