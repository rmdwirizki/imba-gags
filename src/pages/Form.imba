import {db} from '../core/Config.imba'
import {checkImage} from '../lib/checkImage.js'

const slugify      = require '@sindresorhus/slugify'
const randomstring = require 'randomstring'

export tag Form
  prop title
  prop url
  
  prop imgSrc
  prop imgPlaceholder default: 'http://via.placeholder.com/300?text=Image%20Preview'

  prop postKey default: null

  prop isValid default: true
  prop isEdit default: false

  def mount
    if !params:slug
      clear
    else
      if data:posts:length > 0
        const post = data:posts:find do |item|
          if item:slug == params:slug
            @postKey = item:key
            return true

        @title = post:title
        @url = post:src
        @imgSrc = post:src
      else
        # Update from firebase
        const ref = db().ref('posts')
        const query = ref.orderByChild('slug').equalTo(params:slug)
        query.once 'value', do |snap| 
          for key, post of snap.val()
            @postKey = key

            @title = post:title
            @url = post:src
            @imgSrc = post:src

            Imba.commit
            
      @isEdit = true

      Imba.commit

  def clear
    # Reset on create new post
    @title  = ''
    @url    = ''
    @imgSrc = @imgPlaceholder

    Imba.commit

  def validateImage
    # Using checkImage library

    const success = do 
      @imgSrc = @url
      @isValid = true

      Imba.commit

    const failure = do 
      @imgSrc = @imgPlaceholder
      @isValid = false

      Imba.commit

    # Bug with value

    setTimeout(&, 100) do
      checkImage @url, success, failure

  def submit
    if !isValid
      window:alert 'Image is invalid'
      return;

    const postsRef = db().ref('posts')

    if !@isEdit
      const newSlug = slugify(@title) + '-' + randomstring:generate(5)
      const newPost = {
        title  : @title,
        src    : @imgSrc
        slug   : newSlug,
        author : data:session:user,
        counter: {
          comments: 0,
          funs    : 0
        },
        timestamp: Date.now()
      }

      let newPostRef = postsRef.push()
      newPostRef.set newPost, do |err|
        if !err
          router:go '/detail/' + newSlug
    else
      const newPost = {
        '/title': @title,
        '/src': @imgSrc,
        '/timestamp': Date.now()
      }

      let updatedPostRef = postsRef.child(@postKey)
      updatedPostRef.update newPost, do |err|
        if !err
          router:go '/detail/' + params:slug

  def render
    <self> <section> 
      if !postKey && isEdit
        <div.info> "Loading"
      else
        <form :submit.prevent.submit>
          <input[title] type="text" placeholder="Title" required>
          <input[url] :keydown.validateImage :paste.validateImage type="url" placeholder="Insert the URL" required>
          <div.preview>
            <span> "Preview"
            <img src=imgSrc>
          <button type="submit"> "Submit"
