import {db} from '../core/Config.imba'

export tag Detail
  prop post
  prop comments default: []

  prop content
  prop postCommentsRef default: null

  def mount
    updateLocalPost
    clearContent

  def unmount
    if @postCommentsRef
      @postCommentsRef.off()

  def clearContent
    @content = ''
    Imba.commit

  def updateLocalPost
    if data:posts:length > 0
      # Update from store
      @post = data:posts:find do |item|
        return item:slug == params:slug

      setupCommentListener
    else
      # Update from firebase
      const ref = db().ref('posts')
      const query = ref.orderByChild('slug').equalTo(params:slug)
      query.once 'value', do |snap| 
        for key, post of snap.val()
          post:key = key
          @post = post
          if !@postCommentsRef
            setupCommentListener
          Imba.commit

    Imba.commit

  def setupCommentListener
    @comments = []

    @postCommentsRef = db().ref('postComments/' + @post:key)
    @postCommentsRef.on 'child_added', do |snapshot|
      const comment = snapshot.val()
      comment:key = snapshot:key
      @comments:push comment

      Imba.commit

    @postCommentsRef.on 'child_removed', do |snapshot|
      const key = snapshot:key
      @comments = @comments:filter do |item|
        return item:key !== key
      
      Imba.commit

  def addComment
    const newComment = {
      user: data:session:user,
      content: @content,
      timestamp: Date.now()
    }
    
    let newCommentRef = @postCommentsRef.push()
    newCommentRef.set newComment, do |err|
      if !err
        # Increase comment counter on post
        const postRef = db().ref('posts/' + @post:key + '/counter/comments')
        postRef.set @post:counter:comments + 1
        # Local change
        post:counter:comments++

    clearContent

  def editComment key
    const oldCommentIndex = @comments:findIndex do |item|
      return item:key == key
    const oldComment = @comments[oldCommentIndex]
    const newComment = window:prompt 'Edit comment', oldComment:content

    if newComment != null && /\S/.test(newComment)
      let updatedCommentRef = @postCommentsRef.child(key)
      updatedCommentRef.update {
        '/content': newComment,
        '/timestamp': Date.now()
      }, do |err|
        if !err
          # Local changes
          @comments[oldCommentIndex]:content = newComment
          Imba.commit

  def removeComment key
    let confirm = window:confirm 'Are you sure?'
    if confirm == true
      let removedCommentRef = @postCommentsRef.child(key)
      removedCommentRef.remove do |err|
        if !err
          # Decrease comment counter on post
          const postRef = db().ref('posts/' + @post:key + '/counter/comments')
          postRef.set @post:counter:comments - 1
          # Local change
          post:counter:comments--
  
  def removePost key
    let confirm = window:confirm 'Are you sure?'
    if confirm == true
      let removedPostRef = db().ref('posts/' + @post:key)
      removedPostRef.remove do |err|
        if !err
          # Remove comment from post in firebase
          let removedCommentsRef = @postCommentsRef
          removedCommentsRef.remove do |err|
            if !err
              # console.log 'All related comments has been deleted'

          router:go '/'

  def render
    <self> <section> 
      
      if !post
        <div.info> "Loading"
      else
        <div.post-card>
          <div.title> post:title
          <div.image>
            <img src=post:src>
          <div.label>
            <span> "{post:counter:funs} Fun"
            <span> "{post:counter:comments} Comments"
          if post:author:email == data:session:user:email
            <div.action>
              <button route-to=('/edit/' + post:slug)> "Edit"
              <button :click.prevent.removePost(post:key)> "Delete"

        <div.comment-box>
          if data:session:loggedIn
            <div.input>
              <form :submit.prevent.addComment>
                <textarea[content] required>
                <button type='submit'> "Submit"
          else
            <div.alert> "Login to write a comment"

          if @post:counter:comments == 0
            <div.warning> "There's nothing"
          else
            if @comments:length == 0
              <div.info> "Loading"
            else
              <div.comments-list>
                for comment in comments
                  <div.comment-card>
                    <div.user> 
                      <img.avatar src=comment:user:photoUrl>
                      <span.name> comment:user:name
                    <div.content>
                      comment:content
                    if comment:user:email == data:session:user:email
                      <div.action>
                        <button :click.prevent.editComment(comment:key)> "Edit"
                        <button :click.prevent.removeComment(comment:key)> "Delete"
