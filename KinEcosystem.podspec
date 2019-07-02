Pod::Spec.new do |s|
  s.name             = 'KinEcosystem'
  s.version          = '0.9.1'
  s.summary          = 'Kin Ecosystem mobile sdk for iOS'
  s.description      = <<-DESC
Kin ecosystem mobile sdk for iOS
                       DESC

  s.homepage         = 'https://kinecosystem.org'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kin' => 'kin@kinfoundation.com' }
  s.source           = { :git => 'https://github.com/kinfoundation/kin-ecosystem-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.resource_bundles = { "kinLocalization" => ["KinEcosystem/*.lproj/*.strings"],
                         "kinFonts" => ["KinEcosystem/fonts/*.otf"] }
  s.source_files = 'KinEcosystem/**/*.{h,m,swift}'
  s.resources = 'KinEcosystem/**/*.{xcassets,xcdatamodeld,storyboard,xib,png,pdf,jpg,json,strings,otf,ttf}'
  s.swift_version = '4.2'
  s.dependency 'SimpleCoreDataStack', '0.1.6'
  s.dependency 'KinMigrationModule', '0.1.0'
end
