import { Controller } from '@hotwired/stimulus';
import consumer from '../channels/consumer'

class GameController extends Controller {
  static targets = ["game_view"];
  static values = { url: String }
  connect() {
    console.log('Welcome to Game!')
    this.game_subscription = consumer.subscriptions.create(
      {
        channel: "GameChannel",
        id: this.data.get("id")
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );

    this.user_subscription = consumer.subscriptions.create(
      {
        channel: "GameChannel",
        id: this.data.get("id"),
        user_id: this.data.get('user_id')
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }
  _connected() { }

  _disconnected() { }

  _received(data) {
    console.log(data)
    if (data.game_view != null) this.game_viewTarget.innerHTML = data.game_view
  }
}
export default GameController