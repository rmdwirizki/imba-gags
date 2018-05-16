export tag Home
  def fetch url
    const res = await window.fetch url
    return res.json

  def load
    let posts = await fetch '/data/posts.json'
    data:posts = posts:reverse()

  def render
    <self>
      <section> 
        <div.post>
          for post in data:posts
            <div.title> post:title
            <div.image>
              <img src=post:src>
            <div.label>
              <span> "{post:fun} Fun"
              <span> "{post:comments:length} Comments"

