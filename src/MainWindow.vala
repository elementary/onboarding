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
    public MainWindow () {
        Object (
            deletable: false,
            icon_name: "system-os-installer",
            title: _("Set up %s").printf (Utils.get_pretty_name ())
        );
    }

    construct {
        var welcome_view = new WelcomeView ();
        var location_services_view = new LocationServicesView ();
        var finish_view = new FinishView ();

        var stack = new Gtk.Stack ();
        stack.expand = true;
        stack.valign = stack.halign = Gtk.Align.CENTER;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        stack.add_titled (welcome_view, "welcome", welcome_view.title);
        stack.add_titled (location_services_view, "location", location_services_view.title);
        stack.add_titled (finish_view, "finish", finish_view.title);
        stack.child_set_property (welcome_view, "icon-name", "pager-checked-symbolic");
        stack.child_set_property (location_services_view, "icon-name", "pager-checked-symbolic");
        stack.child_set_property (finish_view, "icon-name", "pager-checked-symbolic");

        var skip_button = new Gtk.Button.with_label (_("Skip"));

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.stack = stack;

        var next_button = new Gtk.Button.with_label (_("Next"));
        next_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var action_area = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        action_area.expand = true;
        action_area.spacing = 6;
        action_area.valign = Gtk.Align.END;
        action_area.layout_style = Gtk.ButtonBoxStyle.EDGE;
        action_area.add (skip_button);
        action_area.add (stack_switcher);
        action_area.add (next_button);

        var grid = new Gtk.Grid ();
        grid.margin = 10;
        grid.margin_top = 0;
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 48;
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

        stack.notify["visible-child-name"].connect (() => {
            if (stack.visible_child_name == "finish") {
                next_button.label = _("Finish Setup");
            } else {
                next_button.label = _("Next");
            }
        });

        next_button.clicked.connect (() => {
            switch (stack.visible_child_name) {
                case "welcome":
                    stack.visible_child_name = "location";
                case "location":
                    stack.visible_child_name = "finish";
                case "finish":
                    destroy ();
                    break;
            }
        });

        skip_button.clicked.connect (() => {
            destroy ();
        });
    }
}
