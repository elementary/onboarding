/*-
 * Copyright 2020 elementary, Inc. (https://elementary.io)
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

public class Onboarding.StyleView : AbstractOnboardingView {
    private const string INTERFACE_SCHEMA = "org.gnome.desktop.interface";
    private const string STYLESHEET_KEY = "gtk-theme";
    private const string STYLESHEET_PREFIX = "io.elementary.stylesheet.";

    private Pantheon.AccountsService? pantheon_act = null;

    private enum AccentColor {
        NO_PREFERENCE,
        RED,
        ORANGE,
        YELLOW,
        GREEN,
        MINT,
        BLUE,
        PURPLE,
        PINK,
        BROWN,
        GRAY;

        public string to_string () {
            switch (this) {
                case RED:
                    return "strawberry";
                case ORANGE:
                    return "orange";
                case YELLOW:
                    return "banana";
                case GREEN:
                    return "lime";
                case MINT:
                    return "mint";
                case BLUE:
                    return "blueberry";
                case PURPLE:
                    return "grape";
                case PINK:
                    return "bubblegum";
                case BROWN:
                    return "cocoa";
                case GRAY:
                    return "slate";
                default:
                    return "auto";
            }
        }
    }

    public StyleView () {
        Object (
            view_name: "style",
            description: _("Make it your own by choosing a visual style and accent color. Apps may override these with their own look."),
            icon_name: "preferences-desktop-theme",
            title: _("Choose Your Look")
        );
    }

    construct {
        string? user_path = null;
        try {
            FDO.Accounts? accounts_service = GLib.Bus.get_proxy_sync (
                GLib.BusType.SYSTEM,
               "org.freedesktop.Accounts",
               "/org/freedesktop/Accounts"
            );

            user_path = accounts_service.find_user_by_name (GLib.Environment.get_user_name ());
        } catch (Error e) {
            critical (e.message);
        }

        if (user_path != null) {
            try {
                pantheon_act = GLib.Bus.get_proxy_sync (
                    GLib.BusType.SYSTEM,
                    "org.freedesktop.Accounts",
                    user_path,
                    GLib.DBusProxyFlags.GET_INVALIDATED_PROPERTIES
                );
            } catch (Error e) {
                warning ("Unable to get AccountsService proxy, color scheme preference may be incorrect");
            }
        }

        var default_preview = new DesktopPreview ("default");

        var prefer_default_radio = new Gtk.CheckButton ();
        prefer_default_radio.add_css_class ("image-button");

        var prefer_default_grid = new Gtk.Grid ();
        prefer_default_grid.attach (default_preview, 0, 0);
        prefer_default_grid.attach (
            new Gtk.Label (_("Default")) {
                mnemonic_widget = prefer_default_radio
            }, 0, 1
        );
        prefer_default_grid.set_parent (prefer_default_radio);

        var dark_preview = new DesktopPreview ("dark");

        var prefer_dark_radio = new Gtk.CheckButton () {
            group = prefer_default_radio
        };
        prefer_dark_radio.add_css_class ("image-button");

        var prefer_dark_grid = new Gtk.Grid ();
        prefer_dark_grid.attach (dark_preview, 0, 0);
        prefer_dark_grid.attach (
            new Gtk.Label (_("Dark")) {
                mnemonic_widget = prefer_dark_radio
            }, 0, 1
        );
        prefer_dark_grid.set_parent (prefer_dark_radio);

        var scheduled_preview = new DesktopPreview ("scheduled");

        var prefer_scheduled_radio = new Gtk.CheckButton () {
            group = prefer_default_radio
        };
        prefer_scheduled_radio.add_css_class ("image-button");

        var prefer_scheduled_grid = new Gtk.Grid ();
        prefer_scheduled_grid.attach (scheduled_preview, 0, 0);
        prefer_scheduled_grid.attach (
            new Gtk.Label (_("Sunset to Sunrise")) {
                mnemonic_widget = prefer_scheduled_radio
            }, 0, 1
        );
        prefer_scheduled_grid.set_parent (prefer_scheduled_radio);

        var color_scheme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        color_scheme_box.append (prefer_default_radio);
        color_scheme_box.append (prefer_dark_radio);
        color_scheme_box.append (prefer_scheduled_radio);

        var blueberry_button = new PrefersAccentColorButton (pantheon_act, AccentColor.BLUE) {
            tooltip_text = _("Blueberry")
        };

        var mint_button = new PrefersAccentColorButton (pantheon_act, AccentColor.MINT) {
            group = blueberry_button,
            tooltip_text = _("Mint")
        };

        var lime_button = new PrefersAccentColorButton (pantheon_act, AccentColor.GREEN) {
            group = blueberry_button,
            tooltip_text = _("Lime")
        };

        var banana_button = new PrefersAccentColorButton (pantheon_act, AccentColor.YELLOW) {
            group = blueberry_button,
            tooltip_text = _("Banana")
        };

        var orange_button = new PrefersAccentColorButton (pantheon_act, AccentColor.ORANGE) {
            group = blueberry_button,
            tooltip_text = _("Orange")
        };

        var strawberry_button = new PrefersAccentColorButton (pantheon_act, AccentColor.RED) {
            group = blueberry_button,
            tooltip_text = _("Strawberry")
        };

        var bubblegum_button = new PrefersAccentColorButton (pantheon_act, AccentColor.PINK) {
            group = blueberry_button,
            tooltip_text = _("Bubblegum")
        };

        var grape_button = new PrefersAccentColorButton (pantheon_act, AccentColor.PURPLE) {
            group = blueberry_button,
            tooltip_text = _("Grape")
        };

        var cocoa_button = new PrefersAccentColorButton (pantheon_act, AccentColor.BROWN) {
            group = blueberry_button,
            tooltip_text = _("Cocoa")
        };

        var slate_button = new PrefersAccentColorButton (pantheon_act, AccentColor.GRAY) {
            group = blueberry_button,
            tooltip_text = _("Slate")
        };

        var auto_button = new PrefersAccentColorButton (pantheon_act, AccentColor.NO_PREFERENCE) {
            group = blueberry_button,
            tooltip_text = _("Automatic based on wallpaper")
        };

        var accent_box= new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.CENTER
        };
        accent_box.append (blueberry_button);
        accent_box.append (mint_button);
        accent_box.append (lime_button);
        accent_box.append (banana_button);
        accent_box.append (orange_button);
        accent_box.append (strawberry_button);
        accent_box.append (bubblegum_button);
        accent_box.append (grape_button);
        accent_box.append (cocoa_button);
        accent_box.append (slate_button);
        accent_box.append (auto_button);

        custom_bin.append (color_scheme_box);
        custom_bin.append (accent_box);

        var settings = new GLib.Settings ("io.elementary.settings-daemon.prefers-color-scheme");

        if (settings.get_string ("prefer-dark-schedule") == "sunset-to-sunrise") {
            prefer_scheduled_radio.active = true;
        } else if (pantheon_act.prefers_color_scheme == Granite.Settings.ColorScheme.DARK) {
            prefer_dark_radio.active = true;
        } else {
            prefer_default_radio.active = true;
        }

        prefer_default_radio.toggled.connect (() => {
            pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.NO_PREFERENCE;
            settings.set_string ("prefer-dark-schedule", "disabled");
        });

        prefer_dark_radio.toggled.connect (() => {
            pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.DARK;
            settings.set_string ("prefer-dark-schedule", "disabled");
        });

        prefer_scheduled_radio.toggled.connect (() => {
            settings.set_string ("prefer-dark-schedule", "sunset-to-sunrise");
        });
    }

    private class DesktopPreview : Gtk.Widget {
        private static Settings pantheon_settings;
        private static Settings gnome_settings;
        private Gtk.Picture picture;

        class construct {
            set_css_name ("desktop-preview");
        }

        static construct {
            set_layout_manager_type (typeof (Gtk.BinLayout));

            pantheon_settings = new Settings ("io.elementary.desktop.background");
            gnome_settings = new Settings ("org.gnome.desktop.background");
        }

        public DesktopPreview (string style_class) {
            picture = new Gtk.Picture () {
                content_fit = COVER
            };

            var dock = new Gtk.Box (HORIZONTAL, 0) {
                halign = CENTER,
                valign = END
            };
            dock.add_css_class ("dock");

            var window_back = new Gtk.Box (HORIZONTAL, 0) {
                halign = CENTER,
                valign = CENTER
            };
            window_back.add_css_class ("window");
            window_back.add_css_class ("back");

            var window_front = new Gtk.Box (HORIZONTAL, 0) {
                halign = CENTER,
                valign = CENTER
            };
            window_front.add_css_class ("window");
            window_front.add_css_class ("front");

            var shell = new Gtk.Box (HORIZONTAL, 0);
            shell.add_css_class ("shell");

            var overlay = new Gtk.Overlay () {
                child = picture,
                overflow = HIDDEN
            };
            overlay.add_overlay (shell);
            overlay.add_overlay (dock);
            overlay.add_overlay (window_back);
            overlay.add_overlay (window_front);
            overlay.add_css_class (Granite.STYLE_CLASS_CARD);
            overlay.add_css_class (Granite.STYLE_CLASS_ROUNDED);

            var frame = new Gtk.AspectFrame (0.5f, 0.5f, (float) 4 / 3, false) {
                child = overlay
            };
            frame.set_parent (this);

            add_css_class (style_class);

            update_picture ();
            gnome_settings.changed.connect (update_picture);

            if (has_css_class ("dark")) {
                update_dim ();
                pantheon_settings.changed.connect (update_dim);
            }

            realize.connect (() => {
                var monitor = Gdk.Display.get_default ().get_monitor_at_surface (
                    (((Gtk.Application) Application.get_default ()).active_window).get_surface ()
                );

                frame.ratio = (float) monitor.geometry.width / monitor.geometry.height;
            });
        }

        private void update_dim () {
            if (pantheon_settings.get_boolean ("dim-wallpaper-in-dark-style")) {
                add_css_class ("dim");
            } else {
                remove_css_class ("dim");
            }
        }

        private void update_picture () {
            if (gnome_settings.get_string ("picture-options") == "none") {
                Gdk.RGBA rgba = {};
                rgba.parse (gnome_settings.get_string ("primary-color"));

                var pixbuf = new Gdk.Pixbuf (RGB, false, 8, 500, 500);
                pixbuf.fill (rgba_to_pixel (rgba));

                picture.paintable = Gdk.Texture.for_pixbuf (pixbuf);
                return;
            }

            if (has_css_class ("dark")) {
                var dark_file = File.new_for_uri (
                    gnome_settings.get_string ("picture-uri-dark")
                );

                if (dark_file.query_exists ()) {
                    picture.file = dark_file;
                    return;
                }
            }

            picture.file = File.new_for_uri (
                gnome_settings.get_string ("picture-uri")
            );
        }

        // Borrowed from
        // https://github.com/GNOME/california/blob/master/src/util/util-gfx.vala
        private static uint32 rgba_to_pixel (Gdk.RGBA rgba) {
            return (uint32) fp_to_uint8 (rgba.red) << 24
                | (uint32) fp_to_uint8 (rgba.green) << 16
                | (uint32) fp_to_uint8 (rgba.blue) << 8
                | (uint32) fp_to_uint8 (rgba.alpha);
        }

        private static uint8 fp_to_uint8 (double value) {
            return (uint8) (value * uint8.MAX);
        }

        ~DesktopPreview () {
            get_first_child ().unparent ();
        }
    }

    private class PrefersAccentColorButton : Gtk.CheckButton {
        public AccentColor color { get; construct; }
        public Pantheon.AccountsService? pantheon_act { get; construct; default = null; }

        private static GLib.Settings interface_settings;

        public PrefersAccentColorButton (Pantheon.AccountsService? pantheon_act, AccentColor color) {
            Object (
                pantheon_act: pantheon_act,
                color: color
            );
        }

        static construct {
            interface_settings = new GLib.Settings (INTERFACE_SCHEMA);
        }

        construct {
            add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);
            add_css_class (color.to_string ());

            realize.connect (() => {
                active = color == pantheon_act.prefers_accent_color;

                toggled.connect (() => {
                    if (color != AccentColor.NO_PREFERENCE) {
                        interface_settings.set_string (
                            STYLESHEET_KEY,
                            STYLESHEET_PREFIX + color.to_string ()
                        );
                    }

                    if (((GLib.DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
                        pantheon_act.prefers_accent_color = color;
                    }
                });
            });
        }
    }
}
