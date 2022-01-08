# Onboarding
[![Translation status](https://l10n.elementary.io/widgets/installer/-/onboarding/svg-badge.svg)](https://l10n.elementary.io/engage/installer/?utm_source=widget)

![Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* libgtk-4-dev
* libgranite-7-dev
* libadwaita-1-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    ninja install

To test, reset the `viewed` key, then launch Onboarding:

    gsettings reset io.elementary.onboarding viewed; io.elementary.onboarding
