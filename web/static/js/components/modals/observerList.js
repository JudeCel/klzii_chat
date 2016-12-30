import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';

const ObserverListModal = React.createClass({
  mixins: [mixins.modalWindows],
  renderObservers() {
    const { observers } = this.props;

    let onlineObservers = [];
    observers.map((observer) => {
      if(observer.online) {
        onlineObservers.push(observer);
      }
    });

    if (onlineObservers.length) {
      return onlineObservers.map((observer) =>
        <div className='col-md-3' key={ observer.id }>
          <div className='icon-eye'></div>
          <div className='observer-name'>
            <div style={{ backgroundColor: observer.colour }}>{ observer.username }</div>
          </div>
        </div>
      )
    }
    else {
      return <div className='text-center'>No Spectators at this moment</div>
    }
  },
  render() {
    let show = this.showSpecificModal('observerList');

    if(show) {
      return (
        <Modal dialogClassName='observer-list-modal modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Spectators</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row observer-section'>
              { this.renderObservers() }
            </div>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Close</button>
          </Modal.Footer>
        </Modal>
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
    observers: state.members.observers,
    colours: state.chat.session.colours
  }
};

export default connect(mapStateToProps)(ObserverListModal);
