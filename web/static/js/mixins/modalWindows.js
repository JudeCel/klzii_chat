import Constants from '../constants';

const modalWindows = {
  onEnterModal(e) {
    const { colours } = this.props;

    let modalFrame = e.querySelector('.modal-content');
    modalFrame.style.borderColor = colours.mainBorder;
  },
  showSpecificModal(key) {
    return this.props.modalWindows[key];
  },
  openSpecificModal(key) {
    const { modalWindows, dispatch } = this.props;

    if(!modalWindows) {
      console.error("No modalWindows from state: ", key, this.props);
    }

    for(let i in modalWindows) {
      let modal = modalWindows[i];

      if(modal && i != key) {
        this.closeAllModals();
        break;
      }
    }

    dispatch({ type: Constants.OPEN_MODAL_WINDOW, modal: key });
  },
  closeAllModals() {
    this.props.dispatch({ type: Constants.CLOSE_ALL_MODAL_WINDOWS });
  }
};

export default modalWindows;
