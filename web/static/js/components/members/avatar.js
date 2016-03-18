import React, {PropTypes}   from 'react';
import Snap                 from 'snapsvg';
import Member               from './member.js'

const Avatar =  React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  componentDidMount() {
    let _this = this;
    const [base_number, face_number, body_number, hair_number, desk_number] = this.props.avatar_info.split(":")
    let s = Snap(`#svg-${this.props.id}`);
    // Snap.load(`/images/avatar/base_${_this.padToTwo(base_number)}.svg`, function (f) {
    //   s.append(f);
    //   Snap.load(`/images/avatar/face_${_this.padToTwo(face_number)}.svg`, function (f) {
    //     s.append(f);
    //     Snap.load(`/images/avatar/body_${_this.padToTwo(body_number)}.svg`, function (f) {
    //       s.append(f);
    //       Snap.load(`/images/avatar/hair_${_this.padToTwo(hair_number)}.svg`, function (f) {
    //         s.append(f);
            Snap.load(`/images/avatar/desk_${_this.padToTwo(desk_number)}.svg`, function (f) {
              s.append(f.select("svg"));
            });
    //       });
    //     });
    //   });
    // });
  },
  render() {
    return (
      <svg id={`svg-${this.props.id}`}>

      </svg>
      // <div className="combined-avatar">
      //   <img src={`/images/avatar/base_${this.padToTwo(base_number)}.svg`} />
      //   <img src={`/images/avatar/face_${this.padToTwo(face_number)}.svg`} />
      //   <img src={`/images/avatar/body_${this.padToTwo(body_number)}.svg`} />
      //   <img src={`/images/avatar/hair_${this.padToTwo(hair_number)}.svg`} />
      //   <img src={`/images/avatar/desk_${this.padToTwo(desk_number)}.svg`} />
      // </div>
    )
  }
})

export default Avatar;
