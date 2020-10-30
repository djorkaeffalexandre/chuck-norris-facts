platform :ios, '11.0'

def test_pods

  # Rx
  pod 'RxTest'
  pod 'RxBlocking'

end

target 'Chuck Norris Facts' do
  use_frameworks!

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxRealm'

  # Tools
  pod 'SwiftLint'
  pod 'SwiftGen'

  # UI
  pod 'lottie-ios'

  # Networking
  pod 'Moya/RxSwift'

  # Storage
  pod 'RealmSwift'

  target 'Chuck Norris FactsTests' do
    inherit! :search_paths
    test_pods
  end

  target 'Chuck Norris FactsUITests' do
    test_pods
  end

end
