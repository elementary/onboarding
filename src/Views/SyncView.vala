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
    // private const string OAUTH_URL = "https://elementary.github.io/accounts-prototype/oauth";
    private const string OAUTH_URL = "http://0.0.0.0:4000/oauth";

    public SyncView () {
        Object (
            view_name: "sync",
            title: _("elementary Sync")
        );
    }

    construct {
        var css = new WebKit.UserStyleSheet (
            """
            body {
              --background-color: #f5f5f5;
              --color: #333;
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

        // FIXME: Needs to be set before construction
        var web_context = new WebKit.WebContext.ephemeral ();
        web_view.web_context = web_context;

        web_view.load_uri (OAUTH_URL);

        add (web_view);

        web_view.create.connect ((action) => { return on_new_window_requested (action); });
    }

    private Gtk.Widget? on_new_window_requested (WebKit.NavigationAction action) {
        var uri = action.get_request ().get_uri ();
        try {
            AppInfo.launch_default_for_uri (uri, null);
        } catch (Error e) {
            warning ("Error launching browser for external link: %s", e.message);
        }

        return null;
    }
}
