/*
 * Copyright © 2014–2020 elementary, Inc. (https://elementary.io)
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
 *              Marvin Beckers <beckersmarvin@gmail.com>
 */

public class Utils {
    private static string _support_url;
    public static string support_url {
        get {
            if (_support_url == null) {
                parse_osrelease ();
            }

            return _support_url;
        }
    }

    private static string _os_name;
    public static string os_name {
        get {
            if (_os_name == null) {
                parse_osrelease ();
            }

            return _os_name;
        }
    }

    private static string _logo_icon_name;
    public static string logo_icon_name {
        get {
            if (_logo_icon_name == null) {
                parse_osrelease ();

                // If it's still null, fall back
                if (_logo_icon_name == null) {
                    _logo_icon_name = "distributor-logo";
                }
            }

            return _logo_icon_name;
        }
    }


    private static void parse_osrelease () {
        var file = File.new_for_path ("/etc/os-release");
        try {
            var osrel = new Gee.HashMap<string, string> ();
            var dis = new DataInputStream (file.read ());
            string line;
            // Read lines until end of file (null) is reached
            while ((line = dis.read_line (null)) != null) {
                var osrel_component = line.split ("=", 2);
                if (osrel_component.length == 2) {
                    osrel[osrel_component[0]] = osrel_component[1].replace ("\"", "");
                }
            }
            _os_name = osrel["NAME"];
            _support_url = osrel["SUPPORT_URL"];
            _logo_icon_name = osrel["LOGO"];
        } catch (Error e) {
            critical (e.message);
            _os_name = "elementary OS";
            _support_url = "https://elementary.io/support";
            _logo_icon_name = "distributor-logo";
        }
    }

    public static bool has_touchscreen () {
        weak Gdk.Display? display = Gdk.Display.get_default ();
        if (display != null) {
            var manager = display.get_device_manager ();
            GLib.List<weak Gdk.Device> devices = manager.list_devices (Gdk.DeviceType.SLAVE);
            foreach (weak Gdk.Device device in devices) {
                if (device.input_source == Gdk.InputSource.TOUCHSCREEN) {
                    return true;
                }
            }
        }

        return false;
    }

    public static Gee.LinkedList<Onboarding.MonitorMode> get_common_monitor_modes (Gee.LinkedList<Onboarding.Monitor> monitors) {
        var common_modes = new Gee.LinkedList<Onboarding.MonitorMode> ();
        double min_scale = get_min_compatible_scale (monitors);
        bool first_monitor = true;
        foreach (var monitor in monitors) {
            if (first_monitor) {
                foreach (var mode in monitor.modes) {
                    if (min_scale in mode.supported_scales) {
                        common_modes.add (mode);
                    }
                }

                first_monitor = false;
            } else {
                var to_remove = new Gee.LinkedList<Onboarding.MonitorMode> ();
                foreach (var mode_to_check in common_modes) {
                    bool mode_found = false;
                    foreach (var monitor_mode in monitor.modes) {
                        if (mode_to_check.width == monitor_mode.width &&
                            mode_to_check.height == monitor_mode.height) {
                            mode_found = true;
                            break;
                        }
                    }

                    if (mode_found == false) {
                        to_remove.add (mode_to_check);
                    }
                }

                common_modes.remove_all (to_remove);
            }
        }

        return common_modes;
    }

    public static double get_min_compatible_scale (Gee.LinkedList<Onboarding.Monitor> monitors) {
        double min_scale = double.MAX;
        foreach (var monitor in monitors) {
            min_scale = double.min (min_scale, monitor.get_max_scale ());
        }

        return min_scale;
    }
}
