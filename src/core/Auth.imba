import {auth} from './Config.imba'

export def login callback = null
  const provider = auth:GoogleAuthProvider.new
  const signIn = auth():signInWithPopup(provider)
  
  const success = do |res|

    if callback
      if callback.success
        callback.success

  const failure = do |err|

    if callback
      if callback.error
        callback.error

  signIn.then(success).catch(failure)

export def logout callback = null
  const signOut = auth().signOut()

  const success = do |res|

    if callback
      if callback.success
        callback.success
  
  const failure = do |err|

    if callback
      if callback.error
        callback.error
    
  signOut.then(success).catch(failure)

export def setAuthListener &session
  auth().onAuthStateChanged do |user|
    if user
      session:loggedIn = true
      session:user = {
        name: user:displayName,
        email: user:email,
        photoUrl: user:photoURL
      }
    else
      session:loggedIn = false
      session:user = {}
      
    Imba.commit
