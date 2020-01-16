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
    public ScalingFactorView () {
        Object (
            view_name: "scaling-factor",
            description: _("This device’s display size and resolution are in a tricky range. These settings may help make things look the right physical size."),
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

        var text_size_combo = new Gtk.ComboBoxText ();
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
    }
}
