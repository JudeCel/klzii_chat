import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap'
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import Board              from './board';
import Actions            from '../../../../actions/facilitatorBoard';
import NotificationActions      from '../../../../actions/notifications';

const BoardModal = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return { content: this.props.boardContent };
  },
  shouldComponentUpdate(nextProps, nextState) {
    return this.state.content === nextState.content && nextProps.permission;
  },
  onOpen(e) {
    this.onEnterModal(e);
    if (this.props.boardContent != this.state.content) {
      this.setContent(this.props.boardContent);
    }

    let preview = document.getElementsByClassName('medium-editor-anchor-preview')[0];
    let toolbar = document.getElementsByClassName('medium-editor-toolbar medium-editor-stalker-toolbar')[0];
    e.appendChild(preview);
    e.appendChild(toolbar);
  },
  onSave(e) {
    let { channel, dispatch, modalWindows } = this.props
    if (!modalWindows.postData) {
      Actions.saveBoard(channel, dispatch, this.state.content);
    }
  },
  onClose(e) {
    if (!this.props.modalWindows.postData) {
      this.closeAllModals();
    }
  },
  setContent(content) {
    this.setState({ content: content });
  },
  render() {
    const show = this.showSpecificModal('facilitatorBoard');
    const { boardContent } = this.props;

    if(show) {
      return (
        <Modal dialogClassName='modal-section facilitator-board-modal' show={ show } onHide={ this.closeAllModals } onEnter={ this.onOpen }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onClose }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Facilitator Board</h4>
            </div>

            <div className='col-md-2'>
              <span className='pull-right fa fa-check' onClick={ this.onSave }></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row facilitator-board-section'>
              <Board { ... { boardContent, setContent: this.setContent } } />
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
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    channel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(BoardModal);
