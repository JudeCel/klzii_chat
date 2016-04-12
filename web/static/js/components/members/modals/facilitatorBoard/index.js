import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap'
import { connect }        from 'react-redux';
import onEnterModalMixin  from '../../../../mixins/onEnterModal';
import Board              from './board';
import ReactDOM           from 'react-dom';

const BoardModal = React.createClass({
  mixins: [onEnterModalMixin],
  getInitialState() {
    return { content: this.props.boardContent }
  },
  onOpen(e) {
    this.setState(this.getInitialState());
    this.onEnter(e);

    let preview = document.getElementsByClassName('medium-editor-anchor-preview')[0];
    let toolbar = document.getElementsByClassName('medium-editor-toolbar medium-editor-stalker-toolbar')[0];
    e.appendChild(preview);
    e.appendChild(toolbar);
  },
  onClose(e) {
    this.setState(this.getInitialState());
    this.props.onHide(e);
  },
  render() {
    const { show, onHide, boardContent } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section facilitator-board-modal' show={ show } onHide={ onHide } onEnter={ this.onOpen }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onClose }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Facilitator Board</h4>
            </div>

            <div className='col-md-2'>
              {/*<span className={ this.newButtonClass(rendering) } onClick={ this.onNew }></span>*/}
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row facilitator-board-section'>
              <Board />
            </div>
          </Modal.Body>
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
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(BoardModal);
