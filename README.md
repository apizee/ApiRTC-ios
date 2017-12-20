# ApiRTC iOS SDK

ApiRTC cloud-based WebRTC API are built for web and mobile developers. Empower you website with real-time text, audio and video interaction by leveraging our javascript library (compatible Node.js or Angular.js) or use our plugins for your mobile apps. 

[Apizee](https://apizee.com/) takes care of browser compatibility, security and NAT traversal issues for you.

# Tutorial
This tutorial describes how to use ApiRTC with examples from [Sample](https://github.com/apizee/ApiRTC-ios-sample) 

* [Main classes](#main-classes)
* [First steps](#first-steps)
    - [Create acount](#create-an-account-to-get-your-api-key)
    - [Installation](#installation)
    - [Initialization](#initialization)
* [Basic video call](#basic-video-call)
* [Handling video formats](#video-formats)
* [Switching camera](#switching-camera)
* [Mute audio](#mute-audio)
* [Mute video](#mute-video)
* [Custom user data](#custom-user-data)
* [Connected contacts list](#connected-contacts-list)
* [Presence groups](#presence-groups)
* [API references](http://docv2.apizee.com/sdk/ios/index.html)
* [SDK GitHub](https://github.com/apizee/ApiRTC-ios)
* [Sample GitHub](https://github.com/apizee/ApiRTC-ios-sample)
* [AppStore](#appstore)

## Main classes

* **ApiRTC**: Main endpoint
* **Session**: Provides current SDK session functionality
* **Call**: Provides peer-to-peer audio/video calls

All code units are described in the [API Reference](http://docv2.apizee.com/sdk/ios/index.html)

## Requirements

* Swift 4
* iOS 9+
* Xcode 9+
* Bitcode is not supported at this moment

# First steps

## Create an account to get your API key

[Create an account](https://apirtc.com/get-key/)

## Installation

```
pod 'ApiRTC'
```

or

```
pod 'ApiRTC', :git => 'https://github.com/apizee/ApiRTC-ios', :tag => '0.4.0'
```

## Initialization


Initialize framework with `your_api_key`:

```
ApiRTC.initialize(apiKey: "your_api_key")
```

You should attach handlers for current session events:

```
ApiRTC.session.onEvent { event in
    switch event {
    case .connected:
        ...
    case .incomingCall(let call): 
        // Provide incoming call handler, eg:
        self.currentCall = call
    case .error(let error):
        ...
    }
}

```
Connect current session:

```
ApiRTC.session.connect() // `SessionEvent.connected` will be fired
```

# Basic video call

Create video call:

```
call = ApiRTC.createCall(type: .video, destinationId: "some_number")
```

For each call events handler should be attached:

```
call.onEvent { event in
    switch event {
    case .call:
        ...
    case .localCaptureSession(let captureSession):
        // Use CameraView or provide your own, eg:
        DispatchQueue.main.async {
            self.cameraView.previewLayer.videoGravity = .resizeAspectFill
            self.cameraView.captureSession = captureSession
        }
    case .remoteMediaStream(let mediaStream):
        // Use EAGLVideoView or MetalVideoView or provide your own, eg:
        if let videoTrack = mediaStream.videoTracks.first {
            DispatchQueue.main.async {
                self.remoteVideoTrack = videoTrack
                self.remoteVideoTrack?.add(renderer: self.remoteVideoView.renderer)
            }
        }
    case .closed:
        ...
    case .error(let error):
        ...
    }
}
```

Call:

```
call.start()
```

# Video formats

720p video format is used by default for local capture session.

You can define another format from the list of supported formats. It can be done before or during the call, eg:

```
if let device = ApiRTC.getCaptureDevice(position: .front) {
    
    let formats = ApiRTC.supportedFormats(device)
    
    let format = ...
    
    call.setCapture(with: device, format: format)
}
```

# Switching camera

You can switch camera easily:

```
if let call = currentCall as? VideoCall {
    call.switchCamera()
}
```

Actually it's just a shortcut that changes a device in `setCapture(...)`. You may redefine the device or format by yourself:

```
guard let currentDevice = call.captureDevice else {
    return
}

let switchedPosition: AVCaptureDevice.Position = currentDevice.position == .front ? .back : .front

if let device = ApiRTC.getCaptureDevice(position: switchedPosition) {
    call.setCapture(with: device) // you may also define format here
}
```

# Mute audio

You can mute/unmute audio by:

```
call.isLocalAudioEnabled = false
```

# Mute video

Just stop session capture:

```
guard let call = currentCall as? VideoCall else {
    return
}

call.stopCapture()
```

You can turn on/off capture like this:

```
call.isCapturing ? call.stopCapture() : call.startCapture()
```

`call.startCapture` is shortcut for `setCapture(...)` used front camera with the default format.

# Call in background mode
If you switch app to the background during the call session will be closed by default.
In order to prevent session interruption in the background, appropriate app capability should be enabled:
Go to the **Target Settings** -> **Capabilities** -> Enable **Background Modes** -> Check **Audio, AirPlay, and Picture in Picture**.

OR

Put in your `Info.plist`:

```
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

# Custom user data
**TODO**

# Connected contacts list
**TODO**

# Presence groups
**TODO**

# AppStore

If you're publishing your app to the AppStore you may need to remove unused architectures from the framework. 
Go to the **Build Phases** -> Add **New Run Script Phase** -> Insert content of *Utils/strip-architecture.sh*
