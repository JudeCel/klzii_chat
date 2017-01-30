import Constants from '../constants';

const mobileHelpers = {
  isMobile() {
    return screen.width < Constants.MOBILE_SCREEN_WIDTH && screen.height < Constants.MOBILE_SCREEN_HEIGHT;
  },
  isVerticalMobile() {
    return this.isMobile() && screen.height > screen.width;
  },
  isHorizontalMobile() {
    return this.isMobile() && screen.height < screen.width;
  }
}

export default mobileHelpers;
