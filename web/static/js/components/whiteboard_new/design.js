const design = {
  getExpandButtonImage() {
    if(this.state.minimized) {
      return '/images/icon_whiteboard_expand.png';
    }
    else {
      return '/images/icon_whiteboard_shrink.png';
    }
  },
  expandWhiteboard() {
    this.setState({ minimized: !this.state.minimized });
  },
  expandButtonClass() {
    return this.state.minimized ? ' minimized' : ' maximized';
  }
};

export default design;
