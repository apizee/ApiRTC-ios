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
    
})
```

### Registration with Apizee users management
```
ua = UserAgent(UserAgentOptions(uri: .apizee("your_login_here")))

ua.register(registerInformation: RegisterInformation(password: "your_pass")) { (error, session) in
    
}
```

## P2P call

```
let contact = session.getContact(id: "contact_id")
contact.call { (error, call) in 
    call.onEvent(self) { (event) in
    switch event {
    case .accepted:
        // ...
    case .declined:
        // ..
    case .localStreamAvailable(let localStream):
        // ..
    case .streamAdded(let remoteStream):
        // ..
    }
}
```
--> 

# AppStore

If you're publishing your app to the AppStore you may need to remove unused architectures from the framework. 
Go to the **Build Phases** -> Add **New Run Script Phase** -> Insert content of *strip-architecture.sh*