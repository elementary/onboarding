/*-
 * Copyright (c) 2018 elementary LLC.
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

[DBus (name = "org.gnome.Mutter.DisplayConfig")]
public interface MutterDisplayConfigInterface : Object {
    public abstract void get_resources (out uint serial, out MutterReadDisplayCrtc[] crtcs, out MutterReadDisplayOutput[] outputs, out MutterReadDisplayMode[] modes, out int max_screen_width, out int max_screen_height) throws Error;
    public abstract void apply_configuration (uint serial, bool persistent, MutterWriteDisplayCrtc[] crtcs, MutterWriteDisplayOutput[] outputs) throws Error;
    public abstract int change_backlight (uint serial, uint output, int value) throws Error;
    public abstract void get_crtc_gamma (uint serial, uint crtc, out uint[] red, out uint[] green, out uint[] blue) throws Error;
    public abstract void set_crtc_gamma (uint serial, uint crtc, uint[] red, uint[] green, uint[] blue) throws Error;
    public abstract int power_save_mode { get; set; }
    public signal void monitors_changed ();
    public abstract void get_current_state (out uint serial, out MutterReadMonitor[] monitors, out MutterReadLogicalMonitor[] logical_monitors, out GLib.HashTable<string, GLib.Variant> properties) throws Error;
    public abstract void apply_monitors_config (uint serial, MutterApplyMethod method, MutterWriteLogicalMonitor[] logical_monitors, GLib.HashTable<string, GLib.Variant> properties) throws Error;
}

[CCode (type_signature = "u")]
public enum MutterApplyMethod {
    VERIFY = 0,
    TEMPORARY = 1,
    PERSISTENT = 2
}

[CCode (type_signature = "u")]
public enum DisplayTransform {
    NORMAL = 0,
    ROTATION_90 = 1,
    ROTATION_180 = 2,
    ROTATION_270 = 3,
    FLIPPED = 4,
    FLIPPED_ROTATION_90 = 5,
    FLIPPED_ROTATION_180 = 6,
    FLIPPED_ROTATION_270 = 7;

    public string to_string () {
        // These values are based on the direction that the physical display has been rotated from its original position.
        // They should not reflect the rotation that must be applied to the contents on screen.
        switch (this) {
            case ROTATION_90:
                return _("Clockwise");
            case ROTATION_180:
                return _("Upside-down");
            case ROTATION_270:
                return _("Counterclockwise");
            case FLIPPED:
                return _("Flipped");
            case FLIPPED_ROTATION_90:
                return _("Flipped Clockwise");
            case FLIPPED_ROTATION_180:
                return _("Flipped Upside-down");
            case FLIPPED_ROTATION_270:
                return _("Flipped Counterclockwise");
            default:
                return _("None");
        }
    }
}

public struct MutterReadMonitorInfo {
    public string connector;
    public string vendor;
    public string product;
    public string serial;
    public uint hash {
        get {
            return (connector + vendor + product + serial).hash ();
        }
    }
}

public struct MutterReadMonitorMode {
    public string id;
    public int width;
    public int height;
    public double frequency;
    public double preferred_scale;
    public double[] supported_scales;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterReadMonitor {
    public MutterReadMonitorInfo monitor;
    public MutterReadMonitorMode[] modes;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterReadLogicalMonitor {
    public int x;
    public int y;
    public double scale;
    public DisplayTransform transform;
    public bool primary;
    public MutterReadMonitorInfo[] monitors;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterWriteMonitor {
    public string connector;
    public string monitor_mode;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterWriteLogicalMonitor {
    public int x;
    public int y;
    public double scale;
    public DisplayTransform transform;
    public bool primary;
    public MutterWriteMonitor[] monitors;
}

public struct MutterReadDisplayCrtc {
    public uint id;
    public int64 winsys_id;
    public int x;
    public int y;
    public int width;
    public int height;
    public int current_mode;
    public DisplayTransform current_transform;
    public DisplayTransform[] transforms;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterWriteDisplayCrtc {
    public uint id;
    public int new_mode;
    public int x;
    public int y;
    public DisplayTransform transform;
    public uint[] outputs;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterReadDisplayOutput {
    public uint id;
    public int64 winsys_id;
    public int current_crtc;
    public uint[] possible_crtcs;
    public string connector_name;
    public uint[] modes;
    public uint[] clones;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterWriteDisplayOutput {
    public uint id;
    public GLib.HashTable<string, GLib.Variant> properties;
}

public struct MutterReadDisplayMode {
    public uint id;
    public int64 winsys_id;
    public uint width;
    public uint height;
    public double frequency;
    public uint flags;
}
