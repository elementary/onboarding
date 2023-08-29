icon_sizes = ['24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        join_paths('icons', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps'),
        rename: meson.project_name() + '.svg'
    )
    install_data(
        join_paths('icons', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps'),
        rename: meson.project_name() + '.svg'
    )
endforeach

i18n.merge_file(
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.project_source_root (), 'po', 'extra'),
    type: 'desktop',
    install_dir: join_paths(get_option('datadir'), 'applications'),
    install: true
)

i18n.merge_file(
    input: 'onboarding.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: join_paths(meson.project_source_root(), 'po', 'extra'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

install_data(
    'autostart.desktop',
    rename: meson.project_name() + '.desktop',
    install_dir: join_paths(get_option('sysconfdir'), 'xdg', 'autostart')
)

install_data(
    'io.elementary.onboarding.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

# Stop the default guest session dialog from showing
install_data(
    'prefs.sh',
    install_dir: get_option('sysconfdir') / 'guest-session'
)
