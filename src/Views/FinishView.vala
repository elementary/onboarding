/*-
 * Copyright (c) 2019 elementary, Inc. (https://elementary.io)
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

public class Onboarding.FinishView : AbstractOnboardingView {
    public FinishView () {
        Object (
            description: _("Thanks for choosing %s!").printf (Utils.get_os_name ()),
            icon_name: "process-completed",
            title: _("All Done!")
        );
    }

    construct {
        string support_url;

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

            support_url = osrel["SUPPORT_URL"];
        } catch (Error e) {
            critical (e.message);
            support_url = "https://elementary.io/support";
        }

        var support_link = new Gtk.LinkButton.with_label (support_url, _("Get Support"));

        custom_bin.add (support_link);
    }
}
