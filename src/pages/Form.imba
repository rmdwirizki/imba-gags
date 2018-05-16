import {checkImage} from '../lib/checkImage.js'

export tag Form
  prop title
  prop url
  
  prop imgSrc
  prop imgPlaceholder default: 'http://via.placeholder.com/300?text=Image%20Preview'

  def mount
    # Reset on create new post
    @title  = ''
    @url    = ''
    @imgSrc = @imgPlaceholder

    Imba.commit

  def validateImage e
    # Using checkImage library

    const success = do 
      @imgSrc = @url
      Imba.commit

    const failure = do 
      @imgSrc = @imgPlaceholder
      Imba.commit

    # Bug with value

    setTimeout(&, 100) do
      checkImage @url, success, failure

  def submit
    data:posts:unshift {
      title   : @title,
      src     : @imgSrc,
      author  : data:session:username,
      email   : data:session:email,
      comments: [],
      fun     : 0
    }
    router:go '/'

  def render
    <self>
      <section> 
        <form :submit.prevent.submit>
          <input[title] type="text" placeholder="Title" required>
          <input[url] :keydown.validateImage :paste.validateImage type="url" placeholder="Insert the URL" required>
          <div.preview>
            <span> "Preview"
            <img src=imgSrc>
          <button type="submit"> "Submit"

