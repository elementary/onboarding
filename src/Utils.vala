/*-
 * Copyright 2014-2021 elementary, Inc. (https://elementary.io)
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
 *              Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class Utils {
    private static string _documentation_url;
    public static string documentation_url {
        get {
            if (_documentation_url == null) {
                _documentation_url = Environment.get_os_info (GLib.OsInfoKey.DOCUMENTATION_URL);

                if (_documentation_url == null) {
                    _documentation_url = "https://elementary.io/docs/learning-the-basics";
                }
            }

            return _documentation_url;
        }
    }

    private static string _support_url;
    public static string support_url {
        get {
            if (_support_url == null) {
                _support_url = Environment.get_os_info (GLib.OsInfoKey.SUPPORT_URL);

                if (_support_url == null) {
                    _support_url = "https://elementary.io/support";
                }
            }

            return _support_url;
        }
    }

    private static string _os_name;
    public static string os_name {
        get {
            if (_os_name == null) {
                _os_name = Environment.get_os_info (GLib.OsInfoKey.NAME);

                if (_os_name == null) {
                    _os_name = "elementary OS";
                }
            }

            return _os_name;
        }
    }

    private static string _logo_icon_name;
    public static string logo_icon_name {
        get {
            if (_logo_icon_name == null) {
                _logo_icon_name = Environment.get_os_info ("LOGO");

                if (_logo_icon_name == null) {
                    _logo_icon_name = "distributor-logo";
                }
            }

            return _logo_icon_name;
        }
    }

    public static bool is_running_in_virtual_machine {
        get {
            try {
                string contents;
                if (FileUtils.get_contents ("/proc/cpuinfo", out contents)) {
                    var regex = new Regex ("flags\\s*:.*(hypervisor)");
                    return regex.match (contents);
                }
            } catch (Error e) {
                warning ("Could not detect if running in Virtual Machine: %s", e.message);
            }

            return false;
        }
    }
}
