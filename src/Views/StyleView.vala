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
            }

            return "auto";
        }
    }

    public StyleView () {
        Object (
            view_name: "style",
            description: _("Make it your own by choosing a visual style and accent color. Apps may override these with their own look."),
            icon_name: "preferences-desktop-wallpaper",
            title: _("Choose Your Look")
        );
    }

    construct {
        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("/io/elementary/onboarding/StyleView.css");

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

        var prefer_default_image = new Gtk.Image.from_resource ("/io/elementary/onboarding/appearance-default.svg");

        var prefer_default_card = new Gtk.Grid () {
            margin_start = 12,
            margin_end = 6,
            margin_bottom = 6
        };
        prefer_default_card.add (prefer_default_image);

        unowned Gtk.StyleContext prefer_default_card_context = prefer_default_card.get_style_context ();
        prefer_default_card_context.add_class (Granite.STYLE_CLASS_CARD);
        prefer_default_card_context.add_class (Granite.STYLE_CLASS_ROUNDED);
        prefer_default_card_context.add_provider (css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var prefer_default_grid = new Gtk.Grid ();
        prefer_default_grid.row_spacing = 6;
        prefer_default_grid.attach (prefer_default_card, 0, 0);
        prefer_default_grid.attach (new Gtk.Label (_("Default")), 0, 1);

        var prefer_default_radio = new Gtk.RadioButton (null) {
            halign = Gtk.Align.END,
            hexpand = true
        };
        prefer_default_radio.get_style_context ().add_class ("image-button");
        prefer_default_radio.add (prefer_default_grid);

        var prefer_dark_image = new Gtk.Image.from_resource ("/io/elementary/onboarding/appearance-dark.svg");

        var prefer_dark_card = new Gtk.Grid () {
            margin_start = 12,
            margin_end = 6,
            margin_bottom = 6
        };
        prefer_dark_card.add (prefer_dark_image);

        unowned Gtk.StyleContext prefer_dark_card_context = prefer_dark_card.get_style_context ();
        prefer_dark_card_context.add_class (Granite.STYLE_CLASS_CARD);
        prefer_dark_card_context.add_class (Granite.STYLE_CLASS_ROUNDED);
        prefer_dark_card_context.add_provider (css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var prefer_dark_grid = new Gtk.Grid ();
        prefer_dark_grid.row_spacing = 6;
        prefer_dark_grid.attach (prefer_dark_card, 0, 0);
        prefer_dark_grid.attach (new Gtk.Label (_("Dark")), 0, 1);

        var prefer_dark_radio = new Gtk.RadioButton.from_widget (prefer_default_radio) {
            halign = Gtk.Align.START,
            hexpand = true
        };
        prefer_dark_radio.get_style_context ().add_class ("image-button");
        prefer_dark_radio.add (prefer_dark_grid);

        var blueberry_button = new PrefersAccentColorButton (pantheon_act, AccentColor.BLUE);
        blueberry_button.tooltip_text = _("Blueberry");

        var mint_button = new PrefersAccentColorButton (pantheon_act, AccentColor.MINT, blueberry_button);
        mint_button.tooltip_text = _("Mint");

        var lime_button = new PrefersAccentColorButton (pantheon_act, AccentColor.GREEN, blueberry_button);
        lime_button.tooltip_text = _("Lime");

        var banana_button = new PrefersAccentColorButton (pantheon_act, AccentColor.YELLOW, blueberry_button);
        banana_button.tooltip_text = _("Banana");

        var orange_button = new PrefersAccentColorButton (pantheon_act, AccentColor.ORANGE, blueberry_button);
        orange_button.tooltip_text = _("Orange");

        var strawberry_button = new PrefersAccentColorButton (pantheon_act, AccentColor.RED, blueberry_button);
        strawberry_button.tooltip_text = _("Strawberry");

        var bubblegum_button = new PrefersAccentColorButton (pantheon_act, AccentColor.PINK, blueberry_button);
        bubblegum_button.tooltip_text = _("Bubblegum");

        var grape_button = new PrefersAccentColorButton (pantheon_act, AccentColor.PURPLE, blueberry_button);
        grape_button.tooltip_text = _("Grape");

        var cocoa_button = new PrefersAccentColorButton (pantheon_act, AccentColor.BROWN, blueberry_button);
        cocoa_button.tooltip_text = _("Cocoa");

        var slate_button = new PrefersAccentColorButton (pantheon_act, AccentColor.GRAY, blueberry_button);
        slate_button.tooltip_text = _("Slate");

        var auto_button = new PrefersAccentColorButton (pantheon_act, AccentColor.NO_PREFERENCE, blueberry_button);
        auto_button.tooltip_text = _("Automatic based on wallpaper");

        var accent_grid = new Gtk.Grid () {
            column_spacing = 6,
            halign = Gtk.Align.CENTER
        };
        accent_grid.add (blueberry_button);
        accent_grid.add (mint_button);
        accent_grid.add (lime_button);
        accent_grid.add (banana_button);
        accent_grid.add (orange_button);
        accent_grid.add (strawberry_button);
        accent_grid.add (bubblegum_button);
        accent_grid.add (grape_button);
        accent_grid.add (cocoa_button);
        accent_grid.add (slate_button);
        accent_grid.add (auto_button);

        custom_bin.row_spacing = 12;
        custom_bin.attach (prefer_default_radio, 0, 0);
        custom_bin.attach (prefer_dark_radio, 1, 0);
        custom_bin.attach (accent_grid, 0, 1, 2);

        switch (pantheon_act.prefers_color_scheme) {
            case Granite.Settings.ColorScheme.DARK:
                prefer_dark_radio.active = true;
                break;
            default:
                prefer_default_radio.active = true;
                break;
        }

        prefer_default_radio.toggled.connect (() => {
            pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.NO_PREFERENCE;
        });

        prefer_dark_radio.toggled.connect (() => {
            pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.DARK;
        });
    }

    private class PrefersAccentColorButton : Gtk.CheckButton {
        public AccentColor color { get; construct; }
        public Pantheon.AccountsService? pantheon_act { get; construct; default = null; }

        private static GLib.Settings interface_settings;

        public PrefersAccentColorButton (Pantheon.AccountsService? pantheon_act, AccentColor color, Gtk.CheckButton? group_member = null) {
            Object (
                pantheon_act: pantheon_act,
                color: color,
                group: group_member
            );
        }

        static construct {
            interface_settings = new GLib.Settings (INTERFACE_SCHEMA);

            var current_stylesheet = interface_settings.get_string (STYLESHEET_KEY);
        }

        construct {
            unowned Gtk.StyleContext context = get_style_context ();
            context.add_class (Granite.STYLE_CLASS_COLOR_BUTTON);
            context.add_class (color.to_string ());

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
