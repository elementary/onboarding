/*
 * Copyright (c) 2017-2019 elementary, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Onboarding.PageChecker : Gtk.Button {
    public const double MIN_OPACITY = 0.4;

    public unowned Adw.Carousel carousel { get; construct; }
    public unowned AbstractOnboardingView page { get; construct; }

    private int page_number;

    public PageChecker (Adw.Carousel carousel, AbstractOnboardingView page) {
        Object (carousel: carousel, page: page);
    }

    private void update_opacity () {
        double progress = double.max (1 - (carousel.position - page_number).abs (), 0);

        opacity = MIN_OPACITY + (1 - MIN_OPACITY) * progress;
    }

    construct {
        icon_name = "pager-checked-symbolic";

        tooltip_text = page.title;
        for (var item_count = 0; item_count < carousel.get_n_pages (); item_count++) {
            if (carousel.get_nth_page (item_count) == page) {
                page_number = item_count;
                break;
            }
        }

        update_opacity ();

        clicked.connect (() => {
            carousel.scroll_to (page);
        });

        carousel.notify["position"].connect (() => {
            update_opacity ();
        });

        page.destroy.connect (() => {
            destroy ();
        });
    }
}
