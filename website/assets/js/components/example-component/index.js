const { h, Component } = require('preact')

module.exports = class ExampleComponent extends Component {
  render() {
    return <h1 data-state={this.props._state}>{this.props.text}</h1>
  }
}
