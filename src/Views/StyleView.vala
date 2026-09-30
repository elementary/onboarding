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
    public StyleView () {
        Object (
            view_name: "style",
            description: _("Make it your own by choosing a visual style and accent color. Apps may override these with their own look."),
            icon_name: "preferences-desktop-theme",
            title: _("Choose Your Look")
        );
    }

    construct {
        var prefer_default_card = new DesktopPreview ();
        prefer_default_card.add_css_class ("prefer-default");

        var prefer_default_radio = new Gtk.CheckButton () {
            accessible_role = RADIO
        };
        prefer_default_radio.add_css_class ("image-button");

        var default_label = new Gtk.Label (_("Default"));

        var prefer_default_grid = new Gtk.Grid ();
        prefer_default_grid.attach (prefer_default_card, 0, 0);
        prefer_default_grid.attach (default_label, 0, 1);
        prefer_default_grid.set_parent (prefer_default_radio);

        prefer_default_radio.update_property_value (
            {LABEL, DESCRIPTION},
            {_("Style"), default_label.label}
        );

        var prefer_dark_card = new DesktopPreview ();
        prefer_dark_card.add_css_class ("prefer-dark");

        var prefer_dark_radio = new Gtk.CheckButton () {
            accessible_role = RADIO,
            group = prefer_default_radio
        };
        prefer_dark_radio.add_css_class ("image-button");

        var dark_label = new Gtk.Label (_("Dark"));

        var prefer_dark_grid = new Gtk.Grid ();
        prefer_dark_grid.attach (prefer_dark_card, 0, 0);
        prefer_dark_grid.attach (dark_label, 0, 1);
        prefer_dark_grid.set_parent (prefer_dark_radio);

        prefer_dark_radio.update_property_value (
            {LABEL, DESCRIPTION},
            {_("Style"), dark_label.label}
        );

        var prefer_scheduled_card = new DesktopPreview ();
        prefer_scheduled_card.add_css_class ("prefer-scheduled");

        var prefer_scheduled_radio = new Gtk.CheckButton () {
            accessible_role = RADIO,
            group = prefer_default_radio
        };
        prefer_scheduled_radio.add_css_class ("image-button");

        var prefer_scheduled_label = new Gtk.Label (_("Sunset to Sunrise")) {
            justify = CENTER,
            wrap = true
        };

        var prefer_scheduled_grid = new Gtk.Grid ();
        prefer_scheduled_grid.attach (prefer_scheduled_card, 0, 0);
        prefer_scheduled_grid.attach (prefer_scheduled_label, 0, 1);
        prefer_scheduled_grid.set_parent (prefer_scheduled_radio);

        prefer_scheduled_radio.update_property_value (
            {LABEL, DESCRIPTION},
            {_("Style"), prefer_scheduled_label.label}
        );

        var color_scheme_box = new Granite.Box (HORIZONTAL, HALF);
        color_scheme_box.append (prefer_default_radio);
        color_scheme_box.append (prefer_dark_radio);
        color_scheme_box.append (prefer_scheduled_radio);

        var blueberry_button = new PrefersAccentColorButton (BLUE) {
            tooltip_text = _("Blueberry")
        };

        var mint_button = new PrefersAccentColorButton (MINT) {
            tooltip_text = _("Mint")
        };

        var lime_button = new PrefersAccentColorButton (GREEN) {
            tooltip_text = _("Lime")
        };

        var banana_button = new PrefersAccentColorButton (YELLOW) {
            tooltip_text = _("Banana")
        };

        var orange_button = new PrefersAccentColorButton (ORANGE) {
            tooltip_text = _("Orange")
        };

        var strawberry_button = new PrefersAccentColorButton (RED) {
            tooltip_text = _("Strawberry")
        };

        var bubblegum_button = new PrefersAccentColorButton (PINK) {
            tooltip_text = _("Bubblegum")
        };

        var grape_button = new PrefersAccentColorButton (PURPLE) {
            tooltip_text = _("Grape")
        };

        var cocoa_button = new PrefersAccentColorButton (BROWN) {
            tooltip_text = _("Cocoa")
        };

        var slate_button = new PrefersAccentColorButton (GRAY) {
            tooltip_text = _("Slate")
        };

        var latte_button = new PrefersAccentColorButton (LATTE) {
            tooltip_text = _("Latte")
        };

        var auto_button = new PrefersAccentColorButton (NO_PREFERENCE) {
            tooltip_text = _("Automatic based on wallpaper")
        };

        var accent_box= new Granite.Box (HORIZONTAL, HALF) {
            halign = CENTER
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
        accent_box.append (latte_button);
        accent_box.append (auto_button);

        custom_bin.append (color_scheme_box);
        custom_bin.append (accent_box);

        var background_settings = new Settings ("org.gnome.desktop.background");

        var background_uri = background_settings.get_string ("picture-uri");
        var file = File.new_for_uri (background_uri);
        if (file.query_exists ()) {
            var background_provider = new Gtk.CssProvider ();
            background_provider.load_from_string (
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
                """.printf (background_uri, background_uri, background_uri)
            );

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                background_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        var settings = new GLib.Settings ("io.elementary.settings-daemon.prefers-color-scheme");

        if (settings.get_string ("prefer-dark-schedule") == "sunset-to-sunrise") {
            prefer_scheduled_radio.active = true;
        } else if (settings.get_string ("color-scheme") == "prefer-dark") {
            prefer_dark_radio.active = true;
        } else {
            prefer_default_radio.active = true;
        }

        prefer_default_radio.toggled.connect (() => {
            settings.set_string ("color-scheme", "no-preference");
            settings.set_string ("prefer-dark-schedule", "disabled");
        });

        prefer_dark_radio.toggled.connect (() => {
            settings.set_string ("color-scheme", "prefer-dark");
            settings.set_string ("prefer-dark-schedule", "disabled");
        });

        prefer_scheduled_radio.toggled.connect (() => {
            settings.set_string ("color-scheme", "no-preference");
            settings.set_string ("prefer-dark-schedule", "sunset-to-sunrise");
        });
    }

    private class DesktopPreview : Gtk.Widget {
        class construct {
            set_css_name ("desktop-preview");
        }

        construct {
            add_css_class (Granite.CssClass.CARD);
        }
    }

    private class PrefersAccentColorButton : Gtk.CheckButton {
        public enum AccentColor {
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
            GRAY,
            LATTE;

            public string to_string () {
                switch (this) {
                    case RED:
                        return "red";
                    case ORANGE:
                        return "orange";
                    case YELLOW:
                        return "yellow";
                    case GREEN:
                        return "green";
                    case MINT:
                        return "mint";
                    case BLUE:
                        return "blue";
                    case PURPLE:
                        return "purple";
                    case PINK:
                        return "pink";
                    case BROWN:
                        return "brown";
                    case GRAY:
                        return "gray";
                    case LATTE:
                        return "latte";
                    default:
                        return "automatic";
                }
            }
        }

        public AccentColor color { get; construct; }

        private static SimpleActionGroup action_group;

        public PrefersAccentColorButton (AccentColor color) {
            Object (color: color);
        }

        static construct {
            var interface_settings = new GLib.Settings ("io.elementary.settings-daemon.interface");
            action_group = new SimpleActionGroup ();
            action_group.add_action (interface_settings.create_action ("accent-color"));
        }

        construct {
            insert_action_group ("interface", action_group);

            action_target = new Variant.string (color.to_string ());
            action_name = "interface.accent-color";

            var css_color = color.to_string ();
            css_color = css_color.replace ("gray", "slate");
            css_color = css_color.replace ("automatic", "auto");

            accessible_role = Gtk.AccessibleRole.RADIO;
            add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);
            add_css_class (css_color);

            update_property_value (
                {LABEL},
                {_("accent color")}
            );
        }
    }
}
