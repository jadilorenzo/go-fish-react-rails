import { Controller } from '@hotwired/stimulus';
class UserController extends Controller {
  connect() {
    console.log('Connected to login page')
  }

  loggedIn() {
    console.log('You hit the login button')
  }
}
export default UserController