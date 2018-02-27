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
* [Call in background mode](#call-in-background-mode)
* [Video view](#video-view)
    - [Take snapshot](#take-snapshot)
* [Presence groups](#presence-groups)
    - [Manage presence groups](#manage-presence-groups)
    - [Handle presence group events](#handle-presence-group-events)
* [Custom user data](#custom-user-data)
* [Rooms](#rooms)
* [Conference](#conference)
* [Whiteboard](#whiteboard)
* [API references](http://docv2.apizee.com/sdk/ios/index.html)
* [SDK GitHub](https://github.com/apizee/ApiRTC-ios)
* [Sample GitHub](https://github.com/apizee/ApiRTC-ios-sample)
* [AppStore publishing](#appstore-publishing)

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
pod 'ApiRTC', :git => 'https://github.com/apizee/ApiRTC-ios', :tag => '0.5.0'
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

# Video view

`EAGLVideoView` has some extended features:

`view.contentMode = .scaleAspectFit ` work as usual.

`view.contentMode = .scaleAspectFill` resizes and aligns video to optimally show the central area of video.

## Take snapshot

You can take a snapshot from the remote video view during the call:

`let snapshotImage = remoteVideoView.takeSnapshot()`

You can use put `CGRect` to this method to take only desired area.

# Presence groups

Presence groups allow you to exchange an actual information about the current status between the contacts.

User can have *joined / subscribed / joined & subscribed* status related to participation in the group:

* **joined**: user doesn't receive events from this group, other group's users receive events from this user (user is visible for others)
* **subscribed**: user receive events from this group, other group's users don't receive events from this user (user is not visible for others)
* **joined & subscribed**: user receive events from this group, other group's users receive events from this user (user is visible for others)

## Manage presence groups

Each user included in `default` presence group by default.

You can redefine this behavior:

at initialization:

```
ApiRTC.initialize(..., presenceGroups: ["customGroup1", "customGroup2"], subscribeToPresenceGroups: ["customGroup1"], ...)
```

after initialization:

```
ApiRTC.session.joinGroup("someGroup")
ApiRTC.session.leaveGroup("someGroup")
ApiRTC.session.subscribeGroup("someGroup")
ApiRTC.session.unsubscribeGroup("someGroup")

```

You can get an actual presence group's information in order to check group states, active contacts etc:

```
if let group = ApiRTC.session.presenceGroups["someGroup"] {
    let contacts = group.contacts
    ...
}
```

## Handle presence group events

When any group you are subscribed to is updated, `Session` will receive `contactListUpdated` event contained updated `PresenceGroup` and `PresenceGroupUpdate` object that separately contains useful updated data. It may be handled like this:

```
ApiRTC.session.onEvent { (event) in
    switch event {
    ...
    case .contactListUpdated(let presenceGroup, let groupUpdate):

        switch groupUpdate.type {
        case .join:
            let joinedContacts = groupUpdate.contacts
            ...
        }
    }
}
```

# Custom user data

`User` object has `data` property that may contain custom user data.
You can manage it:

at initialization:

```
ApiRTC.initialize(..., userData: ["key": "value"])
```

after initialization:

```
ApiRTC.session.setUserData(["key": "value"])
```
It will update the current user data locally and also on the server. Users who are subscribed to the appropriate groups will be notified about these changes with `contactListUpdated` event: 


```
ApiRTC.session.onEvent { (event) in
    switch event {
    ...
    case .contactListUpdated(let presenceGroup, let groupUpdate):

        switch groupUpdate.type {
        case .userDataChange:
            let changedContacts = groupUpdate.contacts
            ...
        }
    }
}
```

# Rooms

`Room` is one of the core objects that provides the interaction between users in rooms (groups) and helps to be informed about current room users state (e.g. this is used in the Whiteboard):

```
room.onEvent { event in

    switch event {
    case .updated(let roomUpdate):
        switch roomUpdate.type {
        case .join:
            ....
            let joinedContacts = roomUpdate.contacts
    }
}
```

# Conference

ApiRTC allows you to make a calls in the conference mode.

To start a new conference:

```
let conference = Conference(id: "conference_id")
conference.start()
```

or join existing one:

```
conference.join()
```

Now you can receive and handle conference events:

```
conference.onEvent { event in
    switch event {
    case .newRemoteStream(let stream): 
        ...
    }
    ...
}
```

You can publish your media to this conference:

```
conference.publish(.video)
```

If you are publishing the media of video type you will receive `localCaptureSession(AVCaptureSession)` conference event.

`Conference.streams` variable has actual information about available streams represented by array of `ConferenceStream` objects.

You can subscribe to any available stream to obtain appropriate media:

```
conference.subscribeToStream(withId: streamId, mediaType: .video)
```

After a successful subscription you should receive `remoteMediaStream(MediaStream)` conference event.

You can use such conference events as `newRemoteStream(ConferenceStream)` and `removedStreamWithId(String)` to be informed about streams state.

You can leave conference by:

```
conference.leave()
```

It will stop local and remote streams handling. Be careful when you attach `MediaStream` object to any other object and clean this connection before leaving conference how it is done in the conference sample.


# Whiteboard

ApiRTC has built-in functionality to run the whiteboard.

Start a new whiteboard:

```
ApiRTC.session.startNewWhiteboard()
```

You will receive `SessionEvent.newWhiteboard(Whiteboard)` event when a new whiteboard is created or you are invited:

```
ApiRTC.session.onEvent { (event) in
    switch event {
    ...
    case .newWhiteboard(let whiteboard):
        ...
    default:
        break
    }
}
```

You can join, invite contact or leave the whiteboard using appropriate `Whiteboard` object methods. 

There is `WhiteboardView` object in order to represent the whiteboard in the view's hierarchy. After adding this view it should be attached to the current whiteboard:

`whiteboard.setView(whiteboardView)`

You can use such properties as `tool`, `color`, `brushSize` etc to operate with whiteboard:

```
whiteboard.tool = .pen
whiteboard.color = .red
whiteboard.brushSize = 3
```

You can be notified about whiteboard's room user activity by subscribing to `whiteboard.room` events. See [Rooms](#rooms) section.


# AppStore publishing

If you're publishing your app to the AppStore you may need to remove unused architectures from the framework. 
Go to the **Build Phases** -> Add **New Run Script Phase** -> Insert content of *Utils/strip-architecture.sh*
