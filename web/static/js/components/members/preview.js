import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';

const AvatarPreview = React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  componentDidMount() {
    const { index, type } = this.props;

    let avatar = Snap(`#preview-avatar-${index}`);
    Snap.load(`/images/avatar/base_00.svg`, (base) => {
      Snap.load(`/images/avatar/${type}_${this.padToTwo(index)}.svg`, (element) => {
        avatar.append(base);
        avatar.append(element);
      });
    });
  },
  render() {
    const { index, click } = this.props;

    return (
      <span>
        <svg id={ `preview-avatar-${index}` } height='73px' width='65%' onClick={ click } data-id={ index }>

        </svg>
      </span>
    )
  }
})

export default AvatarPreview;
