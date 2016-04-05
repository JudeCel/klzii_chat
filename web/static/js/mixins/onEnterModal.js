const OnEnterMixin = {
  onEnter(e) {
    const { colours } = this.props;

    let modalFrame = e.querySelector('.modal-content');
    modalFrame.style.borderColor = colours.mainBorder;
  }
}

export default OnEnterMixin;
