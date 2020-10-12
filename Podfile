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

  # Tools
  pod 'SwiftLint'

  # UI
  pod 'lottie-ios'

  target 'Chuck Norris FactsTests' do
    inherit! :search_paths
    test_pods
  end

  target 'Chuck Norris FactsUITests' do
    test_pods
  end

end
