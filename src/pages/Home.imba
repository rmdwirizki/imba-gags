import {db} from '../core/Config.imba'

export tag Home
  prop onscroll
  prop lastScroll default: 0

  def load 
    @onscroll = do @lastScroll = window:scrollY

  def mount
    window.addEventListener 'scroll', @onscroll
    window.scroll 0, @lastScroll

  def unmount
    window.removeEventListener 'scroll', @onscroll

  def setup
    const postsRef = db().ref('posts')

    postsRef.on 'child_added', do |snapshot|
      const post = snapshot.val()
      post:key = snapshot:key
      
      data:posts:unshift post
      
      Imba.commit

    postsRef.on 'child_changed', do |snapshot|
      let post = snapshot.val()
      post:key = snapshot:key

      const postIndex = data:posts:findIndex do |item|
        return snapshot:key == item:key
      data:posts[postIndex] = post

      Imba.commit

    postsRef.on 'child_removed', do |snapshot|
      const key = snapshot:key
      data:posts = data:posts:filter do |item|
        return item:key !== key
      
      Imba.commit
    
  def render
    <self> <section> 
      if data:posts:length == 0
        <div.info> "Loading"
      else
        <div.posts-list>
          for post in data:posts
            <div.post-card>
              <div.title route-to=('/detail/' + post:slug)> post:title
              <div.image route-to=('/detail/' + post:slug)>
                <img src=post:src>
              <div.label>
                # <span> "{post:counter:funs} Fun"
                <span route-to=('/detail/' + post:slug)> "{post:counter:comments} Comments"
