import {db} from '../core/Config.imba'
import {login} from '../core/Auth.imba'

export tag Detail
  prop post
  prop comments default: []

  prop content

  prop postRef default: null
  prop postCommentsRef default: null

  def mount
    self.updateLocalPost
    self.clearContent

    window.scroll 0, 0

  def unmount
    if @postCommentsRef
      @postCommentsRef.off()
    if @postRef
      @postRef.off()

  def clearContent
    @content = ''

  def updateLocalPost
    # Update local post from store
    if data:posts:length > 0
      @post = data:posts:find do |item|
        return item:slug == params:slug
    
    # If store empty
    # Update local post from firebase
    if !@post
      const ref = db().ref('posts')
      const query = ref.orderByChild('slug').equalTo(params:slug)
      query.once 'value', do |snap| 
        for key, post of snap.val()
          @post = Object.assign post, {}, {'key': key}
          self.setupListener
        
          Imba.commit
    else 
      self.setupListener
    
    Imba.commit

  def setupListener
    # Listen to all comment change on this post

    @comments = []
    @postCommentsRef = db().ref('postComments/' + @post:key)

    @postCommentsRef.on 'child_added', do |snapshot|
      const comment = Object.assign snapshot.val(), {}, {'key': snapshot:key}
      @comments:push comment

      Imba.commit

    @postCommentsRef.on 'child_changed', do |snapshot|
      const comment = Object.assign snapshot.val(), {}, {'key': snapshot:key}
      const index = @comments:findIndex do |item|
        return snapshot:key == item:key
      @comments[index] = comment

      Imba.commit

    @postCommentsRef.on 'child_removed', do |snapshot|
      @comments = @comments:filter do |item|
        return item:key !== snapshot:key
      
      Imba.commit
    
    # Listen to post change
    
    @postRef = db().ref('posts/' + @post:key)
    @postRef.on 'value', do |snapshot|
      @post = Object.assign snapshot.val(), {}, {'key': snapshot:key}

      Imba.commit

  def signIn
    login {
      success: do # console.log 'berhasil'
    }

  def addComment
    const newComment = {
      user: data:session:user,
      content: @content,
      timestamp: Date.now()
    }
    
    let newCommentRef = @postCommentsRef.push()
    newCommentRef.set newComment, do |err|
      if !err
        # Handled on firebase cloud function trigger
        # Increase comment counter on post

    self.clearContent

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
          # Handled on firebase cloud function trigger
          # Decrease comment counter on post
          
  def removePost key
    let confirm = window:confirm 'Are you sure?'
    if confirm == true
      let removedPostRef = db().ref('posts/' + @post:key)
      removedPostRef.remove do |err|
        if !err
          # Handled on firebase cloud function trigger
          # Remove all comments from post in firebase
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
            # <span> "{post:counter:funs} Fun"
            <span> "{post:counter:comments} Comments"
          if post:author:email == data:session:user:email
            <div.action>
              <button.edit route-to=('/edit/' + post:slug)> "Edit"
              <button.remove :click.prevent.removePost(post:key)> "Delete"

        <div.comment-box>
          if data:session:loggedIn
            <form :submit.prevent.addComment>
              <div.avatar>
                <img src=data:session:user:photoUrl>
              <div.input>
                <textarea[content] required>
                <button type='submit'> "Submit"
          else
            <div.alert> 
              <a href='#' :click.prevent.signIn> "Login to write a comment"

          if @post:counter:comments == 0
            <div.warning> "There's nothing"
          else
            if @comments:length == 0
              <div.info> "Loading"
            else
              <div.comments-list>
                for comment in @comments
                  <div.comment-card>
                    <div.detail>
                      <div.avatar> 
                        <img src=comment:user:photoUrl>
                      <div.content>
                        comment:content
                    if comment:user:email == data:session:user:email
                      <div.action>
                        <button.edit :click.prevent.editComment(comment:key)> "Edit"
                        <button.remove :click.prevent.removeComment(comment:key)> "Delete"
