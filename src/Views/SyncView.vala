/*
 * Copyright © 2019–2020 elementary, Inc. (https://elementary.io)
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

public class Onboarding.SyncView : AbstractOnboardingView {
    public SyncView () {
        Object (
            view_name: "sync",
            description: _("Securely share purchases and payment methods between your devices. Enter an email address to log in or sign up."),
            icon_name: Utils.logo_icon_name,
            badge_name: "emblem-synchronized",
            title: _("elementary Sync")
        );
    }

    construct {
        var email_entry = new Gtk.Entry ();
        email_entry.placeholder_text = _("Email address");
        email_entry.width_request = 200;

        var next_button = new Gtk.Button.with_label (_("Next"));
        next_button.halign = Gtk.Align.END;
        next_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var privacy_link = new Gtk.LinkButton.with_label (
            "https://elementary.io/privacy",
            _("Privacy…")
        );
        privacy_link.halign = Gtk.Align.START;

        var email_grid = new Gtk.Grid ();
        email_grid.halign = Gtk.Align.CENTER;
        email_grid.row_spacing = 6;
        email_grid.attach (email_entry, 0, 0, 2);
        email_grid.attach (privacy_link, 0, 1);
        email_grid.attach (next_button, 1, 1);

        var instructions_spinner = new Gtk.Spinner ();
        instructions_spinner.start ();

        var instructions_grid = new Gtk.Grid ();
        instructions_grid.column_spacing = 6;
        instructions_grid.add (instructions_spinner);
        instructions_grid.add (new Gtk.Label (_("Check your email for a link to finish logging in.")));
        // TODO: Add a "use different email address"/back button?

        var success_grid = new Gtk.Grid ();
        success_grid.column_spacing = 6;
        success_grid.add (new Gtk.Label (_("You’re logged in!")));
        success_grid.add (new Gtk.Image.from_icon_name ("process-completed", Gtk.IconSize.BUTTON));

        // TODO: Add a failure state

        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        stack.transition_duration = 150;
        stack.add_named (email_grid, "email");
        stack.add_named (instructions_grid, "instructions");

        custom_bin.add (stack);

        next_button.clicked.connect (() => {
            stack.visible_child = instructions_grid;
        });
    }
}
