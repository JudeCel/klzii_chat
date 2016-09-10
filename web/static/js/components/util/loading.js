import React       from 'react';
import { connect } from 'react-redux';
import ReactDOM    from 'react-dom';

const Loading = React.createClass({
  componentDidUpdate(props) {
    if(this.props.modalWindows.postData && props.modalWindows.postData != this.props.modalWindows.postData) {
      let modal = document.getElementsByClassName('modal-section modal-dialog')[0];
      let element = ReactDOM.findDOMNode(this);
      modal.appendChild(element);
    }
  },
  render() {
    const { modalWindows } = this.props;

    if(modalWindows.postData) {
      return (
        <div id='overlay'>
          <i id='loading' className='fa fa-spinner fa-pulse fa-fw'></i>
        </div>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
  }
};

export default connect(mapStateToProps)(Loading);
