/*-
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
 */

public class Onboarding.SearchEngineView : AbstractOnboardingView {
    public SearchEngineView () {
        Object (
            view_name: "search-engine",
            description: _("Choose default for searching the web from the Applications Menu, Epiphany, and other apps."),
            icon_name: "applications-internet",
            badge_name: "system-search",
            title: _("Search Engine")
        );
    }

    construct {
        var default_radio = new Gtk.RadioButton (null);
        var startpage_radio = new Gtk.RadioButton.with_label_from_widget (default_radio, "Startpage.com");
        var duckduckgo_radio = new Gtk.RadioButton.with_label_from_widget (default_radio, "DuckDuckGo");
        var google_radio = new Gtk.RadioButton.with_label_from_widget (default_radio, "Google");

        custom_bin.orientation = Gtk.Orientation.VERTICAL;

        custom_bin.add (startpage_radio);
        custom_bin.add (duckduckgo_radio);
        custom_bin.add (google_radio);
    }
}
