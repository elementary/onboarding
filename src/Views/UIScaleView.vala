/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 elementary, Inc. (https://elementary.io)
 */

public class Onboarding.UIScaleView : AbstractOnboardingView {
    private uint scale_timeout;

    public UIScaleView () {
        Object (
            view_name: "ui-scale",
            description: _("This device’s scaling couldn’t be determined automatically."),
            icon_name: "preferences-desktop-display-scale",
            title: _("Display Scaling")
        );
    }

    construct {
        var dpi_header = new Granite.HeaderLabel (_("Display Density")) {
            secondary_text = _("Adjust to the closest fit first")
        };

        var lodpi_radio = new Gtk.CheckButton.with_label (_("1× (LoDPI)"));

        var hidpi2_radio = new Gtk.CheckButton.with_label (_("2× (HiDPI—3K and above)")) {
            group = lodpi_radio
        };

        var hidpi3_radio = new Gtk.CheckButton.with_label (_("3× (Ultra HiDPI—6k and above)")) {
            group = lodpi_radio
        };

        var dpi_box = new Gtk.Box (VERTICAL, 6);
        dpi_box.append (lodpi_radio);
        dpi_box.append (hidpi2_radio);
        dpi_box.append (hidpi3_radio);

        var text_header = new Granite.HeaderLabel (_("Interface Size")) {
            secondary_text = _("May cause some blurriness")
        };

        var text_adjustment = new Gtk.Adjustment (-1, 0.75, 1.5, 0.05, 0, 0);

        var text_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, text_adjustment) {
            draw_value = false,
            hexpand = true,
            width_request = 275
        };
        text_scale.add_mark (1, Gtk.PositionType.BOTTOM, null);
        text_scale.add_mark (1.25, Gtk.PositionType.BOTTOM, null);

        custom_bin.append (dpi_header);
        custom_bin.append (dpi_box);
        custom_bin.append (text_header);
        custom_bin.append (text_scale);

        unowned var monitor_manager = Display.MonitorManager.get_default ();

        lodpi_radio.toggled.connect (() => {
            if (lodpi_radio.active) {
                monitor_manager.set_scale_on_all_monitors ((double) 1);
            }
        });

        hidpi2_radio.toggled.connect (() => {
            if (hidpi2_radio.active) {
                monitor_manager.set_scale_on_all_monitors ((double) 2);
            }
        });

        hidpi3_radio.toggled.connect (() => {
            if (hidpi3_radio.active) {
                monitor_manager.set_scale_on_all_monitors ((double) 3);
            }
        });

        var interface_settings = new Settings ("org.gnome.desktop.interface");
        interface_settings.bind ("text-scaling-factor", text_adjustment, "value", SettingsBindFlags.GET);

        // Setting scale is slow, so we wait while pressed to keep UI responsive
        text_adjustment.value_changed.connect (() => {
            if (scale_timeout != 0) {
                GLib.Source.remove (scale_timeout);
            }

            scale_timeout = Timeout.add (300, () => {
                scale_timeout = 0;
                interface_settings.set_double ("text-scaling-factor", text_adjustment.value);
                return false;
            });
        });
    }
}
