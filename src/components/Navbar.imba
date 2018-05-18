import {login, logout} from '../core/Auth.imba'

export tag Navbar
  def signOut
    logout {
      success: do
        const path = window:location:pathname
        if path:indexOf('/create') > -1 || path.indexOf('/edit/') > -1
          router:go '/'
    }

  def signIn
    login 

  def signInRedirect
    login {
      success: do 
        router:go '/create'
    }

  def render
    <self>
      <a route-to='/'> 'Home'
      if data:session:loggedIn
        <a route-to='/create'> 'Add Post'
        <a href='#' :click.prevent.signOut> 'Logout'
      else
        <a href='#' :click.prevent.signInRedirect> 'Add Post'
        <a href='#' :click.prevent.signIn> 'Login'
