/*
 * Copyright © 2020 elementary, Inc. (https://elementary.io)
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

public class Onboarding.ScalingFactorView : AbstractOnboardingView {
    private const string INTERFACE_SCHEMA = "org.gnome.desktop.interface";
    private const string TEXT_SIZE_KEY = "text-scaling-factor";
    private const double[] TEXT_SCALE = {0.75, 1, 1.25, 1.5};

    private Gtk.ComboBoxText dpi_combo;
    private Gtk.ComboBoxText text_size_combo;

    public ScalingFactorView () {
        Object (
            view_name: "scaling-factor",
            description: _("This device’s scaling factor couldn’t be set automatically. These settings may help."),
            icon_name: "preferences-desktop-display",
            title: _("Display Scaling")
        );
    }

    construct {
        var scaling_factor_label = new Gtk.Label (_("Scaling factor:"));
        scaling_factor_label.halign = Gtk.Align.END;

        var scaling_factor_combo = new Gtk.ComboBoxText ();
        scaling_factor_combo.append_text (_("LoDPI"));
        scaling_factor_combo.append_text (_("Pixel Doubled"));

        var text_size_label = new Gtk.Label (_("Text size:"));
        text_size_label.halign = Gtk.Align.END;

        text_size_combo = new Gtk.ComboBoxText ();
        text_size_combo.append_text (_("Small"));
        text_size_combo.append_text (_("Default"));
        text_size_combo.append_text (_("Large"));
        text_size_combo.append_text (_("Larger"));

        var grid = new Gtk.Grid ();
        grid.column_spacing = grid.row_spacing = 6;

        grid.attach (scaling_factor_label, 0, 0);
        grid.attach (scaling_factor_combo, 1, 0);
        grid.attach (text_size_label, 0, 1);
        grid.attach (text_size_combo, 1, 1);

        custom_bin.add (grid);

        unowned Onboarding.MonitorManager monitor_manager = Onboarding.MonitorManager.get_default ();
        scaling_factor_combo.active = (int)monitor_manager.virtual_monitors[0].scale - 1;

        scaling_factor_combo.changed.connect (() => {
            monitor_manager.set_scale_on_all_monitors ((double)(scaling_factor_combo.active + 1));
        });

        var interface_settings = new Settings (INTERFACE_SCHEMA);

        update_text_size_combo (interface_settings);

        interface_settings.changed.connect (() => {
            update_text_size_combo (interface_settings);
        });

        text_size_combo.changed.connect (() => {
            set_text_scale (interface_settings, text_size_combo.active);
        });
    }

    private int get_text_scale (GLib.Settings interface_settings) {
        double text_scaling_factor = interface_settings.get_double (TEXT_SIZE_KEY);

        if (text_scaling_factor <= TEXT_SCALE[0]) {
            return 0;
        } else if (text_scaling_factor <= TEXT_SCALE[1]) {
            return 1;
        } else if (text_scaling_factor <= TEXT_SCALE[2]) {
            return 2;
        } else {
            return 3;
        }
    }

    private void set_text_scale (GLib.Settings interface_settings, int option) {
        interface_settings.set_double (TEXT_SIZE_KEY, TEXT_SCALE[option]);
    }

    private void update_text_size_combo (GLib.Settings interface_settings) {
        text_size_combo.active = get_text_scale (interface_settings);
    }
}
