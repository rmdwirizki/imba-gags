const firebase = require 'firebase'

export var firebaseConf = {
  apiKey: "AIzaSyBiaz0qs3hl0MnDPG7EhNvF4WxaBu7XmhI",
  authDomain: "imba-gags.firebaseapp.com",
  databaseURL: "https://imba-gags.firebaseio.com",
  projectId: "imba-gags",
  storageBucket: "imba-gags.appspot.com",
  messagingSenderId: "877107529844"
}
export var firebaseApp = firebase:initializeApp(firebaseConf)
export var db = firebaseApp:firebase_:database
export var auth = firebaseApp:firebase_:auth
