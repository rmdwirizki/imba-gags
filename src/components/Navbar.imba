import {login, logout} from '../core/Auth.imba'

export tag Navbar
  def signOut
    logout {
      success: do
        const path = window:location:pathname
        if path:indexOf('/create') > -1 || path.indexOf('/edit/') > -1
          router:go '/'
    }

  def signInRedirect
    login {
      success: do 
        router:go '/create'
    }

  def render
    <self>
      <div.promote>
        <a href='https://github.com/rmdwirizki/imba-gags' target='_blank'>
          'Source on Github'
      <div.logo>
        <a route-to='/'> 'Imba Gags'
      <div.action>
        if data:session:loggedIn
          <div.create>
            <a route-to='/create'> 'Add Post'
          <div.user>
            <div.avatar>
              <img src=data:session:user:photoUrl>
            <div.dropdown>
              <a href='#' :click.prevent.signOut> 'Logout'
        else
          <div.create>
            <a href='#' :click.prevent.signInRedirect> 'Add Post'
