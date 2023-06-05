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
    private static GLib.Settings settings;

    private Adw.Carousel carousel;
    private Gtk.SizeGroup buttons_group;

    public MainWindow () {
        Object (
            deletable: false,
            icon_name: "io.elementary.onboarding",
            title: _("Set up %s").printf (Utils.os_name)
        );
    }

    static construct {
        settings = new GLib.Settings ("io.elementary.onboarding");
    }

    construct {
        carousel = new Adw.Carousel () {
            hexpand = true,
            vexpand = true,
            valign = Gtk.Align.CENTER
        };

        if (Posix.isatty (Posix.STDIN_FILENO) == false) {
            viewed = settings.get_strv ("viewed");
        }

        var welcome_view = new WelcomeView ("finish" in viewed);
        carousel.append (welcome_view);

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
            carousel.append (guest_view);
        }

        if (early_access) {
            var early_access_view = new EarlyAccessView ();
            carousel.append (early_access_view);
        }

        if (FileUtils.test ("/run/ostree-booted", FileTest.EXISTS)) {
            var immutable_view = new ImmutableView ();
            carousel.append (immutable_view);
        }

        if (!("style" in viewed)) {
            var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
            if (interface_settings.get_string ("gtk-theme").has_prefix ("io.elementary.stylesheet.")) {
                var style_view = new StyleView ();
                carousel.append (style_view);
            }
        }

        if (!("night-light" in viewed)) {
            var night_light_view = new NightLightView ();
            carousel.append (night_light_view);
        }

        if (!("housekeeping" in viewed || guest_session)) {
            var housekeeping_view = new HouseKeepingView ();
            carousel.append (housekeeping_view);
        }

        if (!("onlineaccounts" in viewed || guest_session)) {
            var onlineaccounts_view = new OnlineAccountsView ();
            carousel.append (onlineaccounts_view);
        }

        if (Environment.find_program_in_path ("io.elementary.appcenter") != null) {
          if (!("appcenter" in viewed)) {
              var appcenter_view = new AppCenterView ();
              carousel.append (appcenter_view);
          }

          if (!("updates" in viewed || guest_session)) {
              var updates_view = new UpdatesView ();
              carousel.append (updates_view);
          }
        }

        // Bail if there are no feature views
        if (carousel.get_n_pages () == 1) {
            GLib.Application.get_default ().quit ();
        }

        // Only show What's New view if there's something other than the Early Access warning
        if (early_access && "welcome" in viewed && carousel.get_n_pages () == 2) {
            carousel.remove (welcome_view);
        }

        var finish_view = new FinishView ();
        carousel.append (finish_view);

        var skip_button = new Gtk.Button.with_label (_("Skip All"));

        var skip_revealer = new Gtk.Revealer () {
            overflow = Gtk.Overflow.VISIBLE,
            reveal_child = true,
            transition_type = Gtk.RevealerTransitionType.NONE,
            child = skip_button
        };

        var switcher = new Switcher (carousel) {
            halign = Gtk.Align.CENTER,
            hexpand = true
        };

        var finish_label = new Gtk.Label (_("Get Started")) {
            opacity = 0
        };

        var next_label = new Gtk.Label (_("Next"));

        var next_finish_overlay = new Gtk.Overlay () {
            child = finish_label
        };
        next_finish_overlay.add_overlay (next_label);

        var next_button = new Gtk.Button () {
            child = next_finish_overlay
        };
        next_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        buttons_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        buttons_group.add_widget (skip_revealer);
        buttons_group.add_widget (next_button);

        var action_area = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            vexpand = true,
            valign = Gtk.Align.END
        };
        action_area.add_css_class ("dialog-action-area");
        action_area.append (skip_revealer);
        action_area.append (switcher);
        action_area.append (next_button);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 24);
        box.append (carousel);
        box.append (action_area);

        child = box;
        titlebar = new Gtk.Grid () { visible = false };
        add_css_class ("dialog");

        next_button.grab_focus ();

        carousel.notify["position"].connect (() => {
            var visible_view = get_visible_view ();
            if (visible_view == null) {
                return;
            }

            mark_viewed (visible_view.view_name);

            var opacity = double.min (1, carousel.n_pages - carousel.position - 1);

            skip_button.opacity = opacity;
            skip_revealer.reveal_child = opacity > 0;

            next_label.opacity = opacity;

            finish_label.opacity = 1 - opacity;
        });

        next_button.clicked.connect (() => {
            int index = (int) Math.round (carousel.position);
            if (index < carousel.get_n_pages () - 1) {
                carousel.scroll_to (carousel.get_nth_page (index + 1), true);
            } else {
                destroy ();
            }
        });

        skip_button.clicked.connect (() => {
            for (var view_count = 0; view_count < carousel.get_n_pages (); view_count++) {
                var view = carousel.get_nth_page (view_count);
                assert (view is AbstractOnboardingView);

                var view_name = ((AbstractOnboardingView) view).view_name;

                mark_viewed (view_name);
            }

            carousel.scroll_to (finish_view, true);
        });
    }

    private AbstractOnboardingView? get_visible_view () {
        var index = (int) Math.round (carousel.position);

        var widget = carousel.get_nth_page (index);

        if (!(widget is AbstractOnboardingView)) {
            return null;
        }

        return (AbstractOnboardingView) widget;
    }

    private void mark_viewed (string view_name) {
        if (!(view_name in viewed)) {
            var viewed_copy = viewed;
            viewed_copy += view_name;
            viewed = viewed_copy;

            settings.set_strv ("viewed", viewed);
        }
    }
}
