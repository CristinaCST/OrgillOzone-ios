# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
target 'OZONE' do
  # Uncomment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'AzureNotificationHubs-iOS'
  # Pods for WEATCB
  # pod 'Embassy', '~> 4.1'
  # pod 'EnvoyAmbassador', '~> 4.0'
  #  pod 'GCDWebServer'
  # pod 'GCDWebServer/WebUploader', '~> 3.0'
  # pod 'GCDWebServer/WebDAV', '~> 3.0'
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end
