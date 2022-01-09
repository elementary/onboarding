// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
//
//  Copyright (C) 2011-2012 Giulio Collura
//  Copyright (C) 2014 Corentin Noël <tintou@mailoo.org>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


public class Onboarding.Switcher : Gtk.Box {
    public Adw.Carousel carousel { get; construct; }
    private bool has_enough_children {
        get {
            return observe_children.get_n_items () > 1;
        }
    }

    construct {
        show_all ();

        for (var child_index = 0; child_index < carousel.get_n_pages (); child_index++) {
            var child = carousel.get_nth_page (child_index);
            add_child (child);
        }

        // carousel.add.connect_after (add_child);
    }

    public Switcher (Adw.Carousel carousel) {
        Object (
            carousel: carousel,
            halign: Gtk.Align.CENTER,
            can_focus: false,
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 0
        );
    }

    private void add_child (Gtk.Widget widget) {
        assert (widget is AbstractOnboardingView);

        var button = new PageChecker (carousel, (AbstractOnboardingView) widget);
        pack_start (button, false, false);
    }

    public override void show () {
        base.show ();
        if (!has_enough_children) {
            hide ();
        }
    }

    public override void present () {
        if (!has_enough_children) {
            hide ();
        }

        base.present ();
    }
}
