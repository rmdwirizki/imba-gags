const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Only update counter when it is first created or deleted.
exports.updateCommentCounter = functions.database.ref('/postComments/{postId}/{commentId}')
  .onWrite((snapshot, context) => {
    
    let increment;
    if (snapshot.after.exists() && !snapshot.before.exists()) {
      increment = 1;
    } else if (!snapshot.after.exists() && snapshot.before.exists()) {
      increment = -1;
    } else {
      return null;
    }

    const postId = context.params.postId;
    const counterRef = admin.database().ref('/posts/' + postId + '/counter/comments');

    // Return the promise from counterRef.transaction() so our function
    // waits for this async event to complete before it exits.
    return counterRef.transaction((current) => {
      return (current || 0) + increment;
    }).then(() => {
      return console.log('Counter updated.');
    });
  });

// If post is deleted -> delete all comments associated with it
exports.deleteAllPostComments = functions.database.ref('/posts/{postId}')
  .onDelete((snapshot, context) => {
    const postId = context.params.postId;
    const collectionRef = admin.database().ref('/postComments/' + postId);

    return collectionRef.remove((err) => {
      if (!err) {
        console.log('All related comments for post: ' + postId + ' has been deleted');
      }
    })
  });