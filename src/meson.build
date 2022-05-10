
vala_files = [
    'Application.vala',
    'MainWindow.vala',
    'PageChecker.vala',
    'PantheonAccountsServicePlugin.vala',
    'Switcher.vala',
    'Utils.vala',
    'Views/AbstractOnboardingView.vala',
    'Views/AppCenterView.vala',
    'Views/EarlyAccessView.vala',
    'Views/FinishView.vala',
    'Views/HouseKeepingView.vala',
    'Views/NightLightView.vala',
    'Views/OnlineAccountsView.vala',
    'Views/StyleView.vala',
    'Views/UpdatesView.vala',
    'Views/WelcomeView.vala',
    'Views/WhatsNewView.vala',
]

config_data = configuration_data()
config_data.set('MIN_UID', get_option('min_uid'))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_data.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
config_file = configure_file(
  input: 'config.vala.in',
  output: 'config.vala',
  configuration: config_data
)

executable(
    meson.project_name(),
    vala_files,
    asresources,
    config_file,
    dependencies : dependencies,
    install: true
)
