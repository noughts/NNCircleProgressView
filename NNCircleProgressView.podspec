Pod::Spec.new do |s|
  s.name         = "NNCircleProgressView"
  s.version      = "0.1.0"
  s.summary      = "NNCircleProgressView"
  s.homepage     = "https://github.com/noughts/NNCircleProgressView"
  s.author       = { "noughts" => "noughts@gmail.com" }
  s.source       = { :git => "https://github.com/noughts/NNCircleProgressView.git" }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform = :ios
  s.requires_arc = true
  s.source_files = 'NNCircleProgressView/**/*.{h,m}'
end
