#
#  Be sure to run `pod spec lint GTNetMon.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "GTNetMon"
  spec.version      = "1.0.0"
  spec.summary      = "A lightweight Swift library to get network status and connection information, and to monitor for network changes."
  spec.description  = <<-DESC
                    GTNetMon is a lightweight Swift library that detects whether a device is connected to Internet, it identifies the connection type (wifi, cellular, and more), and monitors for changes in the network status.
                   DESC
  spec.homepage     = "https://github.com/gabrieltheodoropoulos/GTNetMon.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors             = { "Gabriel Theodoropoulos" => "gabrielth.devel@gmail.com" }
  spec.social_media_url   = "https://twitter.com/gabtheodor"
  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.13"
  spec.source       = { :git => "https://github.com/gabrieltheodoropoulos/GTNetMon.git", :tag => "#{spec.version}" }
  spec.source_files = "Source/GTNetMon"
  spec.swift_version = "4.2"

end
