/*
 * Copyright © 2018–2020 elementary, Inc.
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

public class Onboarding.VirtualMonitor : GLib.Object {
    public int x { get; set; }
    public int y { get; set; }
    public int current_x { get; set; }
    public int current_y { get; set; }
    public double scale { get; set; }
    public DisplayTransform transform { get; set; }
    public bool primary { get; set; }
    public Gee.LinkedList<Onboarding.Monitor> monitors { get; construct; }

    public signal void modes_changed ();

    /*
     * Used to distinguish two VirtualMonitors from each other.
     * We make up and ID by sum all hashes of
     * monitors that a VirtualMonitor has.
     */
    public string id {
        owned get {
            uint val = 0;
            foreach (var monitor in monitors) {
                val += monitor.hash;
            }

            return val.to_string ();
        }
    }

    public bool is_mirror {
        get {
            return monitors.size > 1;
        }
    }

    public bool is_active {
        get {
            return true;
        }
    }

    /*
     * Get the first monitor of the list, handy in non-mirror context.
     */
    public Onboarding.Monitor monitor {
        owned get {
            if (is_mirror) {
                critical ("Do not use Onboarding.VirtualMonitor.monitor in a mirror context!");
            }

            return monitors[0];
        }
    }

    construct {
        monitors = new Gee.LinkedList<Onboarding.Monitor> ();
    }

    public unowned string get_display_name () {
        if (is_mirror) {
            return _("Mirrored Display");
        } else {
            return monitor.display_name;
        }
    }

    public void get_current_mode_size (out int width, out int height) {
        if (!is_active) {
            width = 1280;
            height = 720;
        } else if (is_mirror) {
            var current_mode = monitors[0].current_mode;
            width = current_mode.width;
            height = current_mode.height;
        } else {
            var current_mode = monitor.current_mode;
            width = current_mode.width;
            height = current_mode.height;
        }
    }

    public Gee.LinkedList<Onboarding.MonitorMode> get_available_modes () {
        if (is_mirror) {
            return Utils.get_common_monitor_modes (monitors);
        } else {
            return monitor.modes;
        }
    }

    public void set_current_mode (Onboarding.MonitorMode current_mode) {
        if (is_mirror) {
            monitors.foreach ((_monitor) => {
                bool mode_found = false;
                foreach (var mode in _monitor.modes) {
                    if (mode_found) {
                        mode.is_current = false;
                        continue;
                    }

                    if (mode.width == current_mode.width && mode.height == current_mode.height) {
                        mode_found = true;
                        mode.is_current = true;
                    } else {
                        mode.is_current = false;
                    }
                }

                return true;
            });
        } else {
            foreach (var mode in monitor.modes) {
                mode.is_current = mode == current_mode;
            }
        }
    }

    public static string generate_id_from_monitors (MutterReadMonitorInfo[] infos) {
        uint val = 0;
        foreach (var info in infos) {
            val += info.hash;
        }

        return val.to_string ();
    }
}
