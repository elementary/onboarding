project(
    'io.elementary.onboarding',
    'vala', 'c',
    version: '7.1.0'
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
gtk_dep = dependency('gtk4')
posix_dep = meson.get_compiler('vala').find_library('posix')
adw_dep = dependency('libadwaita-1')
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

meson.add_install_script('meson/post_install.py')
