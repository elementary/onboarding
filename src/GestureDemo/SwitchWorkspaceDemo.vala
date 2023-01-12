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

public class Onboarding.SwitchWorkspaceDemo : Gtk.Box {
    public SwitchingAnimatedChild animated_child { get; set; }
    construct {
        orientation = Gtk.Orientation.VERTICAL;

        var label = new Granite.Placeholder ("Switch to Workspace") {
            description = "Swipe horizontally with your 3 fingers to switch between workspaces",
            icon = new ThemedIcon ("preferences-desktop-wallpaper"),
            halign = Gtk.Align.START,
            valign = Gtk.Align.START
        };

        animated_child = new SwitchingAnimatedChild () {
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

    public class SwitchingAnimatedChild : Gtk.Widget {
        private Gdk.Texture background;
        private Gdk.Texture touchpad;
        private Gdk.Texture fingers;
        private Gdk.Texture multitasking;
        private Gdk.Texture workspace;
        private Gdk.Texture workspace_two;
        private Gdk.Texture dock;

        private float finger_x = 140;
        private float scale = 1;

        private Adw.TimedAnimation animation;

        private const float LEFTMOST_FINGER_POSITION = 75;
        private const float RIGHTMOST_FINGER_POSITION = 150;
        private const float DOCK_MAX_HEIGHT = 25;
        private const float BACKGROUND_WIDTH = 440;
        private const float BACKGROUND_HEIGHT = 500;
        private const float MULTITASKING_WIDTH = 410;
        private const float MULTITASKING_HEIGHT = 300;

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            background = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-background.svg");
            touchpad = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-touchpad.svg");
            fingers = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-fingers.png");
            multitasking = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-multitasking.svg");
            workspace = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-workspace.svg");
            workspace_two = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-workspace-two.svg");
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
            if (val <= 250) { // We switch for 1 second
                finger_x = LEFTMOST_FINGER_POSITION + ((val / 1000) * (LEFTMOST_FINGER_POSITION * 4));
                scale = 1.0f - (val / 250);
            } else if (val <= 500 && val > 250) { // We stop for another second
                finger_x = RIGHTMOST_FINGER_POSITION;
            } else if (val <= 750 && val > 500) { // We hide workspace for 1 second
                finger_x = LEFTMOST_FINGER_POSITION + (((750 - val) / 1000) * (LEFTMOST_FINGER_POSITION * 4));
                scale = 1.0f - ((750 - val) / 250);
            } else { // We pause
                finger_x = LEFTMOST_FINGER_POSITION;
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
                {30, 100},
                { MULTITASKING_WIDTH, MULTITASKING_HEIGHT }
            });
            snapshot.append_texture (multitasking, {
                {475, 100},
                { MULTITASKING_WIDTH, MULTITASKING_HEIGHT }
            });
            // 475 because 15 margin, 10 bg separator and 15 margin from col2 bg.

            snapshot.save (); // Finger Animation
            snapshot.translate ({finger_x, 145 }); // finger posy from 70 to 160 to simulate swipe up
            fingers.snapshot (snapshot, 250, 300);
            snapshot.restore ();

            snapshot.save (); // Switching FROM workspace animation
            snapshot.translate ({ 475, 100});
            workspace.snapshot (snapshot, 410 - (scale * 410), 300); // we subtract width until workspace1 disappears
            snapshot.restore ();

            snapshot.save (); // Switching TO workspace animation
            snapshot.translate ({ 475 + (410 - (scale * 410)), 100}); // we add desired xpos to w1 width
            workspace_two.snapshot (snapshot, 410 * scale, 300); // which diminishes slowly so w2 will replace it.
            snapshot.restore ();

            snapshot.save (); // Switching FROM dock animation
            snapshot.translate ({ 560 - ((560 - 475) * scale), 340 }); // we subtract width until dock1 disappers
            dock.snapshot (snapshot, 250 - (scale * 250), DOCK_MAX_HEIGHT); // at the origin of w1.
            snapshot.restore ();

            snapshot.save (); // Switching TO dock animation
            snapshot.translate ({ 885 - ((885 - 560) * scale), 340 }); // we subtract from the highest x of w2
            dock.snapshot (snapshot, 250 * scale, DOCK_MAX_HEIGHT); // to get origin and end at 560 where dock starts.
            snapshot.restore ();
        }
    }
}
