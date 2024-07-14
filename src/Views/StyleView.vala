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

        var prefer_default_card = new Gtk.Grid ();
        prefer_default_card.add_css_class (Granite.STYLE_CLASS_CARD);
        prefer_default_card.add_css_class (Granite.STYLE_CLASS_ROUNDED);
        prefer_default_card.add_css_class ("prefer-default");

        var prefer_default_radio = new Gtk.CheckButton ();
        prefer_default_radio.add_css_class ("image-button");

        var prefer_default_grid = new Gtk.Grid ();
        prefer_default_grid.attach (prefer_default_card, 0, 0);
        prefer_default_grid.attach (
            new Gtk.Label (_("Default")) {
                mnemonic_widget = prefer_default_radio
            }, 0, 1
        );
        prefer_default_grid.set_parent (prefer_default_radio);

        var prefer_dark_card = new Gtk.Grid ();
        prefer_dark_card.add_css_class (Granite.STYLE_CLASS_CARD);
        prefer_dark_card.add_css_class (Granite.STYLE_CLASS_ROUNDED);
        prefer_dark_card.add_css_class ("prefer-dark");

        var prefer_dark_radio = new Gtk.CheckButton () {
            group = prefer_default_radio
        };
        prefer_dark_radio.add_css_class ("image-button");

        var prefer_dark_grid = new Gtk.Grid ();
        prefer_dark_grid.attach (prefer_dark_card, 0, 0);
        prefer_dark_grid.attach (
            new Gtk.Label (_("Dark")) {
                mnemonic_widget = prefer_dark_radio
            }, 0, 1
        );
        prefer_dark_grid.set_parent (prefer_dark_radio);

        var prefer_scheduled_card = new Gtk.Grid ();
        prefer_scheduled_card.add_css_class (Granite.STYLE_CLASS_CARD);
        prefer_scheduled_card.add_css_class (Granite.STYLE_CLASS_ROUNDED);
        prefer_scheduled_card.add_css_class ("prefer-scheduled");

        var prefer_scheduled_radio = new Gtk.CheckButton () {
            group = prefer_default_radio
        };
        prefer_scheduled_radio.add_css_class ("image-button");

        var prefer_scheduled_grid = new Gtk.Grid ();
        prefer_scheduled_grid.attach (prefer_scheduled_card, 0, 0);
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

        var background_settings = new Settings ("org.gnome.desktop.background");

        var background_uri = background_settings.get_string ("picture-uri");
        var file = File.new_for_uri (background_uri);
        if (file.query_exists ()) {
            var background_provider = new Gtk.CssProvider ();
            background_provider.load_from_data (
                """
                .prefer-default {
                    background-image:
                        url("resource:///io/elementary/onboarding/appearance-default.svg"),
                        url("%s");
                }

                .prefer-dark {
                    background-size: 86px 64px, cover, cover;
                    background-image:
                        url("resource:///io/elementary/onboarding/appearance-dark.svg"),
                        linear-gradient(
                            to bottom,
                            alpha(black, 0.45),
                            alpha(black, 0.45)
                        ),
                        url("%s");
                }

                .prefer-scheduled {
                    background-image:
                        url("resource:///io/elementary/onboarding/appearance-scheduled.svg"),
                        linear-gradient(
                            120deg,
                            transparent 50%,
                            alpha(black, 0.45) 51%
                        ),
                        url("%s");
                }
                """.printf (background_uri, background_uri, background_uri).data
            );

            prefer_default_card.get_style_context ().add_provider (
                background_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            prefer_dark_card.get_style_context ().add_provider (
                background_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            prefer_scheduled_card.get_style_context ().add_provider (
                background_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

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
