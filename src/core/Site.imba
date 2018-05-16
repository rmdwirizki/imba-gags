import '../styles/appStyles.scss';

import 'imba-router';

let store = {
  session: {
    username: 'rmdwirizki',
    email: 'rmdwirizki@gmail.com'
  },
  posts: [],
}

import {Navbar} from '../components/Navbar.imba'

import {Home} from '../pages/Home.imba'
import {Form} from '../pages/Form.imba'

export tag Site
  def render
    <self>
      <Navbar>
      <Home[store] route='/'>
      <Form[store] route='/form'>
