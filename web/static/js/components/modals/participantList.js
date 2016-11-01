import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';
import Pagination  from "react-js-pagination";

const ParticipantListModal = React.createClass({
  mixins: [mixins.modalWindows, mixins.paginationHelper, mixins.helpers],
  getInitialState() {
    return { page: 1 };
  },
  componentDidUpdate() {
    setTimeout(() => { this.initPaginatorButton('participantsPaginator') }, 0);
  },
  renderParticipant(participant) {
    return (
      <div className='col-md-3' key={ participant.id }>
        <div className='fa fa-users'></div>
        <div className='participant-name'>
          <div>{ participant.lastName } { participant.firstName }</div>
        </div>
      </div>
    );
  },
  renderParticipants() {
    const USERS_PER_PAGE = 12;
    const { participants } = this.props;

    let onlineParticipants = [];
    for (let i=0; i<participants.length; i++) {
      if (participants[i].online) {
        onlineParticipants.push(participants[i]);
      }
    }

    if (onlineParticipants.length) {
      onlineParticipants = this.sort(onlineParticipants, 'lastName');
      let startIndex = (this.state.page - 1) * USERS_PER_PAGE;
      let endIndex = startIndex + USERS_PER_PAGE;
      let onlineParticipantsDisplay = onlineParticipants.slice(startIndex, endIndex);

      return (
        <div>
          { onlineParticipantsDisplay.map((participant) => this.renderParticipant(participant) ) }
          <div className="paginator" id="participantsPaginator">
            <Pagination
              activePage={this.state.page}
              itemsCountPerPage={USERS_PER_PAGE}
              totalItemsCount={onlineParticipants.length}
              pageRangeDisplayed={5}
              onChange={this.pageChange}
            />
          </div>
        </div>
      )
    } else {
      return <div className='text-center'>There are currently no Participants logged in.</div>
    }
  },
  pageChange(pageNumber) {
    if (pageNumber != this.state.page) {
      this.setState({ page: pageNumber });
    }
  },
  render() {
    let show = this.showSpecificModal('participantList');

    if(show) {
      return (
        <Modal dialogClassName='observer-list-modal modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Participants</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row observer-section'>
              { this.renderParticipants() }
            </div>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Close</button>
          </Modal.Footer>
        </Modal>
      )
    } else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    participants: state.members.participants,
    colours: state.chat.session.colours
  }
};

export default connect(mapStateToProps)(ParticipantListModal);
