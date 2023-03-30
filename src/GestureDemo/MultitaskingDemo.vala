/*
 * Copyright 2020-2023 elementary, Inc. (https://elementary.io)
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
 * Authored by: Owen David Malicsi <owendavidmalicsi@gmail.com>
 */

public class Onboarding.MultitaskingDemo : Gtk.Box {
    public MultitaskingAnimatedChild animated_child { get; set; }
    construct {
        orientation = Gtk.Orientation.VERTICAL;

        var label = new Granite.Placeholder ("Multitasking View") {
            description = "Swipe vertically with your 3 fingers to show or hide multitasking view",
            icon = new ThemedIcon ("preferences-desktop-workspaces"),
            halign = Gtk.Align.START,
            valign = Gtk.Align.START,
        };

        animated_child = new MultitaskingAnimatedChild () {
            hexpand = true,
            vexpand = true,
            margin_start = 10,
            margin_bottom = 10,
            margin_end = 10
        };

        append (label);
        append (animated_child);
        vexpand = true;
    }

    public class MultitaskingAnimatedChild : Gtk.Widget {
        private Gdk.Texture background;
        private Gdk.Texture touchpad;
        private Gdk.Texture fingers;
        private Gdk.Texture multitasking;
        private Gdk.Texture workspace;
        private Gdk.Texture dock;

        private float finger_y = 135;
        private float scale = 1;
        private float dock_height = 25;

        private const float LOWEST_FINGER_POSITION = 140;
        private const float HIGHEST_FINGER_POSITION = 70;
        private const float DOCK_MAX_HEIGHT = 25;
        private const float BACKGROUND_WIDTH = 440;
        private const float BACKGROUND_HEIGHT = 500;
        private const float MULTITASKING_WIDTH = 410;
        private const float MULTITASKING_HEIGHT = 300;
        private const float DOCK_STARTING_POSX = 560;

        private Adw.TimedAnimation animation;

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            background = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-background.svg");
            touchpad = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-touchpad.svg");
            fingers = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-fingers.png");
            multitasking = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-multitasking.svg");
            workspace = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-workspace.svg");
            dock = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-dock.png");

            animation = new Adw.TimedAnimation (this, 0, 1000, 4000, new Adw.CallbackAnimationTarget ((value) => {
                set_progress ((float) value);
            })) {
                easing = Adw.Easing.LINEAR
            };

            animation.done.connect (play_animation);
            this.unmap.connect (() => {
                animation.done.disconnect (play_animation);
            });
        }

        public void play_animation () {
            animation.play ();
        }

        private void set_progress (float val) {
            if (val <= 250) { // We show workspace for 1 second
                finger_y = LOWEST_FINGER_POSITION - ((val / 1000) * (HIGHEST_FINGER_POSITION * 4));
                scale = 1.0f - (val / 1000);

                if (val < 64.5) { // we hide the dock faster
                    dock_height = DOCK_MAX_HEIGHT - ((val / 1000) * (DOCK_MAX_HEIGHT * 16));
                } else {
                    dock_height = 0;
                }
            } else if (val <= 500 && val > 250) { // We stop for another second
                finger_y = HIGHEST_FINGER_POSITION;
            } else if (val <= 750 && val > 500) { // We hide workspace for 1 second
                finger_y = LOWEST_FINGER_POSITION - (((750 - val) / 1000) * (HIGHEST_FINGER_POSITION * 4));
                scale = 1.0f - ((750 - val) / 1000);

                if (val < 564.5) {
                    dock_height = 0;
                } else {
                    dock_height = DOCK_MAX_HEIGHT - (((750 - val) / 1000) * (DOCK_MAX_HEIGHT * 16));
                }
            } else { // We pause
                finger_y = LOWEST_FINGER_POSITION;
            }

            queue_draw ();
        }

        protected override void snapshot (Gtk.Snapshot snapshot) {
            snapshot.append_texture (background, {
                { 15, 0},
                { BACKGROUND_WIDTH, BACKGROUND_HEIGHT }
            });

            snapshot.append_texture (background, {
                { 460, 0},
                { BACKGROUND_WIDTH, BACKGROUND_HEIGHT }
            });

            // 30 because 15 margin from background with posx 15
            snapshot.append_texture (touchpad, {
                {30, 30},
                { MULTITASKING_WIDTH, MULTITASKING_HEIGHT }
            });
            snapshot.append_texture (multitasking, {
                {475, 100},
                { MULTITASKING_WIDTH, MULTITASKING_HEIGHT }
            });
            // 475 because 15 margin, 10 bg separator and 15 margin from col2 bg.

            snapshot.save (); // Finger Animation
            snapshot.translate ({110, finger_y}); // finger posy from 70 to 140 to simulate swipe up
            fingers.snapshot (snapshot, 250, 300);
            snapshot.restore ();

            snapshot.save (); // workspace zooming out animation
            snapshot.translate ({ // Position coordinates are increased by a fraction of the size per interval.
                475 + ((410 - (scale * 410)) / 2),
                100 + ((300 - (scale * 300)) / 2)
            }); // divide by 2 so we will be in the center.
            snapshot.scale (scale, scale);
            workspace.snapshot (snapshot, 410, 300);
            snapshot.restore ();

            snapshot.save (); // hide dock animation
            snapshot.translate ({ DOCK_STARTING_POSX, 340 + (25 - dock_height) });
            dock.snapshot (snapshot, 250, dock_height);
            snapshot.restore ();
        }
    }
}
