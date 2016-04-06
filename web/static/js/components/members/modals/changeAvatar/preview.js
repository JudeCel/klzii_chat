import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';

const AvatarPreview = React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  elementsToload() {
    const { index, type } = this.props;
    return [
      '/images/avatar/base_00.svg',
      `/images/avatar/${type}_${this.padToTwo(index)}.svg`
    ];
  },
  render() {
    const elements = this.elementsToload();

    return (
      <div className='preview-images'>
        {
          elements.map((element, index) =>
            <img key={ index } src={ element }></img>
          )
        }
      </div>
    )
  }
});

export default AvatarPreview;
