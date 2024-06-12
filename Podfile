# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

pod 'Alamofire'
pod 'IQKeyboardManagerSwift'
pod 'NVActivityIndicatorView'
pod 'ObjectMapper'
pod 'SDWebImage'
pod 'TTGSnackbar'
pod 'OTPFieldView'
pod 'AdvancedPageControl'

target 'Acme Vendor App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Acme Vendor App
  
  target 'Acme Vendor AppTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'Acme Vendor AppUITests' do
    # Pods for testing
  end
  
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
