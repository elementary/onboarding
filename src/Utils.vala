// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2014-2017 elementary LLC. (https://elementary.io)
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

namespace Utils {
    private static string os_pretty_name;
    private static string get_pretty_name () {
        if (os_pretty_name == null) {
            os_pretty_name = _("Operating System");
            const string ETC_OS_RELEASE = "/etc/os-release";

            try {
                var data_stream = new DataInputStream (File.new_for_path (ETC_OS_RELEASE).read ());

                string line;
                while ((line = data_stream.read_line (null)) != null) {
                    var osrel_component = line.split ("=", 2);
                    if (osrel_component.length == 2 && osrel_component[0] == "PRETTY_NAME") {
                        os_pretty_name = osrel_component[1].replace ("\"", "");
                        break;
                    }
                }
            } catch (Error e) {
                warning ("Couldn't read os-release file: %s", e.message);
            }
        }
        return os_pretty_name;
    }
}
