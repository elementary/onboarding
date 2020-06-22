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

public class Onboarding.Switcher : Gtk.Grid {
    public Hdy.Carousel carousel { get; construct; }
    private bool has_enough_children {
        get {
            return get_children ().length () > 1;
        }
    }

    public signal void on_carousel_changed ();

    construct {
        show_all ();

        foreach (var child in carousel.get_children ()) {
            add_child (child);
        }

        carousel.add.connect_after (add_child);
    }

    public Switcher (Hdy.Carousel carousel) {
        Object (
            carousel: carousel,
            halign: Gtk.Align.CENTER,
            orientation: Gtk.Orientation.HORIZONTAL,
            can_focus: false
        );
    }

    private void add_child (Gtk.Widget widget) {
        assert (widget is AbstractOnboardingView);

        var button = new PageChecker (carousel, (AbstractOnboardingView) widget);
        add (button);
    }

    public override void show () {
        base.show ();
        if (!has_enough_children) {
            hide ();
        }
    }

    public override void show_all () {
        base.show_all ();
        if (!has_enough_children) {
            hide ();
        }
    }
}
