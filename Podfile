# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Waya PayChat 2.0' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Waya PayChat 2.0
  pod 'SwiftValidator', :git => 'https://github.com/quacklabs/SwiftValidator.git', :branch => 'numeric_rule', :commit => '06a3d4d'
  pod 'Alamofire'
  pod 'Signals'
#  pod 'ReachabilitySwift'
#  pod 'AppCenter'
  pod 'ScrollableView', :git => 'https://github.com/markboleigha-waya/ScrollableView.git', :tag => '0.0.8'
  pod 'IQKeyboardManagerSwift', :git => 'https://github.com/hackiftekhar/IQKeyboardManager.git', :tag => 'v6.5.6'  
  pod ‘Firebase/AnalyticsWithoutAdIdSupport’
    
  target 'Waya PayChat 2.0Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Waya PayChat 2.0UITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
