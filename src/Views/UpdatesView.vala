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

public class Onboarding.UpdatesView : AbstractOnboardingView {
    public UpdatesView () {
        Object (
            description: _("Firmware updates from device manufacturers can improve performance and fix critical security issues."),
            icon_name: "application-x-firmware",
            title: _("Stay Secure")
        );
    }

    construct {
        var fwupd_label = new Gtk.Label (_("Firmware updates:"));
        fwupd_label.halign = Gtk.Align.END;

        var fwupd_switch = new Gtk.Switch ();
        fwupd_switch.halign = Gtk.Align.START;

        string privacy_disclaimer = _("Updates are delivered via a third-party service. Diagnostics may be sent to device manufacturers according to the <a href='https://fwupd.org/privacy'>privacy policy</a>.");

        var privacy_label = new Gtk.Label ("<small>%s</small>".printf (privacy_disclaimer));
        privacy_label.justify = Gtk.Justification.CENTER;
        privacy_label.max_width_chars = 50;
        privacy_label.use_markup = true;
        privacy_label.wrap = true;
        privacy_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        custom_bin.attach (fwupd_label, 0, 0);
        custom_bin.attach (fwupd_switch, 1, 0);
        custom_bin.attach (privacy_label, 0, 1, 2);
    }
}

