/*
 * Copyright 2019–2020 elementary, Inc. (https://elementary.io)
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
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Onboarding.MainWindow : Gtk.ApplicationWindow {
    public string[] viewed { get; set; }
    public static GLib.Settings settings;
    public static ListStore pages;

    private Adw.NavigationView navigation_view;
    private FinishView finish_view;

    public MainWindow () {
        Object (
            deletable: false,
            icon_name: "io.elementary.onboarding",
            title: _("Set up %s").printf (Utils.os_name)
        );
    }

    static construct {
        pages = new ListStore (typeof (Adw.NavigationPage));
        settings = new GLib.Settings ("io.elementary.onboarding");
    }

    construct {
        navigation_view = new Adw.NavigationView ();

        if (Posix.isatty (Posix.STDIN_FILENO) == false) {
            viewed = settings.get_strv ("viewed");
        }

        var welcome_view = new WelcomeView ("finish" in viewed);
        navigation_view.add (welcome_view);
        pages.append (welcome_view);

        // Always show Early Access view on pre-release builds
        var early_access = false;
        var apt_sources = File.new_for_path ("/etc/apt/sources.list.d/elementary.list");
        try {
            var @is = apt_sources.read ();
            var dis = new DataInputStream (@is);

            if ("daily" in dis.read_line ()) {
                early_access = true;
            }
        } catch (Error e) {
            critical ("Couldn't read apt sources: %s", e.message);
        }

        var guest_session = Environment.get_user_name ().has_prefix ("guest-");
        if (guest_session || Posix.isatty (Posix.STDIN_FILENO)) {
            var guest_view = new GuestView ();
            pages.append (guest_view);
        }

        if (early_access) {
            var early_access_view = new EarlyAccessView ();
            pages.append (early_access_view);
        }

        if (!("style" in viewed)) {
            var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
            if (interface_settings.get_string ("gtk-theme").has_prefix ("io.elementary.stylesheet.")) {
                var style_view = new StyleView ();
                pages.append (style_view);
            }
        }

        if (!("night-light" in viewed)) {
            var night_light_view = new NightLightView ();
            pages.append (night_light_view);
        }

        if (!("housekeeping" in viewed || guest_session)) {
            var housekeeping_view = new HouseKeepingView ();
            pages.append (housekeeping_view);
        }

        if (!("onlineaccounts" in viewed || guest_session)) {
            var onlineaccounts_view = new OnlineAccountsView ();
            pages.append (onlineaccounts_view);
        }

        if (Environment.find_program_in_path ("io.elementary.appcenter") != null) {
            if (!("appcenter" in viewed)) {
                var appcenter_view = new AppCenterView ();
                pages.append (appcenter_view);
            }
        }

        if (!("updates" in viewed || guest_session)) {
            var updates_view = new UpdatesView ();
            pages.append (updates_view);
        }

        // Bail if there are no feature views
        if (pages.n_items == 1) {
            GLib.Application.get_default ().quit ();
        }

        // Only show What's New view if there's something other than the Early Access warning
        if (early_access && "welcome" in viewed && navigation_view.navigation_stack.get_n_items () == 2) {
            navigation_view.remove (welcome_view);
        }

        finish_view = new FinishView ();
        pages.append (finish_view);

        child = navigation_view;
        titlebar = new Gtk.Grid () { visible = false };
        add_css_class ("dialog");

        navigation_view.get_next_page.connect (get_next_page);

        var next_action = new SimpleAction ("next", null);
        next_action.activate.connect (action_next);

        var skip_action = new SimpleAction ("skip", null);
        skip_action.activate.connect (action_skip);

        add_action (next_action);
        add_action (skip_action);
    }

    private void action_next () {
        var next_page = get_next_page ();
        if (next_page != null) {
            navigation_view.push (next_page);
        } else {
            close ();
        }
    }

    private Adw.NavigationPage get_next_page () {
        uint pos = -1;
        pages.find (navigation_view.visible_page, out pos);
        return (Adw.NavigationPage) pages.get_item (pos + 1);
    }

    private void action_skip () {
        for (var view_count = 0; view_count < pages.get_n_items (); view_count++) {
            var view = (AbstractOnboardingView) pages.get_item (view_count);
            view.mark_viewed ();
        }

        navigation_view.push (finish_view);
    }
}
