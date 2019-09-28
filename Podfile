platform :ios, '10.0'
use_frameworks!

target 'Meteo' do
pod 'Alamofire', '~> 4.5'
pod 'SwiftLint', '~> 0.27.0'
pod 'SwiftGen', '~> 6.0.2'
pod 'Connectivity', '~> 2.0'
pod 'lottie-ios', '~> 2.5.2'
end


# related to: https://github.com/CocoaPods/CocoaPods/issues/5334
# this is a workarround
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
      # workarround for cocoapods 1.5.3: https://github.com/CocoaPods/CocoaPods/issues/7689
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      #config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
