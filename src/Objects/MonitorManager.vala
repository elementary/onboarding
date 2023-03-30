/*-
 * Copyright (c) 2018 elementary LLC.
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Display.MonitorManager : GLib.Object {
    public Gee.LinkedList<Display.VirtualMonitor> virtual_monitors { get; construct; }
    public Gee.LinkedList<Display.Monitor> monitors { get; construct; }

    public bool global_scale_required { get; private set; }
    public bool mirroring_supported { get; private set; }
    public int max_width { get; private set; }
    public int max_height { get; private set; }

    public int virtual_monitor_number {
        get {
            return virtual_monitors.size;
        }
    }

    private MutterDisplayConfigInterface iface;
    private uint current_serial;

    private static MonitorManager monitor_manager;
    public static unowned MonitorManager get_default () {
        if (monitor_manager == null) {
            monitor_manager = new MonitorManager ();
        }

        return monitor_manager;
    }

    private MonitorManager () {
        get_monitor_config ();
    }

    construct {
        monitors = new Gee.LinkedList<Display.Monitor> ();
        virtual_monitors = new Gee.LinkedList<Display.VirtualMonitor> ();
        try {
            iface = Bus.get_proxy_sync (BusType.SESSION, "org.gnome.Mutter.DisplayConfig", "/org/gnome/Mutter/DisplayConfig");
            iface.monitors_changed.connect (get_monitor_config);
        } catch (Error e) {
            critical (e.message);
        }
    }

    private void get_monitor_config () {
        MutterReadMonitor[] mutter_monitors;
        MutterReadLogicalMonitor[] mutter_logical_monitors;
        GLib.HashTable<string, GLib.Variant> properties;
        try {
            iface.get_current_state (out current_serial, out mutter_monitors, out mutter_logical_monitors, out properties);
        } catch (Error e) {
            critical (e.message);
        }

        //TODO: make use of the "global-scale-required" property to differenciate between X and Wayland
        var supports_mirroring_variant = properties.lookup ("supports-mirroring");
        if (supports_mirroring_variant != null) {
            mirroring_supported = supports_mirroring_variant.get_boolean ();
        } else {
            /*
             * Absence of "supports-mirroring" means true according to the documentation.
             */
            mirroring_supported = true;
        }

        var global_scale_required_variant = properties.lookup ("global-scale-required");
        if (global_scale_required_variant != null) {
            global_scale_required = global_scale_required_variant.get_boolean ();
        } else {
            /*
             * Absence of "global-scale-required" means false according to the documentation.
             */
            global_scale_required = false;
        }

        var max_screen_size_variant = properties.lookup ("max-screen-size");
        if (max_screen_size_variant != null) {
            max_width = max_screen_size_variant.get_child_value (0).get_int32 ();
            max_height = max_screen_size_variant.get_child_value (1).get_int32 ();
        } else {
            /*
             * Absence of "supports-mirroring" means true according to the documentation.
             */
            max_width = int.MAX;
            max_height = int.MAX;
        }

        var monitors_with_changed_modes = new Gee.LinkedList<Display.Monitor> ();
        foreach (var mutter_monitor in mutter_monitors) {
            var monitor = get_monitor_by_hash (mutter_monitor.monitor.hash);
            if (monitor == null) {
                monitor = new Display.Monitor ();
                monitors.add (monitor);
            } else {
                monitors_with_changed_modes.add (monitor);
            }

            monitor.connector = mutter_monitor.monitor.connector;
            monitor.vendor = mutter_monitor.monitor.vendor;
            monitor.product = mutter_monitor.monitor.product;
            monitor.serial = mutter_monitor.monitor.serial;

            foreach (var mutter_mode in mutter_monitor.modes) {
                var mode = monitor.get_mode_by_id (mutter_mode.id);
                if (mode == null) {
                    mode = new Display.MonitorMode ();
                    monitor.modes.add (mode);
                }

                mode.id = mutter_mode.id;
                mode.width = mutter_mode.width;
                mode.height = mutter_mode.height;
                mode.frequency = mutter_mode.frequency;
                mode.preferred_scale = mutter_mode.preferred_scale;
                mode.supported_scales = mutter_mode.supported_scales;
                var is_preferred_variant = mutter_mode.properties.lookup ("is-preferred");
                if (is_preferred_variant != null) {
                    mode.is_preferred = is_preferred_variant.get_boolean ();
                } else {
                    mode.is_preferred = false;
                }

                var is_current_variant = mutter_mode.properties.lookup ("is-current");
                if (is_current_variant != null) {
                    mode.is_current = is_current_variant.get_boolean ();
                } else {
                    mode.is_current = false;
                }
            }
        }

        foreach (var mutter_logical_monitor in mutter_logical_monitors) {
            string monitors_id = VirtualMonitor.generate_id_from_monitors (mutter_logical_monitor.monitors);
            var virtual_monitor = get_virtual_monitor_by_id (monitors_id);
            if (virtual_monitor == null) {
                virtual_monitor = new VirtualMonitor ();
                add_virtual_monitor (virtual_monitor);
            }

            virtual_monitor.x = mutter_logical_monitor.x;
            virtual_monitor.y = mutter_logical_monitor.y;
            virtual_monitor.current_x = mutter_logical_monitor.x;
            virtual_monitor.current_y = mutter_logical_monitor.y;
            virtual_monitor.scale = mutter_logical_monitor.scale;
            virtual_monitor.transform = mutter_logical_monitor.transform;
            virtual_monitor.primary = mutter_logical_monitor.primary;
            foreach (var mutter_info in mutter_logical_monitor.monitors) {
                foreach (var monitor in monitors) {
                    if (compare_monitor_with_mutter_info (monitor, mutter_info) && !(monitor in virtual_monitor.monitors)) {
                        virtual_monitor.monitors.add (monitor);
                        if (monitor in monitors_with_changed_modes) {
                            virtual_monitor.modes_changed ();
                        }

                        break;
                    }
                }
            }
        }

        // Look for any monitors that aren't part of a virtual monitor (hence disabled)
        // and create a virtual monitor for them so they can be re-enabled
        foreach (var monitor in monitors) {
            bool found = false;
            foreach (var virtual_monitor in virtual_monitors) {
                if (monitor in virtual_monitor.monitors) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                var virtual_monitor = new VirtualMonitor ();
                add_virtual_monitor (virtual_monitor);
                virtual_monitor.is_active = false;
                virtual_monitor.primary = false;
                virtual_monitor.scale = virtual_monitors[0].scale;
                virtual_monitor.monitors.add (monitor);
            }
        }
    }

    private void set_monitor_config () {
        MutterWriteLogicalMonitor[] logical_monitors = {};
        foreach (var virtual_monitor in virtual_monitors) {
            if (virtual_monitor.is_active) {
                logical_monitors += get_mutter_logical_monitor (virtual_monitor);
            }
        }

        int min_x = int.MAX;
        int min_y = int.MAX;

        // Make sure the remaining enabled monitors start at 0,0 as required by mutter.
        // Calculate their offset, and then offset them if necessary
        foreach (unowned var logical_monitor in logical_monitors) {
            min_x = int.min (min_x, logical_monitor.x);
            min_y = int.min (min_y, logical_monitor.y);
        }

        if (min_x != 0 || min_y != 0) {
            // Iterate over the items in the array directly here, a `foreach` would return a copy
            for (int i = 0; i < logical_monitors.length; i++) {
                logical_monitors[i].x -= min_x;
                logical_monitors[i].y -= min_y;
            }
        }

        var properties = new GLib.HashTable<string, GLib.Variant> (str_hash, str_equal);
        try {
            iface.apply_monitors_config (current_serial, MutterApplyMethod.PERSISTENT, logical_monitors, properties);
        } catch (Error e) {
            critical (e.message);
        }
    }

    private static MutterWriteLogicalMonitor get_mutter_logical_monitor (Display.VirtualMonitor virtual_monitor) {
        var logical_monitor = MutterWriteLogicalMonitor () {
            x = virtual_monitor.x,
            y = virtual_monitor.y,
            scale = virtual_monitor.scale,
            transform = virtual_monitor.transform,
            primary = virtual_monitor.primary
        };

        MutterWriteMonitor[] mutter_monitors = {};
        foreach (var monitor in virtual_monitor.monitors) {
            var properties = new GLib.HashTable<string, GLib.Variant> (str_hash, str_equal);
            var mutter_monitor = MutterWriteMonitor () {
                connector = monitor.connector,
                monitor_mode = monitor.current_mode.id,
                properties = properties
            };

            mutter_monitors += mutter_monitor;
        }

        logical_monitor.monitors = mutter_monitors;
        return logical_monitor;
    }

    public void set_scale_on_all_monitors (double new_scale) {
        if (new_scale <= 0.0) {
            return;
        }

        double max_scale = get_min_compatible_scale (monitors);
        if (new_scale > max_scale) {
            return;
        }

        foreach (var monitor in virtual_monitors) {
            monitor.scale = new_scale;
        }

        set_monitor_config ();
    }

    private void add_virtual_monitor (Display.VirtualMonitor virtual_monitor) {
        virtual_monitors.add (virtual_monitor);
        notify_property ("virtual-monitor-number");
    }

    private VirtualMonitor? get_virtual_monitor_by_id (string id) {
        foreach (var vm in virtual_monitors) {
            if (vm.id == id) {
                return vm;
            }
        }

        return null;
    }

    private static bool compare_monitor_with_mutter_info (Display.Monitor monitor, MutterReadMonitorInfo mutter_info) {
        return monitor.connector == mutter_info.connector
               && monitor.vendor == mutter_info.vendor
               && monitor.product == mutter_info.product
               && monitor.serial == mutter_info.serial;
    }

    private Display.Monitor? get_monitor_by_hash (uint hash) {
        foreach (var monitor in monitors) {
            if (monitor.hash == hash) {
                return monitor;
            }
        }

        return null;
    }

    private double get_min_compatible_scale (Gee.LinkedList<Display.Monitor> monitors) {
        double min_scale = double.MAX;
        foreach (var monitor in monitors) {
            min_scale = double.min (min_scale, monitor.get_max_scale ());
        }

        return min_scale;
    }
}
