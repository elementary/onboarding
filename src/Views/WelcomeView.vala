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

public class Onboarding.WelcomeView : AbstractOnboardingView {
    public WelcomeView () {
        Object (
            description: _("Continue to set up some useful features. Visit the links below for more information about %s.").printf (Utils.os_name),
            icon_name: "distributor-logo",
            title: _("Welcome to %s!").printf (Utils.os_name)
        );
    }

    construct {
        var thebasics_link = new Gtk.LinkButton.with_label ("https://elementary.io/docs/learning-the-basics#learning-the-basics", _("Learning The Basics"));

        var support_link = new Gtk.LinkButton.with_label (Utils.support_url, _("Get Support"));

        var getinvolved_link = new Gtk.LinkButton.with_label ("https://elementary.io/get-involved", _("Get Involved"));

        custom_bin.attach (thebasics_link, 0, 0);
        custom_bin.attach (support_link, 0, 1);
        custom_bin.attach (getinvolved_link, 0, 2);
    }
}
