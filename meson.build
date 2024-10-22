project(
    'io.elementary.onboarding',
    'vala', 'c',
    version: '8.0.1',
    meson_version: '>= 0.57'
)

add_global_arguments(
    '-DGETTEXT_PACKAGE="' + meson.project_name() + '"',
    language:'c'
)

gnome = import('gnome')
i18n = import('i18n')

cc = meson.get_compiler('c')

gee_dep = dependency('gee-0.8')
glib_dep = dependency('glib-2.0', version: '>=2.64.0')
gobject_dep = dependency('gobject-2.0')
granite_dep = dependency('granite-7')
gtk_dep = dependency('gtk4', version: '>= 4.10')
posix_dep = meson.get_compiler('vala').find_library('posix')
adw_dep = dependency('libadwaita-1', version: '>= 1.4.0')
m_dep = cc.find_library('m', required : false)

dependencies = [
    gee_dep,
    glib_dep,
    gobject_dep,
    granite_dep,
    gtk_dep,
    posix_dep,
    adw_dep,
    m_dep
]

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('po')
subdir('src')
subdir('data')

gnome.post_install(glib_compile_schemas: true)
