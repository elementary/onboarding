
vala_files = [
    'Application.vala',
    'MainWindow.vala',
    'PageChecker.vala',
    'Switcher.vala',
    'Utils.vala',
    'Views/AbstractOnboardingView.vala',
    'Views/AppCenterView.vala',
    'Views/FinishView.vala',
    'Views/HouseKeepingView.vala',
    'Views/LocationServicesView.vala',
    'Views/NightLightView.vala',
    'Views/ScalingFactorView.vala',
    'Views/UpdateView.vala',
    'Views/WelcomeView.vala',
]

config_data = configuration_data()
config_data.set('MIN_UID', get_option('min_uid'))
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
