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
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Onboarding.MainWindow : Gtk.Window {
    public const string GEOCLUE_SCHEMA = "io.elementary.desktop.agent-geoclue2";
    public string[] viewed { get; set; }
    private static GLib.Settings settings;

    private Hdy.Carousel carousel;
    private Gtk.SizeGroup buttons_group;

    public MainWindow () {
        Object (
            deletable: false,
            icon_name: "system-os-installer",
            title: _("Set up %s").printf (Utils.os_name),
            width_request: 560
        );
    }

    static construct {
        settings = new GLib.Settings ("io.elementary.onboarding");
    }

    construct {
        carousel = new Hdy.Carousel ();
        carousel.expand = true;
        carousel.valign = Gtk.Align.CENTER;

        viewed = settings.get_strv ("viewed");

        if ("finish" in viewed) {
            var update_view = new UpdateView ();
            carousel.add (update_view);
        } else {
            var welcome_view = new WelcomeView ();
            carousel.add (welcome_view);
        }

        var lookup = SettingsSchemaSource.get_default ().lookup (GEOCLUE_SCHEMA, true);
        if (lookup != null) {
            var location_services_view = new LocationServicesView ();
            carousel.add (location_services_view);
        }

        var night_light_view = new NightLightView ();
        carousel.add (night_light_view);

        var housekeeping_view = new HouseKeepingView ();
        carousel.add (housekeeping_view);

        if (Environment.find_program_in_path ("io.elementary.appcenter") != null) {
            var appcenter_view = new AppCenterView ();
            carousel.add (appcenter_view);
        }

        GLib.List<unowned Gtk.Widget> views = carousel.get_children ();
        foreach (Gtk.Widget view in views) {
            assert (view is AbstractOnboardingView);

            var view_name = ((AbstractOnboardingView) view).view_name;

            if (view_name in viewed) {
                carousel.remove (view);
                view.destroy ();
            }
        }

        // Bail if there are no feature views
        if (carousel.get_children ().length () < 2) {
            GLib.Application.get_default ().quit ();
        }

        var finish_view = new FinishView ();
        carousel.add (finish_view);

        var skip_button = new Gtk.Button.with_label (_("Skip All"));

        var skip_revealer = new Gtk.Revealer ();
        skip_revealer.reveal_child = true;
        skip_revealer.transition_type = Gtk.RevealerTransitionType.NONE;
        skip_revealer.add (skip_button);

        var switcher = new Switcher (carousel);
        switcher.halign = Gtk.Align.CENTER;

        var next_finish_overlay = new Gtk.Overlay ();

        var finish_button = new Gtk.Button.with_label (_("Get Started"));
        finish_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        next_finish_overlay.add (finish_button);

        var next_button = new Gtk.Button.with_label (_("Next"));
        next_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        next_finish_overlay.add_overlay (next_button);

        buttons_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        buttons_group.add_widget (skip_revealer);
        buttons_group.add_widget (next_button);
        buttons_group.add_widget (finish_button);

        var action_area = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        action_area.margin_start = action_area.margin_end = 10;
        action_area.expand = true;
        action_area.spacing = 6;
        action_area.valign = Gtk.Align.END;
        action_area.layout_style = Gtk.ButtonBoxStyle.EDGE;
        action_area.add (skip_revealer);
        action_area.add (switcher);
        action_area.add (next_finish_overlay);
        action_area.set_child_non_homogeneous (switcher, true);

        var grid = new Gtk.Grid ();
        grid.margin_bottom = 10;
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 24;
        grid.add (carousel);
        grid.add (action_area);

        var titlebar = new Gtk.HeaderBar ();
        titlebar.get_style_context ().add_class ("default-decoration");
        titlebar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        titlebar.set_custom_title (new Gtk.Label (null));

        add (grid);
        get_style_context ().add_class ("rounded");
        set_titlebar (titlebar);
        show_all ();

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

            next_button.opacity = opacity;
            next_button.visible = opacity > 0;
        });

        next_button.clicked.connect (() => {
            GLib.List<unowned Gtk.Widget> current_views = carousel.get_children ();
            int index = (int) Math.round (carousel.position);
            if (index < current_views.length () - 1) {
                carousel.scroll_to (current_views.nth_data (index + 1));
            }
        });

        finish_button.clicked.connect (() => {
            destroy ();
        });

        skip_button.clicked.connect (() => {
            foreach (Gtk.Widget view in carousel.get_children ()) {
                assert (view is AbstractOnboardingView);

                var view_name = ((AbstractOnboardingView) view).view_name;

                mark_viewed (view_name);
            }

            carousel.scroll_to (finish_view);
        });
    }

    private AbstractOnboardingView? get_visible_view () {
        var index = (int) Math.round (carousel.position);

        var widget = carousel.get_children ().nth_data (index);

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
