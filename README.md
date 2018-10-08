# Youtuber
A simple Youtube videos consumer iOS app

This app implements a client for consulting the Youtube  search API V3.  

The app requires a Google developer API KEY.  

[Google Console]  (https://console.developers.google.com/apis/)

The code has NOT implemented authentication . **Please create an API KEY without restrictions.**

Place your key in the file **/Models/Config.swift**

The API Key in the repository will be deactivate at any moment. 

---

To run the app the pods must be install:

    'pod install'

---

**Please** Run the test targets ( Unit test and UI test) to see the other cool stuff. 

Regarding testing , my approach is to use unit testing for code where you have to compute or maniputate data. For instance:
I found interesting cover complex algorithms with unit testing.  In that regard using proctocols , generics and dependency injection is a must.  

On the other side to test View Controlllers , actions , events . I think UI testing is  easier and faster to implement. 

