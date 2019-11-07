# Onboarding
[![Translation status](https://l10n.elementary.io/widgets/installer/-/onboarding/svg-badge.svg)](https://l10n.elementary.io/engage/installer/?utm_source=widget)

![Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* libgtk-3-dev
* libgranite-dev
* libhandy-0.0-dev >=0.0.11
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    ninja install
