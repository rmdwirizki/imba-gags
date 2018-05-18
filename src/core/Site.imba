# Styles
import '../styles/appStyles.scss'

# Store and Local Data
let state = {
  session: {
    loggedIn: false,
    user : {}
  },
  posts: []
}

# Listen auth changed
import {setAuthListener} from './Auth.imba'
setAuthListener state:session

# Router
import 'imba-router'

import {Navbar} from '../components/Navbar.imba'

import {Home} from '../pages/Home.imba'
import {Form} from '../pages/Form.imba'
import {Detail} from '../pages/Detail.imba'

export tag Site
  def render
    <self>
      <Navbar[state]>
      <Home[state] route='/'>
      <Form[state] route='/create'>
      <Form[state] route='/edit/:slug'>
      <Detail[state] route='/detail/:slug'>
