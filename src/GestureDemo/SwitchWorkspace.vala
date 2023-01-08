public class Onboarding.SwitchWorkspace : Gtk.Box {
    construct {
        orientation = Gtk.Orientation.VERTICAL;

        var label = new Gtk.Label ("Switch Workspaces") {
            halign = Gtk.Align.START,
            valign = Gtk.Align.START,
            hexpand = true,
            margin_top = 20,
            margin_start = 20
        };
        label.add_css_class (Granite.STYLE_CLASS_H1_LABEL);

        var animated_child = new AnimatedChild () {
            hexpand = true,
            vexpand = true,
            margin_start = 10,
            margin_top = 10,
            margin_bottom = 10,
            margin_end = 10
        };

        append (label);
        append (animated_child);
        vexpand = true;
    }

    private class AnimatedChild : Gtk.Widget {
        private Gdk.Texture background;
        private Gdk.Texture touchpad;
        private Gdk.Texture fingers;
        private Gdk.Texture workspace;
        private Gdk.Texture desktop;
        private Gdk.Texture desktop_two;
        private Gdk.Texture dock;

        private float finger_x = 140;
        private float scale = 1;
        private float dock_height = 30;

        private Adw.TimedAnimation animation;

        private const float LEFTMOST_FINGER_POSITION = 75;
        private const float RIGHTMOST_FINGER_POSITION = 150;
        private const float DOCK_MAX_HEIGHT = 30;
        private const float BACKGROUND_WIDTH = 440;
        private const float BACKGROUND_HEIGHT = 500;

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            background = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-background.svg");
            touchpad = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-touchpad.svg");
            fingers = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-fingers.png");
            workspace = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-workspace.svg");
            desktop = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-desktop.svg");
            desktop_two = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-desktop-two.svg");
            dock = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-dock.png");

            animation = new Adw.TimedAnimation (this, 0, 1000, 4000, new Adw.CallbackAnimationTarget ((value) => {
                set_progress ((float) value);
            })) {
                easing = Adw.Easing.LINEAR
            };

            this.map.connect (play_animation);
            animation.done.connect (play_animation);
            this.unmap.connect (() => {
                animation.done.disconnect (play_animation);
            });
        }

        private void play_animation () {
            animation.play ();
        }

        private void set_progress (float val) {
            if (val <= 250) { // We show workspace for 1 second
                finger_x = RIGHTMOST_FINGER_POSITION - ((val / 1000) * (LEFTMOST_FINGER_POSITION * 4));
                scale = 1.0f - (val / 250);

                if (val < 64.5) { // we hide the dock faster
                    dock_height = DOCK_MAX_HEIGHT - ((val / 1000) * (DOCK_MAX_HEIGHT * 16));
                } else {
                    dock_height = 0;
                }
            } else if (val <= 500 && val > 250) { // We stop for another second
                finger_x = LEFTMOST_FINGER_POSITION;
            } else if (val <= 750 && val > 500) { // We hide workspace for 1 second
                finger_x = RIGHTMOST_FINGER_POSITION - (((750 - val) / 1000) * (LEFTMOST_FINGER_POSITION * 4));
                scale = 1.0f - ((750 - val) / 250);

                if (val < 564.5) {
                    dock_height = 0;
                } else {
                    dock_height = DOCK_MAX_HEIGHT - (((750 - val) / 1000) * (DOCK_MAX_HEIGHT * 16));
                }
            } else { // We pause
                finger_x = RIGHTMOST_FINGER_POSITION;
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

            snapshot.append_texture (touchpad, {{30, 100}, { 410, 300 }});
            snapshot.append_texture (workspace, {{475, 100}, { 410, 300 }});

            snapshot.save ();
            snapshot.translate ({finger_x, 145 }); // 70 to 160
            fingers.snapshot (snapshot, 250, 300);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({ 475, 100});
            desktop.snapshot (snapshot, 410 - (scale * 410), 300);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({ 475 + (410 - (scale * 410)), 100});
            desktop_two.snapshot (snapshot, 410 * scale, 300);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({ 560, 330 });
            dock.snapshot (snapshot, 250 - (scale * 250), 30);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({ 560 + (250 - (scale * 250)), 330 });
            dock.snapshot (snapshot, 250 * scale, 30);
            snapshot.restore ();
        }

        ~AnimatedChild () {
            while (get_last_child () != null) {
                get_last_child ().unparent ();
            }
        }
    }
}
