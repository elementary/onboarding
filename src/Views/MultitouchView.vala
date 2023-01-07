/*
 * Copyright 2020-2023 elementary, Inc. (https://elementary.io)
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
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 *              Cassidy James Blaede <cassidy@elementary.io>
 */

public class Onboarding.MultitouchView : AbstractOnboardingView {
    public MultitouchView () {
        Object (
            view_name: "multitouch",
            description: _("Navigate efficiently through your windows and workspaces with modern 3-finger multitouch gestures."),
            icon_name: "input-touchpad", // Change to better one
            title: _("Multitouch Gestures")
        );
    }

    construct {
        var demo_button = new Gtk.LinkButton.with_label ("", _("Show multitouch gestures demo…")) {
            hexpand = false,
            halign = Gtk.Align.CENTER,
            has_tooltip = false
        };

        var settings_button = new Gtk.Label (_("You can change these gestures later in System Settings")) {
            justify = Gtk.Justification.CENTER,
            max_width_chars = 45,
            use_markup = true,
            valign = Gtk.Align.END,
            vexpand = true,
            wrap = true
        };
        settings_button.add_css_class (Granite.STYLE_CLASS_SMALL_LABEL);
        settings_button.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

        custom_bin.attach (demo_button, 0, 0);
        custom_bin.attach (settings_button, 0, 1);
    }
}
