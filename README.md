# ApiRTC iOS framework
This document describes ApiRTC iOS framework v.0.1.0

## Main classes

* **ApiRTC**: Main endpoint
* **RTCSession**: Main class of all WebRTC session types

All code units are described in the [API Reference](http://docv2.apizee.com/sdk/ios/index.html)

# Quickstart

## Create your account to get your key

ApiKey is used to authentify your account.

[Create an account](https://apirtc.com/get-key/)

## Installation

```
pod 'ApiRTC', :git => 'https://github.com/apizee/ApiRTC-ios', :tag => '0.1.0'
```

## Initialization


Initialize framework with `your_api_key`:

```
ApiRTC.initialize(apiKey: "your_api_key")
```

Add SDK events handler:

```
ApiRTC.onEvent { event in
    switch event {
    case .connected:
        ...
    case .incomingSession(let session):
    // Provide incoming sessions handler
    case .error(let error):
        ...
    }
}

```
Connect:

```
ApiRTC.connect()
```

## Making a video call

Create video call session:

```
session = ApiRTC.createSession(type: .videoCall, destinationId: "some_number")
```

Add session events handler:

```
session.onEvent { event in
    switch event {
    case .call:
        ...
    case .localCaptureSession(let captureSession):
        // Use CameraView or provide your own
        DispatchQueue.main.async {
        self.cameraView.captureSession = captureSession
        }
    case .remoteMediaStream(let mediaStream):
        // Use RemoteVideoView or provide your own
        if let videoTrack = mediaStream.videoTracks.first {
            DispatchQueue.main.async {
                self.remoteVideoTrack = videoTrack
                self.remoteVideoTrack?.add(renderer: self.remoteVideoView)
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
session.start()
```


# API Reference

Check [API Reference](http://docv2.apizee.com/sdk/ios/index.html) to have a complete description of available functionality.

# Tutorial

Check [Tutorial](TODO) **TODO** describing in detail how to use any part of the framework.

# Sample

Check [Sample](TODO) **TODO** app for better understanding on working example.

