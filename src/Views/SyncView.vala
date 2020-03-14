/*
 * Copyright © 2019–2020 elementary, Inc. (https://elementary.io)
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

public class Onboarding.SyncView : AbstractOnboardingView {
    public SyncView () {
        Object (
            view_name: "sync",
            title: _("elementary Sync")
        );
    }

    construct {
        var css = new WebKit.UserStyleSheet (
            """
            html,
            body {
                background-color: #f5f5f5;
                color: #333;
                font-family: Inter, "Open Sans", sans-serif;
            }
            """,
            WebKit.UserContentInjectedFrames.TOP_FRAME,
            WebKit.UserStyleLevel.USER,
            null,
            null
        );

        var user_content_manager = new WebKit.UserContentManager ();
        user_content_manager.add_style_sheet (css);

        var settings = new WebKit.Settings ();
        settings.default_font_family = Gtk.Settings.get_default ().gtk_font_name;

        var web_view = new WebKit.WebView.with_user_content_manager (user_content_manager);
        web_view.expand = true;
        web_view.settings = settings;

        web_view.load_uri ("https://accounts.elementary.io/auth/v1");

        add (web_view);
    }
}
