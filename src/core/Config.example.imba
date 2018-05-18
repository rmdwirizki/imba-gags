const firebase = require 'firebase'

export var firebaseConf = {
  apiKey: "xxx",
  authDomain: "xxx.firebaseapp.com",
  databaseURL: "https://xxx.firebaseio.com",
  projectId: "xxx",
  storageBucket: "xxx.appspot.com",
  messagingSenderId: "xxx"
}
export var firebaseApp = firebase:initializeApp(firebaseConf)
export var db = firebaseApp:firebase_:database
export var auth = firebaseApp:firebase_:auth
