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
    public string[] viewed { get; set; }

    public MainWindow () {
        Object (
            deletable: false,
            icon_name: "system-os-installer",
            title: _("Set up %s").printf (Utils.os_name),
            width_request: 560
        );
    }

    construct {
        var stack = new Gtk.Stack ();
        stack.expand = true;
        stack.valign = stack.halign = Gtk.Align.CENTER;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        viewed = Onboarding.App.settings.get_strv ("viewed");

        WelcomeView welcome_view;
        if (Onboarding.App.settings.get_boolean ("first-run")) {
            welcome_view = new WelcomeView ();
        } else {
            welcome_view = new WelcomeView.with_updates ();
        }
        stack.add_titled (welcome_view, "welcome", welcome_view.title);
        stack.child_set_property (welcome_view, "icon-name", "pager-checked-symbolic");

        if (!("location" in viewed)) {
            var location_services_view = new LocationServicesView ();
            stack.add_titled (location_services_view, "location", location_services_view.title);
            stack.child_set_property (location_services_view, "icon-name", "pager-checked-symbolic");
        }

        if (!("night-light" in viewed)) {
            var night_light_view = new NightLightView ();
            stack.add_titled (night_light_view, "night-light", night_light_view.title);
            stack.child_set_property (night_light_view, "icon-name", "pager-checked-symbolic");
        }

        if (!("housekeeping" in viewed)) {
            var housekeeping_view = new HouseKeepingView ();
            stack.add_titled (housekeeping_view, "housekeeping", housekeeping_view.title);
            stack.child_set_property (housekeeping_view, "icon-name", "pager-checked-symbolic");
        }

        AppCenterView? appcenter_view = null;
        if (
            !("appcenter" in viewed) &&
            Environment.find_program_in_path ("io.elementary.appcenter") != null
        ) {
            appcenter_view = new AppCenterView ();
            stack.add_titled (appcenter_view, "appcenter", appcenter_view.title);
            stack.child_set_property (appcenter_view, "icon-name", "pager-checked-symbolic");
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
            if (stack.visible_child_name == "finish") {
                next_button.label = _("Get Started");
                skip_revealer.reveal_child = false;
            } else {
                next_button.label = _("Next");
                skip_revealer.reveal_child = true;
            }
        });

        string[] views;
        foreach (unowned Gtk.Widget view in stack.get_children ()) {
            var name = GLib.Value (typeof (string));
            stack.child_get_property (view, "name", ref name);
            views += name.get_string ();
        }

        next_button.clicked.connect (() => {
            if (stack.visible_child_name != "finish") {
                mark_viewed (stack.visible_child_name);
                int index;
                for (int i = 0; i < views.length; i++) {
                    if (views[i] == stack.visible_child_name) {
                        index = i;
                        break;
                    }
                }
                stack.visible_child_name = views[index + 1];
            } else {
                Onboarding.App.settings.set_boolean ("first-run", false);
                destroy ();
            }
        });

        skip_button.clicked.connect (() => {
            stack.visible_child_name = "finish";
        });
    }

    private void mark_viewed (string view_name) {
        if (!(view_name in viewed)) {
            var viewed_copy = viewed;
            viewed_copy += view_name;
            viewed = viewed_copy;

            Onboarding.App.settings.set_strv ("viewed", viewed);
        }
    }
}
