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
            description: _("Choose a default for searching the web from the Applications Menu, Epiphany, and other apps."),
            icon_name: "applications-internet",
            badge_name: "system-search",
            title: _("Search Engine")
        );
    }

    construct {
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/io/elementary/onboarding");

        var default_radio = new Gtk.RadioButton (null);

        var duckduckgo_grid = new SearchEngineGrid (
            "DuckDuckGo",
            "internet-search-duckduckgo",
            "https://duckduckgo.com/about",
            default_radio
        );

        var startpage_grid = new SearchEngineGrid (
            "Startpage.com",
            "internet-search-startpage",
            "https://startpage.com",
            default_radio
        );

        var google_grid = new SearchEngineGrid (
            "Google",
            "internet-search-google",
            "https://about.google/",
            default_radio
        );

        custom_bin.orientation = Gtk.Orientation.VERTICAL;
        custom_bin.row_spacing = 12;

        custom_bin.add (duckduckgo_grid);
        custom_bin.add (startpage_grid);
        custom_bin.add (google_grid);
    }

    private class SearchEngineGrid : Gtk.Grid {
        public string search_engine_name { get; construct; }
        public string search_engine_icon_name { get; construct; }
        // public string search_engine_description { get; construct; }
        public string search_engine_url { get; construct; }
        public Gtk.RadioButton? group_member { get; construct; }

        public SearchEngineGrid (
            string _search_engine_name,
            string _search_engine_icon_name,
            // string _search_engine_description,
            string _search_engine_url,
            Gtk.RadioButton? _group_member = null
        ) {
            Object (
                column_spacing: 6,
                group_member: _group_member,
                // search_engine_description: _search_engine_description,
                search_engine_icon_name: _search_engine_icon_name,
                search_engine_name: _search_engine_name,
                search_engine_url: _search_engine_url
            );
        }

        construct {
            var icon = new Gtk.Image.from_icon_name (search_engine_icon_name, Gtk.IconSize.MENU);

            var label = new Gtk.Label (search_engine_name);
            label.halign = Gtk.Align.START;
            // label.hexpand = true;
            label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            // var description = new Gtk.Label (search_engine_description);
            // description.max_width_chars = 48;
            // description.wrap = true;
            // description.xalign = 0;
            // description.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

            var link = new Gtk.LinkButton.with_label (search_engine_url, _("Learn more…"));

            var radio_grid = new Gtk.Grid ();
            radio_grid.add (icon);
            radio_grid.add (label);
            // radio_grid.attach (description, 1, 2);

            var radio = new Gtk.RadioButton.from_widget (group_member);
            radio.add (radio_grid);

            add (radio);
            add (link);
        }
    }
}
