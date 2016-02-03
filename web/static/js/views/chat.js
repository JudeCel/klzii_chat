import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Actions              from '../actions/chat';

class ChatView extends React.Component {
  componentDidMount() {
    this.props.dispatch(Actions.connectToChannel());
    const { socket } = this.props;
}
  render() {
    return (
      <div id="chat-app-container" className="col-md-12">
        <div className="info-section"></div>
        <div className="members"></div>
        <div className="whiteboard"></div>
        <div className='col-md-3 jumbotron chat-messages pull-right'>
          <ul>
            {[].map( message =>
              <li key={message.time}>
                {message.text}
              </li>
            )}
          </ul>
        </div>
        <div className="form-group ">
          <input type="text" className="form-control" id="message" placeholder="Message"/>
        </div>
      </div>
    )
  }
}

const mapStateToProps = (state) => (state);
export default connect(mapStateToProps)(ChatView);
