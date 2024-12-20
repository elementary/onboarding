# Onboarding
[![Translation status](https://l10n.elementary.io/widgets/installer/-/onboarding/svg-badge.svg)](https://l10n.elementary.io/engage/installer/?utm_source=widget)

![Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* libgtk-4-dev (>= 4.10)
* libgranite-7-dev
* libadwaita-1-dev (>= 1.4.0)
* libpantheon-wayland-1-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    ninja install

Launch Onboarding with:

    io.elementary.onboarding
