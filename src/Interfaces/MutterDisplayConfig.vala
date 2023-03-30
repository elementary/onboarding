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
