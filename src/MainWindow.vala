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
        var stack = new Gtk.Stack ();
        stack.expand = true;
        stack.valign = stack.halign = Gtk.Align.CENTER;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        viewed = settings.get_strv ("viewed");

        if ("finish" in viewed) {
            var update_view = new UpdateView ();
            stack.add_titled (update_view, "update", update_view.title);
            stack.child_set_property (update_view, "icon-name", "pager-checked-symbolic");
        } else {
            var welcome_view = new WelcomeView ();
            stack.add_titled (welcome_view, "welcome", welcome_view.title);
            stack.child_set_property (welcome_view, "icon-name", "pager-checked-symbolic");
        }

        var lookup = SettingsSchemaSource.get_default ().lookup (GEOCLUE_SCHEMA, false);
        if (lookup != null) {
            var location_services_view = new LocationServicesView ();
            stack.add_titled (location_services_view, "location", location_services_view.title);
            stack.child_set_property (location_services_view, "icon-name", "pager-checked-symbolic");
        }

        var night_light_view = new NightLightView ();
        stack.add_titled (night_light_view, "night-light", night_light_view.title);
        stack.child_set_property (night_light_view, "icon-name", "pager-checked-symbolic");

        var housekeeping_view = new HouseKeepingView ();
        stack.add_titled (housekeeping_view, "housekeeping", housekeeping_view.title);
        stack.child_set_property (housekeeping_view, "icon-name", "pager-checked-symbolic");

        if (Environment.find_program_in_path ("io.elementary.appcenter") != null) {
            var appcenter_view = new AppCenterView ();
            stack.add_titled (appcenter_view, "appcenter", appcenter_view.title);
            stack.child_set_property (appcenter_view, "icon-name", "pager-checked-symbolic");
        }

        GLib.List<unowned Gtk.Widget> views = stack.get_children ();
        foreach (Gtk.Widget view in views) {
            var view_name_value = GLib.Value (typeof (string));
            stack.child_get_property (view, "name", ref view_name_value);

            string view_name = view_name_value.get_string ();

            if (view_name in viewed) {
                view.destroy ();
            }
        }

        // Bail if there are no feature views
        if (stack.get_children ().length () < 2) {
            GLib.Application.get_default ().quit ();
        }

        var finish_view = new FinishView ();
        stack.add_titled (finish_view, "finish", finish_view.title);
        stack.child_set_property (finish_view, "icon-name", "pager-checked-symbolic");

        var skip_button = new Gtk.Button.with_label (_("Skip All"));

        var skip_revealer = new Gtk.Revealer ();
        skip_revealer.reveal_child = true;
        skip_revealer.transition_type = Gtk.RevealerTransitionType.NONE;
        skip_revealer.add (skip_button);

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.stack = stack;

        var next_button = new Gtk.Button.with_label (_("Next"));
        next_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var action_area = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        action_area.margin_start = action_area.margin_end = 10;
        action_area.expand = true;
        action_area.spacing = 6;
        action_area.valign = Gtk.Align.END;
        action_area.layout_style = Gtk.ButtonBoxStyle.EDGE;
        action_area.add (skip_revealer);
        action_area.add (stack_switcher);
        action_area.add (next_button);
        action_area.set_child_non_homogeneous (stack_switcher, true);

        var grid = new Gtk.Grid ();
        grid.margin_bottom = 10;
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 24;
        grid.add (stack);
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

        stack.notify["visible-child-name"].connect (() => {
            mark_viewed (stack.visible_child_name);

            if (stack.visible_child_name == "finish") {
                next_button.label = _("Get Started");
                skip_revealer.reveal_child = false;
            } else {
                next_button.label = _("Next");
                skip_revealer.reveal_child = true;
            }
        });

        next_button.clicked.connect (() => {
            GLib.List<unowned Gtk.Widget> current_views = stack.get_children ();
            var index = current_views.index (stack.visible_child);
            if (index < current_views.length () - 1) {
                stack.visible_child = current_views.nth_data (index + 1);
            } else {
                destroy ();
            }
        });

        skip_button.clicked.connect (() => {
            foreach (Gtk.Widget view in views) {
                var view_name_value = GLib.Value (typeof (string));
                stack.child_get_property (view, "name", ref view_name_value);

                string view_name = view_name_value.get_string ();

                mark_viewed (view_name);
            }

            stack.visible_child_name = "finish";
        });
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
