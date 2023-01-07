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

    public class AnimatedChild : Gtk.Widget {
        private Gdk.Texture background;
        private Gdk.Texture touchpad;
        private Gdk.Texture fingers;
        private Gdk.Texture workspace;
        private Gdk.Texture desktop;
        private Gdk.Texture dock;

        private float finger_y = 140;
        private float scale = 1;
        private float dock_height = 30;

        private Adw.TimedAnimation animation;

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));
        }

        construct {
            background = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-background.svg");
            touchpad = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-touchpad.svg");
            fingers = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-fingers.png");
            workspace = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-workspace.svg");
            desktop = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-desktop.svg");
            dock = Gdk.Texture.from_resource ("/io/elementary/onboarding/gesture-demo-dock.png");

            animation = new Adw.TimedAnimation (this, 0, 1000, 3000, new Adw.CallbackAnimationTarget ((value) => {
                if (value <= 250) { // aims to end at 70
                    finger_y = 140.0f - ((float) (value / 1000) * 280);
                    scale = 1.0f - (float) (value / 1000);
                    dock_height = (value < 125) ? 30 - ((float) (value / 1000) * 240) : 0;
                } else if (value <= 500 && value > 250) {
                    finger_y = 65;
                } else if (value <= 750 && value > 500){
                    finger_y = 140.0f - ((float) ((750 - value) / 1000) * 280);
                    scale = 1.0f - (float) ((750 - value) / 1000);
                    dock_height = (value < 625) ? 0: 30 - ((float) ((750 - value) / 1000) * 240);
                } else {
                    finger_y = 140;
                }

                queue_draw ();
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

        protected override void snapshot (Gtk.Snapshot snapshot) {
            snapshot.append_texture (background, {{15, 0}, { 440, 500 }});
            snapshot.append_texture (background, {{460, 0}, { 440, 500 }});
            snapshot.append_texture (touchpad, {{30, 30}, { 410, 300 }});
            snapshot.append_texture (workspace, {{475, 90}, { 410, 307 }});

            snapshot.save ();
            snapshot.translate ({110, finger_y}); // 70 to 135
            fingers.snapshot (snapshot, 250, 300);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({
                475 + ((475 - (scale * 475)) / 2),
                90 + ((90 - (scale * 90)) / 2)
            });
            snapshot.scale (scale, scale);
            desktop.snapshot (snapshot, 410, 307);
            snapshot.restore ();

            snapshot.save ();
            snapshot.translate ({550, 310});
            dock.snapshot (snapshot, 250, dock_height);
            snapshot.restore ();
        }

        ~AnimatedChild () {
            while (get_last_child () != null) {
                get_last_child ().unparent ();
            }
        }
    }
}
