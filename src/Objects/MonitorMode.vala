/*
 * Copyright © 2018–2020 elementary, Inc.
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

public class Onboarding.MonitorMode : GLib.Object {
    public string id { get; set; }
    public int width { get; set; }
    public int height { get; set; }
    public double frequency { get; set; }
    public double preferred_scale { get; set; }
    public double[] supported_scales { get; set; }
    public bool is_preferred { get; set; }
    public bool is_current { get; set; }

    private string? resolution_cache = null;
    public unowned string get_resolution () {
        if (resolution_cache == null) {
            var aspect = make_aspect_string ();
            if (aspect != null) {
                resolution_cache = "%u × %u (%s)".printf (width, height, aspect);
            } else {
                resolution_cache = "%u × %u".printf (width, height);
            }
        }

        return resolution_cache;
    }

    private string? make_aspect_string () {
        int ratio;
        string? aspect = null;

        if (width == 0 || height == 0)
            return null;

        if (width > height) {
            ratio = width * 10 / height;
        } else {
            ratio = height * 10 / width;
        }

        switch (ratio) {
            case 13:
                aspect = "4∶3";
                break;
            case 16:
                aspect = "16∶10";
                break;
            case 17:
                aspect = "16∶9";
                break;
            case 23:
                aspect = "21∶9";
                break;
            case 12:
                aspect = "5∶4";
                break;
                /* This catches 1.5625 as well (1600x1024) when maybe it shouldn't. */
            case 15:
                aspect = "3∶2";
                break;
            case 18:
                aspect = "9∶5";
                break;
            case 10:
                aspect = "1∶1";
                break;
        }

        return aspect;
    }
}
