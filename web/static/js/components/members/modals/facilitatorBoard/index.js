import React, {PropTypes} from 'react';
import { Modal }          from 'react-bootstrap'
import { connect }        from 'react-redux';
import onEnterModalMixin  from '../../../../mixins/onEnterModal';
import Board              from './board';

const BoardModal = React.createClass({
  mixins: [onEnterModalMixin],
  getInitialState() {
    return { content: '' };
  },
  shouldComponentUpdate(nextProps, nextState) {
    return this.state.content === nextState.content;
  },
  onOpen(e) {
    this.onEnter(e);

    let preview = document.getElementsByClassName('medium-editor-anchor-preview')[0];
    let toolbar = document.getElementsByClassName('medium-editor-toolbar medium-editor-stalker-toolbar')[0];
    e.appendChild(preview);
    e.appendChild(toolbar);
  },
  onClose(e) {
    this.props.onHide(e);
  },
  onSave(e) {
    console.log(this.state.content);
    this.onClose(e);
  },
  setContent(content) {
    this.setState({ content: content });
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
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(BoardModal);
