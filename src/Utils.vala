/*-
 * Copyright (c) 2014-2019 elementary, Inc. (https://elementary.io)
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
}
