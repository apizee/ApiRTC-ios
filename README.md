# ApiRTC iOS SDK (Beta)

ApiRTC cloud-based WebRTC API are built for web and mobile developers. Empower you website with real-time text, audio and video interaction by leveraging our javascript library (compatible Node.js or Angular.js) or use our plugins for your mobile apps. 

[Apizee](https://apizee.com/) takes care of browser compatibility, security and NAT traversal issues for you.

## Requirements

* Swift 5
* iOS 10+
* Xcode 10+
* Bitcode is not supported at this moment

# Installation 

`pod 'ApiRTC'`

# Samples

[Check our samples](https://github.com/apizee/ApiRTC-ios-sample)

# Quick start tutorials

## User Agent 
User Agent is the starting point of apiRTC and enables you to manage several important aspects such as:
- User identifier
- User registration
- User authentication
- Stream management (usage, recording ...)
- Whiteboard

### User Agent creation and Registration
ApiRTC offers two user management possibilities:
- External users management: manage users on your side.
In this case, you manage the users database and use our services to manage presence and communication establishment. Users are only known as an identifier on our side and you manage other parameters such as identity, photos ...
- Integrated users management: manage users on Apizee Cloud

Using our User Management System will enables you to simplify WebRTC integration and enrich features possibility:
- Manage your contact directory
- Create private conference with moderation
- Manage users rights (conference creation, media access controls etc)
- Enhance users authentications

### Registration with external users management

In order to start communicating with other users, UserAgent has to be registered on Apizee platform. ApiKey is used to isolate your project so you will be able to communicate with users that are registered with the same apiKey.

```
ua = UserAgent(UserAgentOptions(uri: .apzkey("your_api_key")))`

ua.register() { (error, session) in
    // ...
})
```

### Registration with Apizee users management

```
ua = UserAgent(UserAgentOptions(uri: .apizee("your_login_here")))

ua.register(registerInformation: RegisterInformation(password: "your_pass")) { (error, session) in
    // ...
}
```

## Contacts management

You can take actual contacts from the current session:

```
let contacts = session.getContacts("group_id") // all contacts in your environment join at least "default" group
```

```
let contact = session.getContact("contact_id")
```

## P2P call

### On the caller side

```
let contact = session.getContact(id: "contact_id")
contact.call { (error, call) in 
    call.onEvent(self) { (event) in
    switch event {
    case .accepted:
        // ...
    case .declined:
        // ...
    // Look at Stream handling section to learn more about new stream handling
    case .localStreamAvailable(let localStream):
        // ...
    case .streamAdded(let remoteStream):
        // ...
    }
}
```

### On the callee side

```
session.onEvent(self, { (event) in
    switch event {
    case .incomingCall(let invitation):
        invitation.accept(completion: { (error, call) in
            // ...
        })
    }
})
```

### Call handling

On both sides you can handle a call as follows:

```
call.onEvent(self) { (event) in
    switch event {
    case .localStreamAvailable(let localStream):
        // ...
    case .streamAdded(let remoteStream):
        // ...
    }
}
```

## Conversation

### Create conversation

```
conversation = session.getOrCreateConversation(name: "conversation_id")

conversation?.join()

conversation?.onEvent(self, { (event) in
    switch event {
    case .joined:
        // ...
    case .streamListChanged(let streamList):
        // Stream list contains stream info that you may use to subscribe to stream
    case .streamAdded(let stream):
        // ...
    }
})
```

### Subscribe to stream

```
conversation.subscribeToStream(streamId: "stream_id")
```
Then you should get `.streamAdded` conversation event with appropriate stream object.

### Publish stream

```
conversation.publish(stream: stream) { (error, stream) in
    // ...
}
```

## Stream handling

### Create local stream

For example local camera stream:

```
let stream = try Stream.createCameraStream(position: .back)
```
Note: you may need to cast `Stream` to some alias to avoid crossing with Cocoa class.

### Stream rendering

In case of a local stream it should keep `AVCaptureSession` presented by `stream.captureSesssion` variable .  Local stream may be conveniently handled with embedded `CameraView` class:

```
let cameraView = CameraView(...)
// add view somewhere
cameraView.captureSession = localStream.captureSession 
```
 In case of remote stream it should have `MediaStream` object presented by `stream.mediaStream` variable. Remote stream may be conveniently handled with embedded `VideoView` class:
 
```
let videoView = VideoView(...)
// add view somewhere
let videoTrack = mediaStream.videoTracks.first
videoTrack.addRenderer(videoView.renderer)
```

To remove renderer:

```
videoTrack.removeRenderer()
```

## Whiteboard

If you are who starts the whiteboard session you should have connected `UserAgent` then you can start

```
userAgent.startWhiteboard { (error, whiteboardClient) in
    // the you can use WhiteboardClient to change whiteboard settings, set rendering view etc
}
```

### Invite to whiteboard session

```
let contact = session.getContact(id: "contact_id")
contact.sendWhiteboardInvitation { (error, invitation) in
    // ...
}
```

### Handle whiteboard invitation

```
session.onEvent(self, { (event) in
    switch event {
    case .whiteboardInvitation(let invitation):
        invitation.accept(completion: { (error, whiteboardClient) in
            // ...
        })
    }
})
```

### Whiteboard view

Use embedded whiteboard view to handle whiteboard data.

```
let whiteboardView = WhiteboardView(...)
// ...
whiteboardClient.setView(whiteboardView)
whiteboardView.setMode(.edit)
```

## Invitation handling

If you deal with any invitation you can subscribe on invitation events to get actual information about current state:

```
invitation.onEvent(self, { (event) in
    switch event {
    case .statusChanged(let status):
        // ...
    }
})
```

# AppStore

If you're publishing your app to the AppStore you may need to remove unused architectures from the framework. 
Go to the **Build Phases** -> Add **New Run Script Phase** -> Insert content of *strip-architecture.sh*